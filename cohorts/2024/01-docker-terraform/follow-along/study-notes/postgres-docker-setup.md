# PostgreSQL Docker Setup

This document provides information on setting up a PostgreSQL instance using Docker. The setup includes running the PostgreSQL container, accessing it regularly, and managing the container lifecycle.

## Critical Debugging Steps for Successful PostgreSQL:14 Docker Container Launch

1. **Ensure Correct Permissions:**
   Ensure that the directory on the host machine has the correct permissions and ownership.

2. **Update PostgreSQL Configuration:**
   Update the `listen_addresses` setting in the `postgresql.conf` file to allow connections from any IP address. The `listen_addresses` setting can be updated to `'*'` to allow connections from any IP address.

3. **Restart PostgreSQL:**
   Restart the PostgreSQL server to apply the configuration changes.

4. **Check Docker Desktop Settings (Windows):**
   Ensure that file sharing is enabled for the drive where the PostgreSQL data directory is located.

5. **Run `initdb` in a "NATIVE Linux" Root Directory:**
   Initialize the PostgreSQL database cluster in a native Linux environment to avoid permission issues.

6. **Pull `postgres:14.15` to Match Local Version:**
   Ensure the PostgreSQL version in the Docker container matches the version on the host machine.

7. **Change the Port Number from 5432 to 5433:**
   Change the port number in the `docker-compose_2.3.4.yaml` file because another PostgreSQL server has been running on port 5432.

## Building the Docker Image

To build the Docker image with the tag `:14.15`, use the following command:

```bash
docker build -t zoomcamp-postgres:14.15 .
```

## Running PostgreSQL Container

### Detached Mode

To run the PostgreSQL container in detached mode, use the following command. Ensure you are in the directory where the PostgreSQL data has been initialized:

```bash
docker run -d \
    --name zoomcamp-postgres-container \
    --label important=true \
    -e POSTGRES_USER="postgres" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_tax" \
    -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5433:5433 \
    zoomcamp-postgres:14
```

**Detached mode** refers to running a Docker container in the background, allowing you to continue using the terminal for other tasks. When you run a container in detached mode, it runs independently of the terminal session, and you can interact with it using other Docker commands.

### Interactive Mode

To run the PostgreSQL container in interactive mode, use the following command. Ensure you are in the directory where the PostgreSQL data has been initialized:

```bash
docker run -it \
    --name zoomcamp-postgres-container \
    --label important=true \
    -e POSTGRES_USER="postgres" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_tax" \
    -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5433:5433 \
    zoomcamp-postgres:14 bash
```

**Interactive mode** allows you to interact with the container through the terminal. This can be useful for handling authentication by processing the user-password to be entered in the terminal.

### What Happens When You Press `Ctrl + C`

- **Detached Mode (`-d`):** If the container is running in detached mode, pressing `Ctrl + C` in the terminal will not stop the container. The container will continue to run in the background.

- **Foreground Mode (Without `-d`):** If the container is running in the foreground (without the `-d` flag), pressing `Ctrl + C` will send a signal to stop the container. This will terminate the running container and return you to the terminal prompt.

## Accessing the PostgreSQL Container

To access the running PostgreSQL container, use the following command:

```bash
docker exec -it zoomcamp-postgres-container bash
```

This command opens a Bash shell inside the running PostgreSQL container.

## Connecting to PostgreSQL

### From the Local Host

To connect to PostgreSQL from the host machine using `pgcli`, use the following command:

```bash
pgcli -h localhost -p 5433 -u postgres -d ny_tax
```

### From Inside the Docker Container

Once inside the container, use the `psql` command to connect to the PostgreSQL database:

```bash
docker exec -it zoomcamp-postgres-container bash
psql -U postgres -d ny_tax -p 5433
```

### Example Commands

1. **Open a Bash Shell Inside the Container:**
   ```bash
   docker exec -it zoomcamp-postgres-container bash
   ```

2. **Connect to PostgreSQL Using psql:**
   ```bash
   psql -U postgres -d ny_tax -p 5433
   ```

3. **Connect to PostgreSQL Using pgcli:**
   ```bash
   pgcli -h localhost -p 5433 -u postgres -d ny_tax
   ```

### Differences Between `pgcli` and `psql`

#### `pgcli`

- **Written in**: Python
- **Installation**: Via `pip`
- **Features**: Autocompletion, syntax highlighting, user-friendly interface

#### `psql`

- **Written in**: C
- **Installation**: Comes bundled with PostgreSQL installations
- **Features**: Standard command-line interface for PostgreSQL, basic features for executing SQL commands and managing databases

