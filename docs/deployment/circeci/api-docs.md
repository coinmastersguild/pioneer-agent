CircleCI API (v2)
Download OpenAPI specification:Download

License: MIT
This describes the resources that make up the CircleCI API v2.

Context
Endpoints relating to contexts. Use contexts to secure and share environment variables.

List contexts
List all contexts for an owner.

Authorizations:
api_key_headerbasic_authapi_key_query
query Parameters
owner-id
string <uuid>
The unique ID of the owner of the context. Specify either this or owner-slug.

owner-slug
string
A string that represents an organization. Specify either this or owner-id. Cannot be used for accounts.

owner-type
string
Enum: "account" "organization"
The type of the owner. Defaults to "organization". Accounts are only used as context owners in server.

page-token
string
A token to retrieve the next page of results.

Responses
200
A paginated list of contexts

default
Error response.


get
/context
Request samples
Node + RequestPython + Python3Go + NativeShell + CurlRuby + Native

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/context',
qs: {
'owner-id': 'c65b68ef-e73b-4bf2-be9a-7a322a9df150',
'page-token': 'NEXT_PAGE_TOKEN'
},
headers: {'Circle-Token': 'CIRCLE_TOKEN'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Create a new context
Creates a new context.

Authorizations:
api_key_headerbasic_authapi_key_query
Request Body schema: application/json
name
required
string
The user defined name of the context.

owner
required
object or object
Responses
200
The new context

default
Error response.


post
/context
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"name": "string",
"owner": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"type": "organization"
}
}
Response samples
200default
Content type
application/json

Copy
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"name": "string",
"created_at": "2015-09-21T17:29:21.042Z"
}
Get a context
Returns basic information about a context.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
context-id
required
string <uuid>
ID of the context (UUID)

Responses
200
The context

default
Error response.


get
/context/{context-id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/context/%7Bcontext-id%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"name": "string",
"created_at": "2015-09-21T17:29:21.042Z"
}
Delete a context
Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
context-id
required
string <uuid>
ID of the context (UUID)

Responses
200
A confirmation message

default
Error response.


delete
/context/{context-id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/context/%7Bcontext-id%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"message": "string"
}
List environment variables
List information about environment variables in a context, not including their values.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
context-id
required
string <uuid>
ID of the context (UUID)

query Parameters
page-token
string
A token to retrieve the next page of results.

Responses
200
A paginated list of environment variables

default
Error response.


get
/context/{context-id}/environment-variable
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/context/%7Bcontext-id%7D/environment-variable',
qs: {'page-token': 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Remove an environment variable
Delete an environment variable from a context.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
env-var-name
required
string
Example: POSTGRES_USER
The name of the environment variable

context-id
required
string <uuid>
ID of the context (UUID)

Responses
200
A confirmation message

default
Error response.


delete
/context/{context-id}/environment-variable/{env-var-name}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/context/%7Bcontext-id%7D/environment-variable/POSTGRES_USER',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"message": "string"
}
Add or update an environment variable
Create or update an environment variable within a context. Returns information about the environment variable, not including its value.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
context-id
required
string <uuid>
ID of the context (UUID)

env-var-name
required
string
Example: POSTGRES_USER
The name of the environment variable

Request Body schema: application/json
value
required
string
The value of the environment variable

Responses
200
The new environment variable

default
Error response.


put
/context/{context-id}/environment-variable/{env-var-name}
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
{
"value": "some-secret-value"
}
Response samples
200default
Content type
application/json
Example


Copy
{
"variable": "POSTGRES_USER",
"created_at": "2015-09-21T17:29:21.042Z",
"updated_at": "2015-09-21T17:29:21.042Z",
"context_id": "f31d7249-b7b1-4729-b3a4-ec0ba07b4686"
}
🧪 Get context restrictions
[EXPERIMENTAL] Gets a list of project restrictions associated with a context.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
context_id
required
string
Example: be8bb2e3-c3d6-4098-89f4-572ff976ba9a
An opaque identifier of a context.

Responses
200
Successful response.

400
Context ID provided is invalid.

401
Credentials provided are invalid.

404
Entity not found.

429
API rate limits exceeded.

500
Internal server error.


get
/context/{context_id}/restrictions
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/context/be8bb2e3-c3d6-4098-89f4-572ff976ba9a/restrictions',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401404429500
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
🧪 Create context restriction
[EXPERIMENTAL] Creates project restriction on a context.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
context_id
required
string
Example: be8bb2e3-c3d6-4098-89f4-572ff976ba9a
An opaque identifier of a context.

Request Body schema: application/json
required
project_id
string <uuid>
Deprecated
Deprecated - Use "restriction_type" and "restriction_value" instead.

The project ID to use for a project restriction. This is mutually exclusive with restriction_type and restriction_value and implies restriction_type is "project".

restriction_type
string
restriction_value
string
Responses
201
Successful response.

400
Bad request.

401
Credentials provided are invalid.

404
Entity not found.

409
Request conflict.

429
API rate limits exceeded.

500
Internal server error.


post
/context/{context_id}/restrictions
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
{
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"restriction_type": "project",
"restriction_value": "405d8375-3514-403b-8c43-83ae74cfe0e9"
}
Response samples
201400401404409429500
Content type
application/json

Copy
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"name": "string",
"restriction_type": "project",
"restriction_value": "string"
}
🧪 Delete context restriction
[EXPERIMENTAL] Deletes a project restriction on a context.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
context_id
required
string
Example: be8bb2e3-c3d6-4098-89f4-572ff976ba9a
An opaque identifier of a context.

restriction_id
required
string
Example: 1c23d2cb-07b1-4a28-8af3-e369732050ed
An opaque identifier of a context restriction.

Responses
200
Successful response.

400
Context restriction ID provided is invalid.

401
Credentials provided are invalid.

404
Entity not found.

429
API rate limits exceeded.

500
Internal server error.


delete
/context/{context_id}/restrictions/{restriction_id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/context/be8bb2e3-c3d6-4098-89f4-572ff976ba9a/restrictions/1c23d2cb-07b1-4a28-8af3-e369732050ed',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401404429500
Content type
application/json

Copy
{
"message": "Context restriction deleted."
}
Insights
Endpoints relating to Insights. Use Insights to monitor credit and compute usage for your projects.

Get summary metrics and trends for a project across it's workflows and branches
Get summary metrics and trends for a project at workflow and branch level. Workflow runs going back at most 90 days are included in the aggregation window. Trends are only supported upto last 30 days. Please note that Insights is not a financial reporting tool and should not be used for precise credit reporting. Credit reporting from Insights does not use the same source of truth as the billing information that is found in the Plan Overview page in the CircleCI UI, nor does the underlying data have the same data accuracy guarantees as the billing information in the CircleCI UI. This may lead to discrepancies between credits reported from Insights and the billing information in the Plan Overview page of the CircleCI UI. For precise credit reporting, always use the Plan Overview page in the CircleCI UI.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

query Parameters
reporting-window
string
Enum: "last-7-days" "last-90-days" "last-24-hours" "last-30-days" "last-60-days"
Example: reporting-window=last-90-days
The time window used to calculate summary metrics. If not provided, defaults to last-90-days

branches
object
Example: branches=A single branch: ?branches=main or for multiple branches: ?branches=main&branches=feature&branches=dev
The names of VCS branches to include in branch-level workflow metrics.

workflow-names
object
Example: workflow-names=A single workflow name: ?workflow-names=build-test-deploy or for multiple workflow names: ?workflow-names=build&workflow-names=test-and-deploy.
The names of workflows to include in workflow-level metrics.

Responses
200
Aggregated summary metrics and trends by workflow and branches

default
Error response.


get
/insights/pages/{project-slug}/summary
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/pages/gh/CircleCI-Public/api-preview-docs/summary',
qs: {
'reporting-window': 'SOME_STRING_VALUE',
branches: 'SOME_OBJECT_VALUE',
'workflow-names': 'SOME_OBJECT_VALUE'
},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"org_id": null,
"project_id": null,
"project_data": {
"metrics": {},
"trends": {}
},
"project_workflow_data": [
{}
],
"project_workflow_branch_data": [
{}
],
"all_branches": [
"main"
],
"all_workflows": [
"build-and-test"
]
}
Job timeseries data
Get timeseries data for all jobs within a workflow. Hourly granularity data is only retained for 48 hours while daily granularity data is retained for 90 days.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

workflow-name
required
string
Example: build-and-test
The name of the workflow.

query Parameters
branch
string
The name of a vcs branch. If not passed we will scope the API call to the default branch.

granularity
string
Enum: "daily" "hourly"
Example: granularity=hourly
The granularity for which to query timeseries data.

start-date
string <date-time>
Example: start-date=2020-08-21T13:26:29Z
Include only executions that started at or after this date. This must be specified if an end-date is provided.

end-date
string <date-time>
Example: end-date=2020-09-04T13:26:29Z
Include only executions that started before this date. This date can be at most 90 days after the start-date.

Responses
200
An array of timeseries data, one entry per job.

default
Error response.


