# [thespad/twitfix](https://github.com/thespad/docker-twitfix)

[![GitHub Release](https://img.shields.io/github/release/thespad/docker-twitfix.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-twitfix/releases)
![Commits](https://img.shields.io/github/commits-since/thespad/docker-twitfix/latest?color=26689A&include_prereleases&logo=github&style=for-the-badge)
![Image Size](https://img.shields.io/docker/image-size/thespad/twitfix/latest?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=Size)
[![Docker Pulls](https://img.shields.io/docker/pulls/thespad/twitfix.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/thespad/twitfix)
[![GitHub Stars](https://img.shields.io/github/stars/thespad/docker-twitfix.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-twitfix)
[![Docker Stars](https://img.shields.io/docker/stars/thespad/twitfix.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=stars&logo=docker)](https://hub.docker.com/r/thespad/twitfix)

[![ci](https://img.shields.io/github/workflow/status/thespad/docker-twitfix/Check%20for%20update%20and%20release.svg?labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Check%20For%20Upstream%20Updates)](https://github.com/thespad/docker-twitfix/actions/workflows/call-check-and-release.yml)
[![ci](https://img.shields.io/github/workflow/status/thespad/docker-twitfix/Check%20for%20base%20image%20updates.svg?labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Check%20For%20Baseimage%20Updates)](https://github.com/thespad/docker-twitfix/actions/workflows/call-baseimage-update.yml)
[![ci](https://img.shields.io/github/workflow/status/thespad/docker-twitfix/Build%20Image%20On%20Release.svg?labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Build%20Image)](https://github.com/thespad/docker-twitfix/actions/workflows/call-build-image.yml)

[twitfix](https://github.com/dylanpdx/BetterTwitFix/) Basic flask server that serves fixed twitter video embeds to desktop discord by using either the Twitter API or Youtube-DL to grab tweet video information.

## Supported Architectures

Our images support multiple architectures.

Simply pulling `ghcr.io/thespad/twitfix:latest` should retrieve the correct image for your arch.

The architectures supported by this image are:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | latest |
| arm64 | ✅ | latest |
| armhf | ✅ | latest |

## Application Setup

Webui is accessible at `http://SERVERIP:PORT`

More info at [twitfix](https://github.com/dylanpdx/BetterTwitFix/).

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  twitfix:
    image: ghcr.io/thespad/twitfix:latest
    container_name: twitfix
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - ACCESS_SECRET=12345
      - ACCESS_TOKEN=67890
      - API_KEY=adcdef
      - API_SECRET=ghijkl
      - APPNAME=Twitfix
      - "COLOR=#43B581"
      - DATABASE=mongodb://twitfix_db:27017/twitfix
      - LINK_CACHE=db
      - METHOD=youtube-dl
      - URL=https://twitfix.example.com
    volumes:
      - /path/to/appdata/config:/config
    ports:
      - 80:80
    restart: unless-stopped
```

### docker cli

```shell
docker run -d \
  --name=twitfix \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e ACCESS_SECRET=12345
  -e ACCESS_TOKEN=67890
  -e API_KEY=adcdef
  -e API_SECRET=ghijkl
  -e APPNAME=Twitfix
  -e "COLOR=#43B581"
  -e DATABASE=mongodb://twitfix_db:27017/twitfix
  -e LINK_CACHE=db
  -e METHOD=youtube-dl
  -e URL=https://twitfix.example.com
  -p 80:80 \
  -v /path/to/appdata/config:/config \
  --restart unless-stopped \
  ghcr.io/thespad/twitfix:latest
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 80` | Web GUI |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London |
| `-e ACCESS_SECRET=12345` | Twitter Access Secret (Required if METHOD=api) |
| `-e ACCESS_TOKEN=67890` | Twitter Access Token (Required if METHOD=api) |
| `-e API_KEY=adcdef` | Twitter API Key (Required if METHOD=api) |
| `-e API_SECRET=ghijkl` | Twitter API Secret (Required if METHOD=api) |
| `-e APPNAME=Twitfix` | Name that shows in the Embed title |
| `-e "COLOR=#43B581"` | Embded colour strip |
| `-e DATABASE=mongodb://twitfix_db:27017/twitfix` | Mongodb URI (Required if LINK_CACHE=db) |
| `-e LINK_CACHE=db` | Link caching storage, can be set to `json` or `db` |
| `-e METHOD=youtube-dl` | Video fetch method, can be set to `api` (rate limited), `youtube-dl` (slower), or `hybrid` (try api first then youtube-dl) |
| `-e URL=https://twitfix.example.com` | URL where you're hosting the service |
| `-v /config` | Contains all relevant configuration files. |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```shell
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Support Info

* Shell access whilst the container is running: `docker exec -it twitfix /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f twitfix`

### Image Update Notifications - Diun (Docker Image Update Notifier)

* We recommend [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended or supported.

## Versions

* **09.12.22:** - Rebase to Alpine 3.17.
* **06.06.22:** - Switch to dylanpdx/BetterTwitFix for upstream
* **16.05.22:** - Initial Release.
