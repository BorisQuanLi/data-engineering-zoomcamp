# Minimalist Airflow Setup Guide

## Overview
This guide describes a simplified Airflow setup for local development.

## Quick Setup Steps

1. **Create Project Directory Structure**
```bash
mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > .env
```

2. **Setup Google Credentials**
```bash
mkdir -p ~/.google/credentials
# Move your credentials file to the correct location
mv path/to/your/credentials.json ~/.google/credentials/google_credentials.json
```

3. **Download No-Frills Docker Compose**
```bash
# Use the existing simplified docker-compose file
cp docker-compose-nofrills.yml docker-compose.yaml
```

4. **Create Dockerfile**
```dockerfile
FROM apache/airflow:2.2.3

ENV AIRFLOW_HOME=/opt/airflow

USER root
RUN apt-get update -qq && apt-get install vim -qqq
# git gcc g++ -qqq

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Ref: https://airflow.apache.org/docs/docker-stack/recipes.html

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-u", "-x", "-c"]

ARG CLOUD_SDK_VERSION=322.0.0
ENV GCLOUD_HOME=/home/google-cloud-sdk

ENV PATH="${GCLOUD_HOME}/bin/:${PATH}"

RUN DOWNLOAD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz" \
    && TMP_DIR="$(mktemp -d)" \
    && curl -fL "${DOWNLOAD_URL}" --output "${TMP_DIR}/google-cloud-sdk.tar.gz" \
    && mkdir -p "${GCLOUD_HOME}" \
    && tar xzf "${TMP_DIR}/google-cloud-sdk.tar.gz" -C "${GCLOUD_HOME}" --strip-components=1 \
    && "${GCLOUD_HOME}/install.sh" \
       --bash-completion=false \
       --path-update=false \
       --usage-reporting=false \
       --quiet \
    && rm -rf "${TMP_DIR}" \
    && gcloud --version

WORKDIR $AIRFLOW_HOME

USER $AIRFLOW_UID
```

5. **Start Airflow Services**
```bash
docker-compose up -d
```

## Key Differences from Full Setup
- Uses simplified docker-compose with fewer services
- Minimal configuration
- Focuses on essential components only
- Perfect for development and learning environments

## Common Issues & Solutions

### Permission Issues
If you encounter permission problems:
```bash
sudo chown -R $USER:$USER .
```

### Memory Issues
Ensure Docker has at least 4GB RAM allocated:
- Windows/Mac: Adjust in Docker Desktop settings
- Linux: Check system resources

### Connection Issues
If Airflow can't connect to Postgres:
1. Stop all containers
2. Remove them
3. Start fresh with `docker-compose up -d`

## Best Practices
1. Use project-specific Airflow home
2. Maintain separate dev and prod environments
3. Version control DAGs and configs
4. Keep sensitive data in .env (not in VCS)

## Common Commands
```bash
# Development
airflow standalone

# Production-like
docker-compose -f docker-compose-nofrills.yml up
```
