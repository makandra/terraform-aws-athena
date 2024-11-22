mock_provider "aws" {}

run "dont_create_resources_without_input" {
  variables {
    query_bucket_name = "test"
  }
  assert {
    condition     = length(local.named_queries.cloudfront) == 0
    error_message = "local.named_queries.cloudfront should have 0 elements, but has ${length(local.named_queries.cloudfront)}"
  }
  assert {
    condition     = length(aws_athena_database.cloudfront) == 0
    error_message = "aws_athena_database.cloudfront should have 0 instances, but has ${length(aws_athena_database.cloudfront)}"
  }
  assert {
    condition     = length(aws_athena_named_query.cloudfront) == 0
    error_message = "aws_athena_named_query.cloudfront should have 0 instances, but has ${length(aws_athena_database.cloudfront)}"
  }
}

run "create_resources_with_correct_input" {
  variables {
    query_bucket_name = "test"
    cloudfront        = "cloudfront-bucket"
  }

  assert {
    condition     = length(local.named_queries.cloudfront) != 0
    error_message = "local.named_queries.cloudfront should not have 0 elements"
  }
  assert {
    condition     = length(aws_athena_database.cloudfront) == 1
    error_message = "aws_athena_database.cloudfront should have 1 instance, but has ${length(aws_athena_database.cloudfront)}"
  }
  assert {
    condition     = length(aws_athena_named_query.cloudfront) != 0
    error_message = "aws_athena_named_query.cloudfront should not have 0 element"
  }
}
