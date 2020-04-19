variable "region" {
  description = "Chose a region to create required resources. For example us-east-1, eu-central-1 etc."
  type        = "string"
}

variable "profile" {
  type        = "string"
  description = "Please chose a valid profile to communicate to AWS provider."
}

variable "endpoint_configuration_type" {
  description = "Valid values: EDGE, REGIONAL or PRIVATE. If unspecified, defaults to EDGE."
  type        = "string"
}

variable "http_method_type" {
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = "string"
}

variable "apigw_integration_type" {
  description = "The integration input's type. Valid values are HTTP (for HTTP backends), MOCK (not calling any real backend), AWS (for AWS services), AWS_PROXY (for Lambda proxy integration) and HTTP_PROXY (for HTTP proxy integration)."
  type        = "string"
}

variable "integration_connection_type" {
  description = "Valid values are INTERNET (default for connections through the public routable internet), and VPC_LINK (for private connections between API Gateway and a network load balancer in a VPC)."
  type        = "string"
}

variable "api_gw_name" {
  description = "Chose a meaningful name of the API to create."
  type        = "string"
}

variable "stage_name" {
  description = "Chose a valid stage name e.g. test, uat, preprod or prod."
  type        = "string"
}

variable "api_path_part" {
  description = "Chose an API path part, usually after first / in hirerachy e.g. would be /proxy in this case"
  type        = "string"
}

variable "vpc_link_name" {
  description = "Name of VPC Link associated with network load balancer"
  type        = "string"
}

variable "lambda_func_arn" {
  description = "Update name of lambda function ARN if not VPC Link"
  type        = "string"
}

variable "nlb_arn" {
  type        = "string"
  description = "Network load balancer ARN, must be created before using for VPC Link in API gateway"
}

variable "domain_name" {
  description = "Custom domain name."
  type        = "string"
}

variable "certificate_arn" {
  description = "ACM certificate ARN."
  type        = "string"
}

variable "security_policy" {
  description = "The Transport Layer Security (TLS) version. The valid values are TLS_1_0 and TLS_1_2."
  type        = "string"
}