### Summary

- **Use `psql`** if you prefer the standard tool that comes with PostgreSQL and do not need advanced features like autocompletion and syntax highlighting.
- **Use `pgcli`** if you want a more user-friendly interface with features like autocompletion and syntax highlighting.

### Inspecting the Container Configuration

To check the environment variables and confirm the username, use the following command:

```bash
docker inspect zoomcamp-postgres-container | grep POSTGRES_USER
```

### Checking and Creating Roles

1. **Check the Existing Roles:**
   Access the PostgreSQL container and connect to the database using a different user (e.g., `airflow`).

   ```bash
   docker exec -it zoomcamp-postgres-container bash
   psql -U airflow -d ny_tax -p 5433
   ```

   Once connected, list the existing roles:

   ```sql
   \du
   ```

2. **Create the `postgres` Role:**
   If the `postgres` role does not exist, create it:

   ```sql
   CREATE ROLE postgres WITH LOGIN SUPERUSER PASSWORD 'root';
   ```

### Removing Existing Data Directory

If the `postgres` role does not exist, it may be due to the data directory already containing a database. To resolve this, remove the existing data directory and reinitialize the PostgreSQL container:

1. **Stop and Remove the Existing Container:**
   ```bash
   docker stop zoomcamp-postgres-container
   docker rm zoomcamp-postgres-container
   ```

2. **Remove the Existing Data Directory:**
   ```bash
   sudo rm -rf ~/ny_taxi_postgres_data
   ```

3. **Run the PostgreSQL Container Again:**
   ```bash
   docker run -d \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       zoomcamp-postgres:14
   ```

### Checking PostgreSQL Server Status

1. **Check PostgreSQL Server Status:**
   Inside the container, check if the PostgreSQL server process is running. If the `ps` command is not available, install the `procps` package:

   ```bash
   apt-get update && apt-get install -y procps
   ps aux | grep postgres
   ```

2. **Check PostgreSQL Logs:**
   Review the PostgreSQL logs for any error messages.

   ```bash
   cat /var/lib/postgresql/data/log/postgresql.log
   ```

3. **Start PostgreSQL Manually:**
   If the server is not running, try starting it manually.

   ```bash
   pg_ctl -D /var/lib/postgresql/data start
   ```

### Steps to Connect to PostgreSQL

1. **Open a Bash Shell Inside the Container:**
   If you are not already inside the container, use the `docker exec` command to open a Bash shell inside the running container.

2. **Connect to PostgreSQL Using psql:**
   Use the `psql` command to connect to the PostgreSQL database.

### Example Commands

1. **Open a Bash Shell Inside the Container:**
   ```bash
   docker exec -it zoomcamp-postgres-container bash
   ```

2. **Connect to PostgreSQL Using psql:**
   ```bash
   psql -U postgres -d ny_tax -p 5433
   ```

3. **Connect to PostgreSQL Using pgcli:**
   ```bash
   pgcli -h localhost -p 5433 -u postgres -d ny_tax
   ```

### Checking PostgreSQL Configuration

1. **Edit the postgresql.conf File:**
   Edit the `postgresql.conf` file to ensure that PostgreSQL is configured to listen on the specified port.

   ```bash
   vi /var/lib/postgresql/data/postgresql.conf
   ```

   Ensure the following line is set to the correct port:

   ```plaintext
   port = 5433
   listen_addresses = '*'
   ```

2. **Check PostgreSQL Logs:**
   Review the PostgreSQL logs for any error messages.

   ```bash
   cat /var/lib/postgresql/data/log/postgresql.log
   ```

3. **Restart PostgreSQL:**
   Restart the PostgreSQL server to apply any configuration changes.

   ```bash
   pg_ctl -D /var/lib/postgresql/data restart
   ```

## Managing the Container

You can stop and start the container as needed without losing the data stored in the volume:

```bash
# Stop the container
docker stop zoomcamp-postgres-container

# Start the container
docker start zoomcamp-postgres-container
```

## Pruning Docker Resources

To free up disk space by removing unused Docker objects, including volumes, use the following command:

```bash
docker system prune -a --volumes
```

### Precautionary Steps

Before running the prune command, take the following precautionary steps:

1. **Backup Important Data:**
   Ensure that any important data stored in Docker volumes is backed up.

   ```bash
   docker run --rm -v <volume_name>:/data -v $(pwd):/backup busybox tar cvf /backup/backup.tar /data
   ```

2. **Review Docker Volumes:**
   List all Docker volumes to review which ones are currently in use and which ones can be safely removed.

   ```bash
   docker volume ls
   ```

