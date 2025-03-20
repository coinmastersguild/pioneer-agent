# Recommendations for Sprint 2: Eliza Containerization

## Overview

Based on the failures of Sprint 1, we recommend a revised approach for Sprint 2. This document outlines specific technical recommendations and a step-by-step plan to successfully containerize the Eliza multi-agent system and deploy it to DigitalOcean.

## Key Recommendations

### 1. Revised Containerization Strategy

#### Base Image Selection
- Use Node 18-slim instead of Node 23 (better compatibility with native modules)
- Consider using Ubuntu-based images rather than Alpine for better native module support

#### Multi-Stage Build
- Use a builder stage with full development tools installed
- Use a final stage with only runtime dependencies
- Explicitly handle architecture-specific dependencies in each stage

#### Example Dockerfile Structure
```dockerfile
# Builder stage with full development tools
FROM node:18-slim AS builder

# Install build essentials and development dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
    curl \
    # Add other build dependencies

# Set working directory
WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm@9.15.7

# Copy package files
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./
COPY agent/package.json agent/
COPY client/package.json client/
COPY packages/core/package.json packages/core/
# ... copy other package.json files

# Install dependencies with focus on architecture compatibility
RUN pnpm install --production=false

# Copy source code
COPY . .

# Build the application
RUN pnpm run build

# Final stage - runtime only
FROM node:18-slim

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    python3 \
    curl \
    # Add other runtime dependencies

# Set working directory
WORKDIR /app

# Install pnpm globally
RUN npm install -g pnpm@9.15.7

# Copy from builder
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-workspace.yaml ./
COPY --from=builder /app/pnpm-lock.yaml ./
COPY --from=builder /app/.npmrc ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/agent/dist ./agent/dist
COPY --from=builder /app/client/dist ./client/dist
# ... copy other necessary files

# Set environment variables
ENV NODE_ENV=production

# Expose ports
EXPOSE 3000 5173

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -s http://localhost:3000/api/health || exit 1

# Start command
CMD ["pnpm", "start"]
```

### 2. Build Environment Changes

#### Platform Targeting
- Use explicit `--platform linux/amd64` flag in all build commands
- Test builds in a Docker container matching CircleCI's environment

#### Dependencies Management
- Create a dependency audit to identify native modules that need special handling
- Add specific overrides for problematic dependencies in package.json or .npmrc
- Consider adding custom prebuild scripts for architecture-specific modules

### 3. CircleCI Pipeline Improvements

#### Job Configuration
- Add a preliminary build verification step before the main build
- Implement explicit caching of node_modules to improve build time
- Add more detailed output logging for troubleshooting

#### Environment Variables
- Create explicit documentation of all required environment variables
- Add a verification step to ensure all required variables are set

## Step-by-Step Plan for Sprint 2

1. **Week 1: Local Build Environment Setup**
   - Create a local development environment that matches CircleCI
   - Build a test container that verifies CircleCI environment compatibility
   - Perform dependency audit and identify problematic native modules

2. **Week 2: Dockerfile Development**
   - Create and test the multi-stage Dockerfile
   - Implement specific handling for identified problematic dependencies
   - Test builds for both local architecture and target architecture (amd64)

3. **Week 3: CircleCI Integration**
   - Update CircleCI configuration with new job definitions
   - Implement enhanced caching and verification steps
   - Test full pipeline with limited scope (personal fork or branch)

4. **Week 4: Production Deployment**
   - Merge changes to main branch
   - Monitor CircleCI build and push process
   - Verify image in DigitalOcean registry
   - Deploy to Kubernetes using Pulumi

## Testing Strategy

1. **Local Docker Testing**
   - Build image locally: `docker build -t eliza-local:test --platform linux/amd64 .`
   - Run container: `docker run -p 3000:3000 -p 5173:5173 eliza-local:test`
   - Verify application functionality: `curl http://localhost:3000/api/health`

2. **CircleCI Integration Testing**
   - Create a test branch with minimal changes to test CircleCI integration
   - Push to private registry with test tag
   - Verify build logs for any architecture-specific issues

3. **Production Verification**
   - Implement automated verification of deployed container
   - Add health check monitoring

## Risk Mitigation

- **Fallback Plan**: Define a simplified version of Eliza that can be containerized if full version faces persistent issues
- **Gradual Approach**: Start with a minimal containerized version and gradually add components
- **External Dependencies**: Consider using hosted versions of problematic dependencies (e.g., database services) rather than containerizing everything

## Conclusion

By implementing these recommendations, Sprint 2 should overcome the challenges faced in Sprint 1 and successfully containerize the Eliza multi-agent system for deployment to DigitalOcean. 