# AWS Configuration
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "default_tags" {
  description = "Default tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}

# Datadog Configuration
variable "datadog_role_name" {
  description = "Name of the IAM role for Datadog integration"
  type        = string
  default     = "DatadogAWSIntegrationRole"
}

variable "datadog_policy_name_prefix" {
  description = "Prefix for Datadog IAM policy names"
  type        = string
  default     = "DataDogAWSIntegrationPolicy"
}

variable "datadog_policy_chunk_size" {
  description = "Number of permissions per IAM policy (AWS has limits on policy size)"
  type        = number
  default     = 150
}

# AWS Account Configuration
variable "aws_partition" {
  description = "AWS partition (e.g., aws, aws-us-gov)"
  type        = string
  default     = "aws"
}

# Auth Configuration
variable "access_key_pair_enabled" {
  description = "Enable access key pair authentication (alternative to role-based auth)"
  type        = bool
  default     = false
}

variable "aws_access_key_id" {
  description = "AWS access key ID (when using access key pair authentication)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS secret access key (when using access key pair authentication)"
  type        = string
  default     = ""
  sensitive   = true
}

# Datadog Integration Settings
variable "include_all_regions" {
  description = "Whether to include all AWS regions in Datadog monitoring"
  type        = bool
  default     = true
}

variable "include_only_regions" {
  description = "List of AWS regions to include (mutually exclusive with include_all_regions)"
  type        = list(string)
  default     = []
}

variable "exclude_regions" {
  description = "List of AWS regions to exclude from monitoring"
  type        = list(string)
  default     = []
}

variable "automute_enabled" {
  description = "Enable auto-muting of Datadog monitors based on AWS host status"
  type        = bool
  default     = true
}

variable "collect_cloudwatch_alarms" {
  description = "Enable collection of CloudWatch alarms"
  type        = bool
  default     = true
}

variable "collect_custom_metrics" {
  description = "Enable collection of custom metrics"
  type        = bool
  default     = true
}

variable "metrics_collection_enabled" {
  description = "Enable metrics collection"
  type        = bool
  default     = true
}

variable "namespace_filters_exclude_only" {
  description = "List of AWS namespaces to exclude from metrics collection"
  type        = list(string)
  default     = []
}

variable "namespace_filters_include_only" {
  description = "List of AWS namespaces to include (mutually exclusive with exclude_only)"
  type        = list(string)
  default     = []
}

variable "tag_filters" {
  description = "Map of tag filters for metrics collection"
  type = list(object({
    namespace = string
    tags      = list(string)
  }))
  default = []
}

variable "account_tags" {
  description = "Tags to apply to the Datadog AWS account integration"
  type        = list(string)
  default     = []
}

# Security and Compliance
variable "cloud_security_posture_management_collection" {
  description = "Enable Cloud Security Posture Management collection"
  type        = bool
  default     = true
}

variable "extended_collection" {
  description = "Enable extended resource collection"
  type        = bool
  default     = true
}

# X-Ray Tracing
variable "xray_services_include_all" {
  description = "Include all services for X-Ray tracing"
  type        = bool
  default     = true
}

variable "xray_services_include_only" {
  description = "List of specific services to include for X-Ray tracing"
  type        = list(string)
  default     = []
}

variable "xray_services_exclude_only" {
  description = "List of services to exclude from X-Ray tracing"
  type        = list(string)
  default     = []
}

# Lambda Forwarder Configuration
variable "enable_lambda_forwarder" {
  description = "Enable Lambda forwarder for log collection"
  type        = bool
  default     = true
}

variable "lambda_forwarder_lambdas" {
  description = "List of Lambda function ARNs for log forwarding"
  type        = list(string)
  default     = []
}

variable "lambda_forwarder_sources" {
  description = "List of log sources for Lambda forwarder (e.g., s3, cloudtrail, etc.)"
  type        = list(string)
  default     = []
}

# Logs Archive Configuration  
variable "enable_logs_archive" {
  description = "Enable logs archive configuration"
  type        = bool
  default     = false
}

variable "logs_archive_bucket_name" {
  description = "S3 bucket name for logs archive"
  type        = string
  default     = ""
}

variable "logs_archive_path_prefix" {
  description = "S3 path prefix for logs archive"
  type        = string
  default     = ""
}

variable "logs_archive_account_id" {
  description = "AWS account ID for logs archive (if different from main account)"
  type        = string
  default     = ""
}
