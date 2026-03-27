#!/usr/bin/env bash
set -euo pipefail

REPO="ErikHellman/android-cli"
BINARY="acli"

# Detect OS and architecture
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$OS" in
  darwin|linux) ;;
  *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

case "$ARCH" in
  x86_64)  ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

ASSET="${BINARY}-${OS}-${ARCH}"
URL="https://github.com/${REPO}/releases/latest/download/${ASSET}"

# Choose install directory
if [ -w "/usr/local/bin" ]; then
  INSTALL_DIR="/usr/local/bin"
else
  INSTALL_DIR="${HOME}/.local/bin"
  mkdir -p "$INSTALL_DIR"
fi

DEST="${INSTALL_DIR}/${BINARY}"

echo "Downloading ${ASSET}..."
curl -fsSL "$URL" -o "$DEST"
chmod +x "$DEST"

echo "Installed acli to ${DEST}"

# Warn if install dir is not on PATH
case ":${PATH}:" in
  *":${INSTALL_DIR}:"*) ;;
  *) echo "Note: add ${INSTALL_DIR} to your PATH to use acli" ;;
esac
