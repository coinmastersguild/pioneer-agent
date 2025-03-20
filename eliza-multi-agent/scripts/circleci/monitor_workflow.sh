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
API_TOKEN=$CIRCLE_CI_TOKEN
API_URL="https://circleci.com/api/v2"
CHECK_INTERVAL=${2:-30}  # Default to 30 seconds between checks

# Check if workflow ID is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <workflow_id> [check_interval_seconds]"
  exit 1
fi

WORKFLOW_ID=$1

echo "Monitoring workflow ID: $WORKFLOW_ID"
echo "Will check every $CHECK_INTERVAL seconds until the workflow completes"

# Function to get workflow status
get_workflow_status() {
  WORKFLOW_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
    "$API_URL/workflow/$WORKFLOW_ID")
  
  # Check if we got a valid response
  if echo "$WORKFLOW_RESPONSE" | jq -e '.message' >/dev/null 2>&1; then
    echo "Error: $(echo $WORKFLOW_RESPONSE | jq -r '.message')"
    exit 1
  fi
  
  echo "$WORKFLOW_RESPONSE" | jq -r '.status'
}

# Function to check job statuses
check_jobs() {
  JOBS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
    "$API_URL/workflow/$WORKFLOW_ID/job")
  
  # Check if we got a valid response
  if echo "$JOBS_RESPONSE" | jq -e '.message' >/dev/null 2>&1; then
    echo "Error: $(echo $JOBS_RESPONSE | jq -r '.message')"
    return 1
  fi
  
  echo "Current job statuses:"
  echo "$JOBS_RESPONSE" | jq -r '.items[] | "  - \(.name): \(.status)"'
  
  return 0
}

# Monitor the workflow
while true; do
  clear
  echo "======= Workflow Monitor ======="
  echo "Workflow ID: $WORKFLOW_ID"
  echo "Time: $(date)"
  
  STATUS=$(get_workflow_status)
  echo "Workflow Status: $STATUS"
  
  # Display job information
  check_jobs
  
  # If the workflow has completed, exit the loop
  if [ "$STATUS" = "success" ] || [ "$STATUS" = "failed" ] || [ "$STATUS" = "canceled" ] || [ "$STATUS" = "error" ]; then
    echo ""
    echo "Workflow has completed with status: $STATUS"
    break
  fi
  
  echo ""
  echo "Checking again in $CHECK_INTERVAL seconds..."
  echo "Press Ctrl+C to stop monitoring"
  sleep $CHECK_INTERVAL
done

# Get detailed information about the workflow
echo "======= Workflow Details ======="
curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/workflow/$WORKFLOW_ID" | jq '.' 