# FS NPM Registry

> Spin up your own private NPM registry (sinopia) on a docker container with caching that proxies to npmjs with minimal configuration.

## Tasks
1. `make start` or `make` to start the registry in the background on a docker container.
1. `make backup` to perform a backup that produces a *backup.tar* file.
1. `make restore` to start the registry with the backup file.

## Logging
1. `docker logs npm-registry`. See options with `--help`.

## Configuration
You can modify *config.yaml* directly without restarting the registry. See [docs](https://github.com/rlidwka/sinopia/blob/master/conf/full.yaml) for customization options.

## Local Setup
To use your NPM registry, you can do one of the following:
1. Add the line `registry = http://${npm-registry-ip}:4000/` to your *.npmrc* file. Or,
1. Run `npm set registry http://${npm-registry-ip}:4000/` in your project.
