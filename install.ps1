$ErrorActionPreference = "Stop"

$Version = "4.5.7-beta"
$InstallDir = if ($env:INSTALL_DIR) { $env:INSTALL_DIR } else { Join-Path $env:USERPROFILE "ts-discord-bridge" }
$BaseUrl = "https://raw.githubusercontent.com/vinookie/ts-discord-bridge-installer/main"

$MainImage = "vinookie/ts-discord-bridge:$Version"
$SidecarImage = "vinookie/ts-discord-bridge-sidecar:$Version"
$DefaultBetaLicenseKey = "beta-local-test-001"

function Line {
  Write-Host "============================================================"
}

function Info($msg) {
  Write-Host "[info] $msg"
}

function Fail($msg) {
  Write-Error "[error] $msg"
  exit 1
}

function Ask($prompt, $default = $null, [switch]$AllowEmpty) {
  while ($true) {
    if ($null -ne $default -and $default -ne "") {
      $value = Read-Host "$prompt [$default]"
      if ([string]::IsNullOrWhiteSpace($value)) {
        return $default
      }
      return $value
    }

    $value = Read-Host $prompt
    if ($AllowEmpty -or -not [string]::IsNullOrWhiteSpace($value)) {
      return $value
    }
  }
}

function AskSecret($prompt, [switch]$AllowEmpty) {
  while ($true) {
    $secure = Read-Host $prompt -AsSecureString
    $plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
      [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
    )

    if ($AllowEmpty -or -not [string]::IsNullOrWhiteSpace($plain)) {
      return $plain
    }
  }
}

function SetEnvValue($path, $key, $value) {
  $escaped = $value -replace "\\", "\\"
  $lines = @()

  if (Test-Path $path) {
    $lines = Get-Content $path
  }

  $found = $false
  $newLines = foreach ($line in $lines) {
    if ($line -match "^$([regex]::Escape($key))=") {
      $found = $true
      "$key=$escaped"
    } else {
      $line
    }
  }

  if (-not $found) {
    $newLines += "$key=$escaped"
  }

  Set-Content -Path $path -Value $newLines -Encoding UTF8
}

Line
Write-Host "TS Discord Bridge Beta Installer for Windows PowerShell"
Line
Write-Host
Write-Host "This installer will:"
Write-Host "- create: $InstallDir"
Write-Host "- download docker-compose.yml and .env.example"
Write-Host "- guide you through .env setup"
Write-Host "- pull Docker images from Docker Hub"
Write-Host "- optionally start the bridge"
Write-Host

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Fail "Docker CLI is missing. Install Docker Desktop first."
}

docker compose version | Out-Null

$osType = docker info --format "{{.OSType}}" 2>$null
if ($LASTEXITCODE -ne 0) {
  Fail "Docker Desktop is not running or Docker is not reachable."
}

if ($osType -ne "linux") {
  Fail "Docker must run Linux containers. Current OSType: $osType"
}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Set-Location $InstallDir

Info "Using install directory: $InstallDir"

if (Test-Path "docker-compose.yml") {
  Copy-Item "docker-compose.yml" "docker-compose.yml.backup-$(Get-Date -Format yyyyMMdd-HHmmss)" -Force
}

if (Test-Path ".env") {
  Copy-Item ".env" ".env.backup-$(Get-Date -Format yyyyMMdd-HHmmss)" -Force
}

Info "Downloading docker-compose.yml..."
Invoke-WebRequest "$BaseUrl/docker-compose.yml?cb=$(Get-Date -UFormat %s)" -OutFile "docker-compose.yml"

Info "Downloading .env.example..."
Invoke-WebRequest "$BaseUrl/.env.example?cb=$(Get-Date -UFormat %s)" -OutFile ".env.example"

if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env" -Force
}

Line
Write-Host "Configuration"
Line
Write-Host
Write-Host "You now need your Discord bot token, Discord guild/server ID,"
Write-Host "TeamSpeak connection data and TeamSpeak WebQuery API key."
Write-Host

$DiscordToken = AskSecret "Discord Bot Token"
$DiscordGuildId = Ask "Discord Guild/Server ID"
$DiscordStatusChannelId = Ask "Discord status/log channel ID"