3. **Inspect Volume Usage:**
   Inspect the contents and usage of each volume to ensure that you are not removing any volumes that are still needed.

   ```bash
   docker volume inspect <volume_name>
   sudo du -sh /var/lib/docker/volumes/<volume_name>/_data
   ```

4. **List Running Containers:**
   List all running containers to ensure that you are not disrupting any active development work.

   ```bash
   docker ps
   ```

5. **Stop and Remove Unused Containers:**
   Stop and remove any containers that are no longer needed.

   ```bash
   docker container stop <container_id>
   docker container rm <container_id>
   ```

6. **Push Important Images to a Registry:**
   If you have important Docker images, consider pushing them to a Docker registry (e.g., Docker Hub) to avoid losing them.

   ```bash
   docker tag <image_id> <your_dockerhub_username>/<image_name>:<tag>
   docker push <your_dockerhub_username>/<image_name>:<tag>
   ```

### Using Labels to Protect Important Containers

To ensure that you do not accidentally delete a particular container, such as `zoomcamp-postgres-container`, after running `docker system prune -a`, you can use Docker labels to mark important containers. While Docker itself does not provide a built-in mechanism to protect specific containers from being pruned, you can use labels to remind yourself and create custom scripts to handle pruning more carefully.

### Adding Labels to Containers

You can add labels to your Docker containers to mark them as important. This can serve as a reminder and can be used in custom scripts to exclude these containers from being pruned.

### Example Command with Labels

```bash
docker run -d \
    --name zoomcamp-postgres-container \
    --label important=true \
    -e POSTGRES_USER="postgres" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_tax" \
    -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5433:5433 \
    zoomcamp-postgres:14
```

### Custom Script to Prune Docker Resources

You can create a custom script to prune Docker resources while excluding containers with the `important=true` label.

### Example Custom Prune Script

```bash
#!/bin/bash

# List all containers with the "important=true" label
important_containers=$(docker ps -a --filter "label=important=true" --format "{{.ID}}")

# Stop all containers except the important ones
docker ps -a --filter "label!=important=true" --format "{{.ID}}" | xargs -r docker stop

# Remove all containers except the important ones
docker ps -a --filter "label!=important=true" --format "{{.ID}}" | xargs -r docker rm

# Prune all unused Docker objects, including volumes
docker system prune -a --volumes -f
```

### Usage

1. Save the script to a file, e.g., `custom-prune.sh`.
2. Make the script executable:
   ```bash
   chmod +x custom-prune.sh
   ```
3. Run the script:
   ```bash
   ./custom-prune.sh
   ```

## Workflow for Committing a Container to a New Image

If the underlying container image has not been renamed, follow these steps:

1. **Stop the Running Container:**
   ```bash
   docker stop fervent_carver
   ```

2. **Commit the Container to a New Image:**
   ```bash
   docker commit fervent_carver zoomcamp-postgres:14.15
   ```

3. **Remove the Original Container:**
   ```bash
   docker rm fervent_carver
   ```

4. **Run a New Container from the Committed Image in Detached Mode:**
   ```bash
   docker run -d \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       zoomcamp-postgres:14.15
   ```

### Environment Variables and State

When you commit a container to a new image, Docker captures the current state of the container, including the filesystem and any changes made to it. However, environment variables set when the container was originally run are not preserved in the new image. You need to specify the environment variables again when running the new container.

### Example Commands

1. **Stop the Running Container:**
   ```bash
   docker stop fervent_carver
   ```

2. **Commit the Container to a New Image:**
   ```bash
   docker commit fervent_carver zoomcamp-postgres:14.15
   ```

3. **Remove the Original Container:**
   ```bash
   docker rm fervent_carver
   ```

4. **Run a New Container with Environment Variables:**
   ```bash
   docker run -d \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       zoomcamp-postgres:14.15
   ```

## Debugging Methods

### Steps to Resolve the Permission Issue

1. **Check Volume Permissions:**
   Ensure that the directory on the host machine has the correct permissions.

   ```bash
   sudo chown -R $(id -u):$(id -g) /path/to/ny_taxi_postgres_data
   sudo chmod -R 700 /path/to/ny_taxi_postgres_data
   ```

   Replace `/path/to/ny_taxi_postgres_data` with the actual path to the directory on your host machine.

2. **Run the Container with Correct Permissions:**
   Run the container with the correct user permissions.

   ```bash
   docker run -d \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       --user postgres \
       zoomcamp-postgres:14
   ```

