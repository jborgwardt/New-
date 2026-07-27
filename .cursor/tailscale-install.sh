#!/bin/bash
set -e
if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi
tailscale version
