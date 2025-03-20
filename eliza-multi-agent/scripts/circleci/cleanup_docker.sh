#!/bin/bash

# This script cleans up Docker artifacts to free up disk space
# Useful for CI/CD environments with limited disk space

echo "======================================================"
echo "           DOCKER CLEANUP UTILITY                    "
echo "======================================================"

# Remove all stopped containers
echo "Removing stopped containers..."
docker container prune -f

# Remove dangling images (those with <none> tag)
echo "Removing dangling images..."
docker image prune -f

# Remove dangling volumes
echo "Removing dangling volumes..."
docker volume prune -f

# Remove dangling build cache
echo "Removing dangling build cache..."
docker builder prune -f

# Print disk usage after cleanup
echo "Current Docker disk usage:"
docker system df

echo "======================================================"
echo "           CLEANUP COMPLETE                          "
echo "======================================================" 