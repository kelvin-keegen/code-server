# Release Notes

## [1.1.1] - 2026-10-25

### What has changed?

- Fixed OpenCode being unavailable when an existing home volume hides the image-installed binary by moving it to `/opt/opencode/bin`, still owned and installed by `coder`.
- Removed the Compose PATH override so OpenCode, Java, Maven, and system tools inherit the image's PATH.
- Prevented the OpenCode installer from modifying shell configuration; user configuration and credentials remain in the persisted home directory.
- Documented the OpenCode binary location, external PATH overrides, and container recreation without deleting volumes.

---

## [1.1.0] - 2026-10-24

### What has changed?

- Upgraded base image from `codercom/code-server:4.141.0` to `codercom/code-server:4.143.1`.
- Upgraded the default Java version from 21 to 25 (Temurin).
- Added Python 3, pip, and virtual environment support, with `python` mapped to Python 3 and build-time installation checks.
- Added OpenCode to the image and shell PATH; prevented the image release version from incorrectly pinning the OpenCode version.
- Added the Docker CLI, Buildx, and Compose plugin for host Docker daemon access through the mounted socket, without running a daemon inside the container.
- Updated Compose to require `DOCKER_GID` for socket permissions and documented host Docker setup, security considerations, and local image rebuilds.

---

## [1.0.8] - 2026-10-09

### What has changed?

- Upgraded base image from `codercom/code-server:4.123.0` to `codercom/code-server:4.141.0` (Code v4.141.0) for reproducible builds
