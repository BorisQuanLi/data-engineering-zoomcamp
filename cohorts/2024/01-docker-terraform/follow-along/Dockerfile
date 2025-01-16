# The postgres configuration block (at the bottom of this file) uses the template from 
# cohorts/2022/week_2_data_ingestion/airflow/docker-compose_2.3.4.yaml
# as live-demonstrated in https://www.youtube.com/watch?v=2JM-ziJt0WI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=6
# stored in the "Introduction to Docker" section of
# https://github.com/BorisQuanLi/data-engineering-zoomcamp/tree/main/01-docker-terraform
services:
    postgres:
      image: postgres:13
      environment:
        POSTGRES_USER: airflow
        POSTGRES_PASSWORD: airflow
        POSTGRES_DB: airflow
      volumes:
        - postgres-db-volume:/var/lib/postgresql/data
      healthcheck:
        test: ["CMD", "pg_isready", "-U", "airflow"]
        interval: 5s
        retries: 5
      restart: always
  
  # this command kept leading to the postgres docker container automatically shut down.
  docker run -it \
      -e POSTGRES_USER="root" \
      -e POSTGRES_PASSWORD="root" \
      -e POSTGRES_DB="ny_tax" \
      -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgrewql/data \
      -p 5432:5432 \
      postgres:13
  
      # directory path for Linux machine
      # -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgrewql/data \
      # directory path of Windows machine
      # -v c:/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/forked-data-engineering-zoomcamp/data-engineering-zoomcamp/cohorts/2024/01-docker-terraform/follow-along/ny_taxi_postgres_data:/var/lib/postgresql/data
  
  # Following this blog
  # https://medium.com/@sohel/access-postgres-database-running-inside-wsl2-ubuntu-9f5f97a7acc2
  
  # the postgres --version is determined by
  # $ psql --version
  # psql (PostgreSQL) 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)
  
  # Note that, to set the -p option's value, the local folder only works when it is placed 
  # under the WSL2 user's root directory level
  docker run -d \
      --name zoomcamp-postgres-container \
      --label important=true \
      -e POSTGRES_USER="postgres" \
      -e POSTGRES_PASSWORD="root" \
      -e POSTGRES_DB="ny_tax" \
      -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
      -p 5433:5433 \
      zoomcamp-postgres:14
  
  (zoomcamp-data-engineering-venv) boris-ubuntu-22-04@2212-Windows11:/mnt/c/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/forked-data-engineering-zoomcamp/data-engineering-zoomcamp$ pgcli -h localhost -p 5433 -u postgres -d ny_tax
  Password for postgres:
  Server: PostgreSQL 14.15 (Debian 14.15-1.pgdg120+1)
  Version: 4.1.0
  Home: http://pgcli.com
  postgres@localhost:ny_tax>
  
  ## live command-line demo:
  # 3:25, https://www.youtube.com/watch?v=hCAIVe9N0ow&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=8
  
  docker run -it -d \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    --network=pg-network \
    --name pg-admin \
    dpage/pgadmin4
  
  # create an ephemeral network (as long as the host PC is not shut down)
  # 7:45, https://www.youtube.com/watch?v=hCAIVe9N0ow&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=8
  boris-ubuntu-22-04@2212-Windows11:~$ docker network create pg-network
  
  # specify the same network name as the PGAdmin container (docker run command above)
  docker run -d \
      --name zoomcamp-postgres-container-with-network \
      --label important=true \
      -e POSTGRES_USER="postgres" \
      -e POSTGRES_PASSWORD="root" \
      -e POSTGRES_DB="ny_tax" \
      -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
      -p 5433:5433 \
      --network=pg-network \
      zoomcamp-postgres:14

# This Dockerfile sets up a Python environment with necessary dependencies for data processing.
# It uses the official Python 3.10 image and installs wget, curl, pandas, sqlalchemy, and psycopg2.

# Use the official Python image with the matching version
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file into the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Command to run the application
CMD ["python", "upload_data.py"]