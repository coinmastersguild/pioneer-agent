# Master is Always Green Asshole (MAGA) Deployment Paradigm

## Core Principle

> **MASTER IS ALWAYS GREEN. NO EXCEPTIONS.**

This is not a suggestion. It is the foundation of our entire deployment strategy. The master branch represents what is in production and must **ALWAYS** be in a deployable state.

## Deployment Rules

### 1. Master Branch Sanctity

- **NEVER** push directly to master
- **NEVER** merge a PR to master that hasn't passed ALL tests
- **NEVER** disable tests to get a green build
- **EVERY** commit on master must be deployable to production instantly

### 2. GitFlow Implementation

```
feature branches → develop → release branch → master → production
```

1. **Feature branches**
   - Created from: `develop`
   - Merge to: `develop`
   - Naming: `feature/[feature-name]`
   - MUST pass all unit and integration tests before merge

2. **Develop branch**
   - Integration branch for features
   - MUST be kept in working order
   - Automatic CI builds and deployments to dev environment

3. **Release branches**
   - Created from: `develop`
   - Merge to: `master` (and back to `develop`)
   - Naming: `release/vX.Y.Z`
   - **CRITICALLY IMPORTANT**: Must be deployed to near-production environment

4. **Master branch**
   - **ALWAYS** represents production code
   - **ALWAYS** passes all tests
   - **ALWAYS** deployed immediately to production via CI/CD

5. **Hotfix branches**
   - Created from: `master`
   - Merge to: `master` AND `develop`
   - Naming: `hotfix/[issue]-vX.Y.Z`
   - MUST include tests and pass full test suite

## Release Process

### Pre-release Validation

When a release branch is created:

1. Full deployment to staging environment (identical to production)
2. Complete E2E test suite execution
3. Performance testing under production-like load
4. Security scanning
5. Manual QA verification
6. Stakeholder sign-off

### Release Branch Requirements

A release branch **CANNOT** be merged to master unless:

- All tests are passing (unit, integration, E2E)
- Performance benchmarks meet or exceed thresholds
- No critical or high security vulnerabilities
- Complete documentation is updated
- Deployment verification checklist is completed

### Deployment Sequence

1. Release branch is created from develop
2. Automatic deployment to staging happens via Pulumi through CI
3. Automatic and manual tests run on staging
4. ONLY when all tests pass, the release is merged to master via PR
5. Master triggers automatic deployment to production through Pulumi

## Environment Parity

Staging **MUST** mirror production in:
- Infrastructure configuration
- Resource allocation
- Data schema (using anonymized production data)
- External service connections (using equivalent sandbox accounts)

The only acceptable differences are:
- Domain names and URLs
- Credentials (using equivalent security levels)
- Monitoring notification thresholds

## E2E Testing Requirements

All pull requests to release branches must have:
- Full E2E test coverage of critical user journeys
- Performance tests for any changed functionality
- Security tests for any authentication or data handling changes

### Build Failure Response

If a release build fails any tests:

1. The release is **NOT** merged to master
2. The issue is addressed in the release branch
3. Full test suite runs again
4. Only when all tests pass can the merge proceed

## Enforcement

The "Master is Always Green" principle is enforced through:

1. **Technical means**:
   - Branch protection on master
   - Required status checks
   - Required PR reviews
   - Automated deployment gating

2. **Cultural means**:
   - Shared responsibility for master health
   - Breaking master is treated with appropriate severity
   - Celebrating green deployments
   - Zero tolerance for circumventing the process

## Production Incident Prevention

Following this paradigm prevents production incidents by ensuring:

1. Every change to master has been fully verified
2. Production-identical staging catches environment-specific issues
3. Full E2E coverage validates real user scenarios
4. Git history maintains a clear record of production code

## Conclusion

The MAGA (Master is Always Green Asshole) paradigm is non-negotiable. It protects our users from poor experiences, our team from midnight incident responses, and our business from reputational damage.

**Remember: If it's not green on all tests in staging, it doesn't go to master.** 