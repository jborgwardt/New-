#!/bin/bash
# Join the Headscale tailnet on every VM boot.
# Requires the HEADSCALE_AUTHKEY secret (Cursor Dashboard -> Cloud Agents -> Secrets).

if [ -z "$HEADSCALE_AUTHKEY" ]; then
  echo "HEADSCALE_AUTHKEY not set; skipping tailnet join"
  exit 0
fi

# No systemd in the VM: run tailscaled directly
sudo tailscaled --state=/var/lib/tailscale/tailscaled.state >/tmp/tailscaled.log 2>&1 &
sleep 3

sudo tailscale up \
  --login-server=https://headscale.jail.sale \
  --authkey "$HEADSCALE_AUTHKEY" \
  --accept-routes \
  --accept-dns=false \
  --hostname=cursor-agent

# The sandbox's policy routing intercepts 192.168.0.0/16 before Tailscale's
# route table; this rule restores LAN access through the subnet router.
sudo ip rule add to 192.168.1.0/24 lookup 52 priority 100 2>/dev/null || true

tailscale status | head -5
