############################
# Stage 1: Runtime
############################
FROM php:8.4.21-fpm@sha256:e4b0bad269f6140f4c845593926bfe8668277c085aae0977d9f9ea8117feb605

############################
# Metadata
############################
LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="A user-friendly PHP Looking Glass - Reloaded" \
      org.opencontainers.image.documentation="https://github.com/wydler/LookingGlass-Docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/wydler/LookingGlass-Docker" \
      org.opencontainers.image.title="lookingglass-php" \
      org.opencontainers.image.url="https://hub.docker.com/r/wydler/lookingglass-php"

############################
# System dependencies
############################
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        net-tools \
        host \
        mtr \
        iputils-ping \
        traceroute \
        locales \
    && rm -rf /var/lib/apt/lists/*

############################
# PHP extensions
############################
RUN docker-php-ext-install -j"$(nproc)" gettext

############################
# Locale configuration
############################
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

RUN locale-gen de_DE.UTF-8 en_US.UTF-8