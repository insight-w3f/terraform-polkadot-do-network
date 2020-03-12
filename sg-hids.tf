resource "digitalocean_tag" "hids_sg" {
  name  = var.hids_sg_name
  count = var.hids_enabled ? 1 : 0
}

resource "digitalocean_firewall" "hids_sg_ssh" {
  name  = "${var.hids_sg_name}-ssh"
  tags  = [digitalocean_tag.hids_sg[*].id]
  count = var.hids_enabled ? 1 : 0

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  }
}

resource "digitalocean_firewall" "hids_sg_mon_prom" {
  name  = "${var.hids_sg_name}-monitoring"
  tags  = [digitalocean_tag.hids_sg[*].id]
  count = var.hids_enabled && var.monitoring_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9100"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}

resource "digitalocean_firewall" "hids_sg_mon_nordstrom" {
  name  = "${var.hids_sg_name}-monitoring"
  tags  = [digitalocean_tag.hids_sg[*].id]
  count = var.hids_enabled && ! var.monitoring_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9108"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}

resource "digitalocean_firewall" "hids_sg_http_ingress" {
  name  = "${var.hids_sg_name}-http-ingress"
  tags  = [digitalocean_tag.hids_sg[*].id]
  count = var.hids_enabled ? 1 : 0

  inbound_rule {
    protocol   = "tcp"
    port_range = "80"
  }
}

resource "digitalocean_firewall" "hids_sg_consul" {
  name  = "${var.hids_sg_name}-consul"
  tags  = [digitalocean_tag.hids_sg[*].id]
  count = var.hids_enabled && var.consul_enabled ? 1 : 0

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