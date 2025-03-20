# Pioneer Agent Deployment Guide

This document outlines the complete process for deploying the Pioneer Agent application and monitoring deployments.

## Prerequisites

- Docker installed
- Kubernetes CLI (kubectl) configured with your cluster
- Pulumi CLI installed
- CircleCI token for CI/CD monitoring
- Access to DigitalOcean Registry

## Deployment Process

### 1. Repository Setup

Clone both repositories:

```bash
git clone https://github.com/coinmastersguild/pioneer-agent.git
git clone https://github.com/BitHighlander/pioneer-deployment.git
```

### 2. Application Configuration

The application is configured using environment variables. Key configuration files:

- `/Users/highlander/WebstormProjects/pioneer-agent/eliza-multi-agent/Dockerfile` - Container configuration
- `/Users/highlander/WebstormProjects/pioneer-agent/eliza-multi-agent/client/vite.config.ts` - Frontend configuration
- `/Users/highlander/WebstormProjects/pioneer-agent/eliza-multi-agent/package.json` - Application scripts

Important settings:
- Set `host: '0.0.0.0'` in Vite config to ensure the application binds to all network interfaces
- Use proxy server (server-proxy.js) to serve both API and UI from a single port (8080)

### 3. Kubernetes/Pulumi Deployment

The deployment is managed using Pulumi and configured in:
- `/Users/highlander/WebstormProjects/pioneer-deployment/deploy/config.ts` - Service configuration
- `/Users/highlander/WebstormProjects/pioneer-deployment/deploy/index.ts` - Kubernetes deployment specs

To deploy:

```bash
cd /Users/highlander/WebstormProjects/pioneer-deployment/deploy
pulumi up --yes
```

Key deployment components:

```typescript
// Pioneer Agent deployment
const appLabelPioneerAgent = { "app": "pioneer-agent" };
const pioneerAgent = new kubernetes.apps.v1.Deployment("pioneer-agent", {
    spec: {
        selector: { matchLabels: appLabelPioneerAgent },
        replicas: 1,
        template: {
            metadata: { labels: appLabelPioneerAgent },
            spec: {
                containers: [{
                    env: [...env],
                    name: "pioneer-agent",
                    image: "registry.digitalocean.com/pioneer/pioneer-agent:latest",
                    ports: [
                        { containerPort: 3000, name: "api" },
                        { containerPort: 5173, name: "client" },
                        { containerPort: 8080, name: "proxy" }
                    ],
                }],
            },
        },
    },
});

// Service configuration
const pioneerAgentService = new kubernetes.core.v1.Service("svc-pioneer-agent", {
    spec: {
        type: "ClusterIP",
        selector: pioneerAgent.spec.template.metadata.labels,
        ports: [
            { name: "api", port: 3000, targetPort: 3000 },
            { name: "client", port: 5173, targetPort: 5173 },
            { name: "proxy", port: 8080, targetPort: 8080 },
        ],
    },
});

// IngressRoute configuration (Traefik)
const pioneerAgentRoute = new kubernetes.apiextensions.CustomResource("pioneer-agent-route", {
    apiVersion: "traefik.containo.us/v1alpha1",
    kind: "IngressRoute",
    metadata: {
        name: "pioneer-agent-route"
    },
    spec: {
        entryPoints: ["web", "websecure"],
        routes: [{
            match: "PathPrefix(`/`)",
            kind: "Rule",
            services: [{
                name: pioneerAgentService.metadata.name,
                port: 8080
            }]
        }]
    },
});
```

### 4. Verify Deployment

After deploying, verify components:

```bash
# Check all pods
kubectl get pods

# Check pioneer-agent pods specifically
kubectl get pods -l app=pioneer-agent

# Check services
kubectl get service | grep pioneer-agent

# Check ingress routes
kubectl get ingressroute

# View detailed configuration
kubectl describe ingressroute pioneer-agent-route
```

The application should be accessible via:
- API: https://[TRAEFIK_IP]/api
- UI: https://[TRAEFIK_IP]/ 

## CircleCI Monitoring and Troubleshooting

### 1. Setting Up CircleCI Access

Set your CircleCI token:

```bash
export CIRCLE_CI_TOKEN="your-token-here"
```

### 2. Checking Build Status

To check the latest build status:

```bash
cd /Users/highlander/WebstormProjects/pioneer-agent/eliza-multi-agent/scripts/circleci
curl -s -H "Circle-Token: ${CIRCLE_CI_TOKEN}" https://circleci.com/api/v1.1/project/github/coinmastersguild/pioneer-agent?limit=1 | jq '.[0]'
```

Check specific status fields:

```bash
# Check just the status
curl -s -H "Circle-Token: ${CIRCLE_CI_TOKEN}" https://circleci.com/api/v1.1/project/github/coinmastersguild/pioneer-agent?limit=1 | jq '.[0].status'

# Check build subject and any failure reason
curl -s -H "Circle-Token: ${CIRCLE_CI_TOKEN}" https://circleci.com/api/v1.1/project/github/coinmastersguild/pioneer-agent?limit=1 | jq '.[0].subject, .[0].fail_reason'
```

### 3. Fetching Build Logs

To fetch detailed logs for a specific build:

```bash
# Replace 9 with your build number
curl -s -H "Circle-Token: ${CIRCLE_CI_TOKEN}" "https://circleci.com/api/v1.1/project/github/coinmastersguild/pioneer-agent/9/output" | jq
```

For workflow details:

```bash
# Get workflow jobs 
./get_workflow_jobs.sh [workflow-id]

# Get workflow logs
./get_workflow_logs.sh [workflow-id]
```

### 4. Triggering New Builds

To manually trigger a new build:

```bash
./trigger_pipeline.sh
```

### 5. Troubleshooting Failed Builds

Common issues to check:
- Docker build failures (check Dockerfile)
- Missing or incompatible dependencies
- Platform compatibility issues
- Resource limits
- Authorization problems with registries

Check the specific step that failed:

```bash
curl -s -H "Circle-Token: ${CIRCLE_CI_TOKEN}" "https://circleci.com/api/v1.1/project/github/coinmastersguild/pioneer-agent/[build-number]/output" | jq '.[] | select(.message | contains("error"))'
```

## Additional Resources

- [CircleCI API Documentation](https://circleci.com/docs/api/v1/)
- [Pulumi Kubernetes Documentation](https://www.pulumi.com/registry/packages/kubernetes/)
- [Traefik IngressRoute Documentation](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/)

## Common Issues and Solutions

1. **404 Not Found after deployment**
   - Check if Vite is binding to localhost instead of 0.0.0.0
   - Verify IngressRoute is pointing to the correct service and port

2. **CircleCI build failures**
   - Platform compatibility issues with ARM64/AMD64
   - Missing dependencies in Dockerfile
   - Check for syntax errors in configuration files

3. **Connection refused / service unavailable**
   - Check if pods are running (`kubectl get pods`)
   - Check service configuration (`kubectl describe service [service-name]`)
   - Verify IngressRoute configuration (`kubectl describe ingressroute [route-name]`) 