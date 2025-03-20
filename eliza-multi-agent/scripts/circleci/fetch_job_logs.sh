#!/bin/bash

# Script to fetch CircleCI logs for a specific job using v1.1 API

# Check if job number is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <job_number> [api_token]"
  echo "Example: $0 1 your_token_here"
  exit 1
fi

# Project details
VCS_TYPE="gh"
USERNAME="coinmastersguild"
PROJECT="pioneer-agent"
JOB_NUM="$1"
API_TOKEN="$2"

# If token is not provided as argument, prompt for it
if [ -z "$API_TOKEN" ]; then
  echo "Enter your CircleCI API token: "
  read -s API_TOKEN
  if [ -z "$API_TOKEN" ]; then
    echo "Error: CircleCI API token is required"
    exit 1
  fi
fi

echo "Fetching logs for job #$JOB_NUM..."

# Get job details
LOGS_URL="https://circleci.com/api/v1.1/project/$VCS_TYPE/$USERNAME/$PROJECT/$JOB_NUM"
JOB_DATA=$(curl -s -H "Circle-Token: $API_TOKEN" "$LOGS_URL")

# Check if we got a valid response
if ! echo "$JOB_DATA" | jq . > /dev/null 2>&1; then
  echo "Error: Invalid response from API"
  echo "Raw response: $JOB_DATA"
  exit 1
fi

# Check for errors
if echo "$JOB_DATA" | jq -e 'has("message")' > /dev/null; then
  echo "API Error: $(echo "$JOB_DATA" | jq -r '.message')"
  exit 1
fi

# Print basic job info
echo "Job: $(echo "$JOB_DATA" | jq -r '.build_num') - $(echo "$JOB_DATA" | jq -r '.subject')"
echo "Status: $(echo "$JOB_DATA" | jq -r '.status')"
echo "Branch: $(echo "$JOB_DATA" | jq -r '.branch')"
echo ""

# Process and print each step with its log
for ((i=0; i<$(echo "$JOB_DATA" | jq '.steps | length'); i++)); do
  STEP_NAME=$(echo "$JOB_DATA" | jq -r ".steps[$i].name")
  echo "==== STEP: $STEP_NAME ===="
  
  # Process each action in the step
  for ((j=0; j<$(echo "$JOB_DATA" | jq ".steps[$i].actions | length"); j++)); do
    ACTION_NAME=$(echo "$JOB_DATA" | jq -r ".steps[$i].actions[$j].name // \"unknown\"")
    echo "-- Action: $ACTION_NAME --"
    
    # Get output URL
    OUTPUT_URL=$(echo "$JOB_DATA" | jq -r ".steps[$i].actions[$j].output_url // empty")
    
    if [ -n "$OUTPUT_URL" ] && [ "$OUTPUT_URL" != "null" ]; then
      echo "Fetching output from: $OUTPUT_URL"
      OUTPUT=$(curl -s -H "Circle-Token: $API_TOKEN" "$OUTPUT_URL")
      
      if [ -n "$OUTPUT" ]; then
        echo "$OUTPUT"
      else
        echo "No output received"
      fi
    else
      echo "No output URL available for this action"
    fi
    
    echo ""
  done
done

echo "Log fetching complete." 