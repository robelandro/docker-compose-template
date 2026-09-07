# SonarQube Local Scanning Guide

A comprehensive guide for analyzing projects on your local SonarQube instance across major frameworks: **Node.js**, **NestJS**, **Next.js**, **React**, and **Java (Maven/Gradle)**.

---

## 1. SonarQube Instance Details

- **Web Dashboard**: [http://localhost:9000](http://localhost:9000)
- **Default Username**: `admin`
- **Default Password**: `12340987@Nft` *(or your configured password)*
- **Authentication Token**:
  - Generate a token in the UI: **User Avatar (top right) > My Account > Security > Generate Token** (Type: *Global Analysis Token* or *Project Analysis Token*).
  - Example token placeholder:
    ```text
    YOUR_SONAR_TOKEN
    ```

---

## 2. Universal Scanning Methods for JavaScript / TypeScript

For any JavaScript or TypeScript project, there are two primary ways to run scans locally:

### Option A: Using `npx sonar-scanner` (Zero Installation)
Run directly inside any project folder:
```bash
npx sonar-scanner \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=YOUR_SONAR_TOKEN \
  -Dsonar.projectKey=my-project \
  -Dsonar.projectName="My Project" \
  -Dsonar.sources=src
```

### Option B: Using `sonar-project.properties` (Recommended)
Create a `sonar-project.properties` file in your project root, then simply run `npx sonar-scanner`:

```properties
sonar.host.url=http://localhost:9000
sonar.token=YOUR_SONAR_TOKEN
sonar.projectKey=my-project
sonar.projectName=My Project
sonar.sources=src
sonar.sourceEncoding=UTF-8
sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**,**/coverage/**
```

---

## 3. Framework-Specific Guides

### 🟦 NestJS

NestJS projects typically have source files in `src/`, unit/e2e tests in `test/`, and build artifacts in `dist/`.

#### 1. Create `sonar-project.properties` in project root:
```properties
sonar.host.url=http://localhost:9000
sonar.token=YOUR_SONAR_TOKEN
sonar.projectKey=my-nestjs-app
sonar.projectName=My NestJS App

# Source & Test paths
sonar.sources=src
sonar.tests=test
sonar.test.inclusions=**/*.spec.ts,**/*.test.ts,test/**/*.ts

# Exclusions
sonar.exclusions=**/node_modules/**,dist/**,coverage/**

# Test Coverage (Jest LCOV)
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

#### 2. Run Tests with Coverage & Scan:
```bash
# Generate coverage with Jest
npm run test:cov

# Run SonarQube scanner
npx sonar-scanner
```

---

### ⬛ Next.js (App Router & Pages Router)

Next.js projects contain build directories (`.next`, `out`), static files (`public`), and code in `app`, `pages`, `components`, or `src`.

#### 1. Create `sonar-project.properties` in project root:
```properties
sonar.host.url=http://localhost:9000
sonar.token=YOUR_SONAR_TOKEN
sonar.projectKey=my-nextjs-app
sonar.projectName=My Next.js App

# Sources (adapt if you do not use src/)
sonar.sources=src,pages,app,components

# Exclusions (exclude build output, public assets, and cache)
sonar.exclusions=**/.next/**,**/out/**,**/node_modules/**,**/public/**,**/coverage/**,next.config.js

# Test paths and coverage (if using Jest or Vitest)
sonar.test.inclusions=**/*.test.tsx,**/*.test.ts,**/*.spec.tsx,**/*.spec.ts
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

#### 2. Run Scan:
```bash
# Optional: run tests with coverage first
npm run test -- --coverage

# Scan project
npx sonar-scanner
```

---

### ⚛️ React (Vite or Create React App)

React projects feature JSX/TSX components, styles, and bundler outputs (`dist` or `build`).

#### 1. Create `sonar-project.properties` in project root:
```properties
sonar.host.url=http://localhost:9000
sonar.token=YOUR_SONAR_TOKEN
sonar.projectKey=my-react-app
sonar.projectName=My React App

# Sources
sonar.sources=src

# Exclusions
sonar.exclusions=**/node_modules/**,dist/**,build/**,coverage/**,vite.config.ts

# Test files and coverage
sonar.test.inclusions=src/**/*.test.tsx,src/**/*.test.ts,src/**/*.spec.tsx,src/**/*.spec.ts
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

#### 2. Run Tests with Coverage & Scan:
```bash
# Run Vitest/Jest with coverage
npm run test -- --coverage

# Run scan
npx sonar-scanner
```

---

### 🟩 Node.js (Express, Fastify, or Vanilla Backend)

#### 1. Create `sonar-project.properties` in project root:
```properties
sonar.host.url=http://localhost:9000
sonar.token=YOUR_SONAR_TOKEN
sonar.projectKey=my-node-service
sonar.projectName=My Node Service

# Sources & Tests
sonar.sources=src
sonar.tests=test
sonar.test.inclusions=**/*.test.js,**/*.test.ts,**/*.spec.js,**/*.spec.ts

# Exclusions
sonar.exclusions=**/node_modules/**,coverage/**,dist/**

# Code Coverage
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

#### 2. Scan via `package.json` script (Optional convenience):
Add to your `package.json`:
```json
{
  "scripts": {
    "sonar": "sonar-scanner"
  },
  "devDependencies": {
    "sonarqube-scanner": "^3.5.0"
  }
}
```
Then run:
```bash
npm run sonar
```

---

### ☕ Java (Maven & Gradle)

#### Maven
Run directly from your project directory without installing extra scanners:

```bash
# Standard scan
./mvnw clean compile sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=YOUR_SONAR_TOKEN \
  -Dsonar.projectKey=my-java-service

# With tests and JaCoCo coverage
./mvnw clean verify sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=YOUR_SONAR_TOKEN \
  -Dsonar.projectKey=my-java-service
```

> [!TIP]
> If the `sonar:` prefix fails to resolve, invoke the full plugin goal:
> `org.sonarsource.scanner.maven:sonar-maven-plugin:sonar`

#### Gradle
Add the Sonar plugin to `build.gradle` or `build.gradle.kts`:
```groovy
plugins {
    id "org.sonarqube" version "5.0.0.4638"
}
```
Then run:
```bash
./gradlew sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=YOUR_SONAR_TOKEN \
  -Dsonar.projectKey=my-java-service
```

---

## 4. Universal Docker SonarScanner CLI

If you do not want to install Node.js scanners or Java plugins on your host system, you can analyze **any** project using the official Docker image:

```bash
# Navigate to any project root
cd /path/to/your-project

# Run scanner in Docker
docker run --rm \
  --network host \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=YOUR_SONAR_TOKEN \
  -Dsonar.projectKey=my-project \
  -Dsonar.projectName="My Project" \
  -Dsonar.sources=. \
  -Dsonar.exclusions="**/node_modules/**,**/.next/**,**/dist/**,**/build/**,**/coverage/**,**/target/**"
```

> [!NOTE]
> When running on Linux, `--network host` allows the scanner container to reach `http://localhost:9000` directly.
> If using a bridge network (like `shared-net`), use:
> `-Dsonar.host.url=http://sonarqube:9000 --network shared-net`

---

## 5. Code Coverage Configuration Cheat Sheet

To import test coverage into SonarQube, configure your test runner to emit standard LCOV or JaCoCo reports:

| Language / Framework | Recommended Test Tool | Coverage Output File | Sonar Property |
| :--- | :--- | :--- | :--- |
| **JavaScript / TypeScript** | Jest / Vitest / c8 / nyc | `coverage/lcov.info` | `sonar.javascript.lcov.reportPaths=coverage/lcov.info` |
| **Java (Maven/Gradle)** | JaCoCo | `target/site/jacoco/jacoco.xml` | `sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml` |
| **Python** | pytest-cov | `coverage.xml` | `sonar.python.coverage.reportPaths=coverage.xml` |
| **Go** | go test | `coverage.out` | `sonar.go.coverage.reportPaths=coverage.out` |

---

## 6. Viewing Results

1. Go to [http://localhost:9000](http://localhost:9000).
2. Log in with your credentials.
3. Open your project dashboard to inspect:
   - **Quality Gate Status**: Passed / Failed.
   - **Bugs & Vulnerabilities**: Static security and reliability issues.
   - **Security Hotspots**: Code areas requiring manual review.
   - **Code Smells & Technical Debt**: Maintainability indicators.
   - **Coverage & Duplications**: Percentage of code covered by automated tests.

---

## 7. Troubleshooting & Common Issues

### Issue 1: SCM Provider Autodetection Failed
```text
WARN: SCM provider autodetection failed. Please use "sonar.scm.provider" to define SCM of your project, or disable the SCM Sensor...
```
- **Cause**: The project directory is not a Git repository (no `.git` directory).
- **Quick Fix**: Add `-Dsonar.scm.disabled=true` to your scan command or `sonar.scm.disabled=true` in `sonar-project.properties`.
- **Permanent Fix**: Initialize git in the project root (`git init && git add . && git commit -m "Initial commit"`).

### Issue 2: Node.js Out of Memory Error during TypeScript Scan
```text
FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
```
- **Fix**: Allocate more memory to the scanner process:
  ```bash
  export NODE_OPTIONS="--max-old-space-size=4096"
  npx sonar-scanner
  ```

### Issue 3: Docker Scanner Cannot Reach `localhost:9000`
- **Cause**: Inside a Docker container, `localhost` refers to the container itself, not your host.
- **Fix (Linux)**: Use `--network host` and `-Dsonar.host.url=http://localhost:9000`.
- **Fix (Docker Network)**: Connect the scanner container to `shared-net` and use `-Dsonar.host.url=http://sonarqube:9000`.

### Issue 4: Java Class Files Not Found (Java Projects)
```text
Please provide compiled classes of your project with sonar.java.binaries
```
- **Fix**: Compile the code first before scanning:
  - Maven: `./mvnw compile` or `./mvnw package`
  - Gradle: `./gradlew classes`
