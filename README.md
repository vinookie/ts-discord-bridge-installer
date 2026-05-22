
TS Discord Bridge Beta Installer

Ein einfacher Installer für die öffentliche Docker-Beta der TS Discord Bridge.

Die TS Discord Bridge verbindet einen TeamSpeak Voice Channel mit einem Discord Voice Channel.

TeamSpeak -> Discord
Discord -> TeamSpeak

Der Installer richtet die Bridge als Selfhosted-Docker-Setup ein und führt dich durch die erste Konfiguration.

Unterstützte Systeme

Offiziell vorgesehen:

Linux Server/VPS mit Docker
Ubuntu/Debian-basierte Systeme mit Docker
Windows mit WSL2/Ubuntu und Docker/Docker Compose v2

Zusätzlich getestet:

Windows ohne eigene WSL2-Linux-Distribution
Docker Desktop im Linux-Container-Modus
Installation über PowerShell mit install.ps1

Wichtig: Die Docker Images sind Linux-Container. Unter Windows muss Docker Desktop im Linux-Container-Modus laufen.

Prüfen unter Windows PowerShell:

docker info --format "{{.OSType}}"

Erwartung:

linux

Was wird installiert?

Die Bridge besteht aus zwei Docker-Containern:

vinookie/ts-discord-bridge:4.5.7-beta
vinookie/ts-discord-bridge-sidecar:4.5.7-beta

Bedeutung:

ts-discord-bridge
Hauptcontainer für Discord, TeamSpeak, Slash Commands, WebQuery und Bridge-Logik.

ts-discord-bridge-sidecar
Rust-Audio-Sidecar für Audio-Decoding, Mixing und Encoding.

Beide Container werden benötigt.

Was macht die VoiceBridge?

Typischer Ablauf:

Ein registrierter Discord-User joint einen Discord Voice Channel.
Die Bridge startet automatisch.
Der Discord-Bot joint diesen Discord Voice Channel.
Der TeamSpeak-Bot verbindet sich mit deinem TeamSpeak Server.
Optional erkennt WebQuery den passenden oder vollsten TeamSpeak Channel.
Audio wird zwischen TeamSpeak und Discord übertragen.
Funktionen in der Beta
TeamSpeak -> Discord Voice
Discord -> TeamSpeak Voice
Rust-Audio-Sidecar
automatische Bridge für registrierte Discord-User
manuelles Starten/Stoppen per Discord Slash Command
automatisches Verlassen nach Inaktivität
TeamSpeak WebQuery Channel-Erkennung
Auswahl des vollsten TeamSpeak Channels
persistente TeamSpeak-Identity über Docker-Volume
Beta-Lizenzcheck über zentralen Lizenzserver
Linux Docker Support
Windows Docker Desktop Support über PowerShell Installer
Voraussetzungen

Du brauchst:

Docker
Docker Compose v2
Discord Bot Token
Discord Guild/Server ID
Discord Channel ID für Status/Logs
TeamSpeak Serverdaten
TeamSpeak WebQuery API Key
Beta License Key

Aktueller öffentlicher Beta-Key:

BRIDGE_LICENSE_KEY=beta-local-test-001

Wenn du beim Installer bei der License-Key-Frage einfach Enter drückst, wird dieser Beta-Key automatisch genutzt.

Schnellinstallation
Linux / WSL2

curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash

Windows PowerShell ohne WSL2-Distro

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; $Url="https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.ps1"; $Out="$env:TEMP\ts-discord-bridge-install.ps1"; Invoke-WebRequest $Url -OutFile $Out; powershell -ExecutionPolicy Bypass -File $Out

Installation Schritt für Schritt
1. Installer starten

Linux / WSL2:

curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash

Windows PowerShell:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; $Url="https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.ps1"; $Out="$env:TEMP\ts-discord-bridge-install.ps1"; Invoke-WebRequest $Url -OutFile $Out; powershell -ExecutionPolicy Bypass -File $Out

2. Fragen beantworten

Der Installer fragt nach:

Discord:

Discord Bot Token
Discord Guild/Server ID
Discord Status-/Log-Channel ID

TeamSpeak:

TeamSpeak Host/IP
TeamSpeak Voice Port
TeamSpeak Bot Nickname
TeamSpeak Fallback Channel ID
TeamSpeak Server Passwort
TeamSpeak Channel Passwort, falls vorhanden

TeamSpeak WebQuery:

TeamSpeak WebQuery Host/IP
TeamSpeak WebQuery Port
TeamSpeak WebQuery Protocol
TeamSpeak WebQuery Server ID
TeamSpeak WebQuery API Key

