#!/bin/bash
# Build and test script for improved Eliza Docker image

set -e

# Default location is the repository root
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DOCKERFILE="$REPO_ROOT/sprint-2/Dockerfile.improved"
IMAGE_NAME="registry.digitalocean.com/pioneer/pioneer-agent"
TAG="test-build"

echo "Starting build test for Eliza Multi-Agent..."
echo "Repository root: $REPO_ROOT"
echo "Using Dockerfile: $DOCKERFILE"

# Make the script executable
chmod +x "$REPO_ROOT/sprint-2/build-env/setup.sh"
chmod +x "$REPO_ROOT/sprint-2/dependency-audit.sh"

# Check if the build should be run locally or in the CircleCI environment
if [ "$1" == "circleci-env" ]; then
    echo "Building in CircleCI-like environment..."
    cd "$REPO_ROOT/sprint-2/build-env"
    ./setup.sh
    exit 0
fi

# Run the dependency audit
echo "Running dependency audit..."
"$REPO_ROOT/sprint-2/dependency-audit.sh"

# Remove any old containers
echo "Cleaning up any old containers..."
docker rm -f eliza-test 2>/dev/null || true

# Build the Docker image
echo "Building Docker image..."
cd "$REPO_ROOT"
docker build -t "$IMAGE_NAME:$TAG" -f "$DOCKERFILE" \
    --platform linux/amd64 \
    --build-arg BUILDKIT_INLINE_CACHE=1 .

# Test the Docker image
echo "Running container for testing..."
docker run -d --name eliza-test -p 3001:3000 -p 5175:5173 "$IMAGE_NAME:$TAG"

# Wait for container to start
echo "Waiting for container to start up..."
sleep 15

# Check container status
echo "Checking container status..."
docker ps | grep eliza-test || { echo "Container not running!"; docker logs eliza-test; exit 1; }

# Test health endpoint
echo "Testing health endpoint..."
curl -s http://localhost:3001/api/health || { echo "Health endpoint not responding!"; docker logs eliza-test; exit 1; }

echo "Container is running successfully! Testing complete."
echo "You can now access the Eliza client at: http://localhost:5175"
echo "API is available at: http://localhost:3001"
echo ""
echo "To stop the container: docker stop eliza-test"
echo "To view logs: docker logs eliza-test" 