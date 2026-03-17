FROM docker.io/zmkfirmware/zmk-build-arm:stable

ARG JUST_VERSION=1.47.1

# Install curl, jq, and pip (not included in the minimal ZMK image).
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
# keymap-drawer 0.21.0 declares tree-sitter>=0.24, but the tree-sitter-devicetree
# ABI is only compatible with 0.23.x. Install keymap-drawer first, then downgrade
# tree-sitter to match the Nix derivation pins.
RUN pip install --no-cache-dir --break-system-packages \
    yq \
    keymap-drawer==0.21.0 \
    && pip install --no-cache-dir --break-system-packages \
    tree-sitter==0.23.2 \
    tree-sitter-devicetree==0.14.1

WORKDIR /workspace
