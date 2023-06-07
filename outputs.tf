################################################################################
# Cognito user pool
################################################################################

output "arn" {
  description = "ARN of the user pool"
  value       = try(aws_cognito_user_pool.this[0].arn, null)
}

output "endpoint" {
  description = "Endpoint name of the user pool"
  value       = try(aws_cognito_user_pool.this[0].endpoint, null)
}

################################################################################
# Cognito User Pool Domain
################################################################################

output "domain_cloudfront_distribution" {
  description = "The Amazon CloudFront endpoint that you use as the target of the alias that you set up with your Domain Name Service (DNS) provider"
  value       = try(aws_cognito_user_pool_domain.this[0].cloudfront_distribution, null)
}

output "domain_cloudfront_distribution_arn" {
  description = "The URL of the CloudFront distribution. This is required to generate the ALIAS aws_route53_record"
  value       = try(aws_cognito_user_pool_domain.this[0].cloudfront_distribution_arn, null)
}

output "domain_cloudfront_distribution_zone_id" {
  description = "The Route 53 hosted zone ID of the CloudFront distribution"
  value       = try(aws_cognito_user_pool_domain.this[0].cloudfront_distribution_zone_id, null)
}

output "domain_s3_bucket" {
  description = "The S3 bucket where the static files for this domain are stored"
  value       = try(aws_cognito_user_pool_domain.this[0].s3_bucket, null)
}

output "domain_version" {
  description = "The app version"
  value       = try(aws_cognito_user_pool_domain.this[0].version, null)
}

################################################################################
# Cognito User Pool Client
################################################################################

output "user_pool_clients_ids" {
  description = "Map of Cognito User Pool Client names and IDs"
  value = try({
    for client in var.user_pool_clients : client.name =>
    aws_cognito_user_pool_client.this[client.name].id
  }, null)
}

output "user_pool_clients_secrets" {
  description = "Map of Cognito User Pool Client names and secrets"
  value = try({
    for client in var.user_pool_clients : client.name =>
    aws_cognito_user_pool_client.this[client.name].client_secret
  }, null)
  sensitive = true
}

################################################################################
# Cognito Managed User Pool Client
################################################################################

output "managed_user_pool_clients_ids" {
  description = "Map of Cognito Managed User Pool Client names and IDs"
  value = try({
    for client in var.managed_user_pool_clients : client.name =>
    aws_cognito_managed_user_pool_client.this[client.name].id
  }, null)
}

output "managed_user_pool_clients_secrets" {
  description = "Map of Cognito Managed User Pool Client names and secrets"
  value = try({
    for client in var.managed_user_pool_clients : client.name =>
    aws_cognito_managed_user_pool_client.this[client.name].client_secret
  }, null)
  sensitive = true
}
