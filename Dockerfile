FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.15

# set version label
ARG BUILD_DATE
ARG VERSION
ARG APP_VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"

RUN \
  apk add -U --no-cache --virtual=build-dependencies \
    jq && \
  apk add -U --no-cache \
    curl \
    python3 \
    py3-pillow \
    uwsgi \
    uwsgi-python && \
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
  python3 -m ensurepip && \
  rm -rf /usr/lib/python*/ensurepip && \
  cd /app/twitfix && \
  pip3 install --upgrade \
    pip \
    requests \
    wheel \
    yt-dlp && \
  pip3 install --no-cache-dir --find-links "https://wheel-index.linuxserver.io/alpine-3.15/" -r requirements.txt && \
  apk del --purge build-dependencies && \
  rm -rf \
    /tmp/*

COPY root/ /

EXPOSE 80

VOLUME /config