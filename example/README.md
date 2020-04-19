## Use of module in code

```
module "apigateway" {
  source                      = "../apigateway"
  profile                     = "<Name of the profile>"
  region                      = "us-east-2"
  endpoint_configuration_type = "REGIONAL"
  http_method_type            = "GET"
  apigw_integration_type      = "HTTP"
  integration_connection_type = "VPC_LINK"
  api_gw_name                 = "test-tf-APIGW"
  stage_name                  = "apistage"
  api_path_part               = "proxy"
  vpc_link_name               = "vpclink-apigw-test-nlb"
  lambda_func_arn             = "<lambda function arn>"
  nlb_arn                     = "<network load balancer ARN>"
  domain_name                 = "abcd.example.xyz"
  certificate_arn             = "<certificate arn>"
  security_policy             = "TLS_1_2"
}
```

## For storing the state file in S3 backend. Create a bucket prior and update values in [s3-state.tf] accordingly.


  ```bash
  # Initialize Terraform
  terraform init

  # Check to make sure script will do what you think it will do.
  terraform plan

  # Apply changes
  terraform apply
  ```
