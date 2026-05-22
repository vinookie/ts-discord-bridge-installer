# TS Discord Bridge Beta Installer

Ein einfacher Installer für die öffentliche Docker-Beta der **TS Discord Bridge**.

Die TS Discord Bridge verbindet einen **TeamSpeak-Voice-Channel** mit einem **Discord-Voice-Channel**.

```txt
TeamSpeak -> Discord
Discord   -> TeamSpeak

Der Installer richtet die Bridge als Selfhosted-Docker-Setup ein und führt dich durch die erste Konfiguration.

Was wird installiert?

Die Bridge besteht aus zwei Docker-Containern:

vinookie/ts-discord-bridge:4.5.6-beta
vinookie/ts-discord-bridge-sidecar:4.5.6-beta

Bedeutung:

ts-discord-bridge
= Hauptcontainer für Discord, TeamSpeak, Slash Commands, WebQuery und Bridge-Logik

ts-discord-bridge-sidecar
= Rust-Audio-Sidecar für Audio-Decoding, Mixing und Encoding

Beide Container werden benötigt.

Was macht die VoiceBridge?

Typischer Ablauf:

1. Ein registrierter Discord-User joint einen Discord-Voice-Channel.
2. Die Bridge startet automatisch.
3. Der Discord-Bot joint diesen Discord-Voice-Channel.
4. Der TeamSpeak-Bot verbindet sich mit deinem TeamSpeak-Server.
5. Optional erkennt WebQuery den passenden/vollsten TeamSpeak-Channel.
6. Audio wird zwischen TeamSpeak und Discord übertragen.

Unterstützte Funktionen in der Beta:

- TeamSpeak -> Discord Voice
- Discord -> TeamSpeak Voice
- Rust-Audio-Sidecar
- automatische Bridge für registrierte Discord-User
- automatisches Verlassen nach Inaktivität
- TeamSpeak WebQuery Channel-Erkennung
- Auswahl des vollsten TeamSpeak-Channels
- persistente TeamSpeak-Identity über Docker-Volume
- Beta-Lizenzcheck über zentralen Lizenzserver
Voraussetzungen

Du brauchst:

- Linux-Server/VPS
- Docker
- Docker Compose v2
- Discord Bot Token
- Discord Guild/Server ID
- Discord Channel ID für Status/Logs
- TeamSpeak Serverdaten
- TeamSpeak WebQuery API Key
- Beta License Key

Aktueller öffentlicher Beta-Key:

BRIDGE_LICENSE_KEY=beta-local-test-001

Wenn du beim Installer bei der License-Key-Frage einfach Enter drückst, wird dieser Beta-Key automatisch genutzt.

Schnellinstallation
curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash

Der Installer erstellt:

~/ts-discord-bridge/docker-compose.yml
~/ts-discord-bridge/.env
~/ts-discord-bridge/.env.example
~/ts-discord-bridge/bridge.sh
Installation Schritt für Schritt
1. Installer starten
curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash
2. Fragen beantworten

Der Installer fragt nach:

Discord Bot Token
Discord Guild/Server ID
Discord Status-/Log-Channel ID

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
3. Optional direkt starten

Am Ende fragt der Installer:

Start the bridge now? [y/N]:

Mit y startet die Bridge direkt.

Mit n kannst du sie später manuell starten.

Nach der Installation bedienen

Nach der Installation brauchst du den Installer nicht mehr.

Wechsle in den Installationsordner:

cd ~/ts-discord-bridge

Dann kannst du die Bridge über das mitgelieferte Script steuern:

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

./bridge.sh start       Startet die Bridge
./bridge.sh stop        Stoppt die Bridge
./bridge.sh restart     Startet die Bridge neu
./bridge.sh status      Zeigt den Container-Status
./bridge.sh logs        Zeigt Live-Logs
./bridge.sh logs-once   Zeigt die letzten 200 Logzeilen
./bridge.sh update      Zieht neue Docker-Images und startet neu
./bridge.sh stats       Zeigt CPU/RAM live
./bridge.sh check       Kurzer Status-, RAM- und Fehlercheck
Wichtige Docker-Befehle

Direkt mit Docker Compose geht es auch:

Starten
cd ~/ts-discord-bridge
docker compose up -d
Logs anzeigen
cd ~/ts-discord-bridge
docker compose logs -f -t --tail=200
Status prüfen
cd ~/ts-discord-bridge
docker compose ps
Stoppen
cd ~/ts-discord-bridge
docker compose down

Nicht benutzen, außer du willst wirklich die persistenten Daten löschen:

docker compose down -v

down -v löscht das Docker-Volume. Dadurch gehen unter anderem TeamSpeak-Identity und gespeicherte Bridge-Daten verloren.

Persistente Daten

Die Bridge speichert wichtige Laufzeitdaten in einem Docker-Volume:

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

Wenn der Lizenzcheck fehlschlägt, startet die Bridge nicht korrekt beziehungsweise beendet sich.

Discord Bot Hinweise

Der Discord Bot braucht typischerweise:

- Zugriff auf deinen Discord Server
- Voice Channel verbinden
- Voice Channel sprechen
- Slash Commands registrieren/nutzen
- Nachrichten im Status-/Log-Channel senden
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

WebQuery wird unter anderem genutzt für:

- TeamSpeak Channel-Erkennung
- Auswahl des vollsten TeamSpeak-Channels
- bessere automatische Bridge-Zielauswahl

Wichtige .env-Werte:

TS_WEBQUERY_ENABLED=true
TS_WEBQUERY_HOST=CHANGE_ME
TS_WEBQUERY_PORT=30036
TS_WEBQUERY_PROTOCOL=http
TS_WEBQUERY_SERVER_ID=1
TS_WEBQUERY_API_KEY=CHANGE_ME
Update
cd ~/ts-discord-bridge
./bridge.sh update

Oder manuell:

cd ~/ts-discord-bridge
docker compose pull
docker compose up -d
Typische Probleme
Container startet nicht
cd ~/ts-discord-bridge
./bridge.sh logs
Lizenzfehler

Prüfe:

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
Sicherheit

Teile niemals öffentlich:

.env
Discord Bot Token
TeamSpeak Passwort
TeamSpeak WebQuery API Key

Die Datei .env wird vom Installer mit eingeschränkten Rechten angelegt.

Projektstatus

Aktueller Docker-Tag:

4.5.6-beta

Ältere Beta-Tags werden nicht unterstützt.

Hinweis

Dieses Projekt ist ein inoffizielles Community-Projekt.

Es ist nicht mit TeamSpeak, Discord oder anderen genannten Projekten verbunden.
