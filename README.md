## Build image
```
$ docker build . \
  -t francium/gitea:[tag]
  --build-arg ARCH=[arch]
  --build-arg VERSION=[version]
```
Where `[xxx]` specifies tag name, host architecture and version to download. **The
docker-compose.yml file make use of the `latest` tag by default.

## Run
```
$ docker-compose up -d
```

To use Git over SSH, Gitea's builtin SSH server can be turned on by editing
the `app.ini` in the `gitea` volume either through
`/var/lib/docker/volumes/docker-gitea_gitea/_data/etc/gitea/app.ini` on the host
or by `docker-compose exec server /bin/bash` and editing the
`/etc/gitea/app.ini`. Do this after going through the setup process (via the web
interface) after first creating the docker container.
```
  [server]
  ...
+ SSH_PORT=2222          # This can be configured through the web interface during the
                         # setup process too
+ START_SSH_SERVER=true
```
Afterwards make sure to add your GPG key(s) via the user settings page.


## Backup gitea data
**Make sure `./mount` (in this repo) has permission set so that the script inside the
container can write to it when it is mounted inside the container. `chmod 777 mount`
should suffice.**
```
$ docker-compose exec server /gitea/backup.sh
```
Where `server` is the name of the service running gitea.
This will produce a timestamped zip file containing all the gitea data in the `./mount`
directory in this repo.