3. **Remove the Existing Container:**
   Remove any existing container with the name `zoomcamp-postgres-container`.

   ```bash
   docker rm zoomcamp-postgres-container
   ```

4. **Run the Container in Interactive Mode:**
   Run the container in interactive mode with the correct user permissions.

   ```bash
   docker run -it \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       --user postgres \
       zoomcamp-postgres:14 bash
   ```

### Additional Debugging Steps

1. **Check Container Logs:**
   Check the logs of the container to see if there are any error messages.

   ```bash
   docker logs zoomcamp-postgres-container
   ```

2. **Inspect the Container:**
   Inspect the container to get more details about its state.

   ```bash
   docker inspect zoomcamp-postgres-container
   ```

3. **Run the Container in Interactive Mode:**
   Run the container in interactive mode to see if there are any immediate errors.

   ```bash
   docker run -it \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       --user postgres \
       zoomcamp-postgres:14 bash
   ```

4. **Check Docker Desktop Settings (Windows):**
   If you are using Docker Desktop on Windows, ensure that file sharing is enabled for the drive where the `ny_taxi_postgres_data/` directory is located.

   - **Open Docker Desktop:**
     - Click on the Docker icon in the system tray to open Docker Desktop.
   - **Access Settings:**
     - Click on the gear icon (Settings) in the top-right corner of the Docker Desktop window.
   - **Navigate to Resources:**
     - In the Settings menu, navigate to the "Resources" section.
   - **Check WSL Integration:**
     - Under "Resources," select "WSL Integration."
     - Ensure that the correct WSL distributions are enabled for integration with Docker.
   - **Check Advanced Settings:**
     - Under "Resources," select "Advanced."
     - Ensure that the correct drive is listed and accessible.

### Steps to Ensure Drive Accessibility in WSL 2

1. **Check WSL 2 Configuration:**
   Ensure that the drive is accessible in WSL 2 by checking the `/mnt` directory.

2. **Verify Drive Mounting:**
   Verify that the drive is mounted correctly in WSL 2.

### Example Commands

1. **Open WSL 2 Terminal:**
   Open a WSL 2 terminal (e.g., Ubuntu).

2. **Check Mounted Drives:**
   List the contents of the `/mnt` directory to ensure that the drive is accessible.

   ```bash
   ls /mnt
   ```

   You should see the drive listed (e.g., `c` for the `C:` drive).

3. **Navigate to the Directory:**
   Navigate to the directory where the `ny_taxi_postgres_data/` folder is located.

   ```bash
   cd /mnt/c/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/forked-data-engineering-zoomcamp/data-engineering-zoomcamp/cohorts/2024/01-docker-terraform/follow-along
   ```

4. **Check Directory Permissions:**
   Check the permissions of the `ny_taxi_postgres_data/` directory.

   ```bash
   ls -l ny_taxi_postgres_data
   ```

### Steps to Further Debug and Resolve the Issue

1. **Ensure Correct Permissions:**
   Ensure that the directory has the correct permissions and ownership.

   ```bash
   sudo chown -R $(id -u):$(id -g) ny_taxi_postgres_data
   sudo chmod -R 700 ny_taxi_postgres_data
   ```

2. **Run the Container with Correct Permissions:**
   Run the container with the correct user permissions.

   ```bash
   docker run -d \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       --user postgres \
       zoomcamp-postgres:14
   ```

3. **Check Container Logs:**
   Check the logs of the container to see if there are any error messages.

   ```bash
   docker logs zoomcamp-postgres-container
   ```

### Example Commands

1. **Ensure Correct Permissions:**
   ```bash
   sudo chown -R $(id -u):$(id -g) ny_taxi_postgres_data
   sudo chmod -R 700 ny_taxi_postgres_data
   ```

2. **Run the Container with Correct Permissions:**
   ```bash
   docker run -d \
       --name zoomcamp-postgres-container \
       --label important=true \
       -e POSTGRES_USER="postgres" \
       -e POSTGRES_PASSWORD="root" \
       -e POSTGRES_DB="ny_tax" \
       -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
       -p 5433:5433 \
       --user postgres \
       zoomcamp-postgres:14
   ```

3. **Check Container Logs:**
   ```bash
   docker logs zoomcamp-postgres-container
   ```

### Handling Container Name Conflicts

If you encounter a conflict with an existing container name, you can either remove the existing container or use a different name for the new container.

#### Remove the Existing Container

```bash
docker rm zoomcamp-postgres-container
```

#### Run the Container in Interactive Mode

```bash
docker run -it \
    --name zoomcamp-postgres-container \
    --label important=true \
    -e POSTGRES_USER="postgres" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_tax" \
    -v ~/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5433:5433 \
    --user postgres \
    zoomcamp-postgres:14 bash
```

