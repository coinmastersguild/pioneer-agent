#!/bin/bash
# Dependency audit script for Eliza Multi-Agent
# This script identifies potentially problematic native modules

set -e

# Default location is the repository root
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUTPUT_FILE="$REPO_ROOT/sprint-2/dependency-audit.md"

echo "Starting dependency audit for Eliza Multi-Agent..."
echo "Repository root: $REPO_ROOT"
echo "Output will be written to: $OUTPUT_FILE"

# Initialize output file
cat > "$OUTPUT_FILE" << EOF
# Eliza Multi-Agent Dependency Audit

This audit identifies native modules and architecture-specific dependencies that may
cause issues during containerization and deployment.

## Analysis Date: $(date)

## Native Module Dependencies

| Package | Version | Architecture Requirements | Potential Issues |
|---------|---------|---------------------------|------------------|
EOF

# Use pnpm to list all dependencies with detailed info
cd "$REPO_ROOT"
echo "Analyzing dependencies..."

# Get a list of all dependencies using pnpm
DEPS=$(pnpm list -r --depth=0 --json | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | sort | uniq)

# Function to check if a package has native dependencies
check_native_deps() {
    local package=$1
    local has_native=false
    local package_dir="$REPO_ROOT/node_modules/$package"
    
    # Check if package exists
    if [ ! -d "$package_dir" ]; then
        # Try to find it in .pnpm directory
        package_dir=$(find "$REPO_ROOT/node_modules/.pnpm" -type d -name "$package@*" | head -n 1)
        if [ -z "$package_dir" ]; then
            echo "  ❌ Could not locate package: $package"
            return
        fi
        package_dir="$package_dir/node_modules/$package"
    fi
    
    # Check for binding.gyp (indicates native code)
    if [ -f "$package_dir/binding.gyp" ]; then
        has_native=true
        echo "  🔍 Found binding.gyp in $package"
    fi
    
    # Check for .node files
    if find "$package_dir" -name "*.node" -type f | grep -q .; then
        has_native=true
        echo "  🔍 Found .node files in $package"
    fi
    
    # Check package.json for gypfile or binary fields
    if [ -f "$package_dir/package.json" ]; then
        if grep -q '"gypfile"\s*:\s*true' "$package_dir/package.json"; then
            has_native=true
            echo "  🔍 Found gypfile:true in $package"
        fi
        
        if grep -q '"binary"\s*:' "$package_dir/package.json"; then
            has_native=true
            echo "  🔍 Found binary field in $package"
        fi
    fi
    
    # Check for architecture-specific files
    arch_specific=$(find "$package_dir" -type f -name "*-linux-*" -o -name "*-darwin-*" -o -name "*-win32-*" | grep -v "node_modules" | head -n 1)
    if [ -n "$arch_specific" ]; then
        has_native=true
        echo "  🔍 Found architecture-specific files in $package"
    fi
    
    # If has native dependencies, add to output
    if [ "$has_native" = true ]; then
        version=$(grep -o '"version":"[^"]*"' "$package_dir/package.json" | head -1 | cut -d'"' -f4)
        arch_reqs="Unknown"
        issues="May require platform-specific compilation"
        
        # Look for specific architecture patterns
        if find "$package_dir" -name "*-linux-arm64-*" -type f | grep -q .; then
            arch_reqs="Includes ARM64 binaries"
        elif find "$package_dir" -name "*-linux-x64-*" -type f | grep -q .; then
            arch_reqs="Includes x64 binaries"
        fi
        
        # Add to markdown table
        echo "| $package | $version | $arch_reqs | $issues |" >> "$OUTPUT_FILE"
    fi
}

# Process each dependency
for dep in $DEPS; do
    echo "Checking $dep..."
    check_native_deps "$dep"
done

# Add a recommendations section
cat >> "$OUTPUT_FILE" << EOF

## Recommendations

Based on the audit results, the following recommendations are made:

1. Add specific overrides for problematic native modules in package.json or .npmrc
2. Consider using the following structure in .npmrc to handle architecture-specific modules:
   \`\`\`json
   {
     "resolutions": {
       "@rollup/rollup-linux-arm64-gnu": "optional:@rollup/rollup-linux-x64-gnu@*",
       "@swc/core-linux-arm64-gnu": "optional:@swc/core-linux-x64-gnu@*",
       "esbuild-linux-arm64": "optional:esbuild-linux-64@*"
     }
   }
   \`\`\`
3. Use \`--no-optional\` flag with pnpm install to avoid optional native dependencies
4. Build with explicit \`--platform linux/amd64\` when using Docker buildx
5. Use Node 18 instead of Node 23 for better compatibility with native modules

## Next Steps

1. Update the Dockerfile to handle these dependencies
2. Test the build in a CircleCI-like environment 
3. Verify the container runs correctly before proceeding with registry push
EOF

echo "Dependency audit complete. Results written to $OUTPUT_FILE"
