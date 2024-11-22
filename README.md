# Terraform aws athena

This module creates an athena db, a corresponding query to create a table and some general log queries for each service for which you provide the log bucket name.  
Supported services are CloudFront, CloudTrail and SES.

# Contents

## pre-commit-config.yaml

We rely on [pre-commit](https://pre-commit.com/) hooks to ensure the good code quality. It's also responsible for creating [terraform-docs](https://terraform-docs.io/).

## .github/workflows

We have several default workflows prepared.

### checkov

[checkov](https://www.checkov.io/) scans the terraform manifests for common misconfigurations.

### conventional-commits

We want to enforce [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) to ensure our `semantic-release` works correctly.

### semantic-release

Whenever new commits are merged into the `main` branch we want a new release to be created.

### tflint

Terraform linter for finding possible errors, old syntax, unused declarations etc. Also it enforces best practices. See [tflint](https://github.com/terraform-linters/tflint).

# Recommended Repo configuration

We recommend protecting the `main` branch and to allow new code pushes only via Pull Requests. This way it's ensured that all tests pass before a new release is pushed.
