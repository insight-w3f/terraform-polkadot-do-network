resource "digitalocean_tag" "bastion_sg" {
  name  = var.bastion_sg_name
  count = var.bastion_enabled ? 1 : 0
}

resource "digitalocean_firewall" "bastion_sg_ssh" {
  name  = "${var.bastion_sg_name}-ssh"
  tags  = [digitalocean_tag.bastion_sg[*].id]
  count = var.bastion_enabled ? 1 : 0

  droplet_ids = var.bastion_instances

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.corporate_ip == "" ? ["0.0.0.0/0"] : ["${var.corporate_ip}/32"]
  }
}

resource "digitalocean_firewall" "bastion_sg_mon" {
  name  = "${var.bastion_sg_name}-monitoring"
  tags  = [digitalocean_tag.bastion_sg[*].id]
  count = var.bastion_enabled && var.monitoring_enabled ? 1 : 0

  droplet_ids = var.bastion_instances

  inbound_rule {
    protocol    = "tcp"
    port_range  = "9100"
    source_tags = var.monitoring_enabled ? [digitalocean_tag.monitoring_sg[*].id] : []
  }
}