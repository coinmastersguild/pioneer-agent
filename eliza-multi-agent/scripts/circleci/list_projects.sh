#!/bin/bash

# List all projects in the CircleCI organization

# Load environment variables from .env
set -a
source /Users/highlander/WebstormProjects/pioneer-agent/.env
set +a

# Check if environment variables are loaded
if [ -z "$CIRCLE_ORG" ] || [ -z "$CIRCLE_CI_TOKEN" ]; then
  echo "Error: CIRCLE_ORG or CIRCLE_CI_TOKEN not found in .env file"
  exit 1
fi

# Variables
ORG_ID=$CIRCLE_ORG
API_TOKEN=$CIRCLE_CI_TOKEN
API_URL="https://circleci.com/api/v2"

echo "======================================================"
echo "           CIRCLECI PROJECTS LIST                    "
echo "======================================================"
echo "Organization ID: $ORG_ID"
echo "------------------------------------------------------"

# Get projects list
echo "Fetching projects list..."
curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project" | jq '.'

echo "------------------------------------------------------"

# List projects by VCS provider
echo "VCS Providers:"
echo "1. GitHub"
echo "2. Bitbucket"
echo "------------------------------------------------------"

# GitHub projects
echo "GitHub Projects:"
curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/gh" | jq -r '.items[] | "  - \(.slug)"'

echo "------------------------------------------------------"

# Bitbucket projects
echo "Bitbucket Projects:"
curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/bitbucket" | jq -r '.items[] | "  - \(.slug)"'

echo "------------------------------------------------------"

# Get organization information
echo "Organization Information:"
curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/me/collaborations" | jq '.'

echo "======================================================"
echo "           PROJECTS LIST COMPLETE                    "
echo "======================================================" 