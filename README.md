# Keegan's Code-Server Docker Image

This project automates the building and publishing of a Docker image for [code-server](https://github.com/coder/code-server) centred on JAVA, enabling for a portable browser with ease.

## Features

- **Automated CI/CD**: Seamlessly builds and pushes Docker images to the GitHub Container Registry (GHCR).
- **Multi-Platform Support**: Fully supports `linux/amd64` and `linux/arm64` architectures.
- **Versioning**: Dynamically extracts the version from the `Dockerfile` for consistent tagging.

## Workflow Overview

The GitHub Actions workflow is triggered on pushes to `main` for stable releases and `feature/*` for development & testing branches and:
- Checks out the repository code.
- Extracts the version from the `Dockerfile`.
- Builds and pushes the Docker image with appropriate tags and labels.

## Usage

### Running the Docker Image

The Docker host must be a Linux host with Docker Engine running and Docker Compose installed.

1. On the host, configure access to the Docker socket before starting Compose:
   ```bash
   export DOCKER_SOCKET_PATH=/var/run/docker.sock
   export DOCKER_GID=$(stat -c '%g' "$DOCKER_SOCKET_PATH")
   docker compose up -d
   ```
   Set these variables each time you run Compose, or persist their resolved values in a local `.env` file. For rootless Docker, set `DOCKER_SOCKET_PATH` to its actual socket path before calculating `DOCKER_GID`.

2. When using local Dockerfile changes that have not been published to GHCR, first build the image referenced by `compose.yml`:
   ```bash
   docker build -t ghcr.io/kelvin-keegen/code-server:latest .
   docker compose up -d --force-recreate
   ```
   Keep the existing named volumes to preserve your workspace and settings.

### OpenCode

OpenCode is installed as `coder` into `/opt/opencode/bin`, outside the persisted `/home/coder` volume. Image updates can replace the binary without an existing home volume hiding it. Configuration and application data remain under `/home/coder/.config/opencode` and `/home/coder/.local/share/opencode`.

Allow the container to inherit the image's `PATH`. If an external Compose or deployment configuration overrides `PATH`, remove that override or include `/opt/opencode/bin` alongside the Java, Maven, and system binary directories. After rebuilding or pulling the updated image, recreate the container without deleting its volumes and check `opencode --version` in a new terminal.

### Host Docker Access

The image includes the Docker CLI, Buildx, and the Compose plugin. Compose mounts the host Docker socket and adds its numeric group ID to `coder`'s supplementary groups. No Docker daemon runs inside code-server, and privileged mode is not required.

From the code-server terminal, verify access and launch a container:

```bash
docker version
docker compose version
docker run --rm hello-world
```

Containers launched this way run on the host Docker daemon and appear in the host's `docker ps`. Published ports are exposed on the host, not inside code-server. Bind-mount source paths are also resolved on the host: `/my_workspace` inside code-server is a named-volume mount, not necessarily a matching host directory. Use named volumes or host paths that actually exist when launching other containers.

**Security:** Access to a rootful Docker socket effectively grants root access to the host, even though code-server runs as `coder`. Only enable this for trusted users, protect access to code-server, and replace the example password in `compose.yml`. Do not make the socket world-writable.

### Local Development

1. Clone this repository and have fun:
   ```bash
   git clone https://github.com/kelvin-keegen/code-server.git
   cd code-server
   ```
## Contributing

Contributions are always welcome! If you have ideas, suggestions, or find any issues, feel free to open an issue or submit a pull request. 

Happy coding!
