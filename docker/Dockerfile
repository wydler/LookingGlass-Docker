############################
# Stage 1: LookingGlass source
############################
FROM --platform=$BUILDPLATFORM nginx:1.31.9@sha256:84f7876d21d154885f99554d7ae325d8c2213f9169726ea7ab60642f2573a787 AS lookingglass-source

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

COPY docker/lookingglass.version /tmp/lookingglass.version
RUN git clone --depth 1 --branch "$(cat /tmp/lookingglass.version)" https://github.com/wydler/LookingGlass.git /usr/src/lookingglass

############################
# Stage 2: Nginx web image
############################
FROM nginx:1.31.9@sha256:84f7876d21d154885f99554d7ae325d8c2213f9169726ea7ab60642f2573a787 AS web

LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="A user-friendly PHP Looking Glass - Reloaded" \
      org.opencontainers.image.documentation="https://github.com/wydler/LookingGlass-Docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/wydler/LookingGlass-Docker" \
      org.opencontainers.image.title="lookingglass-web" \
      org.opencontainers.image.url="https://hub.docker.com/r/wydler/lookingglass-web"

RUN apt-get update \
    && apt-get install -y --no-install-recommends sqlite3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=lookingglass-source /usr/src/lookingglass/ /var/www/html/

RUN rm -f /var/www/html/index.html \
    && mkdir -p /var/lib/lookingglass \
    && ln -s /var/lib/lookingglass/Config.php /var/www/html/LookingGlass/Config.php \
    && ln -s /var/lib/lookingglass/ratelimit.db /var/www/html/LookingGlass/ratelimit.db

COPY rootfs/nginx/etc/nginx/ /etc/nginx/
COPY --chmod=755 rootfs/docker-entrypoint.d/ /docker-entrypoint.d/

CMD ["nginx", "-g", "daemon off;"]

############################
# Stage 3: PHP-FPM image
############################
FROM php:8.4.28-fpm@sha256:89598ce2b089ebe8dd3772f7188a2d47300145fbcea6578de2db96c8e8f026bb AS php

LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="A user-friendly PHP Looking Glass - Reloaded" \
      org.opencontainers.image.documentation="https://github.com/wydler/LookingGlass-Docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/wydler/LookingGlass-Docker" \
      org.opencontainers.image.title="lookingglass-php" \
      org.opencontainers.image.url="https://hub.docker.com/r/wydler/lookingglass-php"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        net-tools \
        host \
        mtr \
        iputils-ping \
        traceroute \
        locales \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install -j"$(nproc)" gettext

COPY --from=lookingglass-source /usr/src/lookingglass/ /var/www/html/

RUN mkdir -p /var/lib/lookingglass \
    && ln -s /var/lib/lookingglass/Config.php /var/www/html/LookingGlass/Config.php \
    && ln -s /var/lib/lookingglass/ratelimit.db /var/www/html/LookingGlass/ratelimit.db

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

RUN locale-gen de_DE.UTF-8 en_US.UTF-8
