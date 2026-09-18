# AWS Certificate Manager (ACM) SSL/TLS Certificate Configuration
# This configuration:
# - Creates certificate for micronomy.utveckling.init.se and wildcard *.utveckling.init.se
# - Uses DNS validation via Route53 automatically
# - Validates in production after deployment

data "aws_route53_zone" "init_utveckling" {
  name = "utveckling.init.se"
}

resource "aws_acm_certificate" "micronomy_certificate" {
  domain_name               = "micronomy.utveckling.init.se"
  subject_alternative_names = ["micronomy.utveckling.init.se"]
  validation_method         = "DNS"
}


# DNS Validation Records Configuration
# These records are validated before certificate is issued
resource "aws_route53_record" "micronomy_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.micronomy_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.init_utveckling.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.micronomy_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.micronomy_cert_validation : record.fqdn]
}
