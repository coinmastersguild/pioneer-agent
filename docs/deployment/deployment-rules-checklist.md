# DegenQuest Deployment Rules Checklist

## CRITICAL RULES - NON-NEGOTIABLE

This checklist MUST be followed for all deployments. No exceptions.

## Pre-Deployment Checks

- [ ] **NO Kubernetes YAML files exist in the repository**
  - ❌ Manual YAML is strictly prohibited
  - ✅ All infrastructure is defined using Pulumi code

- [ ] **NO `kubectl apply` commands are used in any scripts**
  - ❌ Direct kubectl commands are forbidden
  - ✅ All changes flow through Pulumi

- [ ] **NO local Docker builds for production**
  - ❌ Never use `docker build` locally for prod images
  - ✅ All images are built exclusively through CircleCI

- [ ] **NO hardcoded secrets in any files**
  - ❌ No credentials in code or config files
  - ✅ All secrets managed through Pulumi's secure secret management

## Pull Request Requirements

- [ ] Changes to infrastructure code include `pulumi preview` output
- [ ] Deployment changes are reviewed by at least one DevOps team member
- [ ] CI validation passes with no direct YAML or kubectl warnings
- [ ] Documentation is updated to reflect any changes

## Deployment Process

1. **ALWAYS use infrastructure as code:**
   - [ ] All changes are made in the Pulumi TypeScript/JavaScript code
   - [ ] Changes are committed to version control
   - [ ] Pull request is opened and reviewed

2. **ALWAYS build images via CI:**
   - [ ] Code changes trigger CircleCI pipeline
   - [ ] CircleCI builds and tags Docker images
   - [ ] Images are pushed to authorized container registry only

3. **ALWAYS deploy using Pulumi:**
   - [ ] Pulumi deployment runs through CircleCI
   - [ ] Preview step is verified before applying
   - [ ] Deployment logs are preserved for auditing

4. **ALWAYS verify deployments:**
   - [ ] Automated health checks pass
   - [ ] Monitoring confirms stable deployment
   - [ ] Deployment is tagged in version control

## Emergency Procedure (RARE EXCEPTIONS)

Even during emergencies, certain rules cannot be broken:

1. If CI is down but a critical fix is needed:
   - [ ] Use Pulumi CLI from a designated admin machine
   - [ ] Document the exceptional use with justification
   - [ ] Ensure all changes are committed to version control
   - [ ] NEVER use direct kubectl commands

2. If rollback is needed urgently:
   - [ ] Use Pulumi's rollback feature
   - [ ] NEVER manually modify cluster resources
   - [ ] Document incident for post-mortem

## Enforcement

- Team leads will audit deployment practices weekly
- Violations of these rules will trigger mandatory team review
- Repeated violations will result in removal of deployment permissions

**Remember: These rules exist to ensure consistent, reliable, and secure deployments. There are no valid reasons to circumvent them.** 