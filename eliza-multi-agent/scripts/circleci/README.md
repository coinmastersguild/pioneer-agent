# CircleCI Deployment Tools

This directory contains scripts to interact with CircleCI API for the Eliza Multi-Agent project. These tools help manage, monitor, and automate CircleCI workflows.

## Prerequisites

- `jq` command-line JSON processor
- Valid CircleCI API token stored in the root `.env` file
- CircleCI organization ID stored in the root `.env` file

## Available Scripts

### `list_pipelines.sh`

Lists recent CircleCI pipelines for the project and the branch specified (defaults to `sprint-2`).

```bash
./list_pipelines.sh
```

### `get_workflow_jobs.sh`

Gets detailed information about jobs in a specific workflow.

```bash
./get_workflow_jobs.sh <workflow_id>
```

### `trigger_pipeline.sh`

Triggers a new CircleCI pipeline for the specified branch (defaults to `sprint-2`).

```bash
./trigger_pipeline.sh [branch_name]
```

### `monitor_workflow.sh`

Monitors a workflow's progress in real-time until completion.

```bash
./monitor_workflow.sh <workflow_id> [check_interval_seconds]
```

### `deploy.sh`

Orchestrates the entire deployment process, from triggering a pipeline to monitoring its progress.

```bash
./deploy.sh [branch_name]
```

## Configuration

The scripts load configuration from the root `.env` file, which should contain:

```
CIRCLE_ORG=your-organization-id
CIRCLE_CI_TOKEN=your-circleci-api-token
```

## CircleCI Configuration

The Sprint 2 CircleCI workflow consists of the following jobs:

1. `verify-dockerfile`: Verifies the Dockerfile syntax and performs a test build
2. `dependency-audit`: Audits dependencies for security vulnerabilities
3. `build-and-push`: Builds and pushes the Docker image to the container registry
4. `deploy-to-kubernetes`: Deploys the application to Kubernetes using Pulumi

The workflow uses caching to speed up builds and preserve Docker layers between runs.

## Usage Examples

### Trigger a deployment for the sprint-2 branch

```bash
cd scripts/circleci
./deploy.sh sprint-2
```

### List recent pipelines

```bash
cd scripts/circleci
./list_pipelines.sh
```

### Monitor a specific workflow

```bash
cd scripts/circleci
./monitor_workflow.sh <workflow_id> 30
``` 