get
/insights/time-series/{project-slug}/workflows/{workflow-name}/jobs
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/time-series/gh/CircleCI-Public/api-preview-docs/workflows/build-and-test/jobs',
qs: {
branch: 'SOME_STRING_VALUE',
granularity: 'SOME_STRING_VALUE',
'start-date': 'SOME_STRING_VALUE',
'end-date': 'SOME_STRING_VALUE'
},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"next_page_token": "string",
"items": [
{}
]
}
Get summary metrics with trends for the entire org, and for each project.
Gets aggregated summary metrics with trends for the entire org. Also gets aggregated metrics and trends for each project belonging to the org.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
org-slug
required
string
Example: gh/CircleCI-Public
Org slug in the form vcs-slug/org-name. The / characters may be URL-escaped.

query Parameters
reporting-window
string
Enum: "last-7-days" "last-90-days" "last-24-hours" "last-30-days" "last-60-days"
Example: reporting-window=last-90-days
The time window used to calculate summary metrics. If not provided, defaults to last-90-days

project-names
object
Example: project-names=For a single project: ?project-names=some-project or for multiple projects: ?project-names=some-project1&project-names=some-project2
List of project names.

Responses
200
summary metrics with trends for an entire org and it's projects.

default
Error response.


get
/insights/{org-slug}/summary
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/summary',
qs: {'reporting-window': 'SOME_STRING_VALUE', 'project-names': 'SOME_OBJECT_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"org_data": {
"metrics": {},
"trends": {}
},
"org_project_data": [
{}
],
"all_projects": [
"string"
]
}
Get all branches for a project
Get a list of all branches for a specified project. The list will only contain branches currently available within Insights. The maximum number of branches returned by this endpoint is 5,000.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

query Parameters
workflow-name
string
Example: workflow-name=build-and-test
The name of a workflow. If not passed we will scope the API call to the project.

Responses
200
A list of branches for a project

default
Error response.


get
/insights/{project-slug}/branches
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/api-preview-docs/branches',
qs: {'workflow-name': 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"org_id": null,
"project_id": null,
"branches": [
"main"
]
}
Get flaky tests for a project
Get a list of flaky tests for a given project. Flaky tests are branch agnostic. A flaky test is a test that passed and failed in the same commit.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Responses
200
A list of flaky tests for a project

default
Error response.


get
/insights/{project-slug}/flaky-tests
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/api-preview-docs/flaky-tests',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"flaky-tests": [
{}
],
"total-flaky-tests": 5
}
Get summary metrics for a project's workflows
Get summary metrics for a project's workflows. Workflow runs going back at most 90 days are included in the aggregation window. Metrics are refreshed daily, and thus may not include executions from the last 24 hours. Please note that Insights is not a financial reporting tool and should not be used for precise credit reporting. Credit reporting from Insights does not use the same source of truth as the billing information that is found in the Plan Overview page in the CircleCI UI, nor does the underlying data have the same data accuracy guarantees as the billing information in the CircleCI UI. This may lead to discrepancies between credits reported from Insights and the billing information in the Plan Overview page of the CircleCI UI. For precise credit reporting, always use the Plan Overview page in the CircleCI UI.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

query Parameters
page-token
string
A token to retrieve the next page of results.

all-branches
boolean
Whether to retrieve data for all branches combined. Use either this parameter OR the branch name parameter.

branch
string
The name of a vcs branch. If not passed we will scope the API call to the default branch.

reporting-window
string
Enum: "last-7-days" "last-90-days" "last-24-hours" "last-30-days" "last-60-days"
Example: reporting-window=last-90-days
The time window used to calculate summary metrics. If not provided, defaults to last-90-days

Responses
200
A paginated list of summary metrics by workflow

default
Error response.


get
/insights/{project-slug}/workflows
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/api-preview-docs/workflows',
qs: {
'page-token': 'SOME_STRING_VALUE',
'all-branches': 'SOME_BOOLEAN_VALUE',
branch: 'SOME_STRING_VALUE',
'reporting-window': 'SOME_STRING_VALUE'
},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get recent runs of a workflow
Get recent runs of a workflow. Runs going back at most 90 days are returned. Please note that Insights is not a financial reporting tool and should not be used for precise credit reporting. Credit reporting from Insights does not use the same source of truth as the billing information that is found in the Plan Overview page in the CircleCI UI, nor does the underlying data have the same data accuracy guarantees as the billing information in the CircleCI UI. This may lead to discrepancies between credits reported from Insights and the billing information in the Plan Overview page of the CircleCI UI. For precise credit reporting, always use the Plan Overview page in the CircleCI UI.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

workflow-name
required
string
Example: build-and-test
The name of the workflow.

query Parameters
all-branches
boolean
Whether to retrieve data for all branches combined. Use either this parameter OR the branch name parameter.

branch
string
The name of a vcs branch. If not passed we will scope the API call to the default branch.

page-token
string
A token to retrieve the next page of results.

start-date
string <date-time>
Example: start-date=2020-08-21T13:26:29Z
Include only executions that started at or after this date. This must be specified if an end-date is provided.

end-date
string <date-time>
Example: end-date=2020-09-04T13:26:29Z
Include only executions that started before this date. This date can be at most 90 days after the start-date.

Responses
200
A paginated list of recent workflow runs

default
Error response.


get
/insights/{project-slug}/workflows/{workflow-name}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/api-preview-docs/workflows/build-and-test',
qs: {
'all-branches': 'SOME_BOOLEAN_VALUE',
branch: 'SOME_STRING_VALUE',
'page-token': 'SOME_STRING_VALUE',
'start-date': 'SOME_STRING_VALUE',
'end-date': 'SOME_STRING_VALUE'
},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get summary metrics for a project workflow's jobs.
Get summary metrics for a project workflow's jobs. Job runs going back at most 90 days are included in the aggregation window. Metrics are refreshed daily, and thus may not include executions from the last 24 hours. Please note that Insights is not a financial reporting tool and should not be used for precise credit reporting. Credit reporting from Insights does not use the same source of truth as the billing information that is found in the Plan Overview page in the CircleCI UI, nor does the underlying data have the same data accuracy guarantees as the billing information in the CircleCI UI. This may lead to discrepancies between credits reported from Insights and the billing information in the Plan Overview page of the CircleCI UI. For precise credit reporting, always use the Plan Overview page in the CircleCI UI.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

workflow-name
required
string
Example: build-and-test
The name of the workflow.

query Parameters
page-token
string
A token to retrieve the next page of results.

all-branches
boolean
Whether to retrieve data for all branches combined. Use either this parameter OR the branch name parameter.

branch
string
The name of a vcs branch. If not passed we will scope the API call to the default branch.

reporting-window
string
Enum: "last-7-days" "last-90-days" "last-24-hours" "last-30-days" "last-60-days"
Example: reporting-window=last-90-days
The time window used to calculate summary metrics. If not provided, defaults to last-90-days

job-name
string
Example: job-name=lint
The name of the jobs you would like to filter from your workflow. If not specified, all workflow jobs will be returned. The job name can either be the full job name or just a substring of the job name.

Responses
200
A paginated list of summary metrics by workflow job.

default
Error response.


get
/insights/{project-slug}/workflows/{workflow-name}/jobs
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/api-preview-docs/workflows/build-and-test/jobs',
qs: {
'page-token': 'SOME_STRING_VALUE',
'all-branches': 'SOME_BOOLEAN_VALUE',
branch: 'SOME_STRING_VALUE',
'reporting-window': 'SOME_STRING_VALUE',
'job-name': 'SOME_STRING_VALUE'
},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get metrics and trends for workflows
Get the metrics and trends for a particular workflow on a single branch or all branches

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

workflow-name
required
string
Example: build-and-test
The name of the workflow.

query Parameters
all-branches
boolean
Whether to retrieve data for all branches combined. Use either this parameter OR the branch name parameter.

branch
string
The name of a vcs branch. If not passed we will scope the API call to the default branch.

Responses
200
Metrics and trends for a workflow

default
Error response.


get
/insights/{project-slug}/workflows/{workflow-name}/summary
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/api-preview-docs/workflows/build-and-test/summary',
qs: {'all-branches': 'SOME_BOOLEAN_VALUE', branch: 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"metrics": {
"total_runs": 0,
"successful_runs": 0,
"mttr": 0,
"total_credits_used": 0,
"failed_runs": 0,
"success_rate": 0.1,
"completed_runs": 0,
"window_start": "2019-08-24T14:15:22Z",
"duration_metrics": {},
"window_end": "2019-08-24T14:15:22Z",
"throughput": 0.1
},
"trends": {
"total_runs": 0.1,
"failed_runs": 0.1,
"success_rate": 0.1,
"p95_duration_secs": 0.1,
"median_duration_secs": 0.1,
"total_credits_used": 0.1,
"mttr": 0.1,
"throughput": 0.1
},
"workflow_names": [
"string"
]
}
Get test metrics for a project's workflows
Get test metrics for a project's workflows. Currently tests metrics are calculated based on 10 most recent workflow runs.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

