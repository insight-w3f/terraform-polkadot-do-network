resource "digitalocean_tag" "consul_sg" {
  name  = var.consul_sg_name
  count = var.consul_enabled ? 1 : 0
}

resource "digitalocean_firewall" "consul_sg_bastion_ssh" {
  name  = "${var.consul_sg_name}-ssh"
  tags  = [digitalocean_tag.consul_sg[*].id]
  count = var.consul_enabled && var.bastion_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_tags = [digitalocean_tag.bastion_sg[*].id]
  }
}

resource "digitalocean_firewall" "consul_sg_ssh" {
  name  = "${var.consul_sg_name}-ssh"
  tags  = [digitalocean_tag.consul_sg[*].id]
  count = var.consul_enabled && ! var.bastion_enabled ? 1 : 0

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  }
}

resource "digitalocean_firewall" "consul_sg_mon_prom" {
  name  = "${var.consul_sg_name}-monitoring"
  tags  = [digitalocean_tag.consul_sg[*].id]
  count = var.consul_enabled && var.monitoring_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9100"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}

resource "digitalocean_firewall" "consul_sg_mon_nordstrom" {
  name  = "${var.consul_sg_name}-monitoring"
  tags  = [digitalocean_tag.consul_sg[*].id]
  count = var.consul_enabled && ! var.monitoring_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9428"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}