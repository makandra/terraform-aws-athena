locals {
  named_queries = {
    cloudfront = var.cloudfront != null ? {
      cloudfront_create_log_table               = "Create the table for CloudFront logs",
      cloudfront_log_yesterday_today            = "Show requests to CloudFront yesterday and today",
      cloudfront_log_yesterday_today_for_ip     = "Show requests to CloudFront from a given IP yesterday and today"
      cloudfront_logs_for_specific_distribution = "Shows requests to a given cloudfront distribution, with optional filter for date, status code or ssl_protocol"
    } : {}
    cloudtrail = var.cloudtrail.bucket_name != null ? {
      cloudtrail_create_log_table = "Create the table for CloudTrail logs",
      cloudtrail_console_login    = "Displays console login events, ordered by date"
    } : {}
    ses = var.ses != null ? {
      ses_create_log_table             = "Create the table for SES logs"
      ses_bounce_ratio                 = "Displays bounced email as % of send emails"
      ses_formatted_mails              = "Displays only the most relevant information per email, optional filter for event type"
      ses_daily_not_suppressed_bounces = "Displays amount of bounced emails per day, filtering out bounces caused by addresses being on the suppression list"
    } : {}
  }

}

data "aws_caller_identity" "current" {}

resource "aws_athena_database" "cloudfront" {
  count = var.cloudfront != null ? 1 : 0

  name   = "cloudfront"
  bucket = var.query_bucket_name
  encryption_configuration {
    encryption_option = "SSE_S3"
  }
}

resource "aws_athena_database" "cloudtrail" {
  count = var.cloudtrail.bucket_name != null ? 1 : 0

  name   = "cloudtrail"
  bucket = var.query_bucket_name
  encryption_configuration {
    encryption_option = "SSE_S3"
  }
}

resource "aws_athena_database" "ses" {
  count = var.ses != null ? 1 : 0

  name   = "ses"
  bucket = var.query_bucket_name
  encryption_configuration {
    encryption_option = "SSE_S3"
  }
}

resource "aws_athena_named_query" "cloudfront" {
  for_each    = local.named_queries.cloudfront
  name        = replace(each.key, "_", "-")
  database    = aws_athena_database.cloudfront[0].name
  description = each.value
  query = templatefile("${path.module}/queries/${each.key}.sql.tftpl",
    {
      "bucket"  = var.cloudfront,
      "account" = data.aws_caller_identity.current.account_id,
    }
  )
}

resource "aws_athena_named_query" "cloudtrail" {
  for_each    = local.named_queries.cloudtrail
  name        = replace(each.key, "_", "-")
  database    = aws_athena_database.cloudtrail[0].name
  description = each.value
  query = templatefile("${path.module}/queries/${each.key}.sql.tftpl",
    {
      "bucket"  = var.cloudtrail.bucket_name,
      "account" = data.aws_caller_identity.current.account_id,
      "prefix"  = var.cloudtrail.prefix != null ? "${var.cloudtrail.prefix}/" : ""
    }
  )
}

resource "aws_athena_named_query" "ses" {
  for_each    = local.named_queries.ses
  name        = replace(each.key, "_", "-")
  database    = aws_athena_database.ses[0].name
  description = each.value
  query = templatefile("${path.module}/queries/${each.key}.sql.tftpl",
    {
      "bucket"  = var.ses,
      "account" = data.aws_caller_identity.current.account_id,
    }
  )
}