workflow-name
required
string
Example: build-and-test
The name of the workflow.

query Parameters
branch
string
The name of a vcs branch. If not passed we will scope the API call to the default branch.

all-branches
boolean
Whether to retrieve data for all branches combined. Use either this parameter OR the branch name parameter.

Responses
200
A list of test metrics by workflow

default
Error response.


get
/insights/{project-slug}/workflows/{workflow-name}/test-metrics
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/insights/gh/CircleCI-Public/api-preview-docs/workflows/build-and-test/test-metrics',
qs: {branch: 'SOME_STRING_VALUE', 'all-branches': 'SOME_BOOLEAN_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"average_test_count": 0,
"most_failed_tests": [
{}
],
"most_failed_tests_extra": 0,
"slowest_tests": [
{}
],
"slowest_tests_extra": 0,
"total_test_runs": 0,
"test_runs": [
{}
]
}
User
A set of endpoints you can use to get information about a specific user.

User Information
Provides information about the user that is currently signed in.

Authorizations:
api_key_headerbasic_authapi_key_query
Responses
200
User login information.

default
Error response.


get
/me
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/me',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"login": "string",
"name": "string"
}
Collaborations
Provides the set of organizations of which a user is a member or a collaborator.

The set of organizations that a user can collaborate on is composed of:

Organizations that the current user belongs to across VCS types (e.g. BitBucket, GitHub)
The parent organization of repository that the user can collaborate on, but is not necessarily a member of
The organization of the current user's account
Authorizations:
api_key_headerbasic_authapi_key_query
Responses
200
Collaborations

default
Error response.


get
/me/collaborations
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/me/collaborations',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
[
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"vcs-type": "string",
"name": "string",
"avatar_url": "string",
"slug": "string"
}
]
User Information
Provides information about the user with the given ID.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
id
required
string <uuid>
The unique ID of the user.

Responses
200
User login information.

default
Error response.


get
/user/{id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/user/%7Bid%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"login": "string",
"name": "string"
}
Pipeline
Endpoints relating to pipelines. Get information about your pipelines. Trigger or continue a pipeline.

Get a list of pipelines
Returns all pipelines for the most recently built projects (max 250) you follow in an organization.

Authorizations:
api_key_headerbasic_authapi_key_query
query Parameters
org-slug
string
Example: org-slug=gh/CircleCI-Public
Org slug in the form vcs-slug/org-name. For projects that use GitLab or GitHub App, use circleci as the vcs-slug and replace the org-name with the organization ID (found in Organization Settings).

page-token
string
A token to retrieve the next page of results.

mine
boolean
Only include entries created by your user.

Responses
200
A sequence of pipelines.

default
Error response.


get
/pipeline
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/pipeline',
qs: {
'org-slug': 'SOME_STRING_VALUE',
'page-token': 'SOME_STRING_VALUE',
mine: 'SOME_BOOLEAN_VALUE'
},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Continue a pipeline
Continue a pipeline from the setup phase. For information on using pipeline parameters with dynamic configuration, see the Pipeline values and parameters docs.

Authorizations:
api_key_headerbasic_authapi_key_query
Request Body schema: application/json
continuation-key
required
string (PipelineContinuationKey)
A pipeline continuation key.

configuration
required
string
A configuration string for the pipeline.

parameters
object
An object containing pipeline parameters and their values. Pipeline parameters have the following size limits: 100 max entries, 128 maximum key length, 512 maximum value length.

Responses
200
A confirmation message.

default
Error response.


post
/pipeline/continue
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"continuation-key": "string",
"configuration": "string",
"parameters": {
"deploy_prod": true
}
}
Response samples
200default
Content type
application/json

Copy
{
"message": "string"
}
Get a pipeline by ID
Returns a pipeline by the pipeline ID.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
pipeline-id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the pipeline.

Responses
200
A pipeline object.

default
Error response.


get
/pipeline/{pipeline-id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/pipeline/5034460f-c7c4-4c43-9457-de07e2029e7b',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"id": "5034460f-c7c4-4c43-9457-de07e2029e7b",
"errors": [
{}
],
"project_slug": "gh/CircleCI-Public/api-preview-docs",
"updated_at": "2019-08-24T14:15:22Z",
"number": 25,
"trigger_parameters": {
"property1": "string",
"property2": "string"
},
"state": "created",
"created_at": "2019-08-24T14:15:22Z",
"trigger": {
"type": "scheduled_pipeline",
"received_at": "2019-08-24T14:15:22Z",
"actor": {}
},
"vcs": {
"provider_name": "GitHub",
"target_repository_url": "https://github.com/CircleCI-Public/api-preview-docs",
"branch": "feature/design-new-api",
"review_id": "123",
"review_url": "https://github.com/CircleCI-Public/api-preview-docs/pull/123",
"revision": "f454a02b5d10fcccfd7d9dd7608a76d6493a98b4",
"tag": "v3.1.4159",
"commit": {},
"origin_repository_url": "https://github.com/CircleCI-Public/api-preview-docs"
}
}
Get a pipeline's configuration
Returns a pipeline's configuration by ID.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
pipeline-id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the pipeline.

Responses
200
The configuration strings for the pipeline.

default
Error response.


get
/pipeline/{pipeline-id}/config
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/pipeline/5034460f-c7c4-4c43-9457-de07e2029e7b/config',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"source": "string",
"compiled": "string",
"setup-config": "string",
"compiled-setup-config": "string"
}
Get pipeline values for a pipeline
Returns a map of pipeline values by pipeline ID. For more information see the pipeline values reference page.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
pipeline-id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the pipeline.

Responses
200
A JSON object of pipeline values

default
Error response.


get
/pipeline/{pipeline-id}/values
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/pipeline/5034460f-c7c4-4c43-9457-de07e2029e7b/values',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"property1": "string",
"property2": "string"
}
Get a pipeline's workflows
Returns a paginated list of workflows by pipeline ID.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
pipeline-id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the pipeline.

query Parameters
page-token
string
A token to retrieve the next page of results.

Responses
200
A paginated list of workflow objects.

default
Error response.


get
/pipeline/{pipeline-id}/workflow
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/pipeline/5034460f-c7c4-4c43-9457-de07e2029e7b/workflow',
qs: {'page-token': 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get all pipelines
Returns all pipelines for this project.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

query Parameters
branch
string
The name of a vcs branch.

page-token
string
A token to retrieve the next page of results.

Responses
200
A sequence of pipelines.

default
Error response.


get
/project/{project-slug}/pipeline
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/pipeline',
qs: {branch: 'SOME_STRING_VALUE', 'page-token': 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Trigger a new pipeline
Not available to projects that use GitLab or GitHub App. Triggers a new pipeline on the project. GitHub App users should use the new Trigger Pipeline API.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Request Body schema: application/json
branch
string
The branch where the pipeline ran. The HEAD commit on this branch was used for the pipeline. Note that branch and tag are mutually exclusive. To trigger a pipeline for a PR by number use pull/<number>/head for the PR ref or pull/<number>/merge for the merge ref (GitHub only).

tag
string
The tag used by the pipeline. The commit that this tag points to was used for the pipeline. Note that branch and tag are mutually exclusive.

parameters
object
An object containing pipeline parameters and their values. Pipeline parameters have the following size limits: 100 max entries, 128 maximum key length, 512 maximum value length.

Responses
201
The created pipeline.

default
Error response.


post
/project/{project-slug}/pipeline
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"branch": "feature/design-new-api",
"tag": "v3.1.4159",
"parameters": {
"deploy_prod": true
}
}
Response samples
201default
Content type
application/json

Copy
{
"id": "5034460f-c7c4-4c43-9457-de07e2029e7b",
"state": "created",
"number": 25,
"created_at": "2019-08-24T14:15:22Z"
}
Get your pipelines
Returns a sequence of all pipelines for this project triggered by the user.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

query Parameters
page-token
string
A token to retrieve the next page of results.

Responses
200
A sequence of pipelines.

default
Error response.


get
/project/{project-slug}/pipeline/mine
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/pipeline/mine',
qs: {'page-token': 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get a pipeline by pipeline number
Returns a pipeline by the pipeline number.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

pipeline-number
required
any
Example: 123
The number of the pipeline.

Responses
200
A pipeline object.

default
Error response.


get
/project/{project-slug}/pipeline/{pipeline-number}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/pipeline/123',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"id": "5034460f-c7c4-4c43-9457-de07e2029e7b",
"errors": [
{}
],
"project_slug": "gh/CircleCI-Public/api-preview-docs",
"updated_at": "2019-08-24T14:15:22Z",
"number": 25,
"trigger_parameters": {
"property1": "string",
"property2": "string"
},
"state": "created",
"created_at": "2019-08-24T14:15:22Z",
"trigger": {
"type": "scheduled_pipeline",
"received_at": "2019-08-24T14:15:22Z",
"actor": {}
},
"vcs": {
"provider_name": "GitHub",
"target_repository_url": "https://github.com/CircleCI-Public/api-preview-docs",
"branch": "feature/design-new-api",
"review_id": "123",
"review_url": "https://github.com/CircleCI-Public/api-preview-docs/pull/123",
"revision": "f454a02b5d10fcccfd7d9dd7608a76d6493a98b4",
"tag": "v3.1.4159",
"commit": {},
"origin_repository_url": "https://github.com/CircleCI-Public/api-preview-docs"
}
}
[Recommended] Trigger a new pipeline
Trigger a pipeline given a pipeline definition ID. Supports all integrations except GitLab.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
provider
required
string
Enum: "github" "gh" "bitbucket" "bb" "circleci"
Example: gh
The provider segment of a project or org slug, the first of the three. This may be a VCS. For projects that use GitHub App, use circleci.

organization
required
string
Example: CircleCI-Public
The organization segment of a project or org slug, the second of the three. For GitHub OAuth or Bitbucket projects, this is the organization name. For projects that use GitLab or GitHub App, use the organization ID (found in Organization Settings).

project
required
string
Example: api-preview-docs
The project segment of a project slug, the third of the three. For GitHub OAuth or Bitbucket projects, this is the repository name. For projects that use GitLab or GitHub App, use the project ID (found in Project Settings).

Request Body schema: application/json
definition_id
string <uuid>
The unique id for the pipeline definition. This can be found in the page Project Settings > Pipelines.

config
object
checkout
object
parameters
object
An object containing pipeline parameters and their values. Pipeline parameters have the following size limits: 100 max entries, 128 maximum key length, 512 maximum value length.

Responses
201
Successful response.

400
Unexpected request body provided.

401
Credentials provided are invalid.

404
Entity not found.


post
/project/{provider}/{organization}/{project}/pipeline/run
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"definition_id": "2338d0ae-5541-4bbf-88a2-55e9f7281f80",
"config": {
"branch": "main"
},
"checkout": {
"tag": "v2"
},
"parameters": {
"example_param": "my value",
"example_param2": true,
"example_param3": 3
}
}
Response samples
201400401404
Content type
application/json