By following these steps, you can effectively manage your PostgreSQL Docker container and ensure a clean and efficient Docker environment.

## Resolving PostgreSQL Log File Issue

The error message `cat: /var/lib/postgresql/data/log/postgresql.log: No such file or directory` indicates that the PostgreSQL log file does not exist at the specified path. This could be due to several reasons, such as incorrect directory structure, permissions issues, or PostgreSQL not being properly initialized.

To analyze and resolve this issue, follow these steps:

1. **Check the Directory Structure:**
   Verify that the directory structure is correct and that the log directory exists.

   ```bash
   ls -l /var/lib/postgresql/data
   ```

2. **Check for Initialization Errors:**
   Ensure that PostgreSQL was properly initialized. If not, you may need to initialize the database cluster manually.

   ```bash
   pg_ctl initdb -D /var/lib/postgresql/data
   ```

3. **Check Permissions:**
   Ensure that the `postgres` user has the correct permissions for the data directory.

   ```bash
   sudo chown -R postgres:postgres /var/lib/postgresql/data
   sudo chmod -R 700 /var/lib/postgresql/data
   ```

4. **Start PostgreSQL Manually:**
   Try starting PostgreSQL manually to see if there are any error messages.

   ```bash
   pg_ctl -D /var/lib/postgresql/data start
   ```

## Workflow Inside PostgreSQL Docker Container

Once you are inside the PostgreSQL Docker container, follow these steps to initialize and start PostgreSQL:

1. **Check the Directory Structure:**
   Verify that the necessary files and directories exist within the PostgreSQL data directory.

   ```bash
   ls -l /var/lib/postgresql/data
   ```

   You should see files and directories such as `base`, `global`, `pg_wal`, `pg_xact`, `postgresql.conf`, etc.

2. **Initialize the Database Cluster (if necessary):**
   If the necessary files and directories are missing, you may need to initialize the database cluster manually.

   ```bash
   initdb -D /var/lib/postgresql/data
   ```

3. **Start PostgreSQL Manually:**
   After initializing the database cluster, start the PostgreSQL server manually.

   ```bash
   pg_ctl -D /var/lib/postgresql/data start
   ```

4. **Check PostgreSQL Logs:**
   If PostgreSQL fails to start, check the logs for any error messages.

   ```bash
   cat /var/lib/postgresql/data/log/postgresql.log
   ```

### Example Commands

1. **Check the Directory Structure:**
   ```bash
   ls -l /var/lib/postgresql/data
   ```

2. **Initialize the Database Cluster (if necessary):**
   ```bash
   initdb -D /var/lib/postgresql/data
   ```

3. **Start PostgreSQL Manually:**
   ```bash
   pg_ctl -D /var/lib/postgresql/data start
   ```

4. **Check PostgreSQL Logs:**
   ```bash
   cat /var/lib/postgresql/data/log/postgresql.log
   ```

### Steps to Set Correct Permissions

1. **Navigate to the Parent Directory:**
   Navigate to the parent directory of `ny_taxi_postgres_data`.

   ```bash
   cd /mnt/c/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/forked-data-engineering-zoomcamp/data-engineering-zoomcamp/cohorts/2024/01-docker-terraform/follow-along
   ```

2. **Set Correct Permissions:**
   Set the correct permissions on the `ny_taxi_postgres_data` directory.

   ```bash
   chmod 700 ny_taxi_postgres_data
   ```

3. **Verify Permissions:**
   Verify that the permissions have been set correctly.

   ```bash
   ls -ld ny_taxi_postgres_data
   ```

4. **Initialize the Database Cluster:**
   Run the `initdb` command again to initialize the PostgreSQL database cluster.

   ```bash
   initdb -D ny_taxi_postgres_data
   ```

### Example Commands

1. **Navigate to the Parent Directory:**
   ```bash
   cd /mnt/c/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/forked-data-engineering-zoomcamp/data-engineering-zoomcamp/cohorts/2024/01-docker-terraform/follow-along
   ```

2. **Set Correct Permissions:**
   ```bash
   chmod 700 ny_taxi_postgres_data
   ```

3. **Verify Permissions:**
   ```bash
   ls -ld ny_taxi_postgres_data
   ```

4. **Initialize the Database Cluster:**
   ```bash
   initdb -D ny_taxi_postgres_data
   ```

### Steps to Assign a Different Port

1. **Edit the postgresql.conf File:**
   Edit the `postgresql.conf` file in your `ny_taxi_postgres_data` directory to specify a different port.

   ```bash
   nano ~/ny_taxi_postgres_data/postgresql.conf
   ```