Beta:

Beta License Key
3. Optional direkt starten

Am Ende fragt der Installer:

Start the bridge now? [y/N]:

Mit y startet die Bridge direkt.
Mit n kannst du sie später manuell starten.

Installationsordner

Linux / WSL2:

~/ts-discord-bridge

Windows PowerShell:

%USERPROFILE%\ts-discord-bridge

Der Installer erstellt dort:

docker-compose.yml
.env
.env.example
bridge.sh bei Linux/WSL2
Nach der Installation bedienen
Linux / WSL2

cd ~/ts-discord-bridge

./bridge.sh start
./bridge.sh stop
./bridge.sh restart
./bridge.sh status
./bridge.sh logs
./bridge.sh logs-once
./bridge.sh update
./bridge.sh stats
./bridge.sh check

Bedeutung:

./bridge.sh start startet die Bridge
./bridge.sh stop stoppt die Bridge
./bridge.sh restart startet die Bridge neu
./bridge.sh status zeigt den Container-Status
./bridge.sh logs zeigt Live-Logs
./bridge.sh logs-once zeigt die letzten 200 Logzeilen
./bridge.sh update zieht neue Docker Images und startet neu
./bridge.sh stats zeigt CPU/RAM live
./bridge.sh check zeigt Status, RAM und relevante Fehler
Windows PowerShell

cd "$env:USERPROFILE\ts-discord-bridge"

docker compose up -d
docker compose logs -f -t --tail=200
docker compose ps
docker compose down
docker compose pull
docker compose up -d

Wichtige Docker-Befehle

Starten:

docker compose up -d

Logs anzeigen:

docker compose logs -f -t --tail=200

Status prüfen:

docker compose ps

Stoppen:

docker compose down

Update:

docker compose pull
docker compose up -d

Nicht benutzen, außer du willst wirklich die persistenten Daten löschen:

docker compose down -v

down -v löscht das Docker-Volume. Dadurch gehen unter anderem TeamSpeak-Identity und gespeicherte Bridge-Daten verloren.

Persistente Daten

Die Bridge speichert wichtige Laufzeitdaten in einem Docker-Volume:

ts-discord-bridge_ts-discord-bridge-data

Darin liegen unter anderem:

TeamSpeak Identity
registrierte Discord-User
Volume-/Audio-Einstellungen
Lizenz-Cache

Dieses Volume sollte nicht gelöscht werden.

Lizenz / Beta

Die aktuelle Beta nutzt einen zentralen Lizenzcheck.

In der .env steht nur der License-Key:

BRIDGE_LICENSE_KEY=beta-local-test-001

Die License-Server-Adresse ist im Image fest eingebaut. Nutzer müssen keine License-URL konfigurieren.

Beim Start verbindet sich die Bridge kurz mit dem Maintainer-License-Server, um zu prüfen, ob diese öffentliche Beta-Version noch aktiv/aktuell ist.

Wenn der Lizenzcheck fehlschlägt, startet die Bridge nicht korrekt beziehungsweise beendet sich.

Discord Bot Hinweise

Der Discord Bot braucht typischerweise:

Zugriff auf deinen Discord Server
Voice Channel verbinden
Voice Channel sprechen
Slash Commands registrieren/nutzen
Nachrichten im Status-/Log-Channel senden
TeamSpeak Hinweise

Der TeamSpeak Bot braucht Zugriff auf deinen TeamSpeak Server.

Je nach Server-Konfiguration braucht er Rechte für:

Server verbinden
Channel wechseln
sprechen
Audio senden/empfangen
WebQuery/API-Abfragen

Für automatische Channel-Erkennung wird TeamSpeak WebQuery benötigt.

WebQuery

WebQuery wird genutzt für:

TeamSpeak Channel-Erkennung
Auswahl des vollsten TeamSpeak Channels
bessere automatische Bridge-Zielauswahl

Wichtige .env-Werte:

TS_WEBQUERY_ENABLED=true
TS_WEBQUERY_HOST=CHANGE_ME
TS_WEBQUERY_PORT=30036
TS_WEBQUERY_PROTOCOL=http
TS_WEBQUERY_SERVER_ID=1
TS_WEBQUERY_API_KEY=CHANGE_ME

Discord Commands

Die Bridge wird in Discord über Slash Commands gesteuert. Die Commands erscheinen im Discord-Chat, sobald der Bot auf dem Server ist und die Slash Commands registriert wurden.

Wichtige Commands:

/bridge join

