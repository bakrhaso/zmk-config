FROM docker.io/zmkfirmware/zmk-build-arm:stable

ARG JUST_VERSION=1.47.1

# Install curl and pip (not included in the minimal ZMK image).
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install just (command runner) from GitHub releases.
RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
      amd64) arch="x86_64-unknown-linux-musl" ;; \
      arm64) arch="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported architecture" && exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-${arch}.tar.gz" \
      | tar xz -C /usr/local/bin just; \
    just --version

# Install yq (needed by Justfile) and keymap-drawer (for drawing keymaps).
RUN pip install --no-cache-dir --break-system-packages \
    yq \
    keymap-drawer==0.21.0

WORKDIR /workspace
