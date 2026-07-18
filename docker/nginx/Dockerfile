############################
# Stage 1: Runtime
############################
FROM nginx:1.31.2@sha256:b5a9a3cfc86b81dd6f1458d53f2ad2b559cc255653d2efd6cacee5636bf2066f

############################
# Metadata
############################
LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="A user-friendly PHP Looking Glass - Reloaded" \
      org.opencontainers.image.documentation="https://github.com/wydler/LookingGlass-Docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/wydler/LookingGlass-Docker" \
      org.opencontainers.image.title="lookingglass-web" \
      org.opencontainers.image.url="https://hub.docker.com/r/wydler/lookingglass-web"

############################
# Install dependencies
############################
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sqlite3 \
    git \
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
