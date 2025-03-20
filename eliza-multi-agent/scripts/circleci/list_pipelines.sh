#!/bin/bash

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
PROJECT_NAME="pioneer-agent"
BRANCH="sprint-2"
API_URL="https://circleci.com/api/v2"

echo "Fetching pipelines for project: $PROJECT_NAME, branch: $BRANCH"

# Get project slug
PROJECT_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/gh/$ORG_ID/$PROJECT_NAME")

PROJECT_SLUG=$(echo $PROJECT_RESPONSE | jq -r '.slug')

if [ -z "$PROJECT_SLUG" ] || [ "$PROJECT_SLUG" == "null" ]; then
  echo "Getting project list instead..."
  curl -s -H "Circle-Token: $API_TOKEN" \
    "$API_URL/project/gh/$ORG_ID" | jq '.'
  exit 1
fi

# Get pipelines for the project
echo "Fetching pipelines for project: $PROJECT_SLUG"
PIPELINES_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/project/$PROJECT_SLUG/pipeline?branch=$BRANCH")

# Check if we got a valid response
if echo "$PIPELINES_RESPONSE" | jq -e '.message' >/dev/null 2>&1; then
  echo "Error: $(echo $PIPELINES_RESPONSE | jq -r '.message')"
  exit 1
fi

# Print the pipelines
echo "$PIPELINES_RESPONSE" | jq '.'

# For the latest pipeline, get the workflow IDs
LATEST_PIPELINE_ID=$(echo "$PIPELINES_RESPONSE" | jq -r '.items[0].id')

if [ -n "$LATEST_PIPELINE_ID" ] && [ "$LATEST_PIPELINE_ID" != "null" ]; then
  echo "Getting workflows for pipeline ID: $LATEST_PIPELINE_ID"
  WORKFLOWS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
    "$API_URL/pipeline/$LATEST_PIPELINE_ID/workflow")
  
  echo "$WORKFLOWS_RESPONSE" | jq '.'
fi 