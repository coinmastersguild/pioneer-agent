#!/bin/bash

# Monitor a CircleCI job until it completes, then fetch its logs
JOB_NUMBER=$1
MAX_CHECKS=20
CHECK_INTERVAL=30

if [ -z "$JOB_NUMBER" ]; then
  echo "Usage: $0 <job_number>"
  exit 1
fi

PROJECT_SLUG="gh/coinmastersguild/pioneer-agent"
CIRCLE_TOKEN=${CIRCLE_TOKEN:-$CIRCLECI_TOKEN}

echo "Monitoring job #$JOB_NUMBER..."

for i in $(seq 1 $MAX_CHECKS); do
  echo "Check $i of $MAX_CHECKS..."
  
  JOB_STATUS=$(curl -s --request GET \
    --url "https://circleci.com/api/v2/project/${PROJECT_SLUG}/job/${JOB_NUMBER}" \
    --header "Circle-Token: $CIRCLE_TOKEN" | jq -r '.status')
  
  echo "Current status: $JOB_STATUS"
  
  if [ "$JOB_STATUS" == "success" ] || [ "$JOB_STATUS" == "failed" ]; then
    echo "Job completed with status: $JOB_STATUS"
    break
  elif [ "$JOB_STATUS" == "null" ] || [ "$JOB_STATUS" == "unauthorized" ]; then
    echo "Error fetching job status"
    exit 1
  fi
  
  echo "Waiting $CHECK_INTERVAL seconds for next check..."
  sleep $CHECK_INTERVAL
done

echo "Fetching logs for job #$JOB_NUMBER..."

curl -s --request GET \
  --url "https://circleci.com/api/v2/project/${PROJECT_SLUG}/${JOB_NUMBER}/items" \
  --header "Circle-Token: $CIRCLE_TOKEN" | \
  jq -r '.items[] | select(.type=="step") | [.step_number, .name] | @tsv' | \
  while read -r STEP_NUM STEP_NAME; do
    echo "Step $STEP_NUM: $STEP_NAME"
    
    # Get log output for this step
    LOG_URL="https://circleci.com/api/v2/project/${PROJECT_SLUG}/${JOB_NUMBER}/logs"
    LOG_OUTPUT=$(curl -s --request GET "$LOG_URL" --header "Circle-Token: $CIRCLE_TOKEN" | \
      jq -r ".items[] | select(.step==$STEP_NUM) | .message")
    
    echo "=== LOG START ==="
    echo "$LOG_OUTPUT"
    echo "=== LOG END ==="
    echo ""
  done 