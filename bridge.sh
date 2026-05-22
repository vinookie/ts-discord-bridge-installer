#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

usage() {
  cat <<'HELP'
TS Discord Bridge Control

Usage:
  ./bridge.sh start       Start the bridge
  ./bridge.sh stop        Stop the bridge
  ./bridge.sh restart     Restart the bridge
  ./bridge.sh status      Show container status
  ./bridge.sh logs        Follow logs
  ./bridge.sh logs-once   Show last 200 log lines
  ./bridge.sh update      Pull latest images and restart
  ./bridge.sh stats       Show live CPU/RAM usage
  ./bridge.sh check       Show quick health/license/error check

Examples:
  ./bridge.sh start
  ./bridge.sh logs
  ./bridge.sh restart
HELP
}

case "${1:-}" in
  start)
    docker compose up -d
    docker compose ps
    ;;

  stop)
    docker compose down
    ;;

  restart)
    docker compose down
    docker compose up -d
    docker compose ps
    ;;

  status)
    docker compose ps
    ;;

  logs)
    docker compose logs -f -t --tail=200 ts-discord-bridge rust-audio-sidecar
    ;;

  logs-once)
    docker compose logs -t --tail=200 ts-discord-bridge rust-audio-sidecar
    ;;

  update)
    docker compose pull
    docker compose up -d
    docker compose ps
    ;;

  stats)
    docker stats ts-discord-bridge rust-audio-sidecar
    ;;

  check)
    echo "=== Containers ==="
    docker compose ps

    echo
    echo "=== CPU/RAM ==="
    docker stats --no-stream ts-discord-bridge rust-audio-sidecar || true

    echo
    echo "=== Relevant logs ==="
    docker compose logs --tail=200 ts-discord-bridge rust-audio-sidecar | \
      grep -Ei 'license|sidecar-license|signed|error|warn|panic|Cannot find module|ReferenceError|BufferTooSmall|ts3error|discord-status' \
      || echo "OK: no relevant warnings/errors in last 200 log lines"
    ;;

  ""|-h|--help|help)
    usage
    ;;

  *)
    echo "Unknown command: $1"
    echo
    usage
    exit 1
    ;;
esac
