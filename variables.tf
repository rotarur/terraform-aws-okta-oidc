variable route53_zone_id {
  description = "AWS Route53 Zone ID to create the entry"
  type        = string
}

variable route53_record_name {
  description = "AWS Route53 record name"
  type        = string
}

variable evaluate_target_health {
  description = "AWS Route53 Evaluate Target flag"
  type        = bool
  default     = false
}

variable port {
  description = "Instance port"
  type        = string
}

variable vpc_id {
  description = "VPC ID to place AWS ALB"
  type        = string
}

variable alb_slow_start {
  description = "AWS ALB Slow Start flag"
  default     = 120
}

variable health_check_path {
  description = "AWS ALB Health Check Path"
}

variable health_check_protocol {
  description = "AWS ALB Health Check protocol"
  default     = "HTTP"
}

variable alb_deregistration_delay {
  description = "AWS ALB Deregistration Delay flag"
  default     = 30
}

variable tags {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
}

variable whitelisted_ips {
  description = "List of whitelisted ips to be added to security group"
  type        = list(string)
}

variable vpc_public_subnets {
  description = "A mapping with VPC public subnets"
  type        = list(string)
}

variable certificate_arn {
  description = "Certificate ARN to assign to ALB listener"
  type        = string
}

variable oidc_authorization_endpoint {
  description = "Authorization endpoint from Okta application"
  type        = string
}

variable oidc_client_id {
  description = "OIDC Client ID from Okta application"
  type        = string
}

variable oidc_client_secret {
  description = "OIDC client secret from Okta application"
  type        = string
}

variable oidc_issuer {
  description = "OIDC issuer from Okta application"
  type        = string
}

variable oidc_token_endpoint {
  description = "OIDC token endpoint from Okta application"
  type        = string
}

variable oidc_user_info_endpoint {
  description = "OIDC user info endpoint from Okta application"
  type        = string
}

variable oidc_session_timeout {
   description = "OIDC session timeout"
   default     = 300
}
