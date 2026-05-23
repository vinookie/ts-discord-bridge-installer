#!/usr/bin/env bash
set -euo pipefail

VERSION="4.5.8-beta"
INSTALL_DIR="${INSTALL_DIR:-$HOME/ts-discord-bridge}"
BASE_URL="https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main"

MAIN_IMAGE="vinookie/ts-discord-bridge:${VERSION}"
SIDECAR_IMAGE="vinookie/ts-discord-bridge-sidecar:${VERSION}"

line() {
  echo "============================================================"
}

info() {
  echo "[info] $*"
}

warn() {
  echo "[warn] $*"
}


read_from_tty() {
  if [ -r /dev/tty ]; then
    read "$@" </dev/tty
  else
    read "$@"
  fi
}

fail() {
  echo "[error] $*" >&2
  exit 1
}

ask() {
  local var_name="$1"
  local prompt="$2"
  local default_value="${3:-}"
  local value=""

  if [ -n "$default_value" ]; then
    read_from_tty -rp "$prompt [$default_value]: " value
    value="${value:-$default_value}"
  else
    while [ -z "$value" ]; do
      read_from_tty -rp "$prompt: " value
    done
  fi

  printf -v "$var_name" '%s' "$value"
}


ask_optional() {
  local var_name="$1"
  local prompt="$2"
  local default_value="${3:-}"
  local value=""

  if [ -n "$default_value" ]; then
    read_from_tty -rp "$prompt [$default_value]: " value
    value="${value:-$default_value}"
  else
    read_from_tty -rp "$prompt: " value
  fi

  printf -v "$var_name" '%s' "$value"
}

ask_secret() {
  local var_name="$1"
  local prompt="$2"
  local value=""

  while [ -z "$value" ]; do
    read_from_tty -rsp "$prompt: " value
    echo
  done

  printf -v "$var_name" '%s' "$value"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1"
}

line
echo "TS Discord Bridge Beta Installer"
line
echo
echo "This installer will:"
echo "- create: $INSTALL_DIR"
echo "- download docker-compose.yml and .env.example"
echo "- guide you through .env setup"
echo "- pull Docker images from Docker Hub"
echo "- optionally start the bridge"
echo

require_command curl
require_command docker

if ! docker compose version >/dev/null 2>&1; then
  fail "Docker Compose plugin is missing. Install Docker Compose v2 first."
fi

if ! docker info >/dev/null 2>&1; then
  fail "Docker is not running or your user cannot access Docker."
fi

mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

info "Using install directory: $INSTALL_DIR"

if [ -f docker-compose.yml ]; then
  cp docker-compose.yml "docker-compose.yml.backup-$(date +%Y%m%d-%H%M%S)"
fi

if [ -f .env ]; then
  cp .env ".env.backup-$(date +%Y%m%d-%H%M%S)"
fi

info "Downloading docker-compose.yml..."
curl -fsSL "$BASE_URL/docker-compose.yml" -o docker-compose.yml

info "Downloading .env.example..."
curl -fsSL "$BASE_URL/.env.example" -o .env.example

info "Downloading bridge.sh..."
curl -fsSL "$BASE_URL/bridge.sh" -o bridge.sh
chmod +x bridge.sh

if [ ! -f .env ]; then
  cp .env.example .env
fi

line
echo "Configuration"
line
echo

echo "You now need your Discord bot token, Discord guild/server ID,"
echo "TeamSpeak connection data and TeamSpeak WebQuery API key."
echo

ask_secret DISCORD_TOKEN "Discord Bot Token"
ask DISCORD_GUILD_ID "Discord Guild/Server ID"
ask DISCORD_STATUS_CHANNEL_ID "Discord status/log channel ID"

echo
ask TS_HOST "TeamSpeak host/IP"
ask TS_PORT "TeamSpeak voice port" "30012"
ask TS_NICKNAME "TeamSpeak bot nickname" "DiscordBridge"
ask TS_CHANNEL_ID "Fallback TeamSpeak channel ID"
ask_secret TS_PASSWORD "TeamSpeak server password"
ask_optional TS_CHANNEL_PASSWORD "TeamSpeak channel password, empty if none" ""

echo
ask TS_WEBQUERY_HOST "TeamSpeak WebQuery host/IP" "$TS_HOST"
ask TS_WEBQUERY_PORT "TeamSpeak WebQuery port" "30036"
ask TS_WEBQUERY_PROTOCOL "TeamSpeak WebQuery protocol http/https" "http"
ask TS_WEBQUERY_SERVER_ID "TeamSpeak WebQuery server ID" "1"
ask_secret TS_WEBQUERY_API_KEY "TeamSpeak WebQuery API key"

echo
DEFAULT_BETA_LICENSE_KEY="beta-local-test-001"
ask BRIDGE_LICENSE_KEY "Beta license key, press ENTER to use default" "$DEFAULT_BETA_LICENSE_KEY"

