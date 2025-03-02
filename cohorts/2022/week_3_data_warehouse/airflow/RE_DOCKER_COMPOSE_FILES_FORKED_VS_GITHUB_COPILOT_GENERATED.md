# Docker Compose Configurations for Airflow

This directory contains different Docker Compose configurations for Apache Airflow:

1. `docker-compose.yaml`: The full configuration from Apache Airflow
   - Includes all components (Redis, Celery workers, Triggerer, Flower)
   - Uses CeleryExecutor
   - Best for production-like environments

2. `simplified_docker_compose_by_github_copliot.md`: A streamlined configuration
   - Removes Redis and Celery components
   - Adds custom scripts volume
   - Uses LocalExecutor
   - Good for development with custom scripts

Choose the configuration that best matches your needs:
- Learning/Development: Use `simplified_docker_compose_by_github_copliot.md`
- Production-like setup: Use `docker-compose.yaml`
