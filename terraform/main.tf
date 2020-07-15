terraform {
  backend "s3" {
    bucket = "jeffgran-terraform-remote-state"
    key    = "gran-guerra.com/state.tfstate"
    region = "us-west-1"
  }
}

locals {
  domain_name = "gran-guerra.com"
  namespace   = "jg"
  stage       = "production"
}

provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

resource "aws_route53_zone" "gran-guerra-com" {
  name = local.domain_name
}

module "website" {
  source              = "git::https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn.git?ref=tags/0.26.0"
  namespace           = local.namespace
  stage               = local.stage
  name                = local.domain_name
  allowed_methods     = ["GET", "HEAD"]
  compress            = true
  website_enabled     = true
  parent_zone_id      = aws_route53_zone.gran-guerra-com.zone_id
  acm_certificate_arn = module.cert.arn
  aliases             = ["gran-guerra.com", "www.gran-guerra.com"]
}

module "cert" {
  source                            = "git::https://github.com/cloudposse/terraform-aws-acm-request-certificate.git?ref=tags/0.4.0"
  domain_name                       = local.domain_name
  process_domain_validation_options = true
  subject_alternative_names         = ["*.${local.domain_name}"]
  wait_for_certificate_issued       = true

  providers = {
    aws = aws.use1 # this must be created in us-east-1 in order for this to work right so we have to "hack" the provider like this
  }
}
