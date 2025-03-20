# Pioneer Agent Production Deployment Issues Report

## Executive Summary

The pioneer-agent deployment at https://leeroy.live is experiencing multiple critical failures, resulting in complete service unavailability. The issues span infrastructure, application code, configuration, and networking layers. The primary root causes are resource constraints, container dependency issues, and configuration inconsistencies across different deployment components.

## Infrastructure Issues

### Cluster Instability
- The Kubernetes cluster is in a degraded state, dropping from 5 nodes to 2 nodes
- Multiple nodes are being marked with `ToBeDeletedByClusterAutoscaler` taint
- Nodes experiencing Cilium networking failures: `node.cilium.io/agent-not-ready`
- Uneven resource distribution causing scheduling bottlenecks

### Resource Constraints
- All nodes are S-2vCPU-2GB instances (only 1574Mi allocatable memory)
- Memory utilization at 73-94% across nodes before pioneer-agent deployment
- Even with reduced resources (512Mi/250m), pods cannot be scheduled:
  ```
  0/2 nodes are available: 1 Insufficient memory, 1 node(s) had untolerated taint
  {node.cilium.io/agent-not-ready: }
  ```
- Cluster autoscaler triggered but not resolving issues effectively

## Application Issues

### Container Failures
- Container in `CrashLoopBackOff` state with dependency errors
- Missing Express.js module:
  ```
  Error: Cannot find module 'express'
  Require stack:
  - /app/api-server.js
  ```
- Docker image likely built without proper dependency installation
- Container fails immediately after startup with exit code 1

### Health Check Configuration
- Health checks incorrectly configured, relying on non-existent components:
  ```
  Liveness: http-get http://:proxy/api/health
  Readiness: http-get http://:proxy/api/health
  ```
- Using `proxy` as port name when it doesn't exist in the container configuration
- Container definition only exposes port 3000, not 8080 ("proxy")

## Service Configuration Issues

### Redundant Services
- Two conflicting services for the same application:
  - `pioneer-agent` (LoadBalancer): 80 → 3000
  - `svc-pioneer-agent-0ojfocv9` (ClusterIP): 3000/5173/8080
- Causes confusion in routing and potential network conflicts
- Inconsistent with other deployments in the cluster

### Resource Definition Inconsistencies
- Resource limits not consistently applied across all deployments
- Pioneer-agent deployment inconsistent with other services:
  ```yaml
  # Different from other deployments like DegenServer
  resources:
    requests:
      memory: "512Mi"
      cpu: "250m" 
    limits:
      memory: "1Gi"
      cpu: "500m"
  ```

## Networking & DNS Issues

### Cloudflare Configuration
- Cloudflare returns Error 522 (Connection timed out) for leeroy.live
- Indicates origin server (Kubernetes) not responding to Cloudflare
- Possible SSL mode misconfiguration (Flexible vs Full)
- DNS points to Cloudflare IPs, not direct to LoadBalancer

### Direct Access Failures
- LoadBalancer IP (143.198.246.24) returns "Connection reset by peer"
- Indicates service is receiving traffic but application not handling it
- TCP connection being established but immediately closed by container

### IngressRoute Confusion
- Pulumi deployment defines an IngressRoute despite using LoadBalancer
- Traefik pod was removed, but IngressRoute resources may still exist
- Path/host routing configured for domain that may not be set up properly

## Root Causes

1. **Infrastructure Planning**
   - Small node size (s-2vcpu-2gb) inadequate for workload
   - Resource allocation not properly calculated before deployment

2. **Container Image Issues**
   - Missing dependencies in the Docker image
   - Improper build process not running `npm install` correctly

3. **Configuration Drift**
   - Inconsistent service configuration compared to other components
   - Mix of Traefik IngressRoute and direct LoadBalancer approaches

4. **Health Check Mismatch**
   - Health checks pointing to non-existent port causing pod failures

## Recommendations

### Immediate Actions

1. **Stabilize Infrastructure**
   ```bash
   # Upgrade node pool to larger instances
   doctl kubernetes cluster node-pool update 0ca762bb-6d55-478b-aac8-07152e3e36f2 --size s-4vcpu-8gb --count 3
   ```

2. **Fix Container Image**
   ```bash
   # Rebuild with proper dependency installation
   docker build -t registry.digitalocean.com/pioneer/pioneer-agent:latest -f Dockerfile.fixed .
   docker push registry.digitalocean.com/pioneer/pioneer-agent:latest
   ```

3. **Simplify Service Configuration**
   ```bash
   # Delete redundant service
   kubectl delete service svc-pioneer-agent-0ojfocv9
   
   # Update deployment to fix health checks
   kubectl patch deployment pioneer-agent -p '{
     "spec": {
       "template": {
         "spec": {
           "containers": [{
             "name": "pioneer-agent",
             "livenessProbe": {"httpGet": {"path": "/api/health", "port": 3000}},
             "readinessProbe": {"httpGet": {"path": "/api/health", "port": 3000}}
           }]
         }
       }
     }
   }'
   ```

4. **Verify Cloudflare Configuration**
   - Set SSL/TLS mode to "Full" instead of "Flexible"
   - Ensure Cloudflare is proxying to the correct origin IP

### Long-Term Improvements

1. **Infrastructure as Code Standardization**
   - Standardize Pulumi configurations across all deployments
   - Add resource requirements for all containers

2. **CI/CD Enhancements**
   - Add Docker image validation tests
   - Add pre-deployment health check validation

3. **Monitoring Improvements**
   - Set up CPU/memory usage alerts
   - Add application-specific health monitoring

4. **Documentation Updates**
   - Document the deployment architecture clearly
   - Create a deployment checklist for new services 