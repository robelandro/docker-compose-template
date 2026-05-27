# GitLab Runner Setup Guide

This project now includes a working local GitLab Runner connected to the GitLab instance in `docker-compose.yml`.

## What is already configured

The compose stack includes:

- A `gitlab` service with `external_url 'http://gitlab.local'`
- A Docker network alias so other containers can resolve `gitlab.local`
- A `gitlab-runner` service using `gitlab/gitlab-runner:latest`
- A persistent runner config mount at `./runner-config`
- A Docker socket mount at `/var/run/docker.sock` so CI jobs can use Docker

Current compose shape:

```yaml
services:
  gitlab:
    hostname: gitlab.local
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.local'
    networks:
      default:
        aliases:
          - gitlab.local

  gitlab-runner:
    image: gitlab/gitlab-runner:latest
    volumes:
      - ./runner-config:/etc/gitlab-runner
      - /var/run/docker.sock:/var/run/docker.sock
```

## Step 1: Start the stack

```bash
docker compose up -d
```

Check that both containers are running:

```bash
docker compose ps
```

You should see:

- `gitlab` running and healthy
- `gitlab-runner` running

## Step 2: Get a runner token from GitLab

In GitLab, create a runner and copy the runner authentication token.

Example token format:

```text
glrt-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## Step 3: Register the runner

Use a non-interactive registration command like this:

```bash
docker compose exec -T gitlab-runner gitlab-runner register \
  --non-interactive \
  --url http://gitlab.local \
  --token YOUR_RUNNER_TOKEN \
  --executor docker \
  --docker-image alpine:latest \
  --description docker-runner
```

Why these values matter:

- `--url http://gitlab.local`: matches the GitLab `external_url`
- `--executor docker`: runs CI jobs in Docker containers
- `--docker-image alpine:latest`: default image for jobs that do not specify one
- `--description docker-runner`: friendly runner name shown in GitLab

## Step 4: Verify the registration

```bash
docker compose exec -T gitlab-runner gitlab-runner verify
```

If it worked, you should see output similar to:

```text
Verifying runner... is valid
```

## Step 5: Confirm the saved runner config

Inspect the runner config inside the container:

```bash
docker compose exec -T gitlab-runner sed -n '1,220p' /etc/gitlab-runner/config.toml
```

Important parts to check:

```toml
[[runners]]
  url = "http://gitlab.local"
  executor = "docker"

  [runners.docker]
    image = "alpine:latest"
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
```

That Docker socket mount is important if your CI jobs need Docker commands.

## Step 6: Restart the runner after config changes

If you edit `config.toml`, restart the runner:

```bash
docker compose restart gitlab-runner
```

Then verify again:

```bash
docker compose exec -T gitlab-runner gitlab-runner verify
```

## Common problems

### Runner cannot reach GitLab

Cause:

- `gitlab.local` is set as the GitLab `external_url`, but the runner container cannot resolve that hostname

Fix:

- Make sure the `gitlab` service has this network alias:

```yaml
networks:
  default:
    aliases:
      - gitlab.local
```

### Docker jobs fail inside CI

Cause:

- The runner can start, but job containers cannot access Docker

Fix:

- Make sure both places include the Docker socket:

In `docker-compose.yml`:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

In `/etc/gitlab-runner/config.toml`:

```toml
volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
```

### Registration succeeds but jobs do not run

Check:

- The runner is enabled in GitLab
- The runner is allowed for the project or group you want
- The runner tags match your `.gitlab-ci.yml`, if tags are used
- `docker compose exec -T gitlab-runner gitlab-runner verify` still reports valid

## Useful commands

Start services:

```bash
docker compose up -d
```

View status:

```bash
docker compose ps
```

Register runner:

```bash
docker compose exec -T gitlab-runner gitlab-runner register --non-interactive --url http://gitlab.local --token YOUR_RUNNER_TOKEN --executor docker --docker-image alpine:latest --description docker-runner
```

Verify runner:

```bash
docker compose exec -T gitlab-runner gitlab-runner verify
```

Show runner config:

```bash
docker compose exec -T gitlab-runner sed -n '1,220p' /etc/gitlab-runner/config.toml
```

Restart runner:

```bash
docker compose restart gitlab-runner
```
