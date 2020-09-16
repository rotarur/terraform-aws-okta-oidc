output alb_target_group_arn {
  description = "ALB Target Group ARN"
  value       = aws_lb_target_group.okta.arn
}
