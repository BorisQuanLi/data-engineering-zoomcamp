#!/bin/bash

# No-frills Airflow Setup Script
# This script sets up a basic Airflow installation without extra providers or dependencies
# Designed to work with docker-compose-nofrills.yml

# Load environment variables from the minimal .env file
set -a
source .env
set +a

# Ensure Python version is supported by Airflow
PYTHON_VERSION="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"

# Install core Airflow with version constraints
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Create Airflow directory structure
mkdir -p "${AIRFLOW_HOME}/dags"
mkdir -p "${AIRFLOW_HOME}/logs"
mkdir -p "${AIRFLOW_HOME}/plugins"
