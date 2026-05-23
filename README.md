# TS Discord Bridge Beta Installer

Ein einfacher Installer für die öffentliche Docker-Beta der **TS Discord Bridge**.

Die **TS Discord Bridge** verbindet einen **TeamSpeak Voice Channel** mit einem **Discord Voice Channel**.

```text
TeamSpeak -> Discord
Discord   -> TeamSpeak
```

Der Installer richtet die Bridge als **Selfhosted-Docker-Setup** ein und führt dich durch die erste Konfiguration.

---

## Übersicht

| Bereich | Beschreibung |
|---|---|
| Projekt | TeamSpeak ↔ Discord Voice Bridge |
| Installation | Docker / Docker Compose |
| Hauptcontainer | `vinookie/ts-discord-bridge:4.5.8-beta` |
| Audio-Sidecar | `vinookie/ts-discord-bridge-sidecar:4.5.8-beta` |
| Linux | unterstützt |
| Windows mit WSL2 | unterstützt |
| Windows ohne WSL2-Distro | getestet mit Docker Desktop im Linux-Container-Modus |
| Lizenz | öffentlicher Beta-Key |
| Status | Beta / Community-Projekt |

---

## Unterstützte Systeme

### Offiziell vorgesehen

| System | Status |
|---|---|
| Linux Server/VPS mit Docker | unterstützt |
| Ubuntu/Debian-basierte Systeme mit Docker | unterstützt |
| Windows mit WSL2/Ubuntu und Docker Compose v2 | unterstützt |

### Zusätzlich getestet

| System | Status |
|---|---|
| Windows ohne eigene WSL2-Linux-Distribution | getestet |
| Docker Desktop im Linux-Container-Modus | getestet |
| Installation über PowerShell mit `install.ps1` | getestet |

**Wichtig:** Die Docker Images sind **Linux-Container**. Unter Windows muss Docker Desktop im **Linux-Container-Modus** laufen.

Prüfen unter Windows PowerShell:

```powershell
docker info --format "{{.OSType}}"
```

Erwartung:

```text
linux
```

Wenn dort `windows` steht, ist Docker Desktop im Windows-Container-Modus. Dann funktioniert die Bridge nicht.

---

## Was wird installiert?

Die Bridge besteht aus zwei Docker-Containern:

| Container | Image | Aufgabe |
|---|---|---|
| `ts-discord-bridge` | `vinookie/ts-discord-bridge:4.5.8-beta` | Discord, TeamSpeak, Slash Commands, WebQuery und Bridge-Logik |
| `ts-discord-bridge-sidecar` | `vinookie/ts-discord-bridge-sidecar:4.5.8-beta` | Rust-Audio-Sidecar für Audio-Decoding, Mixing und Encoding |

Beide Container werden benötigt.

---

## Was macht die VoiceBridge?

Typischer Ablauf:

1. Ein registrierter Discord-User joint einen Discord Voice Channel.
2. Die Bridge startet automatisch.
3. Der Discord-Bot joint diesen Discord Voice Channel.
4. Der TeamSpeak-Bot verbindet sich mit deinem TeamSpeak Server.
5. Optional erkennt WebQuery den passenden oder vollsten TeamSpeak Channel.
6. Audio wird zwischen TeamSpeak und Discord übertragen.

---

## Funktionen in der Beta

| Funktion | Status |
|---|---|
| TeamSpeak -> Discord Voice | vorhanden |
| Discord -> TeamSpeak Voice | vorhanden |
| Rust-Audio-Sidecar | vorhanden |
| automatische Bridge für registrierte Discord-User | vorhanden |
| manuelles Starten/Stoppen per Discord Slash Command | vorhanden |
| automatisches Verlassen nach Inaktivität | vorhanden |
| TeamSpeak WebQuery Channel-Erkennung | vorhanden |
| Auswahl des vollsten TeamSpeak Channels | vorhanden |
| persistente TeamSpeak-Identity über Docker-Volume | vorhanden |
| Beta-Lizenzcheck über zentralen Lizenzserver | vorhanden |
| Linux Docker Support | vorhanden |
| Windows Docker Desktop Support über PowerShell Installer | vorhanden |

---

## Voraussetzungen

Du brauchst:

| Voraussetzung | Beschreibung |
|---|---|
| Docker | Docker Engine oder Docker Desktop |
| Docker Compose v2 | `docker compose version` muss funktionieren |
| Discord Bot Token | Token deines Discord Bots |
| Discord Guild/Server ID | ID deines Discord Servers |
| Discord Status-/Log-Channel ID | Channel für Statusmeldungen |
| TeamSpeak Serverdaten | Host/IP, Port, Passwort falls vorhanden |
| TeamSpeak WebQuery API Key | API-Key für Channel-/User-Abfragen |
| Beta License Key | aktueller öffentlicher Beta-Key |

