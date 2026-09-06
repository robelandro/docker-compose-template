# SonarQube Local Scanning Guide

This guide explains how to analyze local projects using your local SonarQube instance, with a dedicated walkthrough for **`kyc-backend`** (`/home/nfta/Desktop/zam/kyc/kyc-backend`).

---

## 1. SonarQube Instance Details

- **Web Dashboard**: [http://localhost:9000](http://localhost:9000)
- **Admin Username**: `admin`
- **Admin Password**: `12340987@Nft`
- **Pre-generated Token**:
  ```text
  squ_6f9f4405c18f79b35e5db7f01c7e0f7b77f30c34
  ```

---

## 2. Scanning `/home/nfta/Desktop/zam/kyc/kyc-backend`

### Method 1: Using the Maven Wrapper (Recommended)

Because Maven plugin groups have now been configured in your `~/.m2/settings.xml`, the `sonar:` prefix is resolved automatically.

1. Open your terminal in the project directory:
   ```bash
   cd /home/nfta/Desktop/zam/kyc/kyc-backend
   ```

2. Run the scan:
   ```bash
   ./mvnw clean compile sonar:sonar \
     -Dsonar.host.url=http://localhost:9000 \
     -Dsonar.token=squ_6f9f4405c18f79b35e5db7f01c7e0f7b77f30c34
   ```

> [!NOTE]
> If you ever run this on another machine without `~/.m2/settings.xml` configured, you can use the fully-qualified plugin name directly:
> ```bash
> ./mvnw clean compile org.sonarsource.scanner.maven:sonar-maven-plugin:sonar \
>   -Dsonar.host.url=http://localhost:9000 \
>   -Dsonar.token=squ_6f9f4405c18f79b35e5db7f01c7e0f7b77f30c34
> ```

---

### Method 2: Including Tests and Code Coverage

If you want to run tests and import coverage into SonarQube:

```bash
./mvnw clean verify sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=squ_6f9f4405c18f79b35e5db7f01c7e0f7b77f30c34
```

---

### Method 3: Using the Official Docker SonarScanner CLI

If you prefer running through Docker:

```bash
# 1. Compile the classes first
./mvnw clean compile

# 2. Run the scanner container attached to shared-net
docker run --rm \
  --network shared-net \
  -v /home/nfta/Desktop/zam/kyc/kyc-backend:/usr/src \
  sonarsource/sonar-scanner-cli \
  -Dsonar.projectKey=kyc-backend \
  -Dsonar.projectName="KYC Backend" \
  -Dsonar.sources=src/main \
  -Dsonar.java.binaries=target/classes \
  -Dsonar.host.url=http://sonarqube:9000 \
  -Dsonar.token=squ_6f9f4405c18f79b35e5db7f01c7e0f7b77f30c34
```

---

## 3. Viewing Results

1. Go to [http://localhost:9000](http://localhost:9000).
2. Log in (`admin` / `12340987@Nft`).
3. Click on the project (e.g. `KYC` / `kyc-backend`) on the homepage to explore:
   - **Bugs & Vulnerabilities**
   - **Security Hotspots**
   - **Code Smells & Debt**
   - **Quality Gate** rating

---

## 5. Troubleshooting & Common Warnings

### SCM provider autodetection failed
```text
SCM provider autodetection failed. Please use "sonar.scm.provider" to define SCM of your project, or disable the SCM Sensor in the project settings.
```

**Why it occurs**:
SonarQube uses SCM (Git/SVN) to determine file authors (`git blame`), commit history, and "New Code" periods. This warning appears when the project folder is not a Git repository (no `.git` directory exists).

**Solution A: Disable the SCM sensor** (quickest):
Add `-Dsonar.scm.disabled=true` to your scan command:
```bash
./mvnw clean compile sonar:sonar \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=squ_6f9f4405c18f79b35e5db7f01c7e0f7b77f30c34 \
  -Dsonar.scm.disabled=true
```
*(Or in SonarQube Web UI: Project > **Project Settings** > **SCM** > Toggle **Disable the SCM Sensor** to **ON**)*.

**Solution B: Initialize Git** (if the project will use Git):
```bash
cd /home/nfta/Desktop/zam/kyc/kyc-backend
git init
git add .
git commit -m "Initial commit"
```
After initializing Git, SonarQube will automatically detect Git and display author/blame data for each line.
