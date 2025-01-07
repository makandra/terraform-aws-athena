# Terraform aws athena

This module creates an athena db, a corresponding query to create a table and some general log queries for each service for which you provide the log bucket name.  
Supported services are CloudFront, CloudTrail and SES.

# Contents

## queries

This contains templates for the individual athena queries

### [cloudfront_create_log_table.sql.tftpl](queries/cloudfront_create_log_table.sql.tftpl)

This query creates the table `cloudfront_logs` if it doesn't already exist. This table is used by all other cloudfront queries.

### [cloudfront_log_yesterday_today.sql.tftpl](queries/cloudfront_log_yesterday_today.sql.tftpl)

This displays all logs from yesterday and today, with a reduced set of columns.

### [cloudfront_log_yesterday_today_for_ip.sql.tftpl](queries/cloudfront_log_yesterday_today_for_ip.sql.tftpl)

This displays all logs from yesterday and today for a single given request IP, with a reduced set of columns.

### [cloudfront_logs_for_specific_distribution.sql.tftpl](queries/cloudfront_logs_for_specific_distribution.sql.tftpl)

This displays all logs from a specific cloudfront distribution that you can identify by it's domain name.  
Some possible filter parameter are added as comments.

### [cloudtrail_create_log_table.sql.tftpl](queries/cloudtrail_create_log_table.sql.tftpl)

This query creates the table `cloudtrail_logs` if it doesn't already exist. This table is used by all other cloudtrail queries.

### [cloudtrail_console_login.sql.tftpl](queries/cloudtrail_console_login.sql.tftpl)

This displays all logs for Console Login events, ordered by date.

### [ses_create_log_table.sql.tftpl](queries/ses_create_log_table.sql.tftpl)

This query creates the table `ses_logs` if it doesn't already exist. This table is used by all other ses queries.

### [ses_daily_bounced_and_send_mails.sql.tftpl](queries/ses_daily_bounced_and_send_mails.sql.tftpl)

This displays the number of non-supressed bounced and send emails for each day. Logging `send` and `bounced` events is required for this, if only one or neither is logged this will not display anything.  
It excludes mails send to addresses on one of the suppression lists, since such emails are not counted for your ses bounce ratio metric.


### [ses_daily_not_suppressed_bounces.sql.tftpl](queries/ses_daily_not_suppressed_bounces.sql.tftpl)

This displays the amount of non-suppresed bounced emails for each day.

### [queries/ses_daily_not_suppressed_bounces.sql.tftpl](queries/ses_daily_not_suppressed_bounces.sql.tftpl)

This displays timestamp, source, destination and diagnosticcode for each bounced email.


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
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.55.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.55.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_athena_database.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_athena_database.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_athena_database.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_athena_named_query.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_named_query.cloudtrail](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_named_query.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudfront"></a> [cloudfront](#input\_cloudfront) | The name of the s3 bucket containing the cloudfront logs. Creates a db and saved cloudfront queries if set. | `string` | `null` | no |
| <a name="input_cloudtrail"></a> [cloudtrail](#input\_cloudtrail) | Configuration for cloudtrail. Creates a db and saved cloudfront queries if bucket\_name is set. Only set prefix if you configured one in your cloudtrail | <pre>object({<br/>    bucket_name = string<br/>    prefix      = optional(string)<br/>  })</pre> | <pre>{<br/>  "bucket_name": null<br/>}</pre> | no |
| <a name="input_query_bucket_name"></a> [query\_bucket\_name](#input\_query\_bucket\_name) | The name of the bucket to save the query into. | `string` | n/a | yes |
| <a name="input_ses"></a> [ses](#input\_ses) | The name of the s3 bucket containing the ses logs. Creates a db and saved ses queries if set | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
