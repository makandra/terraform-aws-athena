mock_provider "aws" {}

run "dont_create_resources_without_input" {
  variables {
    query_bucket_name = "test"
  }
  assert {
    condition     = length(local.named_queries.cloudtrail) == 0
    error_message = "local.named_queries.cloudtrail should have 0 elements, but has ${length(local.named_queries.cloudtrail)}"
  }
  assert {
    condition     = length(aws_athena_database.cloudtrail) == 0
    error_message = "aws_athena_database.cloudtrail should have 0 instances, but has ${length(aws_athena_database.cloudtrail)}"
  }
  assert {
    condition     = length(aws_athena_named_query.cloudtrail) == 0
    error_message = "aws_athena_named_query.cloudtrail should have 0 instances, but has ${length(aws_athena_database.cloudtrail)}"
  }
}

run "create_resources_with_correct_input" {
  variables {
    query_bucket_name = "test"
    cloudtrail = {
      bucket_name = "cloudtrail-bucket"
    }
  }

  assert {
    condition     = length(local.named_queries.cloudtrail) != 0
    error_message = "local.named_queries.cloudtrail should not have 0 elements"
  }
  assert {
    condition     = length(aws_athena_database.cloudtrail) == 1
    error_message = "aws_athena_database.cloudtrail should have 1 instance, but has ${length(aws_athena_database.cloudtrail)}"
  }
  assert {
    condition     = length(aws_athena_named_query.cloudtrail) != 0
    error_message = "aws_athena_named_query.cloudtrail should not have 0 element"
  }
}