2. **Change the Port Number:**
   Find the line that specifies the port (e.g., `port = 5432`) and change it to a different port number (e.g., `port = 5433`).

   ```plaintext
   port = 5433
   ```

3. **Start the PostgreSQL Server:**
   Start the PostgreSQL server using the `pg_ctl` command.

   ```bash
   pg_ctl -D ~/ny_taxi_postgres_data -l logfile start
   ```

4. **Verify the Server is Running:**
   Check the status of the PostgreSQL server to ensure it is running on the new port.

   ```bash
   pg_ctl -D ~/ny_taxi_postgres_data status
   ```

### Example Commands

1. **Edit the postgresql.conf File:**
   ```bash
   nano ~/ny_taxi_postgres_data/postgresql.conf
   ```

2. **Change the Port Number:**
   ```plaintext
   port = 5433
   ```

3. **Start the PostgreSQL Server:**
   ```bash
   pg_ctl -D ~/ny_taxi_postgres_data -l logfile start
   ```

4. **Verify the Server is Running:**
   ```bash
   pg_ctl -D ~/ny_taxi_postgres_data status
   ```

### Steps to Resolve the Issue

1. **Check PostgreSQL Configuration:**
   Verify that PostgreSQL is configured to listen on the specified port.

2. **Check PostgreSQL Logs:**
   Review the PostgreSQL logs for any error messages that might indicate why the server is not listening on the specified port.

3. **Restart PostgreSQL:**
   Restart the PostgreSQL server to apply any configuration changes.

### Example Commands

1. **Check PostgreSQL Configuration:**
   Edit the `postgresql.conf` file to ensure that PostgreSQL is configured to listen on the specified port.

   ```bash
   nano /var/lib/postgresql/data/postgresql.conf
   ```

   Ensure the following line is set to the correct port:

   ```plaintext
   port = 5433
   ```

2. **Check PostgreSQL Logs:**
   Review the PostgreSQL logs for any error messages.

   ```bash
   cat /var/lib/postgresql/data/log/postgresql.log
   ```

3. **Restart PostgreSQL:**
   Restart the PostgreSQL server to apply any configuration changes.

   ```bash
   pg_ctl -D /var/lib/postgresql/data restart
   ```

### Steps to Update PostgreSQL Configuration

1. **Update `listen_addresses`:**
   Change the `listen_addresses` setting to `'*'` to allow connections from any IP address.

2. **Restart PostgreSQL:**
   Restart the PostgreSQL server to apply the configuration changes.

### Example Commands

1. **Update `listen_addresses`:**
   Edit the `postgresql.conf` file to change the `listen_addresses` setting.

   ```bash
   sudo nano /var/lib/postgresql/14/main/postgresql.conf
   ```

   Change the following line:

   ```plaintext
   listen_addresses = 'localhost'
   ```

   To:

   ```plaintext
   listen_addresses = '*'
   ```

2. **Restart PostgreSQL:**
   Restart the PostgreSQL server to apply the configuration changes.

   ```bash
   sudo systemctl restart postgresql
   ```

### Next Steps

1. **Verify Database Connection:**
   You can run some SQL commands to verify that the database is working correctly.

2. **Check Database Tables:**
   List the tables in the `ny_tax` database to ensure that the database schema is set up correctly.

### Example SQL Commands

1. **Connect to the `ny_tax` Database:**
   ```sql
   \c ny_tax
   ```

2. **List Tables:**
   ```sql
   \dt
   ```

3. **Run a Sample Query:**
   ```sql
   SELECT * FROM some_table LIMIT 10;
   ```

### Critical Debugging Steps Recap

1. **Ensure Correct Permissions:**
   Ensure that the directory on the host machine has the correct permissions and ownership.

2. **Update PostgreSQL Configuration:**
   Update the `listen_addresses` setting in the `postgresql.conf` file to allow connections from any IP address.

3. **Restart PostgreSQL:**
   Restart the PostgreSQL server to apply the configuration changes.

4. **Check Docker Desktop Settings (Windows):**
   Ensure that file sharing is enabled for the drive where the PostgreSQL data directory is located.

5. **Run `initdb` in a "NATIVE Linux" Root Directory:**
   Initialize the PostgreSQL database cluster in a native Linux environment to avoid permission issues.

6. **Pull `postgres:14.15` to Match Local Version:**
   Ensure the PostgreSQL version in the Docker container matches the version on the host machine.