Write-Host
$TsHost = Ask "TeamSpeak host/IP"
$TsPort = Ask "TeamSpeak voice port" "30012"
$TsNickname = Ask "TeamSpeak bot nickname" "DiscordBridge"
$TsChannelId = Ask "Fallback TeamSpeak channel ID"
$TsPassword = AskSecret "TeamSpeak server password, empty if none" -AllowEmpty
$TsChannelPassword = Ask "TeamSpeak channel password, empty if none" -AllowEmpty

Write-Host
$TsWebqueryHost = Ask "TeamSpeak WebQuery host/IP" $TsHost
$TsWebqueryPort = Ask "TeamSpeak WebQuery port" "30036"
$TsWebqueryProtocol = Ask "TeamSpeak WebQuery protocol http/https" "http"
$TsWebqueryServerId = Ask "TeamSpeak WebQuery server ID" "1"
$TsWebqueryApiKey = AskSecret "TeamSpeak WebQuery API key"

Write-Host
$BridgeLicenseKey = Ask "Beta license key, press ENTER to use default" $DefaultBetaLicenseKey

SetEnvValue ".env" "DISCORD_TOKEN" $DiscordToken
SetEnvValue ".env" "DISCORD_GUILD_ID" $DiscordGuildId
SetEnvValue ".env" "DISCORD_STATUS_CHANNEL_ID" $DiscordStatusChannelId

SetEnvValue ".env" "TS_HOST" $TsHost
SetEnvValue ".env" "TS_PORT" $TsPort
SetEnvValue ".env" "TS_NICKNAME" $TsNickname
SetEnvValue ".env" "TS_CHANNEL_ID" $TsChannelId
SetEnvValue ".env" "TS_PASSWORD" $TsPassword
SetEnvValue ".env" "TS_CHANNEL_PASSWORD" $TsChannelPassword

SetEnvValue ".env" "TS_WEBQUERY_HOST" $TsWebqueryHost
SetEnvValue ".env" "TS_WEBQUERY_PORT" $TsWebqueryPort
SetEnvValue ".env" "TS_WEBQUERY_PROTOCOL" $TsWebqueryProtocol
SetEnvValue ".env" "TS_WEBQUERY_SERVER_ID" $TsWebqueryServerId
SetEnvValue ".env" "TS_WEBQUERY_API_KEY" $TsWebqueryApiKey

SetEnvValue ".env" "BRIDGE_LICENSE_KEY" $BridgeLicenseKey
SetEnvValue ".env" "BRIDGE_VERSION" $Version

Line
Write-Host "Docker images"
Line
Write-Host
Info "Pulling $MainImage"
docker pull $MainImage

Info "Pulling $SidecarImage"
docker pull $SidecarImage

Line
Write-Host "Beta validation notice"
Line
Write-Host
Write-Host "Important:"
Write-Host "When the bridge starts, it briefly connects to the maintainer license server"
Write-Host "to validate whether this public beta version is still active/current."
Write-Host
Write-Host "The current beta uses a shared beta key and does not require a user account."
Write-Host "Like normal web server access, technical access data such as IP address,"
Write-Host "timestamp, request path, HTTP status and user-agent may appear in server logs."
Write-Host
Write-Host "More details are documented in PRIVACY.md."
Write-Host

Line
Write-Host "Ready"
Line
Write-Host
Write-Host "Files created in:"
Write-Host $InstallDir
Write-Host
Write-Host "Important commands:"
Write-Host
Write-Host "Start:"
Write-Host "  cd `"$InstallDir`"; docker compose up -d"
Write-Host
Write-Host "Logs:"
Write-Host "  cd `"$InstallDir`"; docker compose logs -f -t --tail=200"
Write-Host
Write-Host "Status:"
Write-Host "  cd `"$InstallDir`"; docker compose ps"
Write-Host
Write-Host "Stop:"
Write-Host "  cd `"$InstallDir`"; docker compose down"
Write-Host
Write-Host "Do NOT use 'docker compose down -v' unless you want to delete persistent TeamSpeak identity/settings."
Write-Host

$startNow = Read-Host "Start the bridge now? [y/N]"

if ($startNow -in @("y", "Y", "yes", "YES")) {
  docker compose up -d
  Write-Host
  docker compose ps
  Write-Host
  Write-Host "Showing logs. Press Ctrl+C to stop."
  docker compose logs -f -t --tail=100
} else {
  Write-Host "Not started. Run this later:"
  Write-Host "cd `"$InstallDir`"; docker compose up -d"
}
