#!/bin/bash
set -e

# Configuration
IMAGE_NAME="registry.digitalocean.com/pioneer/pioneer-agent"
IMAGE_TAG="latest"

echo "Building API Docker image..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .

echo "Pushing Docker image to registry..."
docker push ${IMAGE_NAME}:${IMAGE_TAG}

echo "Applying Kubernetes configuration with health checks directly to API port..."
kubectl apply -f ./k8s/pioneer-agent-api.yaml

echo "Restarting deployment to pick up new image..."
kubectl rollout restart deployment/pioneer-agent

echo "Waiting for rollout to complete..."
kubectl rollout status deployment/pioneer-agent

echo "Deployment complete. Check pod status with:"
echo "kubectl get pods" 