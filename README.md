# TS Discord Bridge Beta Installer

Ein einfacher Installer für die öffentliche Docker-Beta der **TS Discord Bridge**.

Die TS Discord Bridge verbindet einen **TeamSpeak-Voice-Channel** mit einem **Discord-Voice-Channel**. Audio kann in beide Richtungen übertragen werden:

```txt
TeamSpeak -> Discord
Discord   -> TeamSpeak
Das Projekt läuft als Selfhosted-Docker-Setup und besteht aus zwei Containern:

vinookie/ts-discord-bridge
vinookie/ts-discord-bridge-sidecar

Der Installer richtet beide Container ein, erstellt eine .env-Datei und führt dich durch die erste Konfiguration.

Was macht die Bridge?

Die Bridge verbindet TeamSpeak und Discord über einen Bot.

Typischer Ablauf:

1. Ein registrierter Discord-User joint einen Discord-Voice-Channel.
2. Die Bridge startet automatisch.
3. Der Discord-Bot joint diesen Discord-Voice-Channel.
4. Der TeamSpeak-Bot verbindet sich mit deinem TeamSpeak-Server.
5. Per TeamSpeak WebQuery wird optional der passendste/vollste TeamSpeak-Channel erkannt.
6. Audio wird zwischen TeamSpeak und Discord übertragen.

Unterstützte Funktionen in der aktuellen Beta:

- TeamSpeak -> Discord Voice
- Discord -> TeamSpeak Voice
- Rust-Audio-Sidecar für Decode/Mix/Encode
- automatische Bridge für registrierte Discord-User
- automatisches Verlassen nach Inaktivität
- TeamSpeak WebQuery Channel-Erkennung
- Auswahl des vollsten TeamSpeak-Channels
- persistente TeamSpeak-Identity über Docker-Volume
- Beta-Lizenzcheck über zentralen Lizenzserver
Schnellinstallation

Auf einem Linux-Server mit Docker:

curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash

Der Installer fragt dich nach den wichtigsten Daten und erstellt danach automatisch:

~/ts-discord-bridge/docker-compose.yml
~/ts-discord-bridge/.env
~/ts-discord-bridge/.env.example

Am Ende kannst du die Bridge direkt starten lassen.

Voraussetzungen

Du brauchst:

- Linux-Server/VPS
- Docker
- Docker Compose v2
- Discord Bot Token
- Discord Server/Guild ID
- Discord Channel ID für Status/Logs
- TeamSpeak Serverdaten
- TeamSpeak WebQuery API Key
- Beta License Key

Der aktuelle öffentliche Beta-Key ist:

BRIDGE_LICENSE_KEY=beta-local-test-001

Wenn du beim Installer bei der License-Key-Frage einfach Enter drückst, wird dieser Beta-Key automatisch verwendet.

Docker Images

Die Images werden von Docker Hub gezogen:

docker pull vinookie/ts-discord-bridge:4.5.6-beta
docker pull vinookie/ts-discord-bridge-sidecar:4.5.6-beta

Beide Images werden benötigt.

ts-discord-bridge
= Hauptcontainer für Discord, TeamSpeak, Slash Commands, WebQuery und Bridge-Logik

ts-discord-bridge-sidecar
= Rust-Audio-Sidecar für Audio-Decoding, Mixing und Encoding

Normalerweise musst du diese Images nicht manuell ziehen. Der Installer macht das automatisch.

Installation Schritt für Schritt
1. Installer starten
curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash
2. Fragen beantworten

Der Installer fragt dich nach:

Discord Bot Token
Discord Guild/Server ID
Discord Status/Log Channel ID

TeamSpeak Host/IP
TeamSpeak Voice Port
TeamSpeak Bot Nickname
TeamSpeak Fallback Channel ID
TeamSpeak Server Passwort
TeamSpeak Channel Passwort, falls vorhanden

TeamSpeak WebQuery Host/IP
TeamSpeak WebQuery Port
TeamSpeak WebQuery Protocol
TeamSpeak WebQuery Server ID
TeamSpeak WebQuery API Key

Beta License Key
3. Bridge starten

Am Ende fragt der Installer:

Start the bridge now? [y/N]:

Mit y startet die Bridge direkt.

Mit n kannst du sie später manuell starten:

cd ~/ts-discord-bridge
docker compose up -d
Wichtige Befehle
Starten
cd ~/ts-discord-bridge
docker compose up -d
Logs anzeigen
cd ~/ts-discord-bridge
docker compose logs -f -t --tail=200
Status prüfen
cd ~/ts-discord-bridge
docker compose ps
CPU/RAM anzeigen
docker stats ts-discord-bridge rust-audio-sidecar
Stoppen
cd ~/ts-discord-bridge
docker compose down

Nicht benutzen, außer du willst wirklich die persistenten Daten löschen:

docker compose down -v

down -v löscht das Docker-Volume. Dadurch gehen unter anderem die TeamSpeak-Identity und gespeicherte Bridge-Daten verloren.

Persistente Daten

Die Bridge speichert wichtige Laufzeitdaten in einem Docker-Volume.

Dazu gehören unter anderem:

TeamSpeak Identity
registrierte Discord-User
Volume-/Audio-Einstellungen
Lizenz-Cache

Deshalb sollte das Volume nicht gelöscht werden.

Lizenz / Beta

Die aktuelle Beta nutzt einen zentralen Lizenzcheck.

Der Nutzer muss in der .env nur den License-Key setzen:

BRIDGE_LICENSE_KEY=beta-local-test-001

Die License-Server-Adresse ist im Image fest eingebaut. Nutzer müssen keine License-URL konfigurieren.

Wenn der Lizenzcheck fehlschlägt, startet die Bridge nicht korrekt beziehungsweise beendet sich.

Discord Bot Hinweise

Der Discord Bot braucht typischerweise:

- Zugriff auf deinen Discord Server
- Voice Channel verbinden
- Voice Channel sprechen
- Slash Commands registrieren/nutzen
- Nachrichten im Status-/Log-Channel senden

Achte darauf, dass der Bot auf deinem Discord Server eingeladen ist und die nötigen Rechte besitzt.

TeamSpeak Hinweise

Der TeamSpeak Bot braucht Zugriff auf deinen TeamSpeak Server.

Je nach Server-Konfiguration braucht er Rechte für:

- Server verbinden
- Channel wechseln
- sprechen
- Audio senden/empfangen
- WebQuery/API-Abfragen

Für automatische Channel-Erkennung wird TeamSpeak WebQuery benötigt.

WebQuery

Die WebQuery-Daten werden in der .env gesetzt:

TS_WEBQUERY_ENABLED=true
TS_WEBQUERY_HOST=CHANGE_ME
TS_WEBQUERY_PORT=30036
TS_WEBQUERY_PROTOCOL=http
TS_WEBQUERY_SERVER_ID=1
TS_WEBQUERY_API_KEY=CHANGE_ME

WebQuery wird unter anderem genutzt für:

- TeamSpeak Channel-Erkennung
- Auswahl des vollsten TeamSpeak Channels
- bessere automatische Bridge-Zielauswahl
Typische Probleme
Container startet nicht

Logs prüfen:

cd ~/ts-discord-bridge
docker compose logs -f -t --tail=200
Lizenzfehler

Prüfe in deiner .env:

BRIDGE_LICENSE_KEY=beta-local-test-001
Discord Bot verbindet nicht

Prüfe:

- DISCORD_TOKEN korrekt?
- DISCORD_GUILD_ID korrekt?
- Bot auf dem Server eingeladen?
- Bot hat Voice-Rechte?
TeamSpeak Bot verbindet nicht

Prüfe:

- TS_HOST korrekt?
- TS_PORT korrekt?
- TS_PASSWORD korrekt?
- TS_CHANNEL_ID korrekt?
- TeamSpeak Server erreichbar?
WebQuery funktioniert nicht

Prüfe:

- TS_WEBQUERY_HOST korrekt?
- TS_WEBQUERY_PORT korrekt?
- TS_WEBQUERY_API_KEY korrekt?
- WebQuery auf deinem TeamSpeak Server aktiviert?
Update

Zum Aktualisieren auf den neuesten Beta-Tag:

cd ~/ts-discord-bridge
docker compose pull
docker compose up -d
Deinstallation

Nur Container stoppen:

cd ~/ts-discord-bridge
docker compose down

Komplett entfernen inklusive persistenter Daten:

cd ~/ts-discord-bridge
docker compose down -v

Achtung: Dadurch wird die TeamSpeak-Identity und gespeicherte Bridge-Konfiguration gelöscht.

Sicherheit

Teile niemals öffentlich:

.env
Discord Bot Token
TeamSpeak Passwort
TeamSpeak WebQuery API Key

Die Datei .env wird vom Installer mit eingeschränkten Rechten angelegt:

-rw-------
Projektstatus

Diese Version ist eine öffentliche Beta.

Aktueller Docker-Tag:

4.5.6-beta

Ältere Beta-Tags werden nicht unterstützt.

Hinweis

Dieses Projekt ist ein inoffizielles Community-Projekt.

Es ist nicht mit TeamSpeak, Discord oder anderen genannten Projekten verbunden.
