#!/bin/bash
if [ -z "$HEADSCALE_AUTHKEY" ]; then
  echo "HEADSCALE_AUTHKEY not set; skipping tailnet join"
  exit 0
fi
sudo tailscaled --state=/var/lib/tailscale/tailscaled.state >/tmp/tailscaled.log 2>&1 &
sleep 3
sudo tailscale up --login-server=https://headscale.jail.sale --authkey "$HEADSCALE_AUTHKEY" --accept-routes --accept-dns=false --hostname=cursor-agent
sudo ip rule add to 192.168.1.0/24 lookup 52 priority 100 2>/dev/null || true
tailscale status | head -5
