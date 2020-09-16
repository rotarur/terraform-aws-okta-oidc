# terraform-aws-okta-oidc

Terraform module AWS ALB Built-in OIDC Authentication for Okta

## Description

This module was created by using this [AWS Documentation](https://aws.amazon.com/blogs/aws/built-in-authentication-in-alb/) and this [article](https://www.shreyasmm.com/securing-web-applications-with-aws-elb-and-okta).

## Example

```
source   = "rotarur/terraform-aws-okta-oidc"
version  = "v1.0.0"

route53_zone_id               = var.aws_route53_zone_id
route53_record_name           = "example.${var.aws_route53_zone_name}"
port                          = 1234
vpc_id                        = var.vpc_id
health_check_path             = "/"
whitelisted_ips               = var.alb_whitelisted_ips
vpc_public_subnets            = [subnet-123]
certificate_arn               = var.aws_acm_certificate_arn
oidc_client_id                = var.client_id
oidc_client_secret            = var.client_secret
oidc_issuer                   = "https://example.okta-emea.com/oauth2/default"
oidc_token_endpoint           = "https://example.okta-emea.com/oauth2/default/v1/token"
oidc_user_info_endpoint       = "https://example.okta-emea.com/oauth2/default/v1/userinfo"
oidc_authorization_endpoint   = "https://example.okta-emea.com/oauth2/default/v1/authorize"

tags = merge(
   {"service_name" = "okta"},
   var.tags,
)
```

## AWS ALB Target Provisioning

This module will only create the ALB for you without any target associated. If you want to your targets to auto-provision themselves you need to use the output from this module `alb_target_group_arn` and add it to your autoscaling code, see [terraform aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#target_group_arns)

## Okta Application

In order to configure your Okta application for this ALB you'll need only the R53 record created by this module and use this [Okta Documentation](https://developer.okta.com/docs/guides/sign-into-web-app/aspnet/create-okta-application/).

You can also create it in [Okta Sandbox Environmnet](https://www.okta.com/resources/datasheet-oktas-preview-sandbox/) before going to production, to test the integration.

## Recomendation

Save your `client_id` and `client_secret` in a vault or AWS SSM storge and use terraform to get those values.

## Inputs

| Variable | Description | Type | Default | Required |
|---|---|---|---|---|
| route53_zone_id | AWS Route53 Zone ID to create the entry | string | - | Yes |
| route53_record_name | AWS Route53 record name | string | - | Yes |
| evaluate_target_health | AWS Route53 Evaluate Target flag | bool | - | No |
| port | Instance port | string | - | Yes |
| vpc_id  | VPC ID to place AWS ALB | string | - | Yes |
| alb_slow_start | AWS ALB Slow Start flag | string | `120` | No |
| health_check_path | AWS ALB Health Check Path | string | - | Yes |
| health_check_protocol | AWS ALB Health Check Protocol | string | `HTTP` | No |
| alb_deregistration_delay | AWS ALB Deregistration Delay flag | string | `30` | No |
| tags | A mapping of tags to assign to the resource | map(string) | - | Yes |
| whitelisted_ips | List of whitelisted ips to be added to security group | list(string) | - | Yes |
| vpc_public_subnets | A mapping with VPC public subnets | list(string) | - | Yes |
| certificate_arn | Certificate ARN to assign to ALB listener | string | - | Yes |
| oidc_client_id | OIDC Client ID from Okta application | string | - | Yes |
| oidc_client_secret | OIDC client secret from Okta application | string | - | Yes |
| oidc_issuer | OIDC issuer from Okta application | string | - | Yes |
| oidc_token_endpoint | OIDC token endpoint from Okta application | string | - | Yes |
| oidc_user_info_endpoint | OIDC user info endpoint from Okta application | string | - | Yes |
| oidc_authorization_endpoint | Authorization endpoint from Okta application | string | - | Yes |
| oidc_session_timeout | OIDC session timeout | string | `300` | No |

## Outputs

| Variable | Description |
|---|---|
| alb_target_group_arn | AWS ALB Target Group ARN |
