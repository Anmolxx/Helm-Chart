FROM jenkins/jenkins:lts

USER root

# Base tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    ca-certificates \
    apt-transport-https \
    gnupg \
    lsb-release

# Install Docker CLI
RUN apt-get update && apt-get install -y docker.io

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Give jenkins access to docker group
RUN usermod -aG docker jenkins

USER jenkins

# Install plugins automatically
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt