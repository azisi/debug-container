FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install essential tools and debugging utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    iproute2 \
    iputils-ping \
    dnsutils \
    net-tools \
    curl \
    netcat-traditional \
    tcpdump \
    mtr \
    bind9-dnsutils \
    host \
    vim \
    less \
    strace \
    lsof \
    procps \
    telnet \
    jq \
    bash \
    bash-completion \
    ca-certificates \
    gnupg \
    openssl \
    nmap \
    httpie \
    postgresql-client \
    mariadb-client \
    redis-tools \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Optional: install kubectl
ARG KUBECTL_VERSION=1.29.0
RUN curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Set bash as default shell
SHELL ["/bin/bash", "-c"]

# Set working directory
WORKDIR /root

# Default command
CMD ["bash"]
