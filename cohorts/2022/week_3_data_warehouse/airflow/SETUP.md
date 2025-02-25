# No-Frills Airflow Setup Guide

## Important: Development vs Production
This guide describes setting up Airflow in your local virtual environment for development purposes.
For actual data pipeline execution, we'll use the Docker setup defined in `docker-compose-nofrills.yml`.

### Why Two Environments?
- **Local Installation** (this guide):
  - For DAG development and testing
  - Quick iterations using `airflow standalone`
  - IDE integration and debugging

- **Docker Installation** (production-like):
  - Multi-container setup with proper services
  - Closer to production environment
  - Isolated from your system
  - What we'll use for running actual pipelines

## Prerequisites
- Python 3.10+
- pip installed
- Virtual environment activated

## Important Notes
- This setup uses a project-specific Airflow home directory
- If you have a global AIRFLOW_HOME in your ~/.bashrc, consider removing it
- Each project should maintain its own Airflow environment

## Setup Steps

1. Install python-dotenv first:
```bash
pip install python-dotenv
```

2. Set up environment:
   - Copy `.env.example` to `.env`
   - Edit `.env` if needed (default values should work)

3. Choose one of these setup methods:

### Option A: Using Bash Script (Recommended)
```bash
chmod +x setup.sh    # Make script executable (first time only)
./setup.sh           # Run the script
```

### Option B: Using Python Script
```bash
python no_frills_airflow_setup.py
```

### Option C: Manual Setup
```bash
# Install Airflow (copy-paste the whole block)
PYTHON_VERSION="$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-2.10.5/constraints-${PYTHON_VERSION}.txt"
pip install "apache-airflow==2.10.5" --constraint "${CONSTRAINT_URL}"

# Create directories (run each line)
mkdir -p /opt/airflow/dags
mkdir -p /opt/airflow/logs
mkdir -p /opt/airflow/plugins
```

## Verification
After setup, verify installation:
```bash
airflow version
```

You should see Airflow version 2.10.5 in the output.

## Next Steps
After verifying the installation:
1. For local development:
   ```bash
   airflow standalone
   ```

2. For production-like environment:
   ```bash
   docker-compose -f docker-compose-nofrills.yml up
   ```
