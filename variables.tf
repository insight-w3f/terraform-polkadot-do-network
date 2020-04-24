########
# Label
########
variable "environment" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "The namespace to deploy into"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The stage of the deployment"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "The network name, ie kusama / mainnet"
  type        = string
  default     = ""
}

variable "owner" {
  type    = string
  default = ""
}

######
# DNS
######
variable "internal_tld" {
  description = "The top level domain for the internal DNS"
  type        = string
  default     = "internal"
}

variable "root_domain_name" {
  description = "The public domain"
  type        = string
  default     = ""
}

variable "create_internal_domain" {
  description = "Boolean to create an internal split horizon DNS"
  type        = bool
  default     = false
}

variable "create_public_regional_subdomain" {
  description = "Boolean to create regional subdomain - ie us-east-1.example.com"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "The zone ID to configure as the root zoon - ie subdomain.example.com's zone ID"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region to deploy into"
  type        = string
  default     = "NYC1"
}

##################
# Security Groups
##################

variable "corporate_ip" {
  description = "The corporate IP you want to restrict ssh traffic to"
  type        = string
  default     = ""
}

variable "bastion_enabled" {
  description = "Boolean to enable a bastion host.  All ssh traffic restricted to bastion"
  type        = bool
  default     = false
}

variable "consul_enabled" {
  description = "Boolean to allow consul traffic"
  type        = bool
  default     = false
}

variable "monitoring_enabled" {
  description = "Boolean to for prometheus related traffic"
  type        = bool
  default     = false
}

variable "hids_enabled" {
  description = "Boolean to enable intrusion detection systems traffic"
  type        = bool
  default     = false
}
variable "logging_enabled" {
  description = "Boolean to allow logging related traffic"
  type        = bool
  default     = false
}
variable "vault_enabled" {
  description = "Boolean to allow vault related traffic"
  type        = bool
  default     = false
}

variable "sentry_node_sg_name" {
  description = "Name for the public node security group"
  type        = string
  default     = "sentry-sg"
}

variable "sentry_node_instances" {
  description = "List of droplet IDs to include in this security group"
  type        = list(string)
  default     = []
}

variable "bastion_sg_name" {
  description = "Name for the bastion security group"
  type        = string
  default     = "bastion-sg"
}

variable "bastion_instances" {
  description = "List of droplet IDs to include in this security group"
  type        = list(string)
  default     = []
}

variable "consul_sg_name" {
  description = "Name for the consult security group"
  type        = string
  default     = "consul-sg"
}

variable "consul_instances" {
  description = "List of droplet IDs to include in this security group"
  type        = list(string)
  default     = []
}

variable "monitoring_sg_name" {
  description = "Name for the monitoring security group"
  type        = string
  default     = "monitoring-sg"
}

variable "monitoring_instances" {
  description = "List of droplet IDs to include in this security group"
  type        = list(string)
  default     = []
}

variable "hids_sg_name" {
  description = "Name for the HIDS security group"
  type        = string
  default     = "hids-sg"
}

variable "hids_instances" {
  description = "List of droplet IDs to include in this security group"
  type        = list(string)
  default     = []
}

variable "logging_sg_name" {
  description = "Name for the logging security group"
  type        = string
  default     = "logging-sg"
}

variable "logging_instances" {
  description = "List of droplet IDs to include in this security group"
  type        = list(string)
  default     = []
}

variable "vault_sg_name" {
  description = "Name for the vault security group"
  type        = string
  default     = "vault-sg"
}

variable "vault_instances" {
  description = "List of droplet IDs to include in this security group"
  type        = list(string)
  default     = []
}