resource aws_route53_record okta {
  zone_id = var.route53_zone_id
  name    = var.route53_record_name
  type    = "A"

  alias {
    name                   = aws_lb.okta.dns_name
    zone_id                = aws_lb.okta.zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
