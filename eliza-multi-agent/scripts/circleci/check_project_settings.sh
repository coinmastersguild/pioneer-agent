#!/bin/bash

# Check CircleCI project settings to ensure proper configuration

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
ORG_SLUG="gh/coinmastersguild"  # Updated to use the correct org slug
API_TOKEN=$CIRCLE_CI_TOKEN
PROJECT_NAME="pioneer-agent"
API_URL="https://circleci.com/api/v2"

echo "======================================================"
echo "           CIRCLECI PROJECT SETTINGS CHECK           "
echo "======================================================"
echo "Organization Slug: $ORG_SLUG"
echo "Project Name: $PROJECT_NAME"
echo "------------------------------------------------------"

# Get the project by slug
PROJECT_SLUG="${ORG_SLUG}/${PROJECT_NAME}"
echo "Using project slug: $PROJECT_SLUG"

# Get project information
echo "Fetching project information..."
PROJECT_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/$PROJECT_SLUG")

if echo "$PROJECT_RESPONSE" | jq -e '.message' >/dev/null 2>&1; then
  echo "Error: $(echo $PROJECT_RESPONSE | jq -r '.message')"
  exit 1
fi

PROJECT_ID=$(echo $PROJECT_RESPONSE | jq -r '.id')

echo "Project ID: $PROJECT_ID"
echo "------------------------------------------------------"

# Get environment variables
echo "Checking environment variables..."
ENV_VARS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/$PROJECT_SLUG/envvar")

echo "Environment Variables:"
echo "$ENV_VARS_RESPONSE" | jq -r '.items[].name' | while read varname; do
  echo "  - $varname: ✓"
done

echo "------------------------------------------------------"

# Check required environment variables
required_vars=("DIGITALOCEAN_ACCESS_TOKEN" "PULUMI_PASSPHRASE")
missing_vars=()

for var in "${required_vars[@]}"; do
  if ! echo "$ENV_VARS_RESPONSE" | jq -r '.items[].name' | grep -q "^$var$"; then
    missing_vars+=("$var")
  fi
done

if [ ${#missing_vars[@]} -eq 0 ]; then
  echo "✅ All required environment variables are set."
else
  echo "❌ Missing required environment variables:"
  for var in "${missing_vars[@]}"; do
    echo "  - $var"
  done
fi

echo "------------------------------------------------------"

# Check project settings
echo "Checking project settings..."
SETTINGS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/$PROJECT_SLUG/settings")

# Check SSH key is set up
SSH_KEYS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/$PROJECT_SLUG/checkout-key")

if [ "$(echo "$SSH_KEYS_RESPONSE" | jq '.items | length')" -gt 0 ]; then
  echo "✅ SSH keys are set up."
else
  echo "❌ No SSH keys are set up."
fi

echo "------------------------------------------------------"

# Check recent status
echo "Checking recent builds status..."
PIPELINES_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/$PROJECT_SLUG/pipeline?branch=sprint-2&limit=5")

echo "Recent builds (sprint-2 branch):"
echo "$PIPELINES_RESPONSE" | jq -r '.items[] | "  - \(.id): Created: \(.created_at), State: \(.state)"'

echo "======================================================"
echo "           CHECK COMPLETE                            "
echo "======================================================" 