Copy
{
"state": "created",
"created_at": "2019-08-24T14:15:22Z",
"number": 25,
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08"
}
Job
Endpoints relating to jobs. Get information about your jobs, retrieve job assets, cancel a job.

Cancel job by job ID
Cancel job with a given job ID.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
job-id
required
string <uuid>
The unique ID of the job.

Responses
200
Job cancelled successfully.

400
Bad request error.

401
Unauthorized error.

403
Forbidden error.

404
Job not found error.

default
Error response.


post
/jobs/{job-id}/cancel
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'POST',
url: 'https://circleci.com/api/v2/jobs/%7Bjob-id%7D/cancel',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401403404default
Content type
application/json

Copy
{
"message": "string"
}
Get job details
Returns job details.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
job-number
required
any
Example: 123
The number of the job.

project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Responses
200
Job details.

default
Error response.


get
/project/{project-slug}/job/{job-number}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/job/123',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"web_url": "string",
"project": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"slug": "gh/CircleCI-Public/api-preview-docs",
"name": "api-preview-docs",
"external_url": "https://github.com/CircleCI-Public/api-preview-docs"
},
"parallel_runs": [
{}
],
"started_at": "2019-08-24T14:15:22Z",
"latest_workflow": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"name": "build-and-test"
},
"name": "string",
"executor": {
"resource_class": "string",
"type": "string"
},
"parallelism": 0,
"status": "success",
"number": 1,
"pipeline": {
"id": "5034460f-c7c4-4c43-9457-de07e2029e7b"
},
"duration": 0,
"created_at": "2019-08-24T14:15:22Z",
"messages": [
{}
],
"contexts": [
{}
],
"organization": {
"name": "string"
},
"queued_at": "2019-08-24T14:15:22Z",
"stopped_at": "2019-08-24T14:15:22Z"
}
Cancel job by job number
Cancel job with a given job number.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
job-number
required
any
Example: 123
The number of the job.

project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Responses
200
default
Error response.


post
/project/{project-slug}/job/{job-number}/cancel
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'POST',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/job/123/cancel',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"message": "string"
}
Get a job's artifacts
Returns a job's artifacts.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
job-number
required
any
Example: 123
The number of the job.

project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Responses
200
A paginated list of the job's artifacts.

default
Error response.


get
/project/{project-slug}/{job-number}/artifacts
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/123/artifacts',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get test metadata
Get test metadata for a build. In the rare case where there is more than 250MB of test data on the job, no results will be returned.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
job-number
required
any
Example: 123
The number of the job.

project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Responses
200
A paginated list of test results.

default
Error response.


get
/project/{project-slug}/{job-number}/tests
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/123/tests',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Workflow
Endpoints relating to workflows. Get information about your workflows, or interact with them to rerun, cancel or approve a job.

Get a workflow
Returns summary fields of a workflow by ID.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the workflow.

Responses
200
A workflow object.

default
Error response.


get
/workflow/{id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/workflow/5034460f-c7c4-4c43-9457-de07e2029e7b',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"pipeline_id": "5034460f-c7c4-4c43-9457-de07e2029e7b",
"canceled_by": "026a6d28-c22e-4aab-a8b4-bd7131a8ea35",
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"name": "build-and-test",
"project_slug": "gh/CircleCI-Public/api-preview-docs",
"errored_by": "c6e40f70-a80a-4ccc-af88-8d985a7bc622",
"tag": "setup",
"status": "success",
"started_by": "03987f6a-4c27-4dc1-b6ab-c7e83bb3e713",
"pipeline_number": 25,
"created_at": "2019-08-24T14:15:22Z",
"stopped_at": "2019-08-24T14:15:22Z"
}
Approve a job
Approves a pending approval job in a workflow.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
approval_request_id
required
string <uuid>
The ID of the job being approved.

id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the workflow.

Responses
202
A confirmation message.

default
Error response.


post
/workflow/{id}/approve/{approval_request_id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'POST',
url: 'https://circleci.com/api/v2/workflow/5034460f-c7c4-4c43-9457-de07e2029e7b/approve/%7Bapproval_request_id%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
202default
Content type
application/json

Copy
{
"message": "string"
}
Cancel a workflow
Cancels a running workflow.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the workflow.

Responses
202
A confirmation message.

default
Error response.


post
/workflow/{id}/cancel
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'POST',
url: 'https://circleci.com/api/v2/workflow/5034460f-c7c4-4c43-9457-de07e2029e7b/cancel',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
202default
Content type
application/json

Copy
{
"message": "string"
}
Get a workflow's jobs
Returns a sequence of jobs for a workflow.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the workflow.

Responses
200
A paginated sequence of jobs.

default
Error response.


get
/workflow/{id}/job
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/workflow/5034460f-c7c4-4c43-9457-de07e2029e7b/job',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Rerun a workflow
Reruns a workflow.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
id
required
string <uuid>
Example: 5034460f-c7c4-4c43-9457-de07e2029e7b
The unique ID of the workflow.

Request Body schema: application/json
enable_ssh
boolean
Whether to enable SSH access for the triggering user on the newly-rerun job. Requires the jobs parameter to be used and so is mutually exclusive with the from_failed parameter.

from_failed
boolean
Whether to rerun the workflow from the failed job. Mutually exclusive with the jobs parameter.

jobs
Array of strings <uuid> [ items <uuid > ]
A list of job IDs to rerun.

sparse_tree
boolean
Completes rerun using sparse trees logic, an optimization for workflows that have disconnected subgraphs. Requires jobs parameter and so is mutually exclusive with the from_failed parameter.

Responses
202
A confirmation message.

default
Error response.


post
/workflow/{id}/rerun
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"enable_ssh": false,
"from_failed": false,
"jobs": [
"c65b68ef-e73b-4bf2-be9a-7a322a9df150",
"5e957edd-5e8c-4985-9178-5d0d69561822"
],
"sparse_tree": false
}
Response samples
202default
Content type
application/json

Copy
{
"workflow_id": "0e53027b-521a-4c40-9042-47e72b3c63a3"
}
Webhook
Endpoints relating to outbound webhooks. Use outbound webhooks to integrate your CircleCI builds with external services.

Create an outbound webhook
Creates an outbound webhook.

Authorizations:
api_key_headerbasic_authapi_key_query
Request Body schema: application/json
name
required
string
Name of the webhook

events
required
Array of strings
Items Enum: "workflow-completed" "job-completed"
Events that will trigger the webhook

url
required
string
URL to deliver the webhook to. Note: protocol must be included as well (only https is supported)

verify-tls
required
boolean
Whether to enforce TLS certificate verification when delivering the webhook

signing-secret
required
string
Secret used to build an HMAC hash of the payload and passed as a header in the webhook request

scope
required
object
The scope in which the relevant events that will trigger webhooks

Responses
201
A webhook

default
Error response.


post
/webhook
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"name": "string",
"events": [
"workflow-completed"
],
"url": "string",
"verify-tls": true,
"signing-secret": "string",
"scope": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"type": "project"
}
}
Response samples
201default
Content type
application/json

