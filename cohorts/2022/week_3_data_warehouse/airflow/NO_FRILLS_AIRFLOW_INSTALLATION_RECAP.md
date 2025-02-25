# Airflow Installation and Implementation Recap

## Project Structure
```
airflow/
├── dags/               # DAG files
├── docs/               # Documentation
├── scripts/            # Support scripts
├── docker-compose*.yml # Docker configurations
└── setup scripts      # Installation helpers
```

## Installation Methods
1. **Docker Setup (Production-like)**
   - Uses docker-compose-nofrills.yml
   - Maintains isolation and service orchestration
   - Recommended for actual pipeline execution

2. **Local Setup (Development)**
   - Uses virtual environment
   - Supports quick testing and debugging
   - Good for DAG development

## Environment Variables
- AIRFLOW_HOME: Points to project directory
- AIRFLOW_VERSION: 2.10.5
- AIRFLOW_UID: 50000

## Key Files
1. **Setup Files**
   - setup.sh
   - no_frills_airflow_setup.sh
   - no_frills_airflow_setup.py

2. **Configuration**
   - .env
   - docker-compose-nofrills.yml

3. **Support**
   - scripts/entrypoint.sh

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
