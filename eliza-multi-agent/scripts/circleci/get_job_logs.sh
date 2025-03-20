#!/bin/bash

# Get logs for a specific job
if [ -z "$1" ]; then
  echo "Usage: $0 <job_number>"
  exit 1
fi

JOB_NUMBER=$1

# Load env vars
if [ -f ".env" ]; then
  source .env
fi

# If token isn't set, prompt for it
if [ -z "$CIRCLE_CI_TOKEN" ]; then
  echo "Enter your CircleCI token: "
  read -s CIRCLE_CI_TOKEN
  if [ -z "$CIRCLE_CI_TOKEN" ]; then
    echo "Error: CIRCLE_CI_TOKEN is required"
    exit 1
  fi
fi

# Get logs using v1.1 API - note: job_number should be numeric, not UUID
curl -s -H "Circle-Token: $CIRCLE_CI_TOKEN" "https://circleci.com/api/v1.1/project/gh/coinmastersguild/pioneer-agent/$JOB_NUMBER" | jq "." 