# syntax=docker/dockerfile:1.7

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG ALR_VERSION=2.1.0

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
   ca-certificates \
   curl \
  gcc \
   git \
  libc6-dev \
    libgmp-dev \
   make \
    pkg-config \
   unzip \
   xz-utils \
 && rm -rf /var/lib/apt/lists/*

RUN ARCH="$(dpkg --print-architecture)" \
 && case "$ARCH" in \
      amd64) ALR_ARCH="x86_64-linux" ;; \
      arm64) ALR_ARCH="aarch64-linux" ;; \
      *) echo "Unsupported Docker architecture: $ARCH" >&2; exit 1 ;; \
   esac \
 && curl -fsSL \
      "https://github.com/alire-project/alire/releases/download/v${ALR_VERSION}/alr-${ALR_VERSION}-bin-${ALR_ARCH}.zip" \
      -o /tmp/alr.zip \
 && unzip -q /tmp/alr.zip -d /opt/alr \
 && ln -s /opt/alr/bin/alr /usr/local/bin/alr \
 && rm -f /tmp/alr.zip \
 && alr --version

RUN mkdir -p /alire \
 && chmod 0777 /alire

WORKDIR /workspace

COPY . /workspace

CMD ["bash"]