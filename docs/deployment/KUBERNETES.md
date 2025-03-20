# Kubernetes Deployment Guide

## Overview

The DegenQuest game server is deployed on DigitalOcean Kubernetes using Pulumi for infrastructure as code. All infrastructure and configuration management must be performed through Pulumi—no local YAML (`.yml`) files should be created or manually deployed.

## Deployment Architecture

Key components managed by Pulumi:

- **degen-server**: Main game server deployment
- **Services**: Exposing deployments via LoadBalancer

**Note:** The previous use of Persistent Volume Claims (PVC) for SQLite database persistence has been removed. Future deployment iterations will migrate to a remote database solution.

### Configuration Management

Deployment toggles are managed exclusively through the Pulumi configuration (`deploy/config.ts`):

```typescript
export const services = {
    // Enabled services
    DegenServer: true,
    pioneerServer: true,

    // Disabled services
    keepkeySupport: false,
};
```

## Common Operations

### Viewing Deployments
```bash
kubectl get deployments
```

### Checking Pod Status
```bash
kubectl get pods | grep degen-server
```

### Getting Pod Logs
```bash
# Get logs from a specific pod
kubectl logs <pod-name>

# Stream logs from a pod
kubectl logs -f <pod-name>

# Logs with timestamps
kubectl logs --timestamps=true <pod-name>
```

### Restarting a Deployment
```bash
kubectl rollout restart deployment <deployment-name>
```

### Scaling a Deployment
```bash
# Scale down (turn off)
kubectl scale deployment <deployment-name> --replicas=0

# Scale up (turn on)
kubectl scale deployment <deployment-name> --replicas=1
```

## Debug and Troubleshooting

### Inspecting Pod Details
```bash
kubectl describe pod <pod-name>
```

### Common Issues

#### Pods Stuck in Pending
Check events:

```bash
kubectl describe pod <pod-name>
```
Possible reasons:
- Resource constraints
- Node scheduling issues

#### Database Type Errors
(This section is temporarily obsolete until the remote DB migration is complete.)

#### Access Container Shell
```bash
kubectl exec -it <pod-name> -- /bin/bash
```

### Viewing Deployment Details
```bash
kubectl get deployment <deployment-name> -o yaml
```

## Updating Deployment

Always use Pulumi:

```bash
cd deploy
pulumi update
```

Never manually create or apply YAML files locally.

## Log Collection Strategy

Debug complex issues:

1. Capture logs:
```bash
kubectl logs <pod-name> > server-logs.txt
```

2. Compare local logs:
```bash
npm run dev > local-logs.txt
```

3. Diff logs:
```bash
diff server-logs.txt local-logs.txt
```

## Environment Differences

Consider:
- Persistent storage differences
- Network latency
- Container resources
- Environment variables

## Performance Monitoring
```bash
kubectl top pods
kubectl describe pod <pod-name> | grep -A 10 "Resources"
```

This guide ensures consistent infrastructure management using Pulumi, eliminating manual YAML file creation or local deployments.

