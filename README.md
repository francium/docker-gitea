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

## Backup gitea data
**Make sure `./mount` (in this repo) has permission set so that the script inside the
container can write to it when it is mounted inside the container. `chmod 777 mount`
should suffice.**
```
$ docker-compose exec -it server /gitea/backup.sh
```
Where `server` is the name of the service running gitea.
This will produce a timestamped zip file containing all the gitea data in the `./mount`
directory in this repo.