Copy
Expand allCollapse all
{
"url": "string",
"verify-tls": true,
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"signing-secret": "string",
"updated-at": "2015-09-21T17:29:21.042Z",
"name": "string",
"created-at": "2015-09-21T17:29:21.042Z",
"scope": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"type": "string"
},
"events": [
"workflow-completed"
]
}
List webhooks
Get a list of outbound webhooks that match the given scope-type and scope-id

Authorizations:
api_key_headerbasic_authapi_key_query
query Parameters
scope-id
required
string <uuid>
ID of the scope being used (at the moment, only project ID is supported)

scope-type
required
string
Value: "project"
Type of the scope being used

Responses
200
A list of webhooks

default
Error response.


get
/webhook
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/webhook',
qs: {'scope-id': 'SOME_STRING_VALUE', 'scope-type': 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Delete an outbound webhook
Deletes an outbound webhook

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
webhook-id
required
string <uuid>
ID of the webhook (UUID)

Responses
200
A confirmation message

default
Error response.


delete
/webhook/{webhook-id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/webhook/%7Bwebhook-id%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"message": "string"
}
Get a webhook
Get an outbound webhook by id.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
webhook-id
required
string <uuid>
ID of the webhook (UUID)

Responses
200
A webhook

default
Error response.


get
/webhook/{webhook-id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/webhook/%7Bwebhook-id%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"url": "string",
"verify-tls": true,
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"signing-secret": "string",
"updated-at": "2015-09-21T17:29:21.042Z",
"name": "string",
"created-at": "2015-09-21T17:29:21.042Z",
"scope": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"type": "string"
},
"events": [
"workflow-completed"
]
}
Update an outbound webhook
Updates an outbound webhook.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
webhook-id
required
string <uuid>
ID of the webhook (UUID)

Request Body schema: application/json
name
string
Name of the webhook

events
Array of strings
Items Enum: "workflow-completed" "job-completed"
Events that will trigger the webhook

url
string
URL to deliver the webhook to. Note: protocol must be included as well (only https is supported)

signing-secret
string
Secret used to build an HMAC hash of the payload and passed as a header in the webhook request

verify-tls
boolean
Whether to enforce TLS certificate verification when delivering the webhook

Responses
200
A webhook

default
Error response.


put
/webhook/{webhook-id}
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"name": "string",
"events": [
"workflow-completed"
],
"url": "string",
"signing-secret": "string",
"verify-tls": true
}
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"url": "string",
"verify-tls": true,
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"signing-secret": "string",
"updated-at": "2015-09-21T17:29:21.042Z",
"name": "string",
"created-at": "2015-09-21T17:29:21.042Z",
"scope": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"type": "string"
},
"events": [
"workflow-completed"
]
}
OIDC Token Management
Endpoints related to manage oidc identity tokens

Delete org-level claims
Deletes org-level custom claims of OIDC identity tokens

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
orgID
required
string <uuid>
query Parameters
claims
required
string
comma separated list of claims to delete. Valid values are "audience" and "ttl".

Responses
200
Claims successfully deleted.

400
The request is malformed (e.g, a given path parameter is invalid)

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


delete
/org/{orgID}/oidc-custom-claims
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/org/%7BorgID%7D/oidc-custom-claims',
qs: {claims: 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400403500
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"audience_updated_at": "2019-08-24T14:15:22Z",
"org_id": "a40f5d1f-d889-42e9-94ea-b9b33585fc6b",
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"ttl": "string",
"ttl_updated_at": "2019-08-24T14:15:22Z"
}
Get org-level claims
Fetches org-level custom claims of OIDC identity tokens

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
orgID
required
string <uuid>
Responses
200
Claims successfully fetched.

400
The request is malformed (e.g, a given path parameter is invalid)

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


get
/org/{orgID}/oidc-custom-claims
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/org/%7BorgID%7D/oidc-custom-claims',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400403500
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"audience_updated_at": "2019-08-24T14:15:22Z",
"org_id": "a40f5d1f-d889-42e9-94ea-b9b33585fc6b",
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"ttl": "string",
"ttl_updated_at": "2019-08-24T14:15:22Z"
}
Patch org-level claims
Creates/Updates org-level custom claims of OIDC identity tokens

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
orgID
required
string <uuid>
Request Body schema: application/json
audience
Array of strings
ttl
string (JSONDuration) ^([0-9]+(ms|s|m|h|d|w)){1,7}$
Responses
200
Claims successfully patched.

400
The request is malformed (e.g, a given path parameter is invalid)

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


patch
/org/{orgID}/oidc-custom-claims
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"ttl": "string"
}
Response samples
200400403500
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"audience_updated_at": "2019-08-24T14:15:22Z",
"org_id": "a40f5d1f-d889-42e9-94ea-b9b33585fc6b",
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"ttl": "string",
"ttl_updated_at": "2019-08-24T14:15:22Z"
}
Delete project-level claims
Deletes project-level custom claims of OIDC identity tokens

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
orgID
required
string <uuid>
projectID
required
string <uuid>
query Parameters
claims
required
string
comma separated list of claims to delete. Valid values are "audience" and "ttl".

Responses
200
Claims successfully deleted.

400
The request is malformed (e.g, a given path parameter is invalid)

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


delete
/org/{orgID}/project/{projectID}/oidc-custom-claims
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/org/%7BorgID%7D/project/%7BprojectID%7D/oidc-custom-claims',
qs: {claims: 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400403500
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"audience_updated_at": "2019-08-24T14:15:22Z",
"org_id": "a40f5d1f-d889-42e9-94ea-b9b33585fc6b",
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"ttl": "string",
"ttl_updated_at": "2019-08-24T14:15:22Z"
}
Get project-level claims
Fetches project-level custom claims of OIDC identity tokens

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
orgID
required
string <uuid>
projectID
required
string <uuid>
Responses
200
Claims successfully fetched.

400
The request is malformed (e.g, a given path parameter is invalid)

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


get
/org/{orgID}/project/{projectID}/oidc-custom-claims
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/org/%7BorgID%7D/project/%7BprojectID%7D/oidc-custom-claims',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400403500
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"audience_updated_at": "2019-08-24T14:15:22Z",
"org_id": "a40f5d1f-d889-42e9-94ea-b9b33585fc6b",
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"ttl": "string",
"ttl_updated_at": "2019-08-24T14:15:22Z"
}
Patch project-level claims
Creates/Updates project-level custom claims of OIDC identity tokens

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
orgID
required
string <uuid>
projectID
required
string <uuid>
Request Body schema: application/json
audience
Array of strings
ttl
string (JSONDuration) ^([0-9]+(ms|s|m|h|d|w)){1,7}$
Responses
200
Claims successfully patched.

400
The request is malformed (e.g, a given path parameter is invalid)

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


patch
/org/{orgID}/project/{projectID}/oidc-custom-claims
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"ttl": "string"
}
Response samples
200400403500
Content type
application/json

Copy
Expand allCollapse all
{
"audience": [
"string"
],
"audience_updated_at": "2019-08-24T14:15:22Z",
"org_id": "a40f5d1f-d889-42e9-94ea-b9b33585fc6b",
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"ttl": "string",
"ttl_updated_at": "2019-08-24T14:15:22Z"
}
Policy Management
Endpoints related to managing policies and making policy decisions

Retrieves the owner's decision audit logs.
This endpoint will return a list of decision audit logs that were made using this owner's policies.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
query Parameters
status
string
Return decisions matching this decision status.

after
string <date-time>
Return decisions made after this date.

before
string <date-time>
Return decisions made before this date.

branch
string
Return decisions made on this branch.

project_id
string
Return decisions made for this project.

build_number
string
Return decisions made for this build number.

offset
integer
Sets the offset when retrieving the decisions, for paging.

Responses
200
Decision logs successfully retrieved.

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


get
/owner/{ownerID}/context/{context}/decision
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/owner/%7BownerID%7D/context/%7Bcontext%7D/decision',
qs: {
status: 'SOME_STRING_VALUE',
after: 'SOME_STRING_VALUE',
before: 'SOME_STRING_VALUE',
branch: 'SOME_STRING_VALUE',
project_id: 'SOME_STRING_VALUE',
build_number: 'SOME_STRING_VALUE',
offset: 'SOME_INTEGER_VALUE'
},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401403500
Content type
application/json

Copy
Expand allCollapse all
[
{
"created_at": "2019-08-24T14:15:22Z",
"decision": {},
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"metadata": {},
"policies": {},
"time_taken_ms": 0
}
]
Makes a decision
This endpoint will evaluate input data (config+metadata) against owner's stored policies and return a decision.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
Request Body schema: application/json
input
required
string
metadata
object
Responses
200
Decision rendered by applying the policy against the provided data. Response will be modeled by the data and rego processed.

400
The request is malformed

401
The request is unauthorized

500
Something unexpected happened on the server.


post
/owner/{ownerID}/context/{context}/decision
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"input": "string",
"metadata": { }
}
Response samples
200400401500
Content type
application/json

