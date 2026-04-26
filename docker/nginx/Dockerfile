############################
# Stage 1: Runtime
############################
FROM nginx:1.30.0@sha256:1a9ab83e2892b75773978e8d91f42a7a2a0d8bb704959a51ff17c0377481973d

############################
# Metadata
############################
LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="A user-friendly PHP Looking Glass - Reloaded" \
      org.opencontainers.image.documentation="https://github.com/dwydler/LookingGlass-Docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/dwydler/LookingGlass-Docker" \
      org.opencontainers.image.title="lookingglass-web" \
      org.opencontainers.image.url="https://hub.docker.com/r/wydler/lookingglass-web"

############################
# Install dependencies
############################
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

############################
# nginx configuration
# Kopiert die angepasste nginx Konfiguration
# direkt in das Standard nginx config Verzeichnis
############################
COPY rootfs/nginx/etc/nginx/ /etc/nginx/

############################
# Entrypoint scripts
############################
COPY --chmod=755 rootfs/docker-entrypoint.d/ /docker-entrypoint.d/

############################
# Start Nginx in foreground mode
############################
CMD ["nginx", "-g", "daemon off;"]