Aktueller öffentlicher Beta-Key:

```env
BRIDGE_LICENSE_KEY=beta-local-test-001
```

Wenn du beim Installer bei der License-Key-Frage einfach **Enter** drückst, wird dieser Beta-Key automatisch genutzt.

---

## Schnellinstallation

### Linux / WSL2

```bash
curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash
```

### Windows PowerShell ohne WSL2-Distro

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; $Url="https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.ps1"; $Out="$env:TEMP\ts-discord-bridge-install.ps1"; Invoke-WebRequest $Url -OutFile $Out; powershell -ExecutionPolicy Bypass -File $Out
```

---

## Installation Schritt für Schritt

### 1. Installer starten

Linux / WSL2:

```bash
curl -fsSL https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.sh | bash
```

Windows PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; $Url="https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main/install.ps1"; $Out="$env:TEMP\ts-discord-bridge-install.ps1"; Invoke-WebRequest $Url -OutFile $Out; powershell -ExecutionPolicy Bypass -File $Out
```

### 2. Fragen beantworten

Der Installer fragt nach:

| Bereich | Werte |
|---|---|
| Discord | Bot Token, Guild/Server ID, Status-/Log-Channel ID |
| TeamSpeak | Host/IP, Voice Port, Bot Nickname, Fallback Channel ID, Server Passwort, Channel Passwort |
| TeamSpeak WebQuery | Host/IP, Port, Protocol, Server ID, API Key |
| Beta | License Key |

### 3. Optional direkt starten

Am Ende fragt der Installer:

```text
Start the bridge now? [y/N]:
```

Mit `y` startet die Bridge direkt.  
Mit `n` kannst du sie später manuell starten.

---

## Installationsordner

| System | Installationsordner |
|---|---|
| Linux / WSL2 | `~/ts-discord-bridge` |
| Windows PowerShell | `%USERPROFILE%\ts-discord-bridge` |

Der Installer erstellt dort:

| Datei | Beschreibung |
|---|---|
| `docker-compose.yml` | Docker Compose Setup |
| `.env` | deine lokale Konfiguration mit Zugangsdaten |
| `.env.example` | Beispiel-Konfiguration |
| `bridge.sh` | Linux/WSL2 Helper-Script für Start/Stop/Logs |

---

## Bedienung nach der Installation

### Linux / WSL2

```bash
cd ~/ts-discord-bridge
```

| Befehl | Bedeutung |
|---|---|
| `./bridge.sh start` | startet die Bridge |
| `./bridge.sh stop` | stoppt die Bridge |
| `./bridge.sh restart` | startet die Bridge neu |
| `./bridge.sh status` | zeigt den Container-Status |
| `./bridge.sh logs` | zeigt Live-Logs |
| `./bridge.sh logs-once` | zeigt die letzten 200 Logzeilen |
| `./bridge.sh update` | zieht neue Docker Images und startet neu |
| `./bridge.sh stats` | zeigt CPU/RAM live |
| `./bridge.sh check` | zeigt Status, RAM und relevante Fehler |

### Windows PowerShell

```powershell
cd "$env:USERPROFILE\ts-discord-bridge"
```

| Befehl | Bedeutung |
|---|---|
| `docker compose up -d` | startet die Bridge |
| `docker compose logs -f -t --tail=200` | zeigt Live-Logs |
| `docker compose ps` | zeigt den Container-Status |
| `docker compose down` | stoppt die Bridge |
| `docker compose pull` | lädt aktuelle Images |
| `docker compose up -d` | startet nach Update neu |

---

## Wichtige Docker-Befehle

| Aktion | Befehl |
|---|---|
| Starten | `docker compose up -d` |
| Logs anzeigen | `docker compose logs -f -t --tail=200` |
| Status prüfen | `docker compose ps` |
| Stoppen | `docker compose down` |
| Update | `docker compose pull` danach `docker compose up -d` |

Nicht benutzen, außer du willst wirklich die persistenten Daten löschen:

```bash
docker compose down -v
```

**Achtung:** `down -v` löscht das Docker-Volume. Dadurch gehen unter anderem TeamSpeak-Identity und gespeicherte Bridge-Daten verloren.

---

## Persistente Daten

Die Bridge speichert wichtige Laufzeitdaten in einem Docker-Volume:

```text
ts-discord-bridge_ts-discord-bridge-data
```

Darin liegen unter anderem:

