mock_provider "aws" {}

run "dont_create_resources_without_input" {
  variables {
    query_bucket_name = "test"
  }
  assert {
    condition     = length(local.named_queries.ses) == 0
    error_message = "local.named_queries.ses should have 0 elements, but has ${length(local.named_queries.ses)}"
  }
  assert {
    condition     = length(aws_athena_database.ses) == 0
    error_message = "aws_athena_database.ses should have 0 instances, but has ${length(aws_athena_database.ses)}"
  }
  assert {
    condition     = length(aws_athena_named_query.ses) == 0
    error_message = "aws_athena_named_query.ses should have 0 instances, but has ${length(aws_athena_database.ses)}"
  }
}

run "create_resources_with_correct_input" {
  variables {
    query_bucket_name = "test"
    ses               = "ses-bucket"
  }

  assert {
    condition     = length(local.named_queries.ses) != 0
    error_message = "local.named_queries.ses should not have 0 elements"
  }
  assert {
    condition     = length(aws_athena_database.ses) == 1
    error_message = "aws_athena_database.ses should have 1 instance, but has ${length(aws_athena_database.ses)}"
  }
  assert {
    condition     = length(aws_athena_named_query.ses) != 0
    error_message = "aws_athena_named_query.ses should not have 0 element"
  }
}
