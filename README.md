# Terraform Datadog AWS Integration Module

This Terraform module creates and configures the necessary AWS resources for Datadog AWS integration, including IAM roles, policies, and the Datadog integration configuration.

## Features

- Creates IAM role and policies for Datadog AWS integration
- Configures Datadog AWS account integration
- Supports metrics, logs, and traces collection
- Configurable namespace filtering
- Cloud Security Posture Management (CSPM) support
- X-Ray tracing integration

## Usage

```hcl
module "datadog_aws_integration" {
  source = "github.com/yutachaos/terraform-datadog-aws-integration"

  # AWS Configuration
  aws_region = "us-east-1"
  default_tags = {
    Environment = "production"
    Project     = "my-project"
  }

  # Datadog Configuration
  datadog_role_name = "DatadogIntegrationRole"

  # Region Configuration (choose one approach)
  include_all_regions = false
  include_only_regions = ["us-east-1", "us-west-2"]
  # exclude_regions = ["eu-west-1", "ap-southeast-1"]

  # Integration Settings
  collect_cloudwatch_alarms = true
  collect_custom_metrics    = true
  
  # Namespace filtering (choose one approach)
  namespace_filters_exclude_only = [
    "AWS/ElasticMapReduce",
    "AWS/AppRunner"
  ]
  # namespace_filters_include_only = ["AWS/EC2", "AWS/RDS"]

  # Tag-based filtering
  tag_filters = [
    {
      namespace = "AWS/EC2"
      tags      = ["Environment:production", "Team:platform"]
    }
  ]

  # Account tags
  account_tags = [
    "env:production",
    "team:platform"
  ]

  # Lambda Forwarder for logs
  enable_lambda_forwarder = true
  lambda_forwarder_lambdas = [
    "arn:aws:lambda:us-east-1:123456789012:function:datadog-forwarder"
  ]
  lambda_forwarder_sources = [
    "s3",
    "cloudtrail"
  ]

  # Logs Archive (optional)
  enable_logs_archive = true
  logs_archive_bucket_name = "my-datadog-logs-archive"
  logs_archive_path_prefix = "datadog-logs/"

  # X-Ray Configuration (choose one approach)
  xray_services_include_all = false
  xray_services_include_only = ["lambda", "api-gateway"]
  # xray_services_exclude_only = ["ecs", "fargate"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.2 |
| aws | ~> 6.2.0 |
| datadog | ~> 3.66.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 6.2.0 |
| datadog | ~> 3.66.0 |
| http | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region for resources | `string` | `"us-east-1"` | no |
| default_tags | Default tags to apply to all AWS resources | `map(string)` | `{}` | no |
| datadog_role_name | Name of the IAM role for Datadog integration | `string` | `"DatadogAWSIntegrationRole"` | no |
| datadog_policy_name_prefix | Prefix for Datadog IAM policy names | `string` | `"DataDogAWSIntegrationPolicy"` | no |
| datadog_policy_chunk_size | Number of permissions per IAM policy | `number` | `150` | no |
| aws_partition | AWS partition (e.g., aws, aws-us-gov) | `string` | `"aws"` | no |
| access_key_pair_enabled | Enable access key pair authentication | `bool` | `false` | no |
| aws_access_key_id | AWS access key ID (when using access key pair auth) | `string` | `""` | no |
| aws_secret_access_key | AWS secret access key (when using access key pair auth) | `string` | `""` | no |
| include_all_regions | Whether to include all AWS regions in monitoring | `bool` | `true` | no |
| include_only_regions | List of AWS regions to include | `list(string)` | `[]` | no |
| exclude_regions | List of AWS regions to exclude | `list(string)` | `[]` | no |
| automute_enabled | Enable auto-muting of Datadog monitors based on AWS host status | `bool` | `true` | no |
| collect_cloudwatch_alarms | Enable collection of CloudWatch alarms | `bool` | `true` | no |
| collect_custom_metrics | Enable collection of custom metrics | `bool` | `true` | no |
| metrics_collection_enabled | Enable metrics collection | `bool` | `true` | no |
| namespace_filters_exclude_only | List of AWS namespaces to exclude | `list(string)` | `[]` | no |
| namespace_filters_include_only | List of AWS namespaces to include | `list(string)` | `[]` | no |
| tag_filters | Tag filters for metrics collection | `list(object)` | `[]` | no |
| account_tags | Tags to apply to the Datadog AWS account integration | `list(string)` | `[]` | no |
| cloud_security_posture_management_collection | Enable Cloud Security Posture Management collection | `bool` | `true` | no |
| extended_collection | Enable extended resource collection | `bool` | `true` | no |
| enable_lambda_forwarder | Enable Lambda forwarder for log collection | `bool` | `true` | no |
| lambda_forwarder_lambdas | List of Lambda function ARNs for log forwarding | `list(string)` | `[]` | no |
| lambda_forwarder_sources | List of log sources for Lambda forwarder | `list(string)` | `[]` | no |
| enable_logs_archive | Enable logs archive configuration | `bool` | `false` | no |
| logs_archive_bucket_name | S3 bucket name for logs archive | `string` | `""` | no |
| logs_archive_path_prefix | S3 path prefix for logs archive | `string` | `""` | no |
| logs_archive_account_id | AWS account ID for logs archive | `string` | `""` | no |
| xray_services_include_all | Include all services for X-Ray tracing | `bool` | `true` | no |
| xray_services_include_only | List of specific services to include for X-Ray | `list(string)` | `[]` | no |
| xray_services_exclude_only | List of services to exclude from X-Ray | `list(string)` | `[]` | no |

## Examples

See the [examples](./examples/) directory for complete usage examples.

## License

This module is licensed under the terms specified in the [LICENSE](LICENSE) file.
