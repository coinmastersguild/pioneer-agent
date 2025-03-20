# API-Only Deployment

This document outlines the deployment strategy for running only the Agent API server while hosting the client separately on Vercel.

## Overview

In this deployment approach:
1. The Agent API server runs in a Docker container on Kubernetes (DigitalOcean)
2. The client/frontend is hosted separately on Vercel
3. The API exposes ports 3000 (direct agent API) and 8080 (proxy)

## Deployment Architecture

```
┌────────────────────────┐        ┌────────────────────────┐
│                        │        │                        │
│     Client (Vercel)    │◄───────┤  Agent API (Kubernetes)│
│                        │        │                        │
└────────────────────────┘        └────────────────────────┘
```

## Docker Image Structure

The API-only Docker image:
- Builds only the necessary API components
- Exposes ports 3000 (direct agent API) and 8080 (proxy server)
- No longer includes the client/frontend code
- Maintains all the same agent capabilities

## Ports Configuration

The Docker container exposes two ports:
- **3000**: The direct agent API port (internal)
- **8080**: The proxy server port (external)

The Kubernetes service should expose port 8080 which then routes to the container.

## CircleCI Integration

The CI/CD pipeline:
1. Builds the API-only Docker image using `Dockerfile.api-only`
2. Pushes the image to DigitalOcean Container Registry
3. Deploys the image to Kubernetes

## Pulumi Deployment Updates

The Pulumi deployment configuration has been updated to:
1. Only expose the API ports (3000 and 8080)
2. Use a LoadBalancer service type
3. Set appropriate resource limits

## Client Deployment on Vercel

To deploy the client on Vercel:
1. Create a new Vercel project pointing to the client directory
2. Set the environment variable `API_URL` to point to your Kubernetes service URL
3. Deploy the client to Vercel

## API URL Configuration

The client needs to know where to find the API. Set the following environment variables in the Vercel dashboard:

```
VITE_API_URL=https://your-api-domain.com
```

## Health Check

The API container includes a health check endpoint at `/api/health` that returns a 200 OK response when the service is healthy.

## Troubleshooting

### API Connection Issues
- Verify the Kubernetes service is running: `kubectl get svc pioneer-agent`
- Check container logs: `kubectl logs deployment/pioneer-agent`
- Verify the LoadBalancer has an external IP: `kubectl get svc pioneer-agent -o wide`

### CORS Issues
- The API server is configured with CORS headers allowing cross-origin requests
- If experiencing CORS issues, verify the client's origin is properly allowed

## Rollback Procedure

If a deployment fails:
1. Identify the last working image tag
2. Update the deployment with the working tag:
   ```
   kubectl set image deployment/pioneer-agent pioneer-agent=registry.digitalocean.com/pioneer/pioneer-agent:[WORKING_TAG]
   ```
3. Verify the rollback: `kubectl rollout status deployment/pioneer-agent` 