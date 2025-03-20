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

# Check if workflow ID is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <workflow_id>"
  exit 1
fi

WORKFLOW_ID=$1

echo "Fetching jobs for workflow ID: $WORKFLOW_ID"

# Get jobs for the workflow
JOBS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/workflow/$WORKFLOW_ID/job")

# Check if we got a valid response
if echo "$JOBS_RESPONSE" | jq -e '.message' >/dev/null 2>&1; then
  echo "Error: $(echo $JOBS_RESPONSE | jq -r '.message')"
  exit 1
fi

# Print the jobs
echo "$JOBS_RESPONSE" | jq '.'

# Get details for each job
echo "Detailed job information:"
for JOB_ID in $(echo "$JOBS_RESPONSE" | jq -r '.items[].id'); do
  echo "Getting details for job ID: $JOB_ID"
  JOB_DETAILS=$(curl -s -H "Circle-Token: $API_TOKEN" \
    "$API_URL/job/$JOB_ID")
  
  echo "Job Details:"
  echo "$JOB_DETAILS" | jq '{id: .id, name: .name, status: .status, number: .job_number, started_at: .started_at, duration: (if .duration != null then .duration else "N/A" end)}'
  
  # Get the latest 5 steps for the job
  echo "Job Steps:"
  curl -s -H "Circle-Token: $API_TOKEN" \
    "$API_URL/job/$JOB_ID/steps" | jq '.items[0:5] | map({name: .name, status: .status, actions: .actions | map({name: .name, status: .status})})'
done 