Copy
Expand allCollapse all
{
"enabled_rules": [
"string"
],
"hard_failures": [
{}
],
"reason": "string",
"soft_failures": [
{}
],
"status": "string"
}
Get the decision settings
This endpoint retrieves the current decision settings (eg enable/disable policy evaluation)

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
Responses
200
Decision settings successfully retrieved.

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


get
/owner/{ownerID}/context/{context}/decision/settings
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/owner/%7BownerID%7D/context/%7Bcontext%7D/decision/settings',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401403500
Content type
application/json

Copy
{
"enabled": true
}
Set the decision settings
This endpoint allows modifying decision settings (eg enable/disable policy evaluation)

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
Request Body schema: application/json
enabled
boolean
Responses
200
Decision settings successfully set.

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


patch
/owner/{ownerID}/context/{context}/decision/settings
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
{
"enabled": true
}
Response samples
200400401403500
Content type
application/json

Copy
{
"enabled": true
}
Retrieves the owner's decision audit log by given decisionID
This endpoint will retrieve a decision for a given decision log ID

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
decisionID
required
string
Responses
200
Decision log successfully retrieved.

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

404
There was no decision log found for given decision_id, and owner_id.

500
Something unexpected happened on the server.


get
/owner/{ownerID}/context/{context}/decision/{decisionID}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/owner/%7BownerID%7D/context/%7Bcontext%7D/decision/%7BdecisionID%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401403404500
Content type
application/json

Copy
Expand allCollapse all
{
"created_at": "2019-08-24T14:15:22Z",
"decision": {
"enabled_rules": [],
"hard_failures": [],
"reason": "string",
"soft_failures": [],
"status": "string"
},
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"metadata": {
"build_number": 0,
"project_id": "405d8375-3514-403b-8c43-83ae74cfe0e9",
"ssh_rerun": true,
"vcs": {}
},
"policies": {
"policy_name1": "1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f5302860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75",
"policy_name2": "5267768822ee624d48fce15ec5ca79cbd602cb7f4c2157a516556991f22ef8c7b5ef7b18d1ff41c59370efb0858651d44a936c11b7b144c48fe04df3c6a3e8da"
},
"time_taken_ms": 0
}
Retrieves Policy Bundle for a given decision log ID
This endpoint will retrieve a policy bundle for a given decision log ID

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
decisionID
required
string
Responses
200
Policy-Bundle retrieved successfully for given decision log ID

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

404
There was no decision log found for given decision_id, and owner_id.

500
Something unexpected happened on the server.


get
/owner/{ownerID}/context/{context}/decision/{decisionID}/policy-bundle
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/owner/%7BownerID%7D/context/%7Bcontext%7D/decision/%7BdecisionID%7D/policy-bundle',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401403404500
Content type
application/json

Copy
Expand allCollapse all
{
"property1": [
{}
],
"property2": [
{}
]
}
Retrieves Policy Bundle
This endpoint will retrieve a policy bundle

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
Responses
200
Policy-Bundle retrieved successfully.

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

500
Something unexpected happened on the server.


get
/owner/{ownerID}/context/{context}/policy-bundle
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/owner/%7BownerID%7D/context/%7Bcontext%7D/policy-bundle',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401403500
Content type
application/json

Copy
Expand allCollapse all
{
"property1": [
{}
],
"property2": [
{}
]
}
Creates policy bundle for the context
This endpoint replaces the current policy bundle with the provided policy bundle

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
query Parameters
dry
boolean
Request Body schema: application/json
policies
object
Responses
200
Policy-Bundle diff successfully returned.

201
Policy-Bundle successfully created.

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

413
The request exceeds the maximum payload size for policy bundles ~2.5Mib

500
Something unexpected happened on the server.


post
/owner/{ownerID}/context/{context}/policy-bundle
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"policies": {
"property1": "string",
"property2": "string"
}
}
Response samples
200201400401403413500
Content type
application/json

Copy
Expand allCollapse all
{
"created": [
"string"
],
"deleted": [
"string"
],
"modified": [
"string"
]
}
Retrieves a policy document
This endpoint will retrieve a policy document.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
ownerID
required
string
context
required
string
policyName
required
string
the policy name set by the rego policy_name rule

Responses
200
Policy retrieved successfully.

400
The request is malformed (e.g, a given path parameter is invalid)

401
The request is unauthorized

403
The user is forbidden from making this request

404
There was no policy that was found with the given owner_id and policy name.

500
Something unexpected happened on the server.


get
/owner/{ownerID}/context/{context}/policy-bundle/{policyName}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/owner/%7BownerID%7D/context/%7Bcontext%7D/policy-bundle/%7BpolicyName%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401403404500
Content type
application/json

Copy
{
"content": "string",
"created_at": "2019-08-24T14:15:22Z",
"created_by": "string",
"name": "string"
}
Project
[EXPERIMENTAL] Endpoints related to creating and managing a project.

Get a project
Retrieves a project by project slug.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Responses
200
A project object

default
Error response.


get
/project/{project-slug}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"slug": "gh/CircleCI-Public/api-preview-docs",
"name": "api-preview-docs",
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"organization_name": "CircleCI-Public",
"organization_slug": "CircleCI-Public",
"organization_id": "CircleCI-Public",
"vcs_info": {
"vcs_url": "https://github.com/CircleCI-Public/api-preview-docs",
"provider": "Bitbucket",
"default_branch": "main"
}
}
Create a new checkout key
Not available to projects that use GitLab or GitHub App. Creates a new checkout key. This API request is only usable with a user API token. Please ensure that you have authorized your account with GitHub before creating user keys. This is necessary to give CircleCI the permission to create a user key associated with your GitHub user account. You can find this page by visiting Project Settings > Checkout SSH Keys

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Request Body schema: application/json
type
required
string (CheckoutKeyInputType)
Enum: "user-key" "deploy-key"
The type of checkout key to create. This may be either deploy-key or user-key.

Responses
201
The checkout key.

default
Error response.


post
/project/{project-slug}/checkout-key
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
{
"type": "deploy-key"
}
Response samples
201default
Content type
application/json

Copy
{
"public-key": "ssh-rsa ...",
"type": "deploy-key",
"fingerprint": "c9:0b:1c:4f:d5:65:56:b9:ad:88:f9:81:2b:37:74:2f",
"preferred": true,
"created-at": "2015-09-21T17:29:21.042Z"
}
Get all checkout keys
Returns a sequence of checkout keys for :project.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

query Parameters
digest
string
Enum: "sha256" "md5"
The fingerprint digest type to return. This may be either md5 or sha256. If not passed, defaults to md5.

Responses
200
A sequence of checkout keys.

default
Error response.


get
/project/{project-slug}/checkout-key
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/checkout-key',
qs: {digest: 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get a checkout key
Returns an individual checkout key via md5 or sha256 fingerprint. sha256 keys should be url-encoded.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

fingerprint
required
string
Example: c9:0b:1c:4f:d5:65:56:b9:ad:88:f9:81:2b:37:74:2f
An SSH key fingerprint.

Responses
200
The checkout key.

default
Error response.


get
/project/{project-slug}/checkout-key/{fingerprint}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/checkout-key/c9:0b:1c:4f:d5:65:56:b9:ad:88:f9:81:2b:37:74:2f',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"public-key": "ssh-rsa ...",
"type": "deploy-key",
"fingerprint": "c9:0b:1c:4f:d5:65:56:b9:ad:88:f9:81:2b:37:74:2f",
"preferred": true,
"created-at": "2015-09-21T17:29:21.042Z"
}
Delete a checkout key
Deletes the checkout key via md5 or sha256 fingerprint. sha256 keys should be url-encoded.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

fingerprint
required
string
Example: c9:0b:1c:4f:d5:65:56:b9:ad:88:f9:81:2b:37:74:2f
An SSH key fingerprint.

Responses
200
A confirmation message.

default
Error response.


delete
/project/{project-slug}/checkout-key/{fingerprint}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/checkout-key/c9:0b:1c:4f:d5:65:56:b9:ad:88:f9:81:2b:37:74:2f',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"message": "string"
}
Create an environment variable
Creates a new environment variable.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Request Body schema: application/json
name
required
string
The name of the environment variable.

value
required
string
The value of the environment variable.

Responses
201
The environment variable.

default
Error response.


post
/project/{project-slug}/envvar
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
{
"name": "foo",
"value": "xxxx1234"
}
Response samples
201default
Content type
application/json

Copy
{
"name": "foo",
"value": "xxxx1234",
"created-at": "#joda/inst 2023-04-14T21:20:14+0000"
}
List all environment variables
Returns four 'x' characters, in addition to the last four ASCII characters of the value, consistent with the display of environment variable values on the CircleCI website.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Responses
200
A sequence of environment variables.

default
Error response.


get
/project/{project-slug}/envvar
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/envvar',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Delete an environment variable
Deletes the environment variable named :name.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

name
required
string
Example: foo
The name of the environment variable.

Responses
200
A confirmation message.

default
Error response.


