############################
# Stage 1: Runtime
############################
FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

############################
# Metadata
############################
LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="A user-friendly PHP Looking Glass - Reloaded" \
      org.opencontainers.image.documentation="https://github.com/wydler/LookingGlass-Docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/wydler/LookingGlass-Docker" \
      org.opencontainers.image.title="lookingglass-iperf" \
      org.opencontainers.image.url="https://hub.docker.com/r/wydler/lookingglass-iperf"

#############################################
# Runtime dependencies
#############################################
RUN apk add --no-cache \
      iperf3 \
  && rm -rf /var/cache/apk/*

############################
# Security hardening
# - create non-root user
# - no home directory
# - no login shell
############################
RUN adduser -D -H -s /sbin/nologin iperf

############################
# Switch to non-root user
############################
USER iperf
    
############################
# iperf3 default port
# TCP + UDP server port
############################
EXPOSE 5201/tcp 5201/udp

############################
# Entrypoint
# Allows: docker run image <args>
# Keeps image flexible
############################
ENTRYPOINT ["iperf3"]

############################
# Healthcheck
# IMPORTANT:
# We avoid network loopback tests (unreliable in containers)
# Instead we check if process is running
############################
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD pgrep iperf3 > /dev/null || exit 1

# iperf3 -s = run in Server mode
CMD ["-s"]
