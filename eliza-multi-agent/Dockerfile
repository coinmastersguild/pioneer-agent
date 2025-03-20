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

# Final runtime image
FROM node:23.3.0-slim

# Add ARGs for platform detection
ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Install runtime dependencies
RUN npm install -g pnpm@9.15.4 && \
    apt-get update && \
    apt-get install -y \
    git \
    python3 \
    ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install proxy server dependencies
RUN npm install -g express http-proxy-middleware

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

# Add the proxy server
COPY server-proxy.js ./

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/api/health || exit 1

# Expose necessary ports
EXPOSE 3000 5173 8080

# Command to start the application
CMD ["sh", "-c", "pnpm start & pnpm --dir client dev --host & node server-proxy.js"]
