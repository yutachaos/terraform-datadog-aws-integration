
provider "datadog" {
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = var.default_tags
  }
}


data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


locals {
  datadog_account_id = "464622532012"
}



# Datadog IAM configuration - Dynamic policy creation from JSON

# Load and process Datadog policy JSON
locals {
  datadog_policy_chunk_size = var.datadog_policy_chunk_size
  datadog_policy_data = jsondecode(data.http.datadog_policy_data.response_body)
  datadog_permissions = local.datadog_policy_data.data.attributes.permissions

  permissions_chunks = [
    for i in range(0, length(local.datadog_permissions), local.datadog_policy_chunk_size) :
    slice(local.datadog_permissions, i, min(i + local.datadog_policy_chunk_size, length(local.datadog_permissions)))
  ]
}

data "http" "datadog_policy_data" {
  method = "GET"
  url    = "https://api.datadoghq.com/api/v2/integration/aws/iam_permissions"
}

# Datadog IAM Role
resource "aws_iam_role" "datadog_integration_iam_role" {
  name = var.datadog_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${local.datadog_account_id}:root"
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = datadog_integration_aws_account.integration.auth_config.aws_auth_config_role.external_id
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "datadog_integration_policy" {
  count  = length(data.aws_iam_policy_document.datadog_integration_policy)
  name_prefix   = "${var.datadog_policy_name_prefix}-${count.index + 1}"
  policy = data.aws_iam_policy_document.datadog_integration_policy[count.index].json
}

data "aws_iam_policy_document" "datadog_integration_policy" {
  count   = length(local.permissions_chunks)
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = local.permissions_chunks[count.index]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "datadog_integration_policy" {
  count      = length(aws_iam_policy.datadog_integration_policy)
  role       = aws_iam_role.datadog_integration_iam_role.name
  policy_arn = aws_iam_policy.datadog_integration_policy[count.index].arn
}


resource "datadog_integration_aws_account" "integration" {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_partition  = var.aws_partition
  
  aws_regions {
    include_all    = var.include_all_regions && length(var.include_only_regions) == 0
    include_only   = length(var.include_only_regions) > 0 ? var.include_only_regions : null
    exclude_only   = length(var.exclude_regions) > 0 ? var.exclude_regions : null
  }

  auth_config {
    dynamic "aws_auth_config_keys" {
      for_each = var.access_key_pair_enabled ? [1] : []
      content {
        access_key_id     = var.aws_access_key_id
        secret_access_key = var.aws_secret_access_key
      }
    }
    
    dynamic "aws_auth_config_role" {
      for_each = !var.access_key_pair_enabled ? [1] : []
      content {
        role_name = var.datadog_role_name
      }
    }
  }

  logs_config {
    dynamic "lambda_forwarder" {
      for_each = var.enable_lambda_forwarder ? [1] : []
      content {
        lambdas = var.lambda_forwarder_lambdas
        sources = var.lambda_forwarder_sources
      }
    }
    
    dynamic "logs_archive" {
      for_each = var.enable_logs_archive ? [1] : []
      content {
        bucket                = var.logs_archive_bucket_name
        path_prefix          = var.logs_archive_path_prefix
        account_id           = var.logs_archive_account_id != "" ? var.logs_archive_account_id : null
      }
    }
  }

  metrics_config {
    automute_enabled          = var.automute_enabled
    collect_cloudwatch_alarms = var.collect_cloudwatch_alarms
    collect_custom_metrics    = var.collect_custom_metrics
    enabled                   = var.metrics_collection_enabled

    namespace_filters {
      exclude_only = length(var.namespace_filters_exclude_only) > 0 ? var.namespace_filters_exclude_only : null
      include_only = length(var.namespace_filters_include_only) > 0 ? var.namespace_filters_include_only : null
    }
    
    dynamic "tag_filters" {
      for_each = var.tag_filters
      content {
        namespace = tag_filters.value.namespace
        tags      = tag_filters.value.tags
      }
    }
  }

  account_tags = var.account_tags
  resources_config {
    cloud_security_posture_management_collection = var.cloud_security_posture_management_collection
    extended_collection                          = var.extended_collection
  }

  traces_config {
    xray_services {
      include_all  = var.xray_services_include_all && length(var.xray_services_include_only) == 0
      include_only = length(var.xray_services_include_only) > 0 ? var.xray_services_include_only : null
      exclude_only = length(var.xray_services_exclude_only) > 0 ? var.xray_services_exclude_only : null
    }
  }
}