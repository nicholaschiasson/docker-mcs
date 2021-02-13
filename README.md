# mcs

Dockerized minecraft server.

## Usage

### Getting started

The simplest way to get up and running is to use a simple `docker-compose.yml`
file like the following.

```yaml
version: "3.9"
services:
  mcs:
    image: nicholaschiasson/mcs:alpine-3-1.16.5-0.2.0
    ports:
      - "25565:25565"
```

Then you can start the server using `docker-compose` from the directory with
your `docker-compose.yml`.

```bash
docker-compose up -d
```

The version of Minecraft is specified in the image tag. The tag is composed of
four segments of the following format:

```
{BASE_IMAGE}-{BASE_IMAGE_VERSION}-{MINECRAFT_VERSION}-{IMAGE_VERSION}
```

Thus, for the above example, we are running the container on a distribution of
`alpine` linux, version `3`, with Minecraft server version `1.16.5`, and on release
`0.2.0` of this project.

Refer to [the docker hub page](https://hub.docker.com/repository/docker/nicholaschiasson/mcs/tags)
to view supported versions of minecraft.

If you would like support for more Minecraft versions or more platforms for the
image, please open an issue or pull request.

### Configuration

#### Server properties

You inject your own `server.properties` by mounting the file in your
`docker-compose.yml` file.

```yaml
version: "3.9"
services:
  mcs:
    image: nicholaschiasson/mcs:alpine-3-1.16.5-0.2.0
    ports:
      - "25565:25565"
    volumes:
      - ./server.properties:/etc/mcs/server.properties:ro
```

Using the `server.properties` file, you can specify the port the Minecraft
server listens on. If you use a different port, make sure to also update the
port binding in the `docker-compose.yml` file.

Also, it is a good idea to make the mounted `server.properties` file read only,
hence the addition of `:ro` in our above example. You may know that the
Minecraft server tries to overwrite the `server.properties` file that it reads,
but making our mounted file read only will not impact this since the container
tries copying `/etc/mcs/server.properties` to `/root/server.properties` before
launching the server, and it is the latter file which is read into the server.

#### Java memory allocation

By default, the container will run the JVM with an initial memory allocation
pool of `1024M` and a maximum memory allocation pool of `1024M`.

These values can be overriden via environment variables.

In your `docker-compose.yml` file, add an `environment` section to update the
values for `JAVA_INITIAL_MEMORY_ALLOCATION_POOL` and
`JAVA_MAXIMUM_MEMORY_ALLOCATION_POOL`.

```yaml
version: "3.9"
services:
  mcs:
    image: nicholaschiasson/mcs:alpine-3-1.16.5-0.2.0
    environment:
      JAVA_INITIAL_MEMORY_ALLOCATION_POOL: 512M
      JAVA_MAXIMUM_MEMORY_ALLOCATION_POOL: 4G
    ports:
      - "25565:25565"
    volumes:
      - ./server.properties:/etc/mcs/server.properties:ro
```

### Persistent data

You probably want to save your world to be able to stop and restart the server.

You can do this by mounting a directory to `/run/mcs`, which is the universe
directory inside the image.

Create a `data/` directory in the same directory as your `docker-compose.yml`
file and then update the `volumes` section of `docker-compose.yml` like so:

```yaml
version: "3.9"
services:
  mcs:
    image: nicholaschiasson/mcs:alpine-3-1.16.5-0.2.0
    environment:
      JAVA_INITIAL_MEMORY_ALLOCATION_POOL: 512M
      JAVA_MAXIMUM_MEMORY_ALLOCATION_POOL: 4G
    ports:
      - "25565:25565"
    volumes:
      - ./data:/run/mcs:rw
      - ./server.properties:/etc/mcs/server.properties:ro
```

Using this `docker-compose.yml` file, you will be able to configure the server
using your own `server.properties` file, and you will also be able to backup
your world.

## Operating

### Build

If you have cloned this repository and want to build the image, you can use the
supplied `docker-compose.yml` file.

```bash
docker-compose build
```

### Start

```bash
docker-compose up -d
```

### Stop

```bash
docker-compose down
```

### Attach

```bash
docker-compose exec mcs bash
```

### Logs

```bash
docker-compose logs -f
```

