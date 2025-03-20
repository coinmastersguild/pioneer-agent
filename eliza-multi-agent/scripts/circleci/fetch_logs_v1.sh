#!/bin/bash

# Script to fetch CircleCI logs using v1.1 API
# This script requires a CircleCI API token with read access

# Workflow ID from failed build
WORKFLOW_ID="94f18082-37c2-4f6a-9c4c-50fc152fb7f9"

# Project details
VCS_TYPE="gh"
USERNAME="coinmastersguild"
PROJECT="pioneer-agent"

# Load from .env if it exists
if [ -f ".env" ]; then
  echo "Loading token from .env file..."
  source .env
fi

# Prompt for token if not provided as argument and not in .env
if [ -z "$CIRCLE_CI_TOKEN" ] && [ -z "$1" ]; then
  echo "Enter your CircleCI API token: "
  read -s CIRCLE_CI_TOKEN
elif [ -z "$CIRCLE_CI_TOKEN" ] && [ -n "$1" ]; then
  CIRCLE_CI_TOKEN="$1"
fi

if [ -z "$CIRCLE_CI_TOKEN" ]; then
  echo "Error: CircleCI API token is required"
  exit 1
fi

echo "Fetching jobs for workflow $WORKFLOW_ID..."

# Step 1: Get the jobs from the workflow (v2 API)
JOBS_RESPONSE=$(curl -s -H "Circle-Token: $CIRCLE_CI_TOKEN" "https://circleci.com/api/v2/workflow/$WORKFLOW_ID/job")

# Check if we got a valid response
if ! echo "$JOBS_RESPONSE" | jq . > /dev/null 2>&1; then
  echo "Error: Invalid response from v2 API"
  echo "Raw response: $JOBS_RESPONSE"
  exit 1
fi

# Extract job numbers
echo "Jobs in workflow:"
echo "$JOBS_RESPONSE" | jq -r '.items[] | "\(.job_number): \(.name) (\(.status))"'

# Get job numbers
JOB_NUMBERS=$(echo "$JOBS_RESPONSE" | jq -r '.items[] | .job_number')

if [ -z "$JOB_NUMBERS" ]; then
  echo "No job numbers found. Using fixed job number for failed job..."
  # Based on workflow logs, we know this is the failed job
  JOB_NUMBERS="1"
fi

# Step 2: Fetch logs for each job
for JOB_NUM in $JOB_NUMBERS; do
  echo ""
  echo "===================="
  echo "Fetching logs for job #$JOB_NUM..."
  echo "===================="
  
  LOGS_URL="https://circleci.com/api/v1.1/project/$VCS_TYPE/$USERNAME/$PROJECT/$JOB_NUM"
  JOB_DATA=$(curl -s -H "Circle-Token: $CIRCLE_CI_TOKEN" "$LOGS_URL")
  
  # Check if we got a valid response
  if ! echo "$JOB_DATA" | jq . > /dev/null 2>&1; then
    echo "Error: Invalid response from v1.1 API"
    echo "Raw response: $JOB_DATA"
    continue
  fi
  
  # Check for errors
  if echo "$JOB_DATA" | jq -e 'has("message")' > /dev/null; then
    echo "API Error: $(echo "$JOB_DATA" | jq -r '.message')"
    continue
  fi
  
  # Print basic job info
  echo "Job: $(echo "$JOB_DATA" | jq -r '.build_num') - $(echo "$JOB_DATA" | jq -r '.subject')"
  echo "Status: $(echo "$JOB_DATA" | jq -r '.status')"
  echo "Branch: $(echo "$JOB_DATA" | jq -r '.branch')"
  echo ""
  
  # Print steps with their logs
  echo "$JOB_DATA" | jq -r '.steps[] | "Step: \(.name)"' 
  
  # Get detailed logs for each step
  STEPS=$(echo "$JOB_DATA" | jq -r '.steps[] | .name')
  STEP_NUM=0
  
  for STEP in $STEPS; do
    echo ""
    echo "## Step: $STEP"
    echo ""
    
    # Get actions for this step
    ACTIONS=$(echo "$JOB_DATA" | jq -r --arg step "$STEP_NUM" '.steps[$step | tonumber].actions[].output_url // empty')
    
    if [ -z "$ACTIONS" ]; then
      echo "No output available for this step"
      continue
    fi
    
    # Fetch each output URL
    for OUTPUT_URL in $ACTIONS; do
      if [ -n "$OUTPUT_URL" ] && [ "$OUTPUT_URL" != "null" ]; then
        echo "Fetching output from: $OUTPUT_URL"
        OUTPUT=$(curl -s -H "Circle-Token: $CIRCLE_CI_TOKEN" "$OUTPUT_URL")
        
        if [ -n "$OUTPUT" ]; then
          echo "$OUTPUT"
        else
          echo "No output received"
        fi
      fi
    done
    
    STEP_NUM=$((STEP_NUM + 1))
  done
done

echo ""
echo "Log fetching complete." 