if [ -z "${BRIDGE_LICENSE_KEY:-}" ]; then
  BRIDGE_LICENSE_KEY="$DEFAULT_BETA_LICENSE_KEY"
fi


require_value() {
  local var_name="$1"
  local value="${!var_name:-}"

  if [ -z "$value" ]; then
    fail "$var_name is required but empty. Please run the installer in an interactive terminal."
  fi
}

set_env() {
  local key="$1"
  local value="$2"

  value="${value//\\/\\\\}"
  value="${value//&/\\&}"

  if grep -q "^${key}=" .env; then
    sed -i "s|^${key}=.*|${key}=${value}|" .env
  else
    echo "${key}=${value}" >> .env
  fi
}


require_value DISCORD_TOKEN
require_value DISCORD_GUILD_ID
require_value DISCORD_STATUS_CHANNEL_ID
require_value TS_HOST
require_value TS_PORT
require_value TS_NICKNAME
require_value TS_CHANNEL_ID
require_value TS_WEBQUERY_HOST
require_value TS_WEBQUERY_PORT
require_value TS_WEBQUERY_PROTOCOL
require_value TS_WEBQUERY_SERVER_ID
require_value TS_WEBQUERY_API_KEY
require_value BRIDGE_LICENSE_KEY

set_env DISCORD_TOKEN "$DISCORD_TOKEN"
set_env DISCORD_GUILD_ID "$DISCORD_GUILD_ID"
set_env DISCORD_STATUS_CHANNEL_ID "$DISCORD_STATUS_CHANNEL_ID"

set_env TS_HOST "$TS_HOST"
set_env TS_PORT "$TS_PORT"
set_env TS_NICKNAME "$TS_NICKNAME"
set_env TS_CHANNEL_ID "$TS_CHANNEL_ID"
set_env TS_PASSWORD "$TS_PASSWORD"
set_env TS_CHANNEL_PASSWORD "$TS_CHANNEL_PASSWORD"

set_env TS_WEBQUERY_HOST "$TS_WEBQUERY_HOST"
set_env TS_WEBQUERY_PORT "$TS_WEBQUERY_PORT"
set_env TS_WEBQUERY_PROTOCOL "$TS_WEBQUERY_PROTOCOL"
set_env TS_WEBQUERY_SERVER_ID "$TS_WEBQUERY_SERVER_ID"
set_env TS_WEBQUERY_API_KEY "$TS_WEBQUERY_API_KEY"

set_env BRIDGE_LICENSE_KEY "$BRIDGE_LICENSE_KEY"
set_env BRIDGE_VERSION "$VERSION"

chmod 600 .env || true

line
echo "Docker images"
line
echo
info "Pulling $MAIN_IMAGE"
docker pull "$MAIN_IMAGE"

info "Pulling $SIDECAR_IMAGE"
docker pull "$SIDECAR_IMAGE"


show_beta_validation_notice() {
  line
  echo "Beta validation notice"
  line
  echo
  echo "Important:"
  echo "When the bridge starts, it briefly connects to the maintainer license server"
  echo "to validate whether this public beta version is still active/current."
  echo
  echo "The current beta uses a shared beta key and does not require a user account."
  echo "Like normal web server access, technical access data such as IP address,"
  echo "timestamp, request path, HTTP status and user-agent may appear in server logs."
  echo
  echo "More details are documented in PRIVACY.md."
  echo
}

show_beta_validation_notice

line
echo "Ready"
line
echo
echo "Files created in:"
echo "$INSTALL_DIR"
echo
echo "Important commands:"
echo
echo "Start:"
echo "  cd $INSTALL_DIR && ./bridge.sh start"
echo
echo "Logs:"
echo "  cd $INSTALL_DIR && ./bridge.sh logs"
echo
echo "Status:"
echo "  cd $INSTALL_DIR && ./bridge.sh status"
echo
echo "Stop:"
echo "  cd $INSTALL_DIR && ./bridge.sh stop"
echo
echo "Update:"
echo "  cd $INSTALL_DIR && ./bridge.sh update"
echo
echo "Health check:"
echo "  cd $INSTALL_DIR && ./bridge.sh check"
echo
echo "Do NOT use 'docker compose down -v' unless you want to delete the persistent TeamSpeak identity/settings."
echo

read_from_tty -rp "Start the bridge now? [y/N]: " START_NOW

case "$START_NOW" in
  y|Y|yes|YES)
    docker compose up -d
    echo
    docker compose ps
    echo
    echo "Showing logs for 60 seconds. Press Ctrl+C to stop earlier."
    timeout 60 docker compose logs -f -t --tail=100 || true
    ;;
  *)
    echo "Not started. Run this later:"
    echo "cd $INSTALL_DIR && ./bridge.sh start"
    ;;
esac
