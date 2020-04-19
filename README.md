# AWS API Gateway Integration

## API Gateway Use Case

API Gateway is managed AWS service that allows users to create a HTTP/RESTful API that serve as a front door for services such as HTTP Endpoints, Lambda function or other AWS services. This module is created to cover all API integration with different end points as per requirement. This also creates a custom domain names and VPC links.

API Gateway can be deployed using different endpoint types.

This Terraform scripts will perform the following:

1. Create API Gateway with required endpoints whether private using VPC Link OR MOCK OR Lambda using AWS_PROXY etc.
2. Create a resource
3. Creates a requested method
4. Create a `VPC Link` with proxy integration if chosen.
5. Create a deployment stage
6. Create a custom domain name.

### Prerequisites

The following parameters are needed prior to getting started:

* **ARN** of the lambda function in required format to set-up an integration with lambda function. Please refer documentation for exact format.
* **ARN** of the network load balancer - This will be the ARN of the target NLB that is required to create VPC_Link.
* **ARN** of the ACM certificate - This will be the ARN of the certificate that is used to create custom domain.

## How To Use

Modify the values as needed in [variables.tf] to suit your environment if you would like to run apigateway module directly.

*  `region` - Choose AWS region where you would like these resources to be created.
*  `profile` - This is AWS credential profile to talk to AWS accounts with sufficient permissions.
*  `endpoint_configuration_type` - Choose endpoint type.
*  `http_method_type` - The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY).
*  `apigw_integration_type` - The integration input's type e.g. HTTP, HTTP_PROXY, MOCK, AWS or AWS_PROXY.
*  `integration_connection_type` - Valid values are INTERNET (pubic access) OR VPC_LINK (private integration).
*  `api_gw_name` - Name of the API GW to be created.
*  `stage_name` - Name of the stage, API will be deployed.
*  `api_path_part` - The last path segment of this API resource.
*  `vpc_link_name` - Name of the VPC Link created.
*  `lambda_func_arn` - ARN of the lambda function when lambda integration is required.
*  `nlb_arn` - Network load balancer ARN, must be created before using for VPC Link in API gateway.
*  `domain_name` - Custom domain to be created and must be validated against certificate used.
*  `certificate_arn` - ARN of the ACM certificate.
*  `security_policy` - The Transport Layer Security (TLS) version.

