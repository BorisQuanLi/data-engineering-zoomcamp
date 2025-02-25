# Setup

## Local Setup
// ...existing code...

## Docker Setup

### Prerequisites
- Docker and Docker Compose installed
- Git (to clone the repository)

### Steps
1. Set environment variables:
```bash
export AIRFLOW_VERSION=2.10.5
export AIRFLOW_HOME=$(pwd)/airflow
export AIRFLOW_UID=50000
```

2. Create the directory structure:
```bash
mkdir -p ${AIRFLOW_HOME}/dags
mkdir -p ${AIRFLOW_HOME}/logs
mkdir -p ${AIRFLOW_HOME}/plugins
```

3. Download the docker-compose file:
```bash
curl -LfO 'https://raw.githubusercontent.com/apache/airflow/2.10.5/docker-compose.yaml'
```

4. Start Airflow:
```bash
docker-compose up
```

Access the Airflow UI at http://localhost:8080 (default credentials: airflow/airflow)

// ...existing code...
