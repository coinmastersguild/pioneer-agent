FROM node:18-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json /app/
RUN npm install express

# Copy the API server file
COPY simple-api-server.js /app/

# Expose API port
EXPOSE 3000

# Start the server
CMD ["node", "simple-api-server.js"] 