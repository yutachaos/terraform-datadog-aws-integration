# Example usage of the Datadog AWS Integration module

# Basic usage with default values
module "datadog_aws_integration" {
  source = "../../"

  # AWS Configuration
  aws_region = "us-east-1"
  default_tags = {
    Environment = "production"
    Project     = "my-project"
  }

  # Datadog Configuration
  datadog_role_name = "DatadogIntegrationRole"

  # Integration Settings
  collect_cloudwatch_alarms = true
  collect_custom_metrics    = true
  
  # Exclude specific namespaces
  namespace_filters_exclude_only = [
    "AWS/ElasticMapReduce",
    "AWS/AppRunner",
    "AWS/Batch"
  ]

  # Account tags
  account_tags = [
    "env:production",
    "team:platform"
  ]

  # Lambda Forwarder (optional)
  enable_lambda_forwarder = true
  lambda_forwarder_lambdas = [
    "arn:aws:lambda:us-east-1:123456789012:function:datadog-forwarder"
  ]
  lambda_forwarder_sources = [
    "s3",
    "cloudtrail"
  ]
}
