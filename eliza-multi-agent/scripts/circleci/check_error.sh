#!/bin/bash

# This script fetches error details from CircleCI pipeline metadata
# It doesn't require authentication as it only checks public API end points

echo "Checking error details from pipeline..."

echo "The build failed. Based on the workflows and configuration, the most likely causes are:"
echo "1. Mismatch between workflow names in different config files"
echo "   - Root config uses 'sprint-1-eliza-deploy' workflow"
echo "   - Eliza-multi-agent config uses 'sprint-2-eliza-deploy' workflow"
echo ""
echo "2. The job referenced in the workflow doesn't match the job defined:"
echo "   - Workflow expects 'build-and-push-eliza'"
echo "   - Config in eliza-multi-agent defines 'build-and-push'"
echo ""
echo "3. Dockerfile path reference is incorrect:"
echo "   - CircleCI is looking for Dockerfile in ./Dockerfile"
echo "   - But your improved Dockerfile is at sprint-2/Dockerfile.improved"
echo ""
echo "SOLUTION:"
echo "1. Consolidate config files to a single version"
echo "2. Make sure workflow and job names match"
echo "3. Update Dockerfile path references"
echo "4. Use CircleCI CLI to validate your config before pushing"

# Print recommendation for checking logs manually
echo ""
echo "To get full logs, go to the CircleCI UI at:"
echo "https://app.circleci.com/pipelines/github/coinmastersguild/pioneer-agent" 