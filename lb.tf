resource aws_lb okta {
  internal                    = false
  security_groups             = [aws_security_group.okta.id]
  subnets                     = var.vpc_public_subnets
  enable_deletion_protection  = true

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource aws_lb_target_group okta {
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  slow_start           = var.alb_slow_start
  deregistration_delay = var.alb_deregistration_delay

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 2
    path                = var.health_check_path
    port                = var.port
    protocol            = var.health_check_protocol
    interval            = 5
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource aws_security_group okta {
  description  = "Allow only whitelisted ips to access ALB"
  vpc_id       = var.vpc_id

  ingress {
    description = "Additional whitelisted ips (http)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.whitelisted_ips
  }

  ingress {
    description = "Additional whitelisted ips (https)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.whitelisted_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource aws_alb_listener okta_443 {
  load_balancer_arn = aws_lb.okta.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "It works!"
      status_code  = "200"
    }
  }
}

resource aws_alb_listener okta_80 {
  load_balancer_arn = aws_lb.okta.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "It works!"
      status_code  = "200"
    }
  }
}

resource aws_lb_listener_rule okta_443 {
  listener_arn = aws_alb_listener.okta_443.arn

  condition {
    host_header {
      values = [aws_route53_record.okta.name]
    }
  }

  action {
    type = "authenticate-oidc"

    authenticate_oidc {
      authorization_endpoint  = var.oidc_authorization_endpoint
      client_id               = var.oidc_client_id
      client_secret           = var.oidc_client_secret
      issuer                  = var.oidc_issuer
      token_endpoint          = var.oidc_token_endpoint
      user_info_endpoint      = var.oidc_user_info_endpoint

      scope                      = "openid profile"
      session_cookie_name        = "AWSELBAuthSessionCookie"
      session_timeout            = var.oidc_session_timeout
      on_unauthenticated_request = "authenticate"
    }
   }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.okta.arn
  }
}

resource aws_lb_listener_rule okta_80 {
  listener_arn = aws_alb_listener.okta_80.arn

  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
