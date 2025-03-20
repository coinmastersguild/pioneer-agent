# CircleCI Configuration for DigitalOcean Container Registry Push

## Overview

Pushing the Eliza multi-agent container to the DigitalOcean container registry requires a properly configured CircleCI job with appropriate authentication and build parameters. This document outlines the requirements and configuration details.

## Prerequisites

1. **DigitalOcean API Token**: A valid API token with write access to the container registry
2. **CircleCI Environment Variables**: The token must be stored as a secure environment variable in CircleCI
3. **Docker BuildX Support**: For multi-architecture builds
4. **Valid Dockerfile**: A properly configured Dockerfile that builds successfully

## CircleCI Job Configuration

The following CircleCI job configuration is required for pushing to the DigitalOcean container registry:

```yaml
build-and-push-eliza:
  machine:
    image: ubuntu-2004:current
    docker_layer_caching: true
  resource_class: large
  steps:
    - checkout
    
    # Restore Docker cache
    - restore_cache:
        keys:
          - eliza-docker-cache-{{ .Branch }}-{{ .Revision }}
          - eliza-docker-cache-{{ .Branch }}-
          - eliza-docker-cache-
    
    # Enable Docker experimental features
    - run:
        name: Enable Docker experimental features
        command: |
          mkdir -p ~/.docker
          echo '{"experimental": "true"}' | tee ~/.docker/config.json
    
    # Set up Docker buildx
    - run:
        name: Set up Docker buildx
        command: |
          docker version
          
          BUILDX_VERSION=v0.12.1
          mkdir -p ~/.docker/cli-plugins
          curl -sSL "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" -o ~/.docker/cli-plugins/docker-buildx
          chmod +x ~/.docker/cli-plugins/docker-buildx
          
          docker buildx version
          docker buildx rm mybuilder || true
          docker buildx create --use --name mybuilder --driver docker-container
          docker buildx inspect --bootstrap mybuilder
    
    # Login to DigitalOcean Registry
    - run:
        name: Login to DigitalOcean Container Registry
        command: |
          echo $DIGITALOCEAN_ACCESS_TOKEN | docker login registry.digitalocean.com -u $DIGITALOCEAN_ACCESS_TOKEN --password-stdin
    
    # Build and push
    - run:
        name: Build and push Eliza multi-agent image
        command: |
          cd eliza-multi-agent
          
          # Try with buildx for multi-platform
          echo "Building with buildx for amd64..."
          docker buildx build \
            --platform linux/amd64 \
            -t registry.digitalocean.com/pioneer/pioneer-agent:${CIRCLE_SHA1} \
            -t registry.digitalocean.com/pioneer/pioneer-agent:latest \
            -f ./Dockerfile \
            --cache-from=registry.digitalocean.com/pioneer/pioneer-agent:latest \
            --build-arg BUILDKIT_INLINE_CACHE=1 \
            --push \
            .
    
    # Save cache for future builds
    - save_cache:
        key: eliza-docker-cache-{{ .Branch }}-{{ .Revision }}
        paths:
          - /home/circleci/.docker/buildx
```

## Environment Variables

The following environment variables must be configured in CircleCI:

| Variable Name | Description | Notes |
|---------------|-------------|-------|
| DIGITALOCEAN_ACCESS_TOKEN | DigitalOcean API token | Must have container registry write access |

## Required Workflow Configuration

The workflow must be configured to run on the appropriate branch:

```yaml
workflows:
  version: 2
  sprint-1-eliza-deploy:
    jobs:
      - build-and-push-eliza:
          filters:
            branches:
              only:
                - sprint-1
                - main
```

## Testing Limitations

- **Local Testing Not Possible**: Pushing to DigitalOcean's registry requires authentication that should only be stored in CircleCI
- **Build Verification**: While the build step can be tested locally, the push step must be tested through CircleCI
- **Alternative Approach**: For local testing, consider pushing to a local registry or Docker Hub with a temporary tag

## Issue Encountered

Even with proper CircleCI configuration, the build process failed during the Docker build step due to architecture-specific dependencies. The push step was not reached because the build could not complete successfully.

## Next Steps

1. Fix the Dockerfile to properly build on CircleCI's Ubuntu environment
2. Consider using a Docker image that better matches the CircleCI environment for local testing
3. Use BuildX's `--platform` flag to explicitly build for the target architecture (linux/amd64)
4. Consider using a multi-stage build with appropriate base images for each stage 