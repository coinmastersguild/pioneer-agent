# Pulumi Deployment Analysis

## Overview

This document analyzes the Pulumi deployment requirements for the Eliza multi-agent application to DigitalOcean Kubernetes. While Sprint 1 didn't reach the deployment phase due to containerization issues, this analysis documents the planned approach and requirements for future sprints.

## Pulumi Project Location

The Pulumi deployment code is located at:
```
/Users/highlander/WebstormProjects/pioneer-deployment/deploy/index.ts
```

## Deployment Environment Requirements

### Infrastructure Components

1. **DigitalOcean Kubernetes Cluster**
   - Existing cluster: `do-cluster-2b9226d`
   - Accessible via DigitalOcean API token

2. **Container Registry**
   - Registry: `registry.digitalocean.com/pioneer`
   - Image: `pioneer-agent`
   - Tags: Latest and commit-specific tags

3. **Deployment Resource Requirements**
   - CPU: 2 cores minimum
   - Memory: 4GB minimum
   - Storage: PVC for persistent data

### Authentication Requirements

1. **DigitalOcean API Token**
   - Requires read/write access to Kubernetes cluster
   - Requires read/write access to container registry

2. **Kubernetes Config**
   - Generated via `doctl kubernetes cluster kubeconfig save do-cluster-2b9226d`
   - Required for deployment validation

## Pulumi Deployment Components

### 1. Kubernetes Namespace

```typescript
const namespace = new k8s.core.v1.Namespace("pioneer-agent", {
    metadata: {
        name: "pioneer-agent",
    },
});
```

### 2. Deployment

```typescript
const deployment = new k8s.apps.v1.Deployment("pioneer-agent", {
    metadata: {
        namespace: namespace.metadata.name,
    },
    spec: {
        selector: {
            matchLabels: {
                app: "pioneer-agent",
            },
        },
        replicas: 1,
        template: {
            metadata: {
                labels: {
                    app: "pioneer-agent",
                },
            },
            spec: {
                containers: [{
                    name: "pioneer-agent",
                    image: "registry.digitalocean.com/pioneer/pioneer-agent:latest",
                    ports: [
                        { containerPort: 3000, name: "server" },
                        { containerPort: 5173, name: "client" }
                    ],
                    resources: {
                        requests: {
                            cpu: "1",
                            memory: "2Gi",
                        },
                        limits: {
                            cpu: "2",
                            memory: "4Gi",
                        },
                    },
                    env: [
                        // Environment variables would be defined here
                    ],
                    livenessProbe: {
                        httpGet: {
                            path: "/api/health",
                            port: "server",
                        },
                        initialDelaySeconds: 30,
                        periodSeconds: 10,
                    },
                    readinessProbe: {
                        httpGet: {
                            path: "/api/health",
                            port: "server",
                        },
                        initialDelaySeconds: 5,
                        periodSeconds: 5,
                    },
                }],
            },
        },
    },
});
```

### 3. Service

```typescript
const service = new k8s.core.v1.Service("pioneer-agent", {
    metadata: {
        namespace: namespace.metadata.name,
    },
    spec: {
        selector: {
            app: "pioneer-agent",
        },
        ports: [
            { port: 80, targetPort: 3000, name: "server" },
            { port: 5173, targetPort: 5173, name: "client" }
        ],
        type: "LoadBalancer",
    },
});
```

### 4. Persistent Volume Claim (if needed)

```typescript
const pvc = new k8s.core.v1.PersistentVolumeClaim("pioneer-agent-data", {
    metadata: {
        namespace: namespace.metadata.name,
    },
    spec: {
        accessModes: ["ReadWriteOnce"],
        resources: {
            requests: {
                storage: "10Gi",
            },
        },
        storageClassName: "do-block-storage",
    },
});
```

## Deployment Process Using Pulumi

1. **Authentication Setup**
   ```bash
   pulumi login
   pulumi stack select dev  # or prod
   doctl auth init -t $DIGITALOCEAN_ACCESS_TOKEN
   doctl kubernetes cluster kubeconfig save do-cluster-2b9226d
   ```

2. **Preview Changes**
   ```bash
   pulumi preview
   ```

3. **Apply Changes**
   ```bash
   pulumi up
   ```

4. **Verify Deployment**
   ```bash
   kubectl get pods -n pioneer-agent
   kubectl get services -n pioneer-agent
   ```

## CI/CD Integration

The CircleCI configuration would need to be updated to include the Pulumi deployment step after successful image build and push:

```yaml
deploy-eliza-pulumi:
  docker:
    - image: pulumi/pulumi:latest
  steps:
    - checkout
    - run:
        name: Install doctl
        command: |
          apt-get update && apt-get install -y curl
          cd /tmp
          curl -sL https://github.com/digitalocean/doctl/releases/download/v1.101.0/doctl-1.101.0-linux-amd64.tar.gz | tar -xzv
          mv doctl /usr/local/bin
    - run:
        name: Setup Kubernetes Config
        command: |
          doctl auth init -t $DIGITALOCEAN_ACCESS_TOKEN
          doctl kubernetes cluster kubeconfig save do-cluster-2b9226d
    - run:
        name: Deploy with Pulumi
        command: |
          cd /path/to/pioneer-deployment/deploy
          pulumi login --local
          pulumi stack select dev
          REGISTRY_IMAGE_TAG=${CIRCLE_SHA1} pulumi up --yes
```

## Environment Variables

The following environment variables would need to be passed to the deployment:

1. **Application Configuration**
   - `NODE_ENV`
   - `SERVER_PORT`
   - `CLIENT_PORT`
   - Any API keys or service credentials

2. **Infrastructure Configuration**
   - `REGISTRY_IMAGE_TAG`: The specific image tag to deploy (e.g., commit SHA)

## Deployment Challenges and Considerations

1. **Environment Configuration**: Managing the extensive `.env` file in Kubernetes
2. **Secrets Management**: Securely handling sensitive credentials
3. **Resource Scaling**: Determining appropriate resource limits based on actual usage
4. **Networking Rules**: Ensuring proper port configuration and access control
5. **Health Monitoring**: Implementing appropriate readiness and liveness probes

## Future Improvements

1. **Horizontal Pod Autoscaling**: Automatically scale based on CPU/memory usage
2. **Rolling Updates Strategy**: Configure zero-downtime deployments
3. **Network Policies**: Restrict network traffic between components
4. **Monitoring and Logging**: Integrate with observability tools

## Conclusion

While Sprint 1 didn't reach the Pulumi deployment phase, this analysis provides a foundation for implementing the deployment in future sprints. The key challenge remains resolving the containerization issues to create a stable, functioning Docker image that can be deployed via Pulumi. 