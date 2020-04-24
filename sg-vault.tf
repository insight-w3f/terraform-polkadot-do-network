resource "digitalocean_tag" "vault_sg" {
  name  = var.vault_sg_name
  count = var.vault_enabled ? 1 : 0
}

resource "digitalocean_firewall" "vault_sg_ssh" {
  name  = "${var.vault_sg_name}-ssh"
  tags  = [digitalocean_tag.vault_sg[*].id]
  count = var.vault_enabled && ! var.bastion_enabled ? 1 : 0

  droplet_ids = var.vault_instances

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  }
}

resource "digitalocean_firewall" "vault_sg_bastion_ssh" {
  name  = "${var.vault_sg_name}-ssh"
  tags  = [digitalocean_tag.vault_sg[*].id]
  count = var.vault_enabled && var.bastion_enabled ? 1 : 0

  droplet_ids = var.vault_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_tags = [digitalocean_tag.bastion_sg[*].id]
  }
}

resource "digitalocean_firewall" "vault_sg_mon" {
  name  = "${var.vault_sg_name}-monitoring"
  tags  = [digitalocean_tag.vault_sg[*].id]
  count = var.vault_enabled && var.monitoring_enabled ? 1 : 0

  droplet_ids = var.vault_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9100"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9333"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}

resource "digitalocean_firewall" "vault_sg_consul" {
  name  = "${var.vault_sg_name}-consul"
  tags  = [digitalocean_tag.vault_sg[*].id]
  count = var.vault_enabled && var.consul_enabled ? 1 : 0

  droplet_ids = var.vault_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "8600"
    source_tags = [digitalocean_tag.consul_sg[*].id]
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8500"
    source_tags = [digitalocean_tag.consul_sg[*].id]
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8301"
    source_tags = [digitalocean_tag.consul_sg[*].id]
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8302"
    source_tags = [digitalocean_tag.consul_sg[*].id]
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "8600"
    source_tags = [digitalocean_tag.consul_sg[*].id]
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "8301"
    source_tags = [digitalocean_tag.consul_sg[*].id]
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "8302"
    source_tags = [digitalocean_tag.consul_sg[*].id]
  }
}

resource "digitalocean_firewall" "vault_sg_various" {
  name  = "${var.vault_sg_name}-various"
  tags  = [digitalocean_tag.vault_sg[*].id]
  count = var.vault_enabled ? 1 : 0

  droplet_ids = var.vault_instances

  inbound_rule {
    protocol   = "tcp"
    port_range = "8200"
  }

  inbound_rule {
    protocol   = "tcp"
    port_range = "8201"
  }
}