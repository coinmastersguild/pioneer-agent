# Ingress and Routing Fix Plan

## Issue Summary
The Pioneer Agent deployment has the following routing/ingress issues:
1. No IngressRoute resources defined to route traffic to the pioneer-agent service
2. The /api/health endpoint returns 404, suggesting routing issues
3. CORS errors when connecting from the local client

## Action Plan

### Step 1: Configure Traefik IngressRoute

Create a IngressRoute resource for the Pioneer Agent:

```yaml
# pioneer-agent-route.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: pioneer-agent-route
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(`134.199.184.173`) && PathPrefix(`/api`)
      kind: Rule
      services:
        - name: svc-pioneer-agent-0ojfocv9
          port: 8080
    - match: Host(`134.199.184.173`) && PathPrefix(`/client`)
      kind: Rule
      services:
        - name: svc-pioneer-agent-0ojfocv9
          port: 5173
    - match: Host(`134.199.184.173`) && PathPrefix(`/`)
      kind: Rule
      priority: 1
      services:
        - name: svc-pioneer-agent-0ojfocv9
          port: 8080
```

Apply with:
```bash
kubectl apply -f pioneer-agent-route.yaml
```

### Step 2: Create CORS Middleware

Create a Traefik middleware to handle CORS:

```yaml
# cors-middleware.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: cors-headers
spec:
  headers:
    accessControlAllowMethods:
      - GET
      - POST
      - PUT
      - DELETE
      - OPTIONS
    accessControlAllowOriginList:
      - "http://localhost:5173"
      - "https://localhost:5173"
      - "https://pioneer-agent.vercel.app"
    accessControlAllowCredentials: true
    accessControlAllowHeaders:
      - "*"
    accessControlMaxAge: 100
    addVaryHeader: true
```

Apply with:
```bash
kubectl apply -f cors-middleware.yaml
```

### Step 3: Update IngressRoute with Middleware

Update the IngressRoute to use the CORS middleware:

```yaml
# pioneer-agent-route-with-cors.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: pioneer-agent-route
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(`134.199.184.173`) && PathPrefix(`/api`)
      kind: Rule
      middlewares:
        - name: cors-headers
      services:
        - name: svc-pioneer-agent-0ojfocv9
          port: 8080
    - match: Host(`134.199.184.173`) && PathPrefix(`/client`)
      kind: Rule
      middlewares:
        - name: cors-headers
      services:
        - name: svc-pioneer-agent-0ojfocv9
          port: 5173
    - match: Host(`134.199.184.173`) && PathPrefix(`/`)
      kind: Rule
      priority: 1
      middlewares:
        - name: cors-headers
      services:
        - name: svc-pioneer-agent-0ojfocv9
          port: 8080
```

Apply with:
```bash
kubectl apply -f pioneer-agent-route-with-cors.yaml
```

### Step 4: Configure a Domain (Optional but Recommended)

If you have a domain (e.g., api.pioneer-agent.com), update the IngressRoute:

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: pioneer-agent-domain-route
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(`api.pioneer-agent.com`) && PathPrefix(`/`)
      kind: Rule
      middlewares:
        - name: cors-headers
      services:
        - name: svc-pioneer-agent-0ojfocv9
          port: 8080
  tls:
    certResolver: le
```

Apply with:
```bash
kubectl apply -f pioneer-agent-domain-route.yaml
```

### Step 5: Set Up Proper TLS Certificate (Optional)

Configure Traefik to use Let's Encrypt for proper SSL certificates:

```yaml
# traefik-tls-config.yaml
apiVersion: traefik.containo.us/v1alpha1
kind: TLSStore
metadata:
  name: default
  namespace: default
spec:
  defaultCertificate:
    secretName: pioneer-agent-tls
---
apiVersion: traefik.containo.us/v1alpha1
kind: TLSOption
metadata:
  name: default
  namespace: default
spec:
  minVersion: VersionTLS12
  sniStrict: false
```

Apply with:
```bash
kubectl apply -f traefik-tls-config.yaml
```

### Step 6: Update Client Configuration

Update the client's API configuration to point to the correct endpoint:

1. For local development:
   ```
   VITE_API_URL=https://134.199.184.173
   ```

2. For production (with domain):
   ```
   VITE_API_URL=https://api.pioneer-agent.com
   ```

## Testing Verification Steps

Once changes are applied:

1. Test the API health endpoint:
```bash
curl -k https://134.199.184.173/api/health
```

2. Test CORS headers:
```bash
curl -k -X OPTIONS -v https://134.199.184.173/api/health
```

3. Test connectivity from local client:
```bash
# From your local machine
cd client
npm run dev
# Then in browser, navigate to http://localhost:5173
```

4. Use browser developer tools to verify API connectivity.

## Rollback Plan

If issues persist:

1. Delete the new IngressRoute:
```bash
kubectl delete ingressroute pioneer-agent-route
```

2. Remove the CORS middleware:
```bash
kubectl delete middleware cors-headers
```

3. Test direct service access:
```bash
kubectl port-forward svc/svc-pioneer-agent-0ojfocv9 8080:8080
curl http://localhost:8080/api/health
``` 