| Datei/Daten | Bedeutung |
|---|---|
| TeamSpeak Identity | Identität des TeamSpeak Bots |
| registrierte Discord-User | Auto-Bridge Nutzer |
| Volume-/Audio-Einstellungen | Lautstärke-/Audio-Werte |
| Lizenz-Cache | zwischengespeicherter Lizenzstatus |

Dieses Volume sollte nicht gelöscht werden.

---

## Lizenz / Beta

Die aktuelle Beta nutzt einen zentralen Lizenzcheck.

In der `.env` steht nur der License-Key:

```env
BRIDGE_LICENSE_KEY=beta-local-test-001
```

Die License-Server-Adresse ist im Image fest eingebaut. Nutzer müssen keine License-URL konfigurieren.

Beim Start verbindet sich die Bridge kurz mit dem Maintainer-License-Server, um zu prüfen, ob diese öffentliche Beta-Version noch aktiv/aktuell ist.

Wenn der Lizenzcheck fehlschlägt, startet die Bridge nicht korrekt beziehungsweise beendet sich.

---

## Discord Bot Hinweise

Der Discord Bot braucht typischerweise:

| Recht | Zweck |
|---|---|
| Zugriff auf deinen Discord Server | Bot muss auf dem Server sein |
| Voice Channel verbinden | Bot muss Voice joinen können |
| Voice Channel sprechen | Bot muss Audio senden können |
| Slash Commands registrieren/nutzen | Commands wie `/bridge join` |
| Nachrichten im Status-/Log-Channel senden | Statusmeldungen und Fehler |

---

## TeamSpeak Hinweise

Der TeamSpeak Bot braucht Zugriff auf deinen TeamSpeak Server.

Je nach Server-Konfiguration braucht er Rechte für:

| Recht | Zweck |
|---|---|
| Server verbinden | Bot muss auf den Server joinen |
| Channel wechseln | Bot muss in den Zielchannel wechseln |
| sprechen | Bot muss Audio senden |
| Audio empfangen/senden | VoiceBridge-Funktion |
| WebQuery/API-Abfragen | Channel-/User-Erkennung |

Für automatische Channel-Erkennung wird TeamSpeak WebQuery benötigt.

---

## WebQuery

WebQuery wird genutzt für:

- TeamSpeak Channel-Erkennung
- Auswahl des vollsten TeamSpeak Channels
- bessere automatische Bridge-Zielauswahl

Wichtige `.env`-Werte:

```env
TS_WEBQUERY_ENABLED=true
TS_WEBQUERY_HOST=CHANGE_ME
TS_WEBQUERY_PORT=30036
TS_WEBQUERY_PROTOCOL=http
TS_WEBQUERY_SERVER_ID=1
TS_WEBQUERY_API_KEY=CHANGE_ME
```

---

## Discord Commands

Die Bridge wird in Discord über Slash Commands gesteuert. Die Commands erscheinen im Discord-Chat, sobald der Bot auf dem Server ist und die Slash Commands registriert wurden.

| Command | Bedeutung |
|---|---|
| `/bridge join` | startet die Bridge manuell |
| `/bridge leave` | stoppt die aktive Bridge |
| `/bridge register` | registriert deinen Discord-User für Auto-Bridge |
| `/bridge unregister` | entfernt deinen Discord-User aus der Auto-Bridge-Liste |
| `/bridge registered` | zeigt die aktuell registrierten Discord-User |
| `/volume` | öffnet oder steuert Lautstärke-Einstellungen |

### `/bridge join`

Startet die Bridge manuell. Der Bot verbindet Discord Voice mit TeamSpeak. Wenn WebQuery aktiv ist, kann die Bridge den passenden oder vollsten TeamSpeak Channel erkennen.

### `/bridge leave`

Stoppt die aktive Bridge manuell. Der Discord-Bot verlässt den Voice Channel und die Audio-Bridge wird beendet.

### `/bridge register`

Registriert deinen Discord-User für Auto-Bridge. Danach kann dein Join in einen Discord Voice Channel die Bridge automatisch starten.

### `/bridge unregister`

Entfernt deinen Discord-User wieder aus der Auto-Bridge-Liste. Danach startet dein Join die Bridge nicht mehr automatisch.

### `/bridge registered`

Zeigt die aktuell registrierten Discord-User an.

### `/volume`

Öffnet oder steuert Lautstärke-Einstellungen, je nach aktueller Bot-Version. Wird genutzt, um Audio zwischen Discord und TeamSpeak anzupassen.

---

## Auto-Bridge Verhalten

