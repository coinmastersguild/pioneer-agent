Version: 1.0.0-alpha
Quickstart Guide
1. Simple Start - Get Running Quickly
   The fastest way to get started with ElizaOS is using the CLI:

# Install globally (optional but recommended)
npm install -g @elizaos/cli

# Or use directly with npx
npx elizaos start

This will:

Start ElizaOS with default settings
Load the default character
Make the agent accessible via terminal and REST API
Chat with your agent:
Visit https://localhost:3000 to interact with your agent through a web interface.

2. Creating a Project
   If you want to create a custom ElizaOS project with your own characters and configurations:

# Create a new project with the interactive wizard
npx elizaos create

# Or specify project type directly
npx elizaos create --type project

Follow the interactive prompts to configure your project. Once created:

# Navigate to your project directory
cd my-project-name

# Start your project
npx elizaos start

Add plugins to your project:
# List available plugins
npx elizaos project list-plugins

# Add a plugin
npx elizaos project add-plugin @elizaos/plugin-discord

3. Creating a Plugin
   Want to extend ElizaOS with custom functionality?

# Create a new plugin project
npx elizaos create --type plugin

# Follow the interactive prompts

Develop your plugin following the structure in your generated project:

# Test your plugin
npx elizaos start

# Publish your plugin when ready
npx elizaos plugin publish

Publishing options:
# Test publish without making changes
npx elizaos plugin publish --test

# Publish to npm
npx elizaos plugin publish --npm

# Specify platform compatibility
npx elizaos plugin publish --platform node

4. Contributing to ElizaOS
   If you want to add features or fix bugs in the ElizaOS core:

# Clone the repository
git clone git@github.com:elizaOS/eliza.git
cd eliza

# Switch to development branch
git checkout develop

# Install dependencies
bun install

# Build the project
bun build

# Start ElizaOS
bun start

Visit https://localhost:3000 to interact with your agent through a web interface.

Automated setup:
git clone git@github.com:elizaOS/eliza.git
cd eliza

# Run the start script with verbose logging
./scripts/start.sh -v




LINKS TO MORE DOCS> https://github.com/elizaOS/eliza/tree/main/docs