# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG APP_VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"
LABEL org.opencontainers.image.source="https://github.com/thespad/docker-twitfix"
LABEL org.opencontainers.image.url="https://github.com/thespad/docker-twitfix"
LABEL org.opencontainers.image.description="A basic flask server that serves fixed twitter video embeds to desktop discord by using either the Twitter API or Youtube-DL to grab tweet video information"

ENV S6_STAGE2_HOOK="/init-hook" \
  PYTHONIOENCODING=utf-8 \
  VIRTUAL_ENV=/pyenv \
  PATH="/pyenv/bin:$PATH"

RUN \
  apk add -U --no-cache --virtual=build-dependencies \
    build-base \
    libjpeg-turbo-dev \
    python3-dev \
    zlib-dev && \
  apk add -U --no-cache \
    python3 \
    uwsgi \
    uwsgi-python3 && \
  echo "**** install twitfix ****" && \
  mkdir -p /app/twitfix && \
  if [ -z ${APP_VERSION+x} ]; then \
    APP_VERSION=$(curl -sL "https://api.github.com/repos/dylanpdx/BetterTwitFix/commits/main" \
    | jq -r 'first(.[])' | cut -c1-8); \
  fi && \
  curl -s -o \
    /tmp/twitfix.tar.gz -L \
    "https://github.com/dylanpdx/BetterTwitFix/archive/${APP_VERSION}.tar.gz" && \
  tar xf \
    /tmp/twitfix.tar.gz -C \
    /app/twitfix/ --strip-components=1 && \
  echo "**** install pip packages ****" && \
  mkdir -p /pyenv && \
  python3 -m venv /pyenv && \
  cd /app/twitfix && \
  pip install -U --no-cache-dir \
    pip \
    requests \
    wheel && \
  pip install --no-cache-dir --find-links "https://wheel-index.linuxserver.io/alpine-3.18/" -r requirements.txt && \
  apk del --purge build-dependencies && \
  rm -rf \
    /tmp/*

COPY root/ /

EXPOSE 80

VOLUME /config