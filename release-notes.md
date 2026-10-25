# Release Notes

## [1.1.0] - 2026-10-24

### What has changed?

- Upgraded base image from `codercom/code-server:4.141.0` to `codercom/code-server:4.143.1`.
- Upgraded the default Java version from 21 to 25 (Temurin).
- Added Python 3, pip, and virtual environment support, with `python` mapped to Python 3 and build-time installation checks.
- Added OpenCode to the image and shell PATH; prevented the image release version from incorrectly pinning the OpenCode version.
- Kept OpenCode installed as `coder` but moved its binary to `/opt/opencode/bin` so persisted home volumes do not hide it; removed the Compose PATH override while preserving user configuration.
- Added the Docker CLI, Buildx, and Compose plugin for host Docker daemon access through the mounted socket, without running a daemon inside the container.
- Updated Compose to require `DOCKER_GID` for socket permissions and documented host Docker setup, security considerations, and local image rebuilds.

---

## [1.0.8] - 2026-10-09

### What has changed?

- Upgraded base image from `codercom/code-server:4.123.0` to `codercom/code-server:4.141.0` (Code v4.141.0) for reproducible builds
