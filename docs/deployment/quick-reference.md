# DegenQuest Deployment Quick Reference

## THE GOLDEN RULES

```
🚫 NEVER write Kubernetes YAML manually
🚫 NEVER deploy without Pulumi
🚫 NEVER build images locally for production
✅ ALWAYS use CircleCI for builds
✅ ALWAYS use Pulumi for infrastructure
```

## Getting Started with Pulumi

1. **Install Pulumi CLI** (for development only)
   ```bash
   # macOS
   brew install pulumi
   
   # Linux
   curl -fsSL https://get.pulumi.com | sh
   
   # Windows (PowerShell)
   iwr https://get.pulumi.com -OutFile install.ps1
   ./install.ps1
   ```

2. **Login to Pulumi**
   ```bash
   pulumi login
   # Follow the prompts
   ```

3. **Clone the infrastructure repository**
   ```bash
   git clone <repo-url>
   cd <repo-directory>/infra
   ```

4. **Select the stack to work with**
   ```bash
   pulumi stack select dev
   # For development environment
   
   # OR
   pulumi stack select staging
   # For staging environment
   
   # OR
   pulumi stack select prod
   # For production (BE CAREFUL!)
   ```

5. **Preview changes** (ALWAYS do this before applying)
   ```bash
   pulumi preview
   ```

6. **Apply changes** (Development/Local ONLY - production deploys via CI)
   ```bash
   pulumi up
   ```

## Deployment Flow

```
Code Change → GitHub PR → CI Builds Image → CI Runs Pulumi → Deployment Complete
```

## Common Tasks

### View deployed resources
```bash
pulumi stack output
```

### Get specific output values
```bash
pulumi stack output [output-name]
```

### View deployment history
```bash
pulumi history
```

### Roll back to a previous version
```bash
pulumi stack history
pulumi up --target-version <version>
```

## Troubleshooting

### CI build failing
1. Check CircleCI logs
2. Verify Docker build configuration
3. Check for syntax errors in Pulumi code
4. **DO NOT attempt to build locally as a workaround**

### Deployment failing
1. Check Pulumi error messages
2. Preview changes again with `--detailed` flag
3. Check resource constraints in cluster
4. **DO NOT use kubectl as a workaround**

### Emergency contacts
- DevOps Lead: [Name] - [Contact]
- Infrastructure Admin: [Name] - [Contact]

## Documentation Links

- [Full Pulumi Documentation](https://www.pulumi.com/docs/)
- [DegenQuest Deployment Rules](./deployment-rules-checklist.md)
- [Milestone 3 Prospectus](./milestone-3-prospectus.md)
- [CircleCI Configuration Guide](./circleci-config-guide.md)

Remember: Following these guidelines ensures reliable, consistent deployments and prevents production incidents. When in doubt, ask the DevOps team for guidance rather than working around the process. 