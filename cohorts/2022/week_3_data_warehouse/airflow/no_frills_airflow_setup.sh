#!/bin/bash

set -x

# Make the script stop if any command returns non-zero exit status
set -e

# Check for required files
if [ ! -f "Dockerfile" ]; then
    echo "Error: Dockerfile not found"
    exit 1
fi

if [ ! -f "requirements.txt" ]; then
    echo "Error: requirements.txt not found"
    exit 1
fi

# Check if docker-compose.yaml exists, if not download it
if [ ! -f "docker-compose.yaml" ]; then
    wget https://raw.githubusercontent.com/DataTalksClub/data-engineering-zoomcamp/main/week_2_data_ingestion/airflow/docker-compose-nofrills.yml -O docker-compose.yaml
fi

# Create necessary directories
mkdir -p ~/.google/credentials
mkdir -p ./dags ./logs ./plugins

# Set up environment variables for Airflow
echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" > .env

# Start Airflow using docker-compose
# Remove -d flag to see the progress in real-time
docker-compose up --build  # Added --build flag to ensure images are built
