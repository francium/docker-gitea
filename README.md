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
