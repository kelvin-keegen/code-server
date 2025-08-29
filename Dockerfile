# Base image with code-server preinstalled
FROM codercom/code-server:latest

ARG JAVA_VERSION=21
ARG JAVA_VARIANT=tem
ARG MAVEN_VERSION=3.9.8
ARG VERSION=1.0.5

LABEL version=${VERSION}

# Switch to root user to install dependencies
USER root

# Install dependencies (curl, unzip, etc.)
RUN apt-get update && \
    apt-get install -y curl unzip zip git && \
    apt-get clean

# Copy custom VS Code user settings (e.g., to set a dark theme)
COPY --chown=coder:coder settings.json /home/coder/.local/share/code-server/User/settings.json

# Switch back to the default user
USER coder

# Install SDKMAN! (to manage Java, Maven, etc.)
RUN curl -s "https://get.sdkman.io" | bash

# Initialize SDKMAN! and install Java & Maven
RUN echo "source $HOME/.sdkman/bin/sdkman-init.sh" >> ~/.bashrc && \
    bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java ${JAVA_VERSION}-${JAVA_VARIANT} && sdk install maven ${MAVEN_VERSION}"

# Set environment variables for Java and Maven (SDKMAN! handles versioning)
ENV JAVA_HOME=/home/coder/.sdkman/candidates/java/current
ENV MAVEN_HOME=/home/coder/.sdkman/candidates/maven/current
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

# Verify Java and Maven installation
RUN java -version && \
    mvn -v

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
