#!/bin/sh
# Run this ON the NAS (dodoland) to stand up the podcast feed server.
#
#   curl -O https://raw.githubusercontent.com/yidarvin/darvinyi-podcast/main/nas/setup-nas.sh
#   sh setup-nas.sh
#
# Or, if your Mac can already ssh to the NAS, from the repo on the Mac:
#   ssh dodoland 'sh -s' < nas/setup-nas.sh
#
# Serves a tiny static server on :8091. Because every device is on Tailscale,
# the feed is then reachable everywhere as  http://dodoland:8091/feed.xml
# — no Cloudflare, no port forwarding, no public exposure.

set -eu
BASE="${PODCAST_BASE:-/volume1/docker/podcast}"   # Synology default docker share
PORT="${PODCAST_PORT:-8091}"

mkdir -p "$BASE/audio" "$BASE/caddy"

cat > "$BASE/caddy/Caddyfile" <<'EOF'
:80 {
    root * /srv
    file_server
    @feed path /feed.xml
    header @feed Cache-Control "no-store"
}
EOF

cat > "$BASE/docker-compose.yml" <<EOF
services:
  podcast:
    image: caddy:2-alpine
    container_name: podcast
    restart: unless-stopped
    ports:
      - "${PORT}:80"
    volumes:
      - ${BASE}:/srv:ro
      - ${BASE}/caddy/Caddyfile:/etc/caddy/Caddyfile:ro
EOF

echo "wrote $BASE/docker-compose.yml and $BASE/caddy/Caddyfile"

if docker compose version >/dev/null 2>&1; then
  ( cd "$BASE" && docker compose up -d ) && echo "container up (docker compose)"
elif command -v docker-compose >/dev/null 2>&1; then
  ( cd "$BASE" && docker-compose up -d ) && echo "container up (docker-compose)"
else
  echo ""
  echo "Docker Compose CLI not found on this NAS. Either:"
  echo "  - enable Container Manager's CLI, then:  cd $BASE && docker compose up -d"
  echo "  - or import $BASE/docker-compose.yml via Synology Container Manager > Project."
fi

echo ""
echo "Verify from any Tailscale device (a 404 before you publish is fine):"
echo "  curl -I http://dodoland:${PORT}/feed.xml"
