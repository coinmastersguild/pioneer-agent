#!/bin/bash

# Script to commit and push CircleCI config fixes

echo "Committing CircleCI config fixes..."

# Navigate to the repository root
cd /Users/highlander/WebstormProjects/pioneer-agent

# Stage the changes
git add .circleci/config.yml eliza-multi-agent/.circleci/config.yml

# Commit the changes
git commit -m "Fix CircleCI config: align workflow names and job references"

echo "Changes committed. Ready to push."
echo ""
echo "To push these changes and trigger a new build, run:"
echo "  git push origin main"
echo ""
echo "After pushing, check the build status at:"
echo "  https://app.circleci.com/pipelines/github/coinmastersguild/pioneer-agent" 