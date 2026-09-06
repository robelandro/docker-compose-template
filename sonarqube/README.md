# SonarQube Docker Compose Template

This directory contains the Docker Compose setup for **SonarQube Community Edition**, configured to use the existing PostgreSQL database container over the `shared-net` bridge network.

## Prerequisites

- Existing Docker network: `shared-net`
- Existing PostgreSQL container named `postgres` running on `shared-net`

## Database Initialization (for Fresh PostgreSQL)

If you are setting this up on a fresh PostgreSQL instance, run the following SQL commands to create the dedicated database and user:

### 1. SQL Commands
```sql
-- 1. Create dedicated user
CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar';

-- 2. Create dedicated database with UTF-8 encoding owned by sonar
CREATE DATABASE sonarqube OWNER sonar ENCODING 'UTF8';

-- 3. Grant database privileges
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;

-- 4. (For PostgreSQL 15+) Ensure schema permissions
\connect sonarqube
GRANT ALL ON SCHEMA public TO sonar;
```

### 2. Quick One-Liner (via Docker)
Execute directly into your running PostgreSQL container (replace `postgres` with your container name and `keycloak` or `postgres` with your superuser):

```bash
docker exec -i postgres psql -U postgres -c "CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar';" \
  -c "CREATE DATABASE sonarqube OWNER sonar ENCODING 'UTF8';" \
  -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;"
```

---

## Configuration

Environment variables can be adjusted in [`.env`](./.env) (or refer to [`.env.example`](./.env.example)):

| Variable | Default Value | Description |
| :--- | :--- | :--- |
| `SONARQUBE_IMAGE` | `sonarqube:community` | Docker image tag for SonarQube |
| `SONARQUBE_PORT` | `9000` | Host port mapped to SonarQube web UI |
| `POSTGRES_HOST` | `postgres` | Container/Host name of PostgreSQL on `shared-net` |
| `POSTGRES_PORT` | `5432` | PostgreSQL port |
| `POSTGRES_DB` | `sonarqube` | Database name for SonarQube |
| `POSTGRES_USER` | `sonar` | Database username |
| `POSTGRES_PASSWORD` | `sonar` | Database password |

## Usage

Start SonarQube in detached mode:
```bash
docker compose up -d
```

Check status and logs:
```bash
docker compose ps
docker compose logs -f
```

Stop SonarQube:
```bash
docker compose down
```

## Accessing the Web UI

- **URL**: [http://localhost:9000](http://localhost:9000)
- **Credentials**:
  - Username: `admin`
  - Password: `12340987@Nft`

## Scanning Local Projects

For a full step-by-step guide on analyzing projects (including Maven/Spring Boot projects like `kyc-backend`), see [**`SoonerLocalGuide.md`**](./SoonerLocalGuide.md).
