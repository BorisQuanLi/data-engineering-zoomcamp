# Docker Operations

This document provides a summary of various Docker operations for listing, inspecting, and pruning Docker resources.

## Listing Docker Resources

### List All Docker Containers
```bash
docker ps -a
```

### List All Docker Volumes
```bash
docker volume ls
```

### List All Docker Images
```bash
docker images -a
```

## Inspecting Docker Resources

### Inspect a Specific Docker Container
```bash
docker inspect <container_id>
```

### Inspect a Specific Docker Volume
```bash
docker volume inspect <volume_name>
```

### Inspect a Specific Docker Image
```bash
docker inspect <image_id>
```

## Checking Disk Usage

### Check Disk Usage of Docker Objects
```bash
docker system df
```

### Check Disk Usage of a Specific Docker Volume
```bash
sudo du -sh /var/lib/docker/volumes/<volume_name>/_data
```

## Pruning Docker Resources

### Prune Dangling Images Only
```bash
docker image prune
```

### Prune All Unused Images
```bash
docker image prune -a
```

### Prune Stopped Containers
```bash
docker container prune
```

### Prune Unused Volumes
```bash
docker volume prune
```

### Prune Unused Networks
```bash
docker network prune
```

### Prune Build Cache
```bash
docker builder prune
```

### Prune All Unused Objects
```bash
docker system prune
```

### Prune All Unused Objects Including Volumes
```bash
docker system prune -a --volumes
```

## Custom Prune Script

You can create a custom script to prune Docker resources while excluding containers with a specific label.

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

## Renaming Docker Images

### Renaming the Underlying Docker Image

To rename the underlying Docker image, you can use the `docker tag` command. This is useful for giving the image a context-specific name.

### Example Command to Rename Docker Image

```bash
docker tag postgres:13 zoomcamp-postgres:13
```

### Removing the Original Image

After renaming the image, you can remove the original image to avoid redundancy:

```bash
docker rmi postgres:13
```

### Listing Docker Images

After renaming and removing the original image, you can list the Docker images to verify the change:

```bash
docker images
```

### Example Output

```bash
REPOSITORY         TAG       IMAGE ID       CREATED       SIZE
zoomcamp-postgres  13        78db9e1a6ba0   5 weeks ago   419MB
```

### Running a Container from the Renamed Image

You can now run a container from the renamed image:

```bash
docker run -d \
    --name zoomcamp-postgres-container \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_tax" \
    -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    zoomcamp-postgres:13
```

### Is It a Good Practice to Give the Image a Context-Specific Name?

Yes, it is a good practice to give Docker images context-specific names. This helps in identifying the purpose and usage of the image, especially when working with multiple projects or environments. It also makes it easier to manage and organize your Docker images.

By following these commands and using the custom script, you can effectively manage and clean up your Docker environment.