1. Ein registrierter Discord-User joint einen Discord Voice Channel.
2. Die Bridge startet automatisch, wenn noch keine passende Bridge aktiv ist.
3. Der Discord-Bot joint den Discord Voice Channel.
4. Der TeamSpeak-Bot verbindet sich mit TeamSpeak.
5. WebQuery wählt optional den passenden oder vollsten TeamSpeak Channel.
6. Audio läuft zwischen TeamSpeak und Discord.

Wenn niemand mehr im Discord-Bridge-Channel ist, kann die Bridge nach einer Wartezeit automatisch verlassen.

Wichtiger `.env`-Wert:

```env
BRIDGE_AUTO_LEAVE_MS=300000
```

`300000` entspricht 5 Minuten.

---

## Typische Probleme

| Problem | Prüfen |
|---|---|
| Container startet nicht | Logs prüfen |
| Lizenzfehler | `BRIDGE_LICENSE_KEY=beta-local-test-001` |
| Discord Bot verbindet nicht | Token, Guild ID, Bot-Rechte, Voice-Rechte |
| TeamSpeak Bot verbindet nicht | Host, Port, Passwort, Channel ID, TS-Rechte |
| WebQuery funktioniert nicht | Host, Port, Protocol, API Key, WebQuery aktiv? |

### Container startet nicht

Linux / WSL2:

```bash
cd ~/ts-discord-bridge
./bridge.sh logs
```

Windows PowerShell:

```powershell
cd "$env:USERPROFILE\ts-discord-bridge"
docker compose logs -f -t --tail=200
```

### Lizenzfehler

Prüfe:

```env
BRIDGE_LICENSE_KEY=beta-local-test-001
```

### Discord Bot verbindet nicht

Prüfe:

- `DISCORD_TOKEN` korrekt?
- `DISCORD_GUILD_ID` korrekt?
- Bot auf dem richtigen Discord Server eingeladen?
- Bot hat Voice-Rechte?
- Bot hat Slash-Command-Rechte?
- Container neu starten

### TeamSpeak Bot verbindet nicht

Prüfe:

- `TS_HOST` korrekt?
- `TS_PORT` korrekt?
- `TS_PASSWORD` korrekt?
- `TS_CHANNEL_ID` korrekt?
- TeamSpeak Server erreichbar?
- TeamSpeak Rechte korrekt?

### WebQuery funktioniert nicht

Prüfe:

- `TS_WEBQUERY_HOST` korrekt?
- `TS_WEBQUERY_PORT` korrekt?
- `TS_WEBQUERY_PROTOCOL` korrekt?
- `TS_WEBQUERY_API_KEY` korrekt?
- WebQuery auf deinem TeamSpeak Server aktiviert?

---

## Sicherheit

Teile niemals öffentlich:

- `.env`
- Discord Bot Token
- TeamSpeak Passwort
- TeamSpeak WebQuery API Key

Die Datei `.env` enthält sensible Zugangsdaten.

---

## Privacy / License Check

The public beta build performs a small license validation request to the maintainer's license server.

The current beta uses a shared beta license key and does not require a user account. The license server does not intentionally collect Discord tokens, TeamSpeak credentials, Discord guild IDs, TeamSpeak hostnames, or channel IDs.

Like with normal web server access, the license server or reverse proxy may process technical access data such as IP address, timestamp, request path, HTTP status code, and user-agent in server logs. These logs are used for operation, troubleshooting, abuse prevention, and security.

More details: see `PRIVACY.md`.

---

## Credits / Inspiration

TS Discord Bridge is an independent TeamSpeak ↔ Discord voice bridge.

Credits go to:

- `clusterzx/ts6-manager` for public work and discussion around TS6 connectivity and TeamSpeak client behavior. The TeamSpeak client/runtime used by this bridge was adapted for this project so TeamSpeak audio can be accepted continuously and forwarded into the bridge pipeline.
- `0xpr03/voice-bridge` as a public reference and inspiration for the general idea of a TeamSpeak ↔ Discord voice bridge.

This project is not affiliated with TeamSpeak, Discord, `clusterzx/ts6-manager`, or `0xpr03/voice-bridge`.

---

## Projektstatus

| Wert | Status |
|---|---|
| Docker-Tag | `4.5.8-beta` |
| Status | öffentliche Beta |
| Ältere Beta-Tags | nicht unterstützt |
| Projektart | inoffizielles Community-Projekt |

Dieses Projekt ist nicht mit TeamSpeak, Discord oder anderen genannten Projekten verbunden.

---

## Preview

![TS Discord Bridge Preview](https://i.ibb.co/V0pTdq9q/42fb761d-96d4-4f4a-9ac1-c0a335b0c9e4.png)