delete
/project/{project-slug}/envvar/{name}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'DELETE',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/envvar/foo',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"message": "string"
}
Get a masked environment variable
Returns the masked value of environment variable :name.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

name
required
string
Example: foo
The name of the environment variable.

Responses
200
The environment variable.

default
Error response.


get
/project/{project-slug}/envvar/{name}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/envvar/foo',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
{
"name": "foo",
"value": "xxxx1234",
"created-at": "#joda/inst 2023-04-14T21:20:14+0000"
}
🧪 Create a project
[EXPERIMENTAL] Creates a new CircleCI project, and returns a list of the default advanced settings. Can only be called on a repo with a main branch and an existing config.yml file. Not yet available to projects that use GitLab or GitHub App.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
provider
required
string
Example: gh
The provider segment of a project or org slug, the first of the three. This may be a VCS. For projects that use GitLab or GitHub App, use circleci.

organization
required
string
Example: CircleCI-Public
The organization segment of a project or org slug, the second of the three. For GitHub OAuth or Bitbucket projects, this is the organization name. For projects that use GitLab or GitHub App, use the organization ID (found in Organization Settings).

project
required
string
Example: api-preview-docs
The project segment of a project slug, the third of the three. For GitHub OAuth or Bitbucket projects, this is the repository name. For projects that use GitLab or GitHub App, use the project ID (found in Project Settings).

Responses
201
Successful response.

400
Unexpected request body provided.

401
Credentials provided are invalid.

403
None or insufficient credentials provided.

404
Either a branch or a project were not found.

405
Create projects using the API is currently supported for classic Github OAuth and Bitbucket projects only.

429
API rate limits exceeded.

500
Internal server error.


post
/project/{provider}/{organization}/{project}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'POST',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
201400401403404405429500
Content type
application/json

Copy
Expand allCollapse all
{
"advanced": {
"autocancel_builds": true,
"build_fork_prs": true,
"build_prs_only": true,
"disable_ssh": true,
"forks_receive_secret_env_vars": true,
"oss": true,
"set_github_status": true,
"setup_workflows": true,
"write_settings_requires_admin": true,
"pr_only_branch_overrides": []
}
}
🧪 Get project settings
[EXPERIMENTAL] Returns a list of the advanced settings for a CircleCI project, whether enabled (true) or not (false).

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
provider
required
string
Example: gh
The provider segment of a project or org slug, the first of the three. This may be a VCS. For projects that use GitLab or GitHub App, use circleci.

organization
required
string
Example: CircleCI-Public
The organization segment of a project or org slug, the second of the three. For GitHub OAuth or Bitbucket projects, this is the organization name. For projects that use GitLab or GitHub App, use the organization ID (found in Organization Settings).

project
required
string
Example: api-preview-docs
The project segment of a project slug, the third of the three. For GitHub OAuth or Bitbucket projects, this is the repository name. For projects that use GitLab or GitHub App, use the project ID (found in Project Settings).

Responses
200
Successful response.

401
Credentials provided are invalid.

403
None or insufficient credentials provided.

404
Insufficient credentials for a private project, OR the organization, project, or repository does not exist.

429
API rate limits exceeded.

500
Internal server error.


get
/project/{provider}/{organization}/{project}/settings
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/settings',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200401403404429500
Content type
application/json

Copy
Expand allCollapse all
{
"advanced": {
"autocancel_builds": true,
"build_fork_prs": true,
"build_prs_only": true,
"disable_ssh": true,
"forks_receive_secret_env_vars": true,
"oss": true,
"set_github_status": true,
"setup_workflows": true,
"write_settings_requires_admin": true,
"pr_only_branch_overrides": []
}
}
🧪 Update project settings
[EXPERIMENTAL] Updates one or more of the advanced settings for a CircleCI project.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
provider
required
string
Example: gh
The provider segment of a project or org slug, the first of the three. This may be a VCS. For projects that use GitLab or GitHub App, use circleci.

organization
required
string
Example: CircleCI-Public
The organization segment of a project or org slug, the second of the three. For GitHub OAuth or Bitbucket projects, this is the organization name. For projects that use GitLab or GitHub App, use the organization ID (found in Organization Settings).

project
required
string
Example: api-preview-docs
The project segment of a project slug, the third of the three. For GitHub OAuth or Bitbucket projects, this is the repository name. For projects that use GitLab or GitHub App, use the project ID (found in Project Settings).

Request Body schema: application/json
required
The setting(s) to update, including one or more fields in the JSON object. Note that oss: true will only be set on projects whose underlying repositories are actually open source.

advanced
object
Responses
200
Successful response. Always includes the full advanced settings object. Returned even when the provided updates match the existing settings, but can also be returned when oss: true fails to set.

400
Request is malformed, e.g. with improperly encoded JSON

401
Credentials provided are invalid.

403
None or insufficient credentials provided.

404
Insufficient credentials for a private project, OR the organization, project, or repository does not exist.

429
API rate limits exceeded.

500
Internal server error.


patch
/project/{provider}/{organization}/{project}/settings
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"advanced": {
"autocancel_builds": false,
"build_prs_only": true,
"pr_only_branch_overrides": []
}
}
Response samples
200400401403404429500
Content type
application/json

Copy
Expand allCollapse all
{
"advanced": {
"autocancel_builds": true,
"build_fork_prs": true,
"build_prs_only": true,
"disable_ssh": true,
"forks_receive_secret_env_vars": true,
"oss": true,
"set_github_status": true,
"setup_workflows": true,
"write_settings_requires_admin": true,
"pr_only_branch_overrides": []
}
}
Usage
Endpoints related to organization usage exports.

The Usage API is an API provided by CircleCI to customers to access all of their usage data on CircleCI. It contains all the metadata (org, project, pipeline, workflow, and job dimensions) as well as credit consumption data. It is provided at the near lowest level of granularity (at the job run level).

Restrictions

Max result set size of 100MB
Query timeout of 4 hours.
Max date window of 32 days
13 months of historical data is available
No PII is surfaced in the Usage API (e.g. email address, Github login name)
The POST endpoint can only be queried up to (i.e. is rate limited to) 10 times per hour per org
The GET endpoint can only be queried up to (i.e. is rate limited to) 10 times per minute per org
To increase performance the API can generate multiple CSV files that need to be merged after download
Requirements

organization ID - To get your organization ID go to to Organization Settings tab in the CircleCI app. ie https://app.circleci.com/settings/organization///overview
API Personal Access Token - https://circleci.com/docs/managing-api-tokens/
Report Fields

Field	Description
organization_id	The org ID
organization_name	The org name
organization_created_date	The date (UTC) that the org was created
Project-level attributes	project_id	The project ID / token
project_name	The project name. For classic orgs, the project name is inherited from Github. For standalone, the org is set by the user.
project_created_date	The date (UTC) that the project was created. For classic orgs, this is the date that the repo was authorized on CircleCI. For standalone orgs, this is the date that the project was created on CircleCI
last_build_finished_at	The date (UTC) of the last pipeline run on this project
Pipeline-level attributes	vcs_name	The name of the VCS connected to the project on which the pipeline was run
vcs_url	The URL of the VCS on which the pipeline was run
vcs_branch	The branch on which the pipeline was run
pipeline_id	The ID of the pipeline instance that was triggered. If a pipeline is re-run, it will share the same pipeline ID as the original pipeline instance
pipeline_created_at	The date (UTC) the pipeline instance was first triggered
pipeline_number	The pipeline number
is_unregistered_user	Y/N flag of whether the pipeline was triggered by a CircleCI user or a user not registered on CircleCI. Examples of the latter include users who commit on a connected VCS and consume credits on CircleCI.
pipeline_trigger_source	The source of the pipeline instance trigger (API, webhook, etc.)
pipeline_trigger_user_id	The user ID / token of the user who triggered the pipeline
Workflow-level attributes	workflow_id	The ID of the workflow instance that was triggered
workflow_name	The name of the workflow
workflow_first_job_queued_at	The timestamp (UTC) of when the workflow instance started to queue
workflow_first_job_started_at	The timestamp (UTC) of when the workflow instance started to run
workflow_stopped_at	The timestamp (UTC) of when the workflow instance stopped
is_workflow_successful	Y/N flag of whether all jobs in the workflow were successfully ran
Job-level attributes	job_name	The name of the job (the name the customer sees in the UI)
job_id	The ID of the job run instance that was triggered
job_run_number	The number of the job run instance that was triggered
job_run_date	The date (UTC) of the job run instance began
job_run_queued_at	The timestamp (UTC) of when the job started to queue
job_run_started_at	The timestamp (UTC) of when the job started to run
job_run_stopped_at	The timestamp (UTC) of when the job stopped
job_build_status	The status of the job run instance
resource_class	The resource class of the job run instance
operating_system	The operating system of the job run instance
executor	The executor of the job run instance
parallelism	The parallelism of the job run instance
job_run_seconds	The duration in seconds of the job run instance
median_cpu_utilization_pct	The median CPU utilization calculated over the course of the entire job run instance. CPU utilization is logged every 15 seconds. It will not be available for any jobs under 15 seconds and occasionally will not be available for jobs greater than 15 seconds.
max_cpu_utilization_pct	The max CPU utilization logged over the course of the entire job run instance. CPU utilization is logged every 15 seconds. It will not be available for any jobs under 15 seconds and occasionally will not be available for jobs greater than 15 seconds.
median_ram_utilization_pct	The median RAM utilization calculated over the course of the entire job run instance. RAM utilization is logged every 15 seconds. It will not be available for any jobs under 15 seconds and occasionally will not be available for jobs greater than 15 seconds.
max_ram_utilization_pct	The max RAM utilization logged over the course of the entire job run instance. RAM utilization is logged every 15 seconds. It will not be available for any jobs under 15 seconds and occasionally will not be available for jobs greater than 15 seconds.
Credit consumption metrics	compute_credits	The compute credits consumed by this job run instance
dlc_credits	The docker-layer caching credits consumed by this job run instance
user_credits	The user credits consumed by this job run instance
storage_credits	The storage credits consumed by this job run instance. Note: When an organization is below its allocated storage threshold, a job that uses storage will have 0 storage credits applied. The organization's included storage threshold can be found on the CircleCI web app by navigating to Plan > Plan Usage.
network_credits	The network credits consumed by this job run instance
lease_credits	The lease credits consumed by this job run instance
lease_overage_credits	The lease overage credits consumed by this job run instance
ipranges_credits	The IP ranges credits consumed by this job run instance
total_credits	The total credits consumed by this job run instance
Create a usage export
Submits a request to create a usage export for an organization.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
org_id
required
string
Example: b9291e0d-a11e-41fb-8517-c545388b5953
An opaque identifier of an organization.

