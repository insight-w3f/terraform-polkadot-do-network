terraform {
  required_version = ">= 0.12"
}

module "label" {
  source = "github.com/robc-io/terraform-null-label.git?ref=0.16.1"
  tags = {
    NetworkName = var.network_name
    Owner       = var.owner
    Terraform   = true
    VpcType     = "main"
  }

  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
}

resource "digitalocean_firewall" "default_egress" {
  name = "default-egress"

  tags = coalescelist(
    digitalocean_tag.bastion_sg[*].id != [] ? digitalocean_tag.bastion_sg[*].id : [],
    digitalocean_tag.consul_sg[*].id != [] ? digitalocean_tag.consul_sg[*].id : [],
    digitalocean_tag.hids_sg[*].id != [] ? digitalocean_tag.hids_sg[*].id : [],
    digitalocean_tag.logging_sg[*].id != [] ? digitalocean_tag.logging_sg[*].id : [],
    digitalocean_tag.monitoring_sg[*].id != [] ? digitalocean_tag.monitoring_sg[*].id : [],
    digitalocean_tag.sentry_node_sg[*].id != [] ? digitalocean_tag.sentry_node_sg[*].id : [],
    digitalocean_tag.vault_sg[*].id != [] ? digitalocean_tag.vault_sg[*].id : []
  )

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
}