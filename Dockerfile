# Base image with code-server preinstalled
FROM codercom/code-server:4.143.1

ARG JAVA_VERSION=25
ARG JAVA_VARIANT=tem
ARG MAVEN_VERSION=3.9.8
ARG VERSION=1.1.0

LABEL version=${VERSION}

# Switch to root user to install dependencies
USER root

# Install dependencies, including Python 3, pip, and virtual environment support
RUN apt-get update && \
    apt-get install -y ca-certificates curl unzip zip git \
        python3 python3-pip python3-venv python-is-python3 && \
    apt-get clean

# Install Docker clients only; containers run on the mounted host daemon
RUN install -m 0755 -d /etc/apt/keyrings && \
    . /etc/os-release && \
    curl -fsSL "https://download.docker.com/linux/${ID}/gpg" -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${ID} ${VERSION_CODENAME} stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# Copy custom VS Code user settings (e.g., to set a dark theme)
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json

# Switch back to the default user
USER coder

# Install OpenCode and make it available in all shells
ENV PATH=/home/coder/.opencode/bin:$PATH
# Avoid treating the image VERSION build argument as an OpenCode version pin.
RUN curl -fsSL https://opencode.ai/install | env -u VERSION bash && \
    opencode --version

# Install SDKMAN! (to manage Java, Maven, etc.)
RUN curl -s "https://get.sdkman.io" | bash

# Initialize SDKMAN! and install Java & Maven
RUN echo "source $HOME/.sdkman/bin/sdkman-init.sh" >> ~/.bashrc && \
    bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java ${JAVA_VERSION}-${JAVA_VARIANT} && sdk install maven ${MAVEN_VERSION}"

# Set environment variables for Java and Maven (SDKMAN! handles versioning)
ENV JAVA_HOME=/home/coder/.sdkman/candidates/java/current
ENV MAVEN_HOME=/home/coder/.sdkman/candidates/maven/current
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

# Verify Java, Maven, and Python installations
RUN java -version && \
    mvn -v && \
    python --version && \
    python3 -m pip --version && \
    python3 -m venv /tmp/python-venv-check && \
    /tmp/python-venv-check/bin/python -m pip --version && \
    rm -rf /tmp/python-venv-check

# Install helpful VS Code extensions for Java and Spring Boot
RUN code-server --install-extension redhat.java \
    && code-server --install-extension vmware.vscode-boot-dev-pack \
    && code-server --install-extension vscjava.vscode-java-pack \
    && code-server --install-extension github.copilot-chat \
    && code-server --install-extension redhat.vscode-yaml

# Set default working directory
WORKDIR /my_workspace

# Expose code-server port
EXPOSE 8080

# Start code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "."]