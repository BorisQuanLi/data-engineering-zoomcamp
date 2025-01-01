

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

docker pull postgres:13
docker run --name pgsql-dev -e POSTGRES_PASSWORD=password -p 5432:5432 postgres