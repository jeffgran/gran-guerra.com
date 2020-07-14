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

module "website" {
  source              = "git::https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn.git?ref=tags/0.26.0"
  namespace           = local.namespace
  stage               = local.stage
  name                = local.domain_name
  allowed_methods     = ["GET", "HEAD"]
  compress            = true
  website_enabled     = true
  # aliases             = ["gran-guerra.com", "www.gran-guerra.com"]
}