Startet die Bridge manuell. Der Bot verbindet Discord Voice mit TeamSpeak. Wenn WebQuery aktiv ist, kann die Bridge den passenden oder vollsten TeamSpeak Channel erkennen.

/bridge leave

Stoppt die aktive Bridge manuell. Der Discord-Bot verlässt den Voice Channel und die Audio-Bridge wird beendet.

/bridge register

Registriert deinen Discord-User für Auto-Bridge. Danach kann dein Join in einen Discord Voice Channel die Bridge automatisch starten.

/bridge unregister

Entfernt deinen Discord-User wieder aus der Auto-Bridge-Liste. Danach startet dein Join die Bridge nicht mehr automatisch.

/bridge registered

Zeigt die aktuell registrierten Discord-User an.

/volume

Öffnet oder steuert Lautstärke-Einstellungen, je nach aktueller Bot-Version. Wird genutzt, um Audio zwischen Discord und TeamSpeak anzupassen.

Auto-Bridge Verhalten
Ein registrierter Discord-User joint einen Discord Voice Channel.
Die Bridge startet automatisch, wenn noch keine passende Bridge aktiv ist.
Der Discord-Bot joint den Discord Voice Channel.
Der TeamSpeak-Bot verbindet sich mit TeamSpeak.
WebQuery wählt optional den passenden oder vollsten TeamSpeak Channel.
Audio läuft zwischen TeamSpeak und Discord.

Wenn niemand mehr im Discord-Bridge-Channel ist, kann die Bridge nach einer Wartezeit automatisch verlassen.

Wichtiger .env-Wert:

BRIDGE_AUTO_LEAVE_MS=300000

300000 entspricht 5 Minuten.

Typische Probleme
Container startet nicht

Linux / WSL2:

cd ~/ts-discord-bridge
./bridge.sh logs

Windows PowerShell:

cd "$env:USERPROFILE\ts-discord-bridge"
docker compose logs -f -t --tail=200

Lizenzfehler

Prüfe:

BRIDGE_LICENSE_KEY=beta-local-test-001

Discord Bot verbindet nicht

Prüfe:

DISCORD_TOKEN korrekt?
DISCORD_GUILD_ID korrekt?
Bot auf dem richtigen Discord Server eingeladen?
Bot hat Voice-Rechte?
Bot hat Slash-Command-Rechte?
Container neu starten
TeamSpeak Bot verbindet nicht

Prüfe:

TS_HOST korrekt?
TS_PORT korrekt?
TS_PASSWORD korrekt?
TS_CHANNEL_ID korrekt?
TeamSpeak Server erreichbar?
TeamSpeak Rechte korrekt?
WebQuery funktioniert nicht

Prüfe:

TS_WEBQUERY_HOST korrekt?
TS_WEBQUERY_PORT korrekt?
TS_WEBQUERY_PROTOCOL korrekt?
TS_WEBQUERY_API_KEY korrekt?
WebQuery auf deinem TeamSpeak Server aktiviert?
Sicherheit

Teile niemals öffentlich:

.env
Discord Bot Token
TeamSpeak Passwort
TeamSpeak WebQuery API Key

Die Datei .env enthält sensible Zugangsdaten.

Privacy / License Check

The public beta build performs a small license validation request to the maintainer's license server.

The current beta uses a shared beta license key and does not require a user account. The license server does not intentionally collect Discord tokens, TeamSpeak credentials, Discord guild IDs, TeamSpeak hostnames, or channel IDs.

Like with normal web server access, the license server or reverse proxy may process technical access data such as IP address, timestamp, request path, HTTP status code, and user-agent in server logs. These logs are used for operation, troubleshooting, abuse prevention, and security.

More details: see PRIVACY.md.

Credits / Inspiration

TS Discord Bridge is an independent TeamSpeak ↔ Discord voice bridge.

Credits go to:

clusterzx/ts6-manager for public work and discussion around TS6 connectivity and TeamSpeak client behavior. The TeamSpeak client/runtime used by this bridge was adapted for this project so TeamSpeak audio can be accepted continuously and forwarded into the bridge pipeline.
0xpr03/voice-bridge as a public reference and inspiration for the general idea of a TeamSpeak ↔ Discord voice bridge.

This project is not affiliated with TeamSpeak, Discord, clusterzx/ts6-manager, or 0xpr03/voice-bridge.

Projektstatus

Aktueller Docker-Tag:

4.5.7-beta

Ältere Beta-Tags werden nicht unterstützt.

Dieses Projekt ist ein inoffizielles Community-Projekt. Es ist nicht mit TeamSpeak, Discord oder anderen genannten Projekten verbunden.
