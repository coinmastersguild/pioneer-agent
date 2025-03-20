#!/bin/bash
set -e

# Set variables
IMAGE_NAME="eliza-circleci-env"
CONTAINER_NAME="eliza-build-env"
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

echo "Project root: $PROJECT_ROOT"

# Build the CircleCI-like environment image
echo "Building CircleCI-like environment image..."
docker build -t $IMAGE_NAME -f Dockerfile.circleci .

# Check if the container is already running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME is already running, attaching..."
    docker exec -it $CONTAINER_NAME bash
    exit 0
fi

# Check if the container exists but is stopped
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME exists but is not running, starting and attaching..."
    docker start $CONTAINER_NAME
    docker exec -it $CONTAINER_NAME bash
    exit 0
fi

# Run the container with access to Docker socket for Docker-in-Docker
echo "Creating and starting container $CONTAINER_NAME..."
docker run -it --name $CONTAINER_NAME \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PROJECT_ROOT:/workspace \
    -w /workspace \
    $IMAGE_NAME

echo "Environment setup complete. You're now in a CircleCI-like environment."
echo "To exit, type 'exit'. To reconnect later, run this script again."
