# Deployment Troubleshooting: Lessons Learned

## Summary of Issues

We encountered several issues when deploying the Pioneer Agent application to Kubernetes with Traefik as the ingress controller and Cloudflare as the CDN/proxy:

1. **Redirect Loop**: The primary issue was an infinite redirect loop between Cloudflare and Traefik
2. **Path Routing**: Problems with routing `/client` path to the correct port (5173)
3. **Multiple Configurations**: Creating too many conflicting solutions simultaneously
4. **Security**: Discovery of a committed `.env.test` file containing test credentials

## Root Causes

### 1. Cloudflare-Traefik Redirect Loop

**Problem**: When accessing leeroy.live, we got the error: "redirected you too many times" (ERR_TOO_MANY_REDIRECTS)

**Root Cause**: 
- Cloudflare was configured in "Flexible SSL" mode, which terminates SSL and forwards HTTP traffic to origin
- Traefik was configured to redirect HTTP to HTTPS by default
- This created an infinite loop:
  1. User → HTTPS → Cloudflare
  2. Cloudflare → HTTP → Traefik
  3. Traefik redirects HTTP → HTTPS
  4. Browser follows redirect back to Cloudflare...and the cycle repeats

### 2. Path-Based Routing Issues

**Problem**: The `/client` path returned 404 errors

**Root Cause**:
- Our IngressRoute was initially routing all traffic (`/` prefix) to port 8080
- The client application runs on port 5173
- We needed a separate route for `/client` path that points to port 5173

### 3. Configuration Sprawl

**Problem**: We created multiple overlapping configurations trying to solve the issue

**Root Cause**:
- Too many simultaneous approaches:
  - Multiple IngressRoutes (pioneer-agent-route, pioneer-agent-direct, pioneer-agent-with-middleware, etc.)
  - Multiple middlewares (cloudflare-https, remove-prefix-client, cloudflare-handler, etc.)
  - Multiple services (client-direct, client-service, etc.)
  - Attempts to patch Traefik directly

### 4. Security Issues

**Problem**: A `.env.test` file was committed to the repository

**Root Cause**:
- Insufficient gitignore configuration
- Test files with sensitive data not properly excluded from version control

## Solutions and Best Practices

### Fixing Cloudflare-Traefik Redirection Issues

**Option 1: Change Cloudflare SSL Mode**
- Set Cloudflare to "Full" SSL mode instead of "Flexible"
- This ensures Cloudflare uses HTTPS to communicate with Traefik

**Option 2: Disable Traefik HTTP-to-HTTPS Redirection**
- Configure Traefik to accept HTTP traffic without redirecting to HTTPS
- Use proper middleware to handle forwarded headers from Cloudflare

### Correct Path-Based Routing

**Best Practice**:
```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: pioneer-agent-route
spec:
  entryPoints:
    - web
    - websecure
  routes:
    - match: Host(`leeroy.live`) && PathPrefix(`/client`)
      kind: Rule
      services:
        - name: svc-pioneer-agent
          port: 5173
    - match: Host(`leeroy.live`) && PathPrefix(`/`)
      kind: Rule
      priority: 1
      services:
        - name: svc-pioneer-agent
          port: 8080
```

### Avoiding Configuration Sprawl

**Best Practices**:
1. Make incremental changes
2. Delete old configurations before creating new ones
3. Test one approach at a time
4. Document the purpose of each resource

### Security Best Practices

1. **Never commit .env files**:
   - Add all `.env*` files to `.gitignore`
   - Use `.env.example` files with placeholder values instead
   - Use secrets management in Kubernetes (Secrets, ConfigMaps)

2. **Remove accidentally committed credentials**:
   ```bash
   git rm --cached path/to/.env.file
   ```

3. **Rotate credentials** if they were exposed

## Testing Deployments

Create a comprehensive test script (like our `test-service.sh`) that:
1. Tests direct IP access
2. Tests domain access
3. Checks all paths and services
4. Inspects headers and redirects
5. Verifies Kubernetes resources

## Conclusion

The main lesson learned is to follow the "one-shot principle" - make focused, incremental changes and verify their effect before moving on to additional changes. When troubleshooting complex systems like Kubernetes with Traefik and Cloudflare, it's critical to understand how the components interact rather than applying multiple overlapping solutions.

Also, proper security hygiene is essential - ensure no sensitive credentials are committed to version control and regularly audit your repository for accidental commits of sensitive data. 