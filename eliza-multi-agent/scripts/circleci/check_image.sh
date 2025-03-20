#!/bin/bash

# Script to check if a container image exists in DigitalOcean Container Registry
# Usage: ./check_image.sh [repository_name] [optional: tag_name]

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Configuration
CONFIG_DIR="$(dirname "$0")"
ENV_FILE="${CONFIG_DIR}/../../.env"
LOG_DIR="${CONFIG_DIR}/logs"

# Ensure logs directory exists
mkdir -p "$LOG_DIR"

# Function to display usage
usage() {
    echo "Usage: $0 [repository_name] [optional: tag_name]"
    echo "Example: $0 pioneer-agent latest"
    exit 1
}

# Check if repository name is provided
if [ $# -lt 1 ]; then
    echo -e "${RED}Error: Repository name is required${NC}"
    usage
fi

REPO_NAME="$1"
TAG_NAME="${2:-latest}" # Default to 'latest' if not provided

# Check if .env file exists and load it
if [ -f "$ENV_FILE" ]; then
    echo "Loading environment variables from $ENV_FILE"
    source "$ENV_FILE"
else
    echo -e "${RED}Error: .env file not found at $ENV_FILE${NC}"
    exit 1
fi

# Check if DIGITALOCEAN_ACCESS_TOKEN is set
if [ -z "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
    echo -e "${RED}Error: DIGITALOCEAN_ACCESS_TOKEN not found in .env file${NC}"
    exit 1
fi

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
LOG_FILE="$LOG_DIR/${REPO_NAME}_${TAG_NAME}_$(date +%Y%m%d%H%M%S).json"
echo "$TAG_INFO" > "$LOG_FILE"
echo -e "${GREEN}Details saved to $LOG_FILE${NC}"

echo -e "\n${GREEN}Container image verification complete!${NC}"
echo -e "Full image reference: registry.digitalocean.com/$REPO_NAME:$TAG_NAME"
echo -e "You can pull this image using:"
echo -e "docker pull registry.digitalocean.com/$REPO_NAME:$TAG_NAME"

exit 0 