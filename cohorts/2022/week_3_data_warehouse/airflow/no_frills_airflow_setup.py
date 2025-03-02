import os
import sys
import subprocess
from pathlib import Path
from dotenv import load_dotenv

def setup_airflow():
    # Load environment variables from .env file
    load_dotenv()
    
    # Get environment variables
    airflow_version = os.getenv('AIRFLOW_VERSION')
    airflow_home = os.getenv('AIRFLOW_HOME')
    
    # Get Python version
    python_version = f"{sys.version_info.major}.{sys.version_info.minor}"
    
    # Construct constraint URL
    constraint_url = f"https://raw.githubusercontent.com/apache/airflow/constraints-{airflow_version}/constraints-{python_version}.txt"
    
    # Install Airflow
    print("Installing Airflow...")
    subprocess.run([
        "pip3", "install",
        f"apache-airflow=={airflow_version}",
        "--constraint", constraint_url
    ])
    
    # Create required directories
    # Note: dags/ directory already exists with example DAGs
    print("Creating required directories...")
    for dir_name in ['logs', 'plugins']:
        Path(os.path.join(airflow_home, dir_name)).mkdir(parents=True, exist_ok=True)
    
    print("Setup complete!")

if __name__ == "__main__":
    setup_airflow()
