# Resource Constraints Resolution Plan

## Issue Summary
The Pioneer Agent deployment is failing because the pod's memory request (2Gi) and CPU request (1 core) cannot be accommodated by any of the available nodes in the cluster. The scheduler logs indicate: "0/5 nodes are available: 5 Insufficient memory".

## Action Plan

### Immediate Fix (Reduce Resource Requirements)

1. Edit the deployment to reduce resource requirements:

```bash
kubectl edit deployment pioneer-agent
```

And modify the resource section to:

```yaml
resources:
  limits:
    cpu: 1
    memory: 2Gi
  requests:
    cpu: 500m
    memory: 1Gi
```

2. Alternative approach - patch the deployment:

```bash
kubectl patch deployment pioneer-agent -p '{"spec":{"template":{"spec":{"containers":[{"name":"pioneer-agent","resources":{"requests":{"memory":"1Gi","cpu":"500m"},"limits":{"memory":"2Gi","cpu":"1"}}}]}}}}'
```

3. Or create a new YAML manifest and apply it:

```yaml
# pioneer-agent-reduced.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pioneer-agent
  labels:
    app: pioneer-agent
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pioneer-agent
  template:
    metadata:
      labels:
        app: pioneer-agent
    spec:
      containers:
      - name: pioneer-agent
        image: registry.digitalocean.com/pioneer/pioneer-agent:latest
        ports:
        - containerPort: 3000
        - containerPort: 8080
        resources:
          limits:
            cpu: 1
            memory: 2Gi
          requests:
            cpu: 500m
            memory: 1Gi
        livenessProbe:
          httpGet:
            path: /api/health
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 15
        readinessProbe:
          httpGet:
            path: /api/health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
```

Apply with: `kubectl apply -f pioneer-agent-reduced.yaml`

### Medium-Term Fix (Adjust Node Pool)

1. Add larger nodes to the DigitalOcean Kubernetes cluster:

```bash
doctl kubernetes cluster node-pool create <cluster-id> \
  --name pioneer-large-nodes \
  --size s-4vcpu-8gb \
  --count 2 \
  --auto-scale \
  --min-nodes 1 \
  --max-nodes 3
```

2. Add node affinity to the deployment to prefer the larger nodes:

```yaml
spec:
  template:
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            preference:
              matchExpressions:
              - key: doks.digitalocean.com/node-pool
                operator: In
                values:
                - pioneer-large-nodes
```

### Long-Term Fix (Infrastructure in Code)

1. Update Pulumi code to specify appropriate resource requirements:

```typescript
const pioneerAgent = new kubernetes.apps.v1.Deployment("pioneer-agent", {
  // other configuration...
  spec: {
    template: {
      spec: {
        containers: [{
          name: "pioneer-agent",
          resources: {
            requests: {
              cpu: "500m",
              memory: "1Gi",
            },
            limits: {
              cpu: "1",
              memory: "2Gi",
            },
          },
          // other container configuration...
        }],
      },
    },
  },
});
```

2. Consider implementing horizontal pod autoscaling for better resource utilization:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: pioneer-agent-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: pioneer-agent
  minReplicas: 1
  maxReplicas: 3
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 80
```

## Verification Steps

After implementing the resource changes:

1. Check pod status:
```bash
kubectl get pods -l app=pioneer-agent
```

2. Verify the pod is running:
```bash
kubectl describe pod -l app=pioneer-agent
```

3. Confirm resource allocation:
```bash
kubectl describe node <node-name> | grep -A 10 "Allocated resources"
```

4. Test API health endpoint once pod is running:
```bash
kubectl port-forward svc/svc-pioneer-agent-0ojfocv9 3000:3000
curl http://localhost:3000/api/health
``` 