7. **Change the Port Number from 5432 to 5433:**
   Change the port number in the `docker-compose_2.3.4.yaml` file because another PostgreSQL server has been running on port 5432.

### Steps to Resolve the Port Issue

1. **Check the Port Configuration:**
   Open a Bash shell inside the container and edit the `postgresql.conf` file to ensure it is set to listen on port `5433`.

   ```bash
   docker exec -it zoomcamp-postgres-container bash
   nano /var/lib/postgresql/data/postgresql.conf
   ```

   Ensure the following line is uncommented and set to the correct port:

   ```plaintext
   port = 5433
   ```

2. **Restart the Container:**
   Restart the PostgreSQL container to apply the configuration changes.

   ```bash
   docker restart zoomcamp-postgres-container
   ```

3. **Check the Container Logs:**
   Verify that PostgreSQL is listening on the correct port by checking the logs.

   ```bash
   docker logs zoomcamp-postgres-container
   ```

4. **Open a Bash Shell Inside the Container:**
   ```bash
   docker exec -it zoomcamp-postgres-container bash
   ```

5. **Connect to PostgreSQL Using psql:**
   ```bash
   psql -U postgres -p 5433
   ```

6. **Connect to PostgreSQL Using pgcli:**
   ```bash
   pgcli -h localhost -p 5433 -u postgres -d ny_taxi
   ```

### Creating the Database

1. **Open a Bash Shell Inside the Container:**
   ```bash
   docker exec -it zoomcamp-postgres-container bash
   ```

2. **Connect to PostgreSQL Using psql:**
   ```bash
   psql -U postgres -p 5433
   ```

3. **Create the Database:**
   ```sql
   CREATE DATABASE ny_taxi;
   ```

4. **Verify the Database Creation:**
   ```sql
   \l
   ```

### Example Commands

1. **Check the Port Configuration:**
   Open a Bash shell inside the container and edit the `postgresql.conf` file to ensure it is set to listen on port `5433`.

   ```bash
   docker exec -it zoomcamp-postgres-container bash
   nano /var/lib/postgresql/data/postgresql.conf
   ```

   Ensure the following line is uncommented and set to the correct port:

   ```plaintext
   port = 5433
   ```

2. **Restart the Container:**
   Restart the PostgreSQL container to apply the configuration changes.

   ```bash
   docker restart zoomcamp-postgres-container
   ```

3. **Check the Container Logs:**
   Verify that PostgreSQL is listening on the correct port by checking the logs.

   ```bash
   docker logs zoomcamp-postgres-container
   ```

4. **Open a Bash Shell Inside the Container:**
   ```bash
   docker exec -it zoomcamp-postgres-container bash
   ```

5. **Connect to PostgreSQL Using psql:**
   ```bash
   psql -U postgres -p 5433
   ```

6. **Connect to PostgreSQL Using pgcli:**
   ```bash
   pgcli -h localhost -p 5433 -u postgres -d ny_taxi
   ```

7. **Create the Database:**
   ```sql
   CREATE DATABASE ny_taxi;
   ```

8. **Verify the Database Creation:**
   ```sql
   \l
   ```

### Next Steps

1. **Verify Database Connection:**
   Open a Bash shell inside the container and use the `psql` command to connect to the PostgreSQL database.

   ```bash
   docker exec -it zoomcamp-postgres-container bash
   psql -U postgres -d ny_tax -p 5433
   ```

2. **Run Some SQL Commands:**
   Once connected, you can run some SQL commands to verify that the database is working correctly.

### Example Commands

1. **Open a Bash Shell Inside the Container:**
   ```bash
   docker exec -it zoomcamp-postgres-container bash
   ```

2. **Connect to PostgreSQL Using psql:**
   ```bash
   psql -U postgres -d ny_tax -p 5433
   ```

3. **Run SQL Commands:**
   ```sql
   \c ny_tax
   \dt
   SELECT * FROM some_table LIMIT 10;
   ```

### Steps to Connect to the `ny_tax` Database and Verify

1. **Connect to the `ny_tax` Database:**
   ```sql
   \c ny_tax
   ```

2. **List Tables in the `ny_tax` Database:**
   ```sql
   \dt
   ```

3. **Run a Sample Query:**
   ```sql
   SELECT * FROM some_table LIMIT 10;
   ```

### Example Commands

1. **Connect to the `ny_tax` Database:**
   ```sql
   \c ny_tax
   ```

2. **List Tables in the `ny_tax` Database:**
   ```sql
   \dt
   ```

3. **Run a Sample Query:**
   ```sql
   SELECT * FROM some_table LIMIT 10;
   ```

