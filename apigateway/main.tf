locals {
  url = "${var.apigw_integration_type == "HTTP" || var.apigw_integration_type == "HTTP_PROXY" ? "https://${var.domain_name}/${aws_api_gateway_rest_api.restapi_api_gw.name}" : "${var.lambda_func_arn}"}"
}

resource "aws_api_gateway_rest_api" "restapi_api_gw" {
  name = "${var.api_gw_name}"
  description = "Managed By Terraform"
  endpoint_configuration {
    types = ["${var.endpoint_configuration_type}"]
  }
}

resource "aws_api_gateway_vpc_link" "restapi_vpc_link" {
  count       = "${var.integration_connection_type == "VPC_LINK" ? 1 : 0}"
  name        = "${var.vpc_link_name}"
  description = "Managed by Terraform"
  target_arns = ["${var.nlb_arn}"]
}

resource "aws_api_gateway_resource" "restapi_api_gw_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  parent_id   = "${aws_api_gateway_rest_api.restapi_api_gw.root_resource_id}"
  path_part   = "${var.api_path_part}"
}

resource "aws_api_gateway_method" "restapi_api_gw_method_post" {
  rest_api_id   = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  resource_id   = "${aws_api_gateway_resource.restapi_api_gw_resource.id}"
  http_method   = "${var.http_method_type}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "restapi_integration" {
  count                   = "${var.integration_connection_type == "VPC_LINK" && (var.apigw_integration_type == "HTTP" || var.apigw_integration_type == "HTTP_PROXY") ? 1 : 0}"
  rest_api_id             = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  resource_id             = "${aws_api_gateway_resource.restapi_api_gw_resource.id}"
  http_method             = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  type                    = "${var.apigw_integration_type}"
  integration_http_method = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"
  uri                     = "${local.url}"
  connection_type         = "${var.integration_connection_type}"
  connection_id           = "${element(aws_api_gateway_vpc_link.restapi_vpc_link.*.id, count.index)}"
}

resource "aws_api_gateway_integration" "restapi_integration_http" {
  count                   = "${var.integration_connection_type != "VPC_LINK" && (var.apigw_integration_type == "HTTP" || var.apigw_integration_type == "HTTP_PROXY") ? 1 : 0}"
  rest_api_id             = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  resource_id             = "${aws_api_gateway_resource.restapi_api_gw_resource.id}"
  http_method             = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  type                    = "${var.apigw_integration_type}"
  integration_http_method = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"
  uri                     = "${local.url}"
}

resource "aws_api_gateway_integration" "restapi_integration_lambda" {
  count                   = "${var.apigw_integration_type == "AWS_PROXY" || var.apigw_integration_type == "AWS" ? 1 : 0}"
  rest_api_id             = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  resource_id             = "${aws_api_gateway_resource.restapi_api_gw_resource.id}"
  http_method             = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  type                    = "${var.apigw_integration_type}"
  integration_http_method = "POST"
  uri                     = "${local.url}"
}

resource "aws_api_gateway_integration" "restapi_integration_mock" {
  count       = "${var.apigw_integration_type == "MOCK" ? 1 : 0}"
  rest_api_id = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  resource_id = "${aws_api_gateway_resource.restapi_api_gw_resource.id}"
  http_method = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  type        = "${var.apigw_integration_type}"
}

resource "aws_api_gateway_method_response" "restapi_api_gw_method_response" {
  rest_api_id = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  resource_id = "${aws_api_gateway_resource.restapi_api_gw_resource.id}"
  http_method = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  status_code = 200
}

resource "aws_api_gateway_integration_response" "restapi_integration_response" {
  depends_on = ["aws_api_gateway_integration.restapi_integration", "aws_api_gateway_integration.restapi_integration_lambda", "aws_api_gateway_integration.restapi_integration_mock", "aws_api_gateway_integration.restapi_integration_http"]

  rest_api_id = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  resource_id = "${aws_api_gateway_resource.restapi_api_gw_resource.id}"
  http_method = "${aws_api_gateway_method.restapi_api_gw_method_post.http_method}"
  status_code = "${aws_api_gateway_method_response.restapi_api_gw_method_response.status_code}"

}

resource "aws_api_gateway_deployment" "restapi_api_deployment" {
  depends_on  = ["aws_api_gateway_integration.restapi_integration", "aws_api_gateway_integration.restapi_integration_lambda", "aws_api_gateway_integration.restapi_integration_mock", "aws_api_gateway_integration.restapi_integration_http"]
  rest_api_id = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  stage_name  = "${var.stage_name}"
}

resource "aws_api_gateway_domain_name" "custom-domain" {
  domain_name              = "${var.domain_name}"
  regional_certificate_arn = "${var.certificate_arn}"
  security_policy          = "${var.security_policy}"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "domain_base_path" {
  api_id      = "${aws_api_gateway_rest_api.restapi_api_gw.id}"
  domain_name = "${aws_api_gateway_domain_name.custom-domain.domain_name}"
  stage_name  = "${aws_api_gateway_deployment.restapi_api_deployment.stage_name}"
}
