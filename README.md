# Datastax VS Code

Built by the Appsembler team, for Datastax. A custom implementation of
"[code-server](https://github.com/cdr/code-server)", which is a VSCode
implementation that allows the user to "Run VS Code on any machine anywhere and
access it in the browser."  The base Docker image is maintained by
[linuxser.io](https://hub.docker.com/r/linuxserver/code-server) folks.

# Configuration 

All the configuration is in the `/root/` directory of this repo.  That directory
is copied to the location where this implementation of `code-server` looks for
it. See `/root/etc/serviced.d/code-server/run` for the command that starts the
server and dictates the configuration storage location. 

- User config: see `/root/config/data/User/settings.json`
- Workspace config: see `/root/config/workspace/.vscode/settings.json`
- bash profile: see `/root/config/.profile` and `/root/config/.bashrc`.  These
  files are sourced when a VSCode termnial starts

These config files are **not** synced to the container, so you'll need to rebuild on
each config change.  Alternatively, you could mount a volume by running with:

```
--volume ./root /config 
```

But see the caveats in the "User / Group Identifiers" section of the
[docs](https://hub.docker.com/r/linuxserver/code-server).  You'll need to
discern your host PUID and PGID and pass them to `docker run`. 

(We have not tested the volume-mounting approach.)

# Features 

1. When the editor opens, we open a terminal
2. Code Tours is installed by default
3. The `tik-tok` GitHub repo is pulled and placed in the workspace

## Extensions

We install two plugins, both of which are stored in this repo: 

- `/root/config/extensions/gabrielgrinberg.auto-run-command-1.5.0/`: The
  automatically run commands from the user config (settings.json)
- `/root/config/extensions/vsls-contrib.codetour-0.0.31/`: Code Tour 

# Build the image and run the container

*For the full docs on how to run the underlying container, see the
[linuxserver.io Docker Hub page, in the the "Usage"
section](https://hub.docker.com/r/linuxserver/code-server).*

## Build it

```
docker build -t IMAGE_NAME:TAG .
```

## Run it 

```
docker run -d \
  --name=code-server \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e PASSWORD=password `#optional` \
  -e HASHED_PASSWORD= `#optional` \
  -e SUDO_PASSWORD=password `#optional` \
  -e SUDO_PASSWORD_HASH= `#optional` \
  -e PROXY_DOMAIN=code-server.my.domain `#optional` \
  -p 8443:8443 \
  -v /path/to/appdata/config:/config \
  --restart unless-stopped \
  IMAGE_NAME:TAG
```
