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

1. Use the compose.yaml for a quick test the image from GHCR:
   ```bash
   docker compose up -d
   ```

### Local Development

1. Clone this repository and have fun:
   ```bash
   git clone https://github.com/kelvin-keegen/code-server.git
   cd code-server
   ```
## Contributing

Contributions are always welcome! If you have ideas, suggestions, or find any issues, feel free to open an issue or submit a pull request. 

Happy coding!
