# Docker Configurations Attempted

This document catalogs the various Docker configurations attempted during Sprint 1 and details the specific issues encountered with each approach.

## Configuration 1: Original Dockerfile

### Description
The original Dockerfile used Node 23.3.0-slim as the base image with a multi-stage build pattern.

### Configuration
```dockerfile
# Use a specific Node.js version for better reproducibility
FROM node:23.3.0-slim AS builder

# Install pnpm globally and necessary build tools
RUN npm install -g pnpm@9.15.4 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    python3 \
    python3-pip \
    curl \
    node-gyp \
    ffmpeg \
    libtool-bin \
    autoconf \
    automake \
    libopus-dev \
    make \
    g++ \
    build-essential \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    openssl \
    libssl-dev libsecret-1-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Set the working directory
WORKDIR /app

# Copy application code
COPY . .

# Install dependencies
RUN pnpm install

# Build the project
RUN pnpm run build && pnpm prune --prod

# Final runtime image
FROM node:23.3.0-slim

# Install runtime dependencies
RUN npm install -g pnpm@9.15.4 && \
    apt-get update && \
    apt-get install -y \
    git \
    python3 \
    ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy built artifacts and production dependencies from the builder stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/pnpm-workspace.yaml ./
COPY --from=builder /app/.npmrc ./
COPY --from=builder /app/turbo.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/agent ./agent
COPY --from=builder /app/client ./client
COPY --from=builder /app/lerna.json ./
COPY --from=builder /app/packages ./packages
COPY --from=builder /app/scripts ./scripts
COPY --from=builder /app/characters ./characters

# Expose necessary ports
EXPOSE 3000 5173

# Command to start the application
CMD ["sh", "-c", "pnpm start & pnpm start:client"]
```

### Issues Encountered
1. **JSON Syntax Error**: Initial build failed due to syntax error in package.json (trailing comma).
2. After fixing the JSON error:
   ```
   ERROR  Expected double-quoted property name in JSON at position 1505 (line 27 column 3) while parsing '{  "name": "eliza",  "scripts": {    ' in /app/package.json
   ```

## Configuration 2: Platform-Specific Dockerfile

### Description
Updated Dockerfile with platform detection and conditional build processes for ARM64.

### Configuration
```dockerfile
# Use a specific Node.js version for better reproducibility
FROM node:23.3.0-slim AS builder

# Add build args for platform detection
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Print platform info for debug purposes
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# Install pnpm globally and necessary build tools
RUN npm install -g pnpm@9.15.4 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    git \
    python3 \
    python3-pip \
    curl \
    node-gyp \
    ffmpeg \
    libtool-bin \
    autoconf \
    automake \
    libopus-dev \
    make \
    g++ \
    build-essential \
    libcairo2-dev \
    libjpeg-dev \
    libpango1.0-dev \
    libgif-dev \
    openssl \
    libssl-dev libsecret-1-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Set the working directory
WORKDIR /app

# Copy application code
COPY . .

# Skip tokenizers for ARM64 to avoid build issues
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      echo "Running on ARM64, modifying dependencies to avoid tokenizers issues"; \
      sed -i 's/"fastembed": ".*"/"fastembed": "optional:fastembed@1.14.1"/' package.json agent/package.json 2>/dev/null || true; \
    fi

# Install dependencies with --no-optional for ARM64
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      pnpm install --no-optional; \
    else \
      pnpm install; \
    fi

# Build the project
RUN pnpm run build && pnpm prune --prod

# Final runtime image (rest of Dockerfile remains the same)
```

### Issues Encountered
1. **Native Module Errors**: Multiple architecture-specific native modules were still missing:
   ```
   Error: Cannot find module '@rollup/rollup-linux-arm64-gnu'. npm has a bug related to optional dependencies...
   ```

2. **Build Process Failure**: Despite conditional logic, the build process still failed due to native dependencies:
   ```
   @elizaos/client-direct:build: Error: Cannot find module @rollup/rollup-linux-arm64-gnu. npm has a bug related to optional dependencies (https://github.com/npm/cli/issues/4828).
   ```

## Configuration 3: Simplified Alpine-based Dockerfile

### Description
Simplified approach using Node 18 Alpine to reduce complexity and native module issues.

### Configuration
```dockerfile
# Use Node 23 on Alpine for a smaller image
FROM node:18-alpine

# Install required system dependencies
RUN apk add --no-cache python3 git ffmpeg curl bash

# Set working directory
WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./
COPY agent/package.json agent/
COPY client/package.json client/
COPY packages/core/package.json packages/core/
COPY packages/client-direct/package.json packages/client-direct/

# Install pnpm
RUN npm install -g pnpm@9.15.4

# Install dependencies without optional packages (no need for native modules)
RUN pnpm install --no-optional

# Copy the rest of the application
COPY . .

# Expose the necessary ports
EXPOSE 3000 5173 

# Command to start the application
CMD ["sh", "-c", "pnpm start & pnpm start:client"]
```

### Issues Encountered
1. **Missing Build Tools**: The Alpine image was missing required build tools for native modules:
   ```
   gyp ERR! stack Error: not found: make
   ```

2. **SWC Core Errors**: The build failed with SWC core native binding issues:
   ```
   Error: Failed to load native binding
   at Object.<anonymous> (/app/node_modules/.pnpm/@swc+core@1.11.4_@swc+helpers@0.5.15/node_modules/@swc/core/binding.js:329:11)
   ```

## Configuration 4: Minimal Demo Container

### Description
Created a minimal container with just Express and a static HTML file for demo purposes.

### Configuration
```dockerfile
# Simple image for demo purposes
FROM node:18-alpine

WORKDIR /app

# Install basic tools
RUN apk add --no-cache curl

# Create necessary directories
RUN mkdir -p /app/client/dist

# Add a static HTML file for testing
RUN echo '<!DOCTYPE html><html><head><title>Eliza Multi-Agent</title></head><body><h1>Eliza Multi-Agent Demo</h1><p>This is a container deployment demo for Pioneer Agent.</p></body></html>' > /app/client/dist/index.html

# Create a simple express server
RUN npm init -y && \
    npm install express

# Copy the server.js file
COPY server.js /app/server.js

# Expose ports
EXPOSE 3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -s http://localhost:3000/api/health | grep -q "ok" || exit 1

# Start server
CMD ["node", "server.js"]
```

### Issues Encountered
1. Initially, there was a syntax error in the server.js content.
2. After fixing, this simplified container worked but was not suitable for actual deployment as it lacked the actual Eliza functionality.

## Summary of Key Issues

1. **Architecture Dependencies**: Many native modules used by Eliza don't support ARM64 architecture or require special handling.

2. **Node Version Compatibility**: Node 23 is recent and some dependencies aren't fully compatible.

3. **Native Module Compilation**: Multiple dependencies require native compilation which creates cross-platform build challenges.

4. **Complex Dependency Tree**: Eliza's dependency tree is complex, making it challenging to isolate and fix individual problematic packages.

5. **BuildX Platform Targeting**: Explicit platform targeting is needed but doesn't fully resolve native module issues.

## Recommendations

1. Use Node 18-slim which has better compatibility with native modules
2. Consider using explicit Ubuntu-based images with complete build tools
3. Add explicit dependency overrides in package.json
4. Use multi-stage builds with careful consideration of required build tools
5. Consider creating a custom build container that matches CircleCI environment 