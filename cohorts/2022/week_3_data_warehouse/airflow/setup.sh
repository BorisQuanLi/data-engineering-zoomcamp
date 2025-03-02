#!/bin/bash

# Load environment variables
set -a
source .env
set +a

# Ensure Python version is supported
PYTHON_VERSION="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"

# Install Airflow with constraints
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip3 install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Create only logs directory if it doesn't exist
# Note: dags and plugins directories should already exist
mkdir -p "${AIRFLOW_HOME}/logs"
