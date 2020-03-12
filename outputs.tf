#####
# SGs
#####
output "bastion_security_group_id" {
  value       = digitalocean_tag.bastion_sg[*].id
  description = "UID of the service account for the bastion host"
}

output "consul_security_group_id" {
  value       = digitalocean_tag.consul_sg[*].id
  description = "UID of the service account for the Consul servers"
}

output "hids_security_group_id" {
  value       = digitalocean_tag.hids_sg[*].id
  description = "UID of the service account for the HIDS group"
}

output "logging_security_group_id" {
  value       = digitalocean_tag.consul_sg[*].id
  description = "UID of the service account for the logging group"
}

output "monitoring_security_group_id" {
  value       = digitalocean_tag.monitoring_sg[*].id
  description = "UID of the service account for the monitoring group"
}

output "sentry_security_group_id" {
  value       = digitalocean_tag.sentry_node_sg[*].id
  description = "UID of the service account for the sentry group"
}

output "vault_security_group_id" {
  value       = digitalocean_tag.vault_sg[*].id
  description = "UID of the service account for the vault group"
}

#####
# DNS
#####
output "root_domain_name" {
  value       = var.root_domain_name
  description = "The name of the root domain"
}

output "internal_tld" {
  value       = var.internal_tld
  description = "The name of the internal domain"
}

output "public_regional_domain" {
  value       = var.create_public_regional_subdomain ? join(",", digitalocean_domain.region_public[*].id) : ""
  description = "The public regional domain"
}
