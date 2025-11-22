# Ubuntu Docker image using Docker compose

## Build

```
docker compose build
```

## Run

Start the container in the background:

```
docker compose up -d
```

Check that it is running:

```
docker ps
```

## Connect

via SSH:

```
ssh dev@localhost -p 2222
```

- Username: `dev`
- Password: `dev`

via Docker shell:

```
docker compose exec ubuntu-server bash
```
