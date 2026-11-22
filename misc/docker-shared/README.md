# Docker Skripte

Dieses Verzeichnis enthaelt Skripte zur Verwaltung von Docker auf Debian und
Ubuntu.

## 01-docker-installation.sh

Installiert Docker Engine und die zugehoerigen Werkzeuge aus dem offiziellen
Docker-APT-Repository.

### Voraussetzungen

- Debian oder Ubuntu mit `VERSION_CODENAME` in `/etc/os-release`
- Eine Netzwerkverbindung
- `sudo` mit administrativen Rechten

### Aufruf

Vom Repository-Hauptverzeichnis aus ausfuehren:

```bash
bash scripts/linux/docker/01-docker-installation.sh
```

Das Skript richtet das offizielle Docker-APT-Repository ein und installiert
Docker Engine, Docker CLI, containerd, Buildx sowie das Docker-Compose-Plugin.
Anschliessend aktiviert und startet es die Docker-Dienste und prueft die
Installation.

Das Skript fuehrt Befehle mit `sudo` aus. Es fuegt den aktuellen Benutzer
nicht zur Gruppe `docker` hinzu. Docker-Befehle benoetigen daher weiterhin
`sudo`, sofern die Gruppenmitgliedschaft nicht separat eingerichtet wird.
