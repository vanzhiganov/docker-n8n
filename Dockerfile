FROM docker.io/tiredofit/nginx:latest
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Defaults
ENV N8N_VERSION=0.171.0 \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    NGINX_WEBROOT=/app \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    IMAGE_NAME="tiredofit/n8n" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-n8n/"

### Install Runtime Dependencies
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .n8n-build-deps \
               build-base \
               python3 \
               && \
    \
    apk add -t .n8n-run-deps \
               graphicsmagick \
               nodejs \
               npm \
               && \
    \
    mkdir -p /app && \
    npm_config_user=root npm install -g n8n@${N8N_VERSION} && \
    \
### Misc & Cleanup
    apk del .n8n-build-deps && \
    rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app/

### Networking Configuration
EXPOSE 5678

### Add Files
ADD install /
