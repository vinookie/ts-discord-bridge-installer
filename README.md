# TS Discord Bridge Beta Installer

Installer for the public Docker beta of TS Discord Bridge.

## Quick install

curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash
The installer will:

create ~/ts-discord-bridge
download docker-compose.yml
download .env.example
guide you through .env setup
pull Docker images from Docker Hub
optionally start the bridge
Docker images
docker pull vinookie/ts-discord-bridge:4.5.6-beta
docker pull vinookie/ts-discord-bridge-sidecar:4.5.6-beta
Manual start
cd ~/ts-discord-bridge
docker compose pull
docker compose up -d
Logs
cd ~/ts-discord-bridge
docker compose logs -f -t --tail=200
Stop
cd ~/ts-discord-bridge
docker compose down

Do not use docker compose down -v unless you want to delete persistent TeamSpeak identity/settings.

License

The beta currently requires a license key.

Default beta key:

BRIDGE_LICENSE_KEY=beta-local-test-001
Notes

This is an unofficial community project and is not affiliated with TeamSpeak or Discord.
