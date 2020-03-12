resource "digitalocean_tag" "sentry_node_sg" {
  name  = var.sentry_node_sg_name
  count = true ? 1 : 0
}

resource "digitalocean_firewall" "sentry_node_sg_ssh" {
  name  = "${var.sentry_node_sg_name}-ssh"
  tags  = digitalocean_tag.sentry_node_sg[*].id
  count = ! var.bastion_enabled ? 1 : 0

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  }
}

resource "digitalocean_firewall" "sentry_node_sg_bastion_ssh" {
  name  = "${var.sentry_node_sg_name}-ssh"
  tags  = digitalocean_tag.sentry_node_sg[*].id
  count = var.bastion_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "22"
    source_tags = digitalocean_tag.bastion_sg[*].id
  }
}

resource "digitalocean_firewall" "sentry_node_sg_mon" {
  name  = "${var.sentry_node_sg_name}-monitoring"
  tags  = digitalocean_tag.sentry_node_sg[*].id
  count = var.monitoring_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9100"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9323"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}


resource "digitalocean_firewall" "sentry_node_sg_hids" {
  name  = "${var.sentry_node_sg_name}-hids"
  tags  = digitalocean_tag.sentry_node_sg[*].id
  count = var.hids_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "1514"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }

  inbound_rule {
    protocol    = "tcp"
    port_range  = "1515"
    source_tags = digitalocean_tag.monitoring_sg[*].id
  }
}

resource "digitalocean_firewall" "sentry_node_sg_consul" {
  name  = "${var.sentry_node_sg_name}-consul"
  tags  = digitalocean_tag.sentry_node_sg[*].id
  count = var.consul_enabled ? 1 : 0

  inbound_rule {
    protocol    = "tcp"
    port_range  = "8600"
    source_tags = digitalocean_tag.consul_sg[*].id
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8500"
    source_tags = digitalocean_tag.consul_sg[*].id
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8301"
    source_tags = digitalocean_tag.consul_sg[*].id
  }
  inbound_rule {
    protocol    = "tcp"
    port_range  = "8302"
    source_tags = digitalocean_tag.consul_sg[*].id
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "8600"
    source_tags = digitalocean_tag.consul_sg[*].id
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "8301"
    source_tags = digitalocean_tag.consul_sg[*].id
  }
  inbound_rule {
    protocol    = "udp"
    port_range  = "8302"
    source_tags = digitalocean_tag.consul_sg[*].id
  }
}

resource "digitalocean_firewall" "sentry_node_sg_p2p" {
  name  = "${var.sentry_node_sg_name}-p2p"
  tags  = digitalocean_tag.sentry_node_sg[*].id
  count = true ? 1 : 0

  inbound_rule {
    protocol         = "tcp"
    port_range       = "30333"
    source_addresses = ["0.0.0.0/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "51820"
    source_addresses = ["0.0.0.0/0"]
  }
}