### Updated Documentation

### Steps to Create Tables and Insert Data

1. **Create a Table:**
   ```sql
   CREATE TABLE example_table (
       id SERIAL PRIMARY KEY,
       name VARCHAR(50),
       age INT
   );
   ```

2. **Insert Data into the Table:**
   ```sql
   INSERT INTO example_table (name, age) VALUES ('Alice', 30), ('Bob', 25);
   ```

3. **Verify the Data Insertion:**
   ```sql
   SELECT * FROM example_table;
   ```

### Example Commands

1. **Create a Table:**
   ```sql
   CREATE TABLE example_table (
       id SERIAL PRIMARY KEY,
       name VARCHAR(50),
       age INT
   );
   ```

2. **Insert Data into the Table:**
   ```sql
   INSERT INTO example_table (name, age) VALUES ('Alice', 30), ('Bob', 25);
   ```

3. **Verify the Data Insertion:**
   ```sql
   SELECT * FROM example_table;
   ```

## Identifying Java Code in the Workspace

To identify which module contains Java code in your workspace, you can look for files with the `.java` extension or directories that typically contain Java source code. Here are some common directories and files to check:

1. **Source Directories**: Java source code is usually stored in directories like `src/main/java` or `src/test/java`.
2. **Build Files**: Look for build files like `pom.xml` (for Maven) or `build.gradle` (for Gradle), which are commonly used in Java projects.

### Steps to Identify Java Code

1. **Search for `.java` Files**:
   - Use the search functionality in your code editor to look for files with the `.java` extension.

2. **Check Common Directories**:
   - Look for directories like `src/main/java` or `src/test/java`.

3. **Check for Build Files**:
   - Look for `pom.xml` (Maven) or `build.gradle` (Gradle) files, which indicate a Java project.

4. **Check `.gitignore`**:
   - Ensure that Java files or directories are not being ignored by your `.gitignore` file. Sometimes, certain file patterns are excluded from version control and may not appear in searches.

### Example `.gitignore` Entry for Java Projects

```gitignore
# Java
*.class
*.jar
*.war
*.ear
*.iml
*.ipr
*.iws
*.log
*.idea/
*.project
*.classpath
target/
bin/
build/
out/
```

### Example Directory Structure

Here is an example of a typical Java project directory structure:

```
project-root/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/
│   │           └── example/
│   │               └── MyClass.java
│   └── test/
│       └── java/
│           └── com/
│               └── example/
│                   └── MyClassTest.java
├── pom.xml
└── build.gradle
```

## Logfile Analysis

### Logfile Generation and Necessity

The `logfile` contains logs from a PostgreSQL instance, including startup attempts and errors. It is important to determine when this file was generated and whether it is needed for your project.

### Steps to Determine the Creation Date and Usage

1. **Check the Creation Date**:
   - Use the `ls -l` command to check the creation date of the `logfile`.

   ```bash
   ls -l /mnt/c/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/forked-data-engineering-zoomcamp/data-engineering-zoomcamp/cohorts/2024/01-docker-terraform/follow-along/logfile
   ```

2. **Review the Content**:
   - Review the content of the `logfile` to understand its relevance. It contains PostgreSQL logs, which might be useful for debugging.

3. **Determine Necessity**:
   - If the `logfile` is needed for debugging or historical reference, it should be kept.
   - If it is not needed, it can be safely removed to clean up the directory.

### Example Command to Remove the `logfile`

If you determine that the `logfile` is not needed, you can remove it using the following command:

```bash
rm /mnt/c/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/forked-data-engineering-zoomcamp/data-engineering-zoomcamp/cohorts/2024/01-docker-terraform/follow-along/logfile
```

### Best Practices for Managing Log Files

1. **Use .gitignore**:
   - Add log files and other temporary files to your `.gitignore` file to ensure they are not committed to the repository.

2. **Centralized Logging**:
   - Use centralized logging solutions like ELK Stack (Elasticsearch, Logstash, Kibana), Splunk, or cloud-based logging services to collect, store, and analyze logs.

3. **Log Rotation**:
   - Implement log rotation to manage the size and retention of log files. Tools like `logrotate` can help automate this process.

4. **Environment-Specific Logging**:
   - Configure logging settings based on the environment (development, staging, production) to ensure appropriate log levels and destinations.

### Example .gitignore Entry for Log Files

Ensure your `.gitignore` file includes entries to ignore log files:

```gitignore
# Ignore log files
*.log
logs/
**/logfile
```

By following these best practices, you can ensure that your production code repository remains clean and manageable, while still effectively handling log files and other temporary data.
