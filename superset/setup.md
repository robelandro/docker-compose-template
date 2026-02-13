docker compose run --rm superset superset db upgrade
docker compose run --rm superset superset fab create-admin \
  --username admin \
  --firstname Admin \
  --lastname User \
  --email admin@example.com \
  --password admin
docker compose run --rm superset superset init


