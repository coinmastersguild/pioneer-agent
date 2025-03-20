#!/bin/bash

# Script to check both DigitalOcean container registry image and Kubernetes deployment status
# Usage: ./check_deployment.sh [repository_name] [deployment_name] [optional: tag_name]

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CONFIG_DIR="$(dirname "$0")"
ENV_FILE="${CONFIG_DIR}/../../.env"
LOG_DIR="${CONFIG_DIR}/logs"

# Ensure logs directory exists
mkdir -p "$LOG_DIR"

# Function to display usage
usage() {
    echo "Usage: $0 [repository_name] [deployment_name] [optional: tag_name]"
    echo "Example: $0 pioneer-agent pioneer-agent latest"
    exit 1
}

# Check if required arguments are provided
if [ $# -lt 2 ]; then
    echo -e "${RED}Error: Repository name and deployment name are required${NC}"
    usage
fi

REPO_NAME="$1"
DEPLOYMENT_NAME="$2"
TAG_NAME="${3:-latest}" # Default to 'latest' if not provided

# Check if .env file exists and load it
if [ -f "$ENV_FILE" ]; then
    echo "Loading environment variables from $ENV_FILE"
    # Source the env file but ignore any errors from non-bash commands
    set -o allexport
    source "$ENV_FILE" || true
    set +o allexport
else
    echo -e "${RED}Error: .env file not found at $ENV_FILE${NC}"
    exit 1
fi

# Check if DIGITALOCEAN_ACCESS_TOKEN is set
if [ -z "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
    echo -e "${RED}Error: DIGITALOCEAN_ACCESS_TOKEN not found in .env file${NC}"
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
for cmd in doctl kubectl jq; do
    if ! command_exists "$cmd"; then
        echo -e "${RED}Error: Required command '$cmd' not found${NC}"
        exit 1
    fi
done

echo -e "\n${BLUE}========= CHECKING IMAGE STATUS ==========${NC}"

echo -e "${YELLOW}Authenticating with DigitalOcean...${NC}"
doctl auth init -t "$DIGITALOCEAN_ACCESS_TOKEN" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to authenticate with DigitalOcean${NC}"
    exit 1
fi

echo -e "${YELLOW}Checking if repository $REPO_NAME exists...${NC}"
REPO_CHECK=$(doctl registry repository list -o json | jq -r ".[] | select(.name == \"$REPO_NAME\") | .name")

if [ -z "$REPO_CHECK" ]; then
    echo -e "${RED}Repository $REPO_NAME not found in your DigitalOcean Container Registry${NC}"
    echo "Available repositories:"
    doctl registry repository list | head -10
    echo "..."
    exit 1
fi

echo -e "${GREEN}Repository $REPO_NAME found!${NC}"

echo -e "${YELLOW}Checking for tag $TAG_NAME...${NC}"
TAG_INFO=$(doctl registry repository list-tags "$REPO_NAME" -o json | jq -r ".[] | select(.tag == \"$TAG_NAME\")")

if [ -z "$TAG_INFO" ]; then
    echo -e "${RED}Tag $TAG_NAME not found in repository $REPO_NAME${NC}"
    echo "Available tags:"
    doctl registry repository list-tags "$REPO_NAME" | head -10
    exit 1
fi

# Format and display tag information
echo -e "${GREEN}Image $REPO_NAME:$TAG_NAME found!${NC}"
echo -e "=== Image Details ==="
echo "$TAG_INFO" | jq -r '"Tag: \(.tag)\nSize: \(.size)\nUpdated: \(.updated_at)\nManifest Digest: \(.manifest_digest)"'

# Save the information to a log file
IMAGE_LOG_FILE="$LOG_DIR/${REPO_NAME}_${TAG_NAME}_$(date +%Y%m%d%H%M%S).json"
echo "$TAG_INFO" > "$IMAGE_LOG_FILE"
echo -e "${GREEN}Image details saved to $IMAGE_LOG_FILE${NC}"

echo -e "\n${BLUE}========= CHECKING KUBERNETES DEPLOYMENT ==========${NC}"

# Get Kubernetes config
echo -e "${YELLOW}Getting Kubernetes configuration...${NC}"
doctl kubernetes cluster kubeconfig save do-cluster-2b9226d > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to get Kubernetes configuration${NC}"
    exit 1
fi

echo -e "${YELLOW}Checking if deployment $DEPLOYMENT_NAME exists...${NC}"
DEPLOYMENT_INFO=$(kubectl get deployment "$DEPLOYMENT_NAME" -o json 2>/dev/null)

if [ $? -ne 0 ]; then
    echo -e "${RED}Deployment $DEPLOYMENT_NAME not found in Kubernetes${NC}"
    echo "Available deployments:"
    kubectl get deployments
    exit 1
fi

# Extract deployment details
READY_REPLICAS=$(echo "$DEPLOYMENT_INFO" | jq -r '.status.readyReplicas // 0')
TOTAL_REPLICAS=$(echo "$DEPLOYMENT_INFO" | jq -r '.status.replicas // 0')
IMAGE=$(echo "$DEPLOYMENT_INFO" | jq -r '.spec.template.spec.containers[0].image')
CREATION_TIME=$(echo "$DEPLOYMENT_INFO" | jq -r '.metadata.creationTimestamp')

echo -e "${GREEN}Deployment $DEPLOYMENT_NAME found!${NC}"
echo -e "=== Deployment Details ==="
echo -e "Ready Replicas: ${READY_REPLICAS}/${TOTAL_REPLICAS}"
echo -e "Image: ${IMAGE}"
echo -e "Creation Time: ${CREATION_TIME}"

# Check if the deployment is using the correct image
if [[ "$IMAGE" == *"$REPO_NAME:$TAG_NAME"* ]]; then
    echo -e "${GREEN}Deployment is using the correct image: $IMAGE${NC}"
else
    echo -e "${YELLOW}Warning: Deployment is using a different image: $IMAGE${NC}"
    echo -e "Expected: registry.digitalocean.com/$REPO_NAME:$TAG_NAME"
fi

# Check deployment status
if [ "$READY_REPLICAS" -eq "$TOTAL_REPLICAS" ] && [ "$TOTAL_REPLICAS" -gt 0 ]; then
    echo -e "${GREEN}Deployment is healthy!${NC}"
else
    echo -e "${YELLOW}Warning: Deployment may not be fully ready${NC}"
    echo -e "Checking pod status..."
    kubectl get pods -l app="$DEPLOYMENT_NAME"
fi

# Save the deployment information to a log file
DEPLOYMENT_LOG_FILE="$LOG_DIR/${DEPLOYMENT_NAME}_$(date +%Y%m%d%H%M%S).json"
echo "$DEPLOYMENT_INFO" > "$DEPLOYMENT_LOG_FILE"
echo -e "${GREEN}Deployment details saved to $DEPLOYMENT_LOG_FILE${NC}"

echo -e "\n${GREEN}Deployment verification complete!${NC}"
echo -e "For more details, use: kubectl describe deployment $DEPLOYMENT_NAME"

exit 0 