Request Body schema: application/json
required
start
required
string <date-time>
The start date & time (inclusive) of the range from which data will be pulled. Must be no more than one year ago.

end
required
string <date-time>
The end date & time (inclusive) of the range from which data will be pulled. Must be no more than 31 days after start.

shared_org_ids
Array of strings <uuid> [ items <uuid > ]
Responses
201
Usage export created successfully

400
Unexpected request body provided.

401
Credentials provided are invalid.

404
Entity not found.

429
API rate limits exceeded.

500
Internal server error.


post
/organizations/{org_id}/usage_export_job
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"start": "2019-08-24T14:15:22Z",
"end": "2019-08-24T14:15:22Z",
"shared_org_ids": [
"497f6eca-6276-4993-bfeb-53cbbbba6f08"
]
}
Response samples
201400401404429500
Content type
application/json

Copy
Expand allCollapse all
{
"usage_export_job_id": "7cd4bded-f639-433a-876b-1a8ea9f53127",
"state": "created",
"start": "2019-08-24T14:15:22Z",
"end": "2019-08-24T14:15:22Z",
"download_urls": [
"http://example.com"
]
}
Get a usage export
Gets a usage export for an organization.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
org_id
required
string
Example: b9291e0d-a11e-41fb-8517-c545388b5953
An opaque identifier of an organization.

usage_export_job_id
required
string <uuid>
Example: e8235eed-f121-4ae3-9c72-2719d6572818
An opaque identifier of a usage export job.

Responses
200
Usage export fetched successfully

400
Unexpected request body provided.

401
Credentials provided are invalid.

404
Entity not found.

429
API rate limits exceeded.

500
Internal server error.


get
/organizations/{org_id}/usage_export_job/{usage_export_job_id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/organizations/b9291e0d-a11e-41fb-8517-c545388b5953/usage_export_job/e8235eed-f121-4ae3-9c72-2719d6572818',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200400401404429500
Content type
application/json

Copy
Expand allCollapse all
{
"usage_export_job_id": "7cd4bded-f639-433a-876b-1a8ea9f53127",
"state": "created",
"download_urls": [
"http://example.com"
],
"error_reason": "string"
}
Schedule
Create a schedule
Not yet available to projects that use GitLab or GitHub App. Creates a schedule and returns the created schedule.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

Request Body schema: application/json
name
required
string
Name of the schedule.

timetable
required
object or object
Timetable that specifies when a schedule triggers.

attribution-actor
required
string
Enum: "current" "system"
The attribution-actor of the scheduled pipeline.

parameters
required
object
Pipeline parameters represented as key-value pairs. Must contain branch or tag.

description
string or null
Description of the schedule.

Responses
201
A schedule object.

default
Error response.


post
/project/{project-slug}/schedule
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"name": "string",
"timetable": {
"per-hour": 0,
"hours-of-day": [],
"days-of-week": [],
"days-of-month": [],
"months": []
},
"attribution-actor": "current",
"parameters": {
"deploy_prod": true,
"branch": "feature/design-new-api"
},
"description": "string"
}
Response samples
201default
Content type
application/json

Copy
Expand allCollapse all
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"timetable": {
"per-hour": 0,
"hours-of-day": [],
"days-of-week": [],
"days-of-month": [],
"months": []
},
"updated-at": "2019-08-24T14:15:22Z",
"name": "string",
"created-at": "2019-08-24T14:15:22Z",
"project-slug": "gh/CircleCI-Public/api-preview-docs",
"parameters": {
"deploy_prod": true,
"branch": "feature/design-new-api"
},
"actor": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"login": "string",
"name": "string"
},
"description": "string"
}
Get all schedules
Returns all schedules for this project.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
project-slug
required
string
Example: gh/CircleCI-Public/api-preview-docs
Project slug in the form vcs-slug/org-name/repo-name. The / characters may be URL-escaped. For projects that use GitLab or GitHub App, use circleci as the vcs-slug, replace org-name with the organization ID (found in Organization Settings), and replace repo-name with the project ID (found in Project Settings).

query Parameters
page-token
string
A token to retrieve the next page of results.

Responses
200
A sequence of schedules.

default
Error response.


get
/project/{project-slug}/schedule
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/project/gh/CircleCI-Public/api-preview-docs/schedule',
qs: {'page-token': 'SOME_STRING_VALUE'},
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"items": [
{}
],
"next_page_token": "string"
}
Get a schedule
Get a schedule by id.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
schedule-id
required
string <uuid>
The unique ID of the schedule.

Responses
200
A schedule object.

default
Error response.


get
/schedule/{schedule-id}
Request samples
Node + RequestPython + Python3Go + NativeShell + Curl

Copy
const request = require('request');

const options = {
method: 'GET',
url: 'https://circleci.com/api/v2/schedule/%7Bschedule-id%7D',
headers: {Authorization: 'Basic REPLACE_BASIC_AUTH'}
};

request(options, function (error, response, body) {
if (error) throw new Error(error);

console.log(body);
});
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"timetable": {
"per-hour": 0,
"hours-of-day": [],
"days-of-week": [],
"days-of-month": [],
"months": []
},
"updated-at": "2019-08-24T14:15:22Z",
"name": "string",
"created-at": "2019-08-24T14:15:22Z",
"project-slug": "gh/CircleCI-Public/api-preview-docs",
"parameters": {
"deploy_prod": true,
"branch": "feature/design-new-api"
},
"actor": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"login": "string",
"name": "string"
},
"description": "string"
}
Update a schedule
Not yet available to projects that use GitLab or GitHub App. Updates a schedule and returns the updated schedule.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
schedule-id
required
string <uuid>
The unique ID of the schedule.

Request Body schema: application/json
description
string or null
Description of the schedule.

name
string
Name of the schedule.

timetable
object
Timetable that specifies when a schedule triggers.

attribution-actor
string
Enum: "current" "system"
The attribution-actor of the scheduled pipeline.

parameters
object
Pipeline parameters represented as key-value pairs. Must contain branch or tag.

Responses
200
A schedule object.

default
Error response.


patch
/schedule/{schedule-id}
Request samples
PayloadNode + RequestPython + Python3Go + NativeShell + Curl
Content type
application/json

Copy
Expand allCollapse all
{
"description": "string",
"name": "string",
"timetable": {
"per-hour": 0,
"hours-of-day": [],
"days-of-week": [],
"days-of-month": [],
"months": []
},
"attribution-actor": "current",
"parameters": {
"deploy_prod": true,
"branch": "feature/design-new-api"
}
}
Response samples
200default
Content type
application/json

Copy
Expand allCollapse all
{
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"timetable": {
"per-hour": 0,
"hours-of-day": [],
"days-of-week": [],
"days-of-month": [],
"months": []
},
"updated-at": "2019-08-24T14:15:22Z",
"name": "string",
"created-at": "2019-08-24T14:15:22Z",
"project-slug": "gh/CircleCI-Public/api-preview-docs",
"parameters": {
"deploy_prod": true,
"branch": "feature/design-new-api"
},
"actor": {
"id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
"login": "string",
"name": "string"
},
"description": "string"
}
Delete a schedule
Not yet available to projects that use GitLab or GitHub App. Deletes the schedule by id.

Authorizations:
api_key_headerbasic_authapi_key_query
path Parameters
schedule-id
required
string <uuid>
The unique ID of the schedule.

Responses
200
A confirmation message.

default
Error response.