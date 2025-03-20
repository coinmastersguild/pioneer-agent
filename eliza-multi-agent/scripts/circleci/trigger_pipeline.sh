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
ORG_SLUG="gh/coinmastersguild"  # Updated to use the correct org slug
API_TOKEN=$CIRCLE_CI_TOKEN
PROJECT_NAME="pioneer-agent"
BRANCH=${1:-"sprint-2"}  # Use provided branch or default to sprint-2
API_URL="https://circleci.com/api/v2"

echo "Triggering pipeline for project: $PROJECT_NAME, branch: $BRANCH"

# Get the project by slug
PROJECT_SLUG="${ORG_SLUG}/${PROJECT_NAME}"
echo "Using project slug: $PROJECT_SLUG"

# Trigger pipeline
echo "Triggering pipeline for project: $PROJECT_SLUG, branch: $BRANCH"
TRIGGER_RESPONSE=$(curl -s -X POST \
  -H "Circle-Token: $API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"branch\":\"$BRANCH\", \"parameters\":{}}" \
  "$API_URL/project/$PROJECT_SLUG/pipeline")

# Check for errors
if echo "$TRIGGER_RESPONSE" | jq -e '.message' >/dev/null 2>&1; then
  echo "Error: $(echo $TRIGGER_RESPONSE | jq -r '.message')"
  exit 1
fi

# Print response
echo "Pipeline triggered successfully!"
echo "$TRIGGER_RESPONSE" | jq '.'

# Get pipeline ID
PIPELINE_ID=$(echo "$TRIGGER_RESPONSE" | jq -r '.id')
echo "Pipeline ID: $PIPELINE_ID"

# Wait for workflows to be created
echo "Waiting for workflows to be created..."
sleep 5

# Get workflows for the pipeline
echo "Getting workflows for pipeline ID: $PIPELINE_ID"
WORKFLOWS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/pipeline/$PIPELINE_ID/workflow")

echo "$WORKFLOWS_RESPONSE" | jq '.' 