resource "digitalocean_tag" "logging_sg" {
  name  = var.logging_sg_name
  count = var.logging_enabled ? 1 : 0
}

resource "digitalocean_firewall" "logging_sg_ssh" {
  name  = "${var.logging_sg_name}-ssh"
  tags  = [digitalocean_tag.logging_sg[*].id]
  count = var.logging_enabled && ! var.bastion_enabled ? 1 : 0

  droplet_ids = var.logging_instances

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  }
}

resource "digitalocean_firewall" "logging_sg_bastion_ssh" {
  name  = "${var.logging_sg_name}-ssh"
  tags  = [digitalocean_tag.logging_sg[*].id]
  count = var.logging_enabled && var.bastion_enabled ? 1 : 0

  droplet_ids = var.logging_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_tags = [digitalocean_tag.bastion_sg[*].id]
  }
}

resource "digitalocean_firewall" "logging_sg_mon_prom" {
  name  = "${var.logging_sg_name}-monitoring"
  tags  = [digitalocean_tag.logging_sg[*].id]
  count = var.logging_enabled && var.monitoring_enabled ? 1 : 0

  droplet_ids = var.logging_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9100"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}

resource "digitalocean_firewall" "logging_sg_mon_nordstrom" {
  name  = "${var.logging_sg_name}-monitoring"
  tags  = [digitalocean_tag.logging_sg[*].id]
  count = var.logging_enabled && ! var.monitoring_enabled ? 1 : 0

  droplet_ids = var.logging_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9108"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}

resource "digitalocean_firewall" "logging_sg_http_ingress" {
  name  = "${var.logging_sg_name}-http-ingress"
  tags  = [digitalocean_tag.logging_sg[*].id]
  count = var.logging_enabled ? 1 : 0

  droplet_ids = var.logging_instances

  inbound_rule {
    protocol   = "tcp"
    port_range = "80"
  }
}

resource "digitalocean_firewall" "logging_sg_consul" {
  name  = "${var.logging_sg_name}-consul"
  tags  = [digitalocean_tag.logging_sg[*].id]
  count = var.logging_enabled && var.consul_enabled ? 1 : 0

  droplet_ids = var.logging_instances

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