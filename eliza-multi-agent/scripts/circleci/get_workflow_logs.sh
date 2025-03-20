#!/bin/bash

# Get logs for an entire workflow
if [ -z "$1" ]; then
  echo "Usage: $0 <workflow_id> [token]"
  exit 1
fi

WORKFLOW_ID=$1
CIRCLE_CI_TOKEN=$2

# If token isn't set as argument, prompt for it
if [ -z "$CIRCLE_CI_TOKEN" ]; then
  echo "Enter your CircleCI token: "
  read -s CIRCLE_CI_TOKEN
  if [ -z "$CIRCLE_CI_TOKEN" ]; then
    echo "Error: CircleCI token is required"
    exit 1
  fi
fi

echo "Getting jobs for workflow $WORKFLOW_ID..."

# Step 1: Get the jobs for the workflow using v2 API
API_RESPONSE=$(curl -s -H "Circle-Token: $CIRCLE_CI_TOKEN" "https://circleci.com/api/v2/workflow/$WORKFLOW_ID/job")

# Debug: Show raw API response
echo "Raw API response:"
echo "$API_RESPONSE"

# Check if response is valid JSON
if ! echo "$API_RESPONSE" | jq . > /dev/null 2>&1; then
  echo "Error: Invalid JSON response from API"
  exit 1
fi

# Check if the API returned an error
if echo "$API_RESPONSE" | jq -e 'has("message")' > /dev/null; then
  echo "API Error: $(echo "$API_RESPONSE" | jq -r '.message')"
  exit 1
fi

# Print job information
echo "Jobs for workflow:"
echo "$API_RESPONSE" | jq -r '.items[] | {job_number, name, status}' 2>/dev/null || echo "No jobs found or invalid response format"

# Step 2: Get the job numbers from the response
JOB_NUMBERS=$(echo "$API_RESPONSE" | jq -r '.items[] | .job_number' 2>/dev/null)

if [ -z "$JOB_NUMBERS" ]; then
  echo "No job numbers found in response"
  exit 1
fi

# Step 3: For each job number, get the logs using v1.1 API
for JOB_NUM in $JOB_NUMBERS; do
  echo "Getting logs for job number $JOB_NUM..."
  JOB_DETAILS=$(curl -s -H "Circle-Token: $CIRCLE_CI_TOKEN" "https://circleci.com/api/v1.1/project/gh/coinmastersguild/pioneer-agent/$JOB_NUM")
  
  # Debug: Show raw job details
  echo "Raw job details:"
  echo "$JOB_DETAILS"
  
  # Check if response is valid JSON
  if ! echo "$JOB_DETAILS" | jq . > /dev/null 2>&1; then
    echo "Error: Invalid JSON response for job $JOB_NUM"
    continue
  fi
  
  echo "Job details:"
  echo "$JOB_DETAILS" | jq '.steps[] | {name, actions}' 2>/dev/null || echo "No steps found or invalid response format"
done 