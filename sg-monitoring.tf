resource "digitalocean_tag" "monitoring_sg" {
  name  = var.monitoring_sg_name
  count = var.monitoring_enabled ? 1 : 0
}

resource "digitalocean_firewall" "monitoring_sg_ssh" {
  name  = "${var.monitoring_sg_name}-ssh"
  tags  = [digitalocean_tag.monitoring_sg[*].id]
  count = var.monitoring_enabled && ! var.bastion_enabled ? 1 : 0

  droplet_ids = var.monitoring_instances

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  }
}

resource "digitalocean_firewall" "monitoring_sg_bastion_ssh" {
  name  = "${var.monitoring_sg_name}-ssh"
  tags  = [digitalocean_tag.monitoring_sg[*].id]
  count = var.monitoring_enabled && var.bastion_enabled ? 1 : 0

  droplet_ids = var.monitoring_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_tags = [digitalocean_tag.bastion_sg[*].id]
  }
}

resource "digitalocean_firewall" "monitoring_sg_http_ingress" {
  name  = "${var.monitoring_sg_name}-http-ingress"
  tags  = [digitalocean_tag.monitoring_sg[*].id]
  count = var.monitoring_enabled ? 1 : 0

  inbound_rule {
    protocol   = "tcp"
    port_range = "80"
  }
}

resource "digitalocean_firewall" "monitoring_sg_consul" {
  name  = "${var.monitoring_sg_name}-consul"
  tags  = [digitalocean_tag.monitoring_sg[*].id]
  count = var.monitoring_enabled && var.consul_enabled ? 1 : 0

  droplet_ids = var.monitoring_instances

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