# Kubernetes Deployment and Rollout Skills

This document outlines the skills and procedures for managing Kubernetes deployments, particularly focusing on rollout restarts which are essential for applying configuration changes and updating container images.

## Essential Kubernetes Rollout Commands

### Restart a Deployment

When you need to apply configuration changes, trigger a new container image pull, or force pods to be recreated:

```bash
kubectl rollout restart deployment/pioneer-agent
```

This command gracefully terminates existing pods and creates new ones with the latest configuration and image. Kubernetes maintains availability by following the deployment strategy (typically rolling update).

### Monitor Rollout Status

After initiating a rollout restart, you should always check its status:

```bash
kubectl rollout status deployment/pioneer-agent
```

This command will show the progress of the rollout and exit successfully when complete.

### Checking Pod Status

To verify the new pods are running correctly:

```bash
kubectl get pods -l app=pioneer-agent
```

### Viewing Pod Logs

If pods are failing to start or experiencing errors:

```bash
kubectl logs <pod-name>
```

### Describing Pods for Detailed Information

For detailed information about pods, including events, conditions, and container statuses:

```bash
kubectl describe pod <pod-name>
```

## Troubleshooting Rollout Issues

If a rollout is stuck or failing:

1. Check pod status and logs
2. Verify health check configuration (readiness/liveness probes)
3. Ensure container ports match Kubernetes service configuration
4. Confirm resource limits are appropriate
5. Check image availability in the registry

## Common Deployment Failure Scenarios

### Health Check Failures

- Incorrect port configuration in deployment YAML
- API endpoint unavailable or returning non-200 status
- Insufficient startup time (initialDelaySeconds too low)

### Resource Constraints

- Insufficient memory or CPU allocated
- Node resource exhaustion

### Image Pull Errors

- Missing or invalid credentials
- Image not available in registry
- Architecture mismatch (e.g., ARM vs AMD64)

## Best Practices

1. Always verify changes with `kubectl rollout status` after restart
2. Use health checks to ensure application availability
3. Set appropriate resource requests/limits
4. Implement proper logging for troubleshooting
5. Follow the MAGA (Master is Always Green) deployment strategy

## Integration with CI/CD

Our CircleCI workflow handles deployment using these same commands within the `deploy-eliza` job. The actual deployment steps are:

1. Build and push Docker image
2. Apply Kubernetes configuration with `kubectl apply`
3. Restart deployment with `kubectl rollout restart`
4. Verify rollout with `kubectl rollout status` 