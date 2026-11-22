#!/bin/bash
# Bei Fehlern und nicht gesetzten Variablen sofort abbrechen
set -euo pipefail

# Betriebssysteminformationen laden und Distribution erkennen
if [[ ! -r /etc/os-release ]]; then
  echo "ERROR: /etc/os-release is missing or unreadable; cannot identify the operating system." >&2
  exit 1
fi

# shellcheck disable=SC1091
. /etc/os-release

# Nur Debian und Ubuntu werden unterstuetzt
case "${ID:-}" in
  ubuntu|debian)
    DISTRO="$ID"
    ;;
  *)
    echo "ERROR: this script supports Ubuntu and Debian only (detected: ${ID:-unknown})." >&2
    exit 1
    ;;
esac

# Der Versionsname wird fuer den Docker Eintrag benoetigt
if [[ -z "${VERSION_CODENAME:-}" ]]; then
  echo "ERROR: VERSION_CODENAME is missing from /etc/os-release." >&2
  exit 1
fi

# Pruefen ob sudo installiert ist und Rechte verfuegbar sind
if ! command -v sudo >/dev/null 2>&1; then
  echo "ERROR: sudo is required but was not found." >&2
  exit 1
fi

if ! sudo -v; then
  echo "ERROR: sudo authentication failed; administrator privileges are required." >&2
  exit 1
fi

# Paketlisten aktualisieren und benoetigte Werkzeuge installieren
sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl git gnupg

# Docker Signaturschluessel herunterladen und fuer APT ablegen
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/$DISTRO/gpg" | sudo gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
sudo chmod 644 /etc/apt/keyrings/docker.gpg

# Docker Repository fuer Architektur und Distribution einrichten
ARCH="$(dpkg --print-architecture)"
printf 'deb [arch=%s signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/%s %s stable\n' \
  "$ARCH" "$DISTRO" "$VERSION_CODENAME" |
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker Engine und Compose installieren und Dienste starten
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

# Installation ueberpruefen
sudo docker --version
sudo docker compose version
sudo docker info > /dev/null