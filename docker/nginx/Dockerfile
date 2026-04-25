############################
# Stage 1: Runtime
############################
FROM nginx:1.29.8

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
# Entrypoint scripts
############################
COPY --chmod=755 /docker/nginx/99-lookingglass-config.sh /docker-entrypoint.d/

############################
# Start Nginx in foreground mode
############################
CMD ["nginx", "-g", "daemon off;"]
