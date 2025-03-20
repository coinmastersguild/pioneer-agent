#!/bin/bash

# This script orchestrates the entire CircleCI workflow
# It triggers a new pipeline, monitors it, and provides real-time feedback

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
BRANCH=${1:-"sprint-2"}  # Use provided branch or default to sprint-2

# Show banner
echo "======================================================"
echo "           ELIZA MULTI-AGENT DEPLOYMENT              "
echo "======================================================"
echo "Branch: $BRANCH"
echo "Starting deployment process..."
echo "------------------------------------------------------"

# 1. Trigger a new pipeline
echo "Step 1: Triggering new CircleCI pipeline"
TRIGGER_OUTPUT=$(./trigger_pipeline.sh $BRANCH)

# Extract pipeline ID
PIPELINE_ID=$(echo "$TRIGGER_OUTPUT" | grep "Pipeline ID:" | awk '{print $3}')

if [ -z "$PIPELINE_ID" ]; then
  echo "Error: Failed to get pipeline ID"
  exit 1
fi

echo "Pipeline triggered with ID: $PIPELINE_ID"
echo "------------------------------------------------------"

# 2. Wait for workflows to be created
echo "Step 2: Waiting for workflows to be created..."
sleep 10

# Get workflows for the pipeline
echo "Getting workflows for pipeline ID: $PIPELINE_ID"
WORKFLOWS_RESPONSE=$(curl -s -H "Circle-Token: $API_TOKEN" \
  "$API_URL/pipeline/$PIPELINE_ID/workflow")

# Extract workflow ID
WORKFLOW_ID=$(echo "$WORKFLOWS_RESPONSE" | jq -r '.items[0].id')

if [ -z "$WORKFLOW_ID" ] || [ "$WORKFLOW_ID" == "null" ]; then
  echo "Error: No workflow found for pipeline"
  exit 1
fi

echo "Workflow created with ID: $WORKFLOW_ID"
echo "------------------------------------------------------"

# 3. Monitor the workflow
echo "Step 3: Monitoring workflow progress"
./monitor_workflow.sh $WORKFLOW_ID 15

# 4. Show final job details
echo "Step 4: Retrieving final job details"
./get_workflow_jobs.sh $WORKFLOW_ID

echo "======================================================"
echo "           DEPLOYMENT PROCESS COMPLETE               "
echo "======================================================" 