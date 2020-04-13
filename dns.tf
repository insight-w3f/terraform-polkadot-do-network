locals {
  public_domain = join(".", [var.region, "do.polkadot", var.root_domain_name])
}

data cloudflare_zones "this" {
  filter {
    name = var.root_domain_name
  }
}

resource "cloudflare_record" "public_delegation" {
  count   = var.root_domain_name == "" ? 0 : 3
  name    = "do.polkadot.${var.root_domain_name}"
  value   = "ns${count.index + 1}.digitalocean.com"
  type    = "NS"
  zone_id = data.cloudflare_zones.this.zones[0].id
}

resource "digitalocean_domain" "this" {
  count = var.root_domain_name == "" ? 0 : 1
  name  = "do.polkadot.${var.root_domain_name}"
}

resource "digitalocean_domain" "root_private" {
  count = var.create_internal_domain ? 1 : 0
  name  = "${var.namespace}.${var.internal_tld}"
}

resource "digitalocean_domain" "region_public" {
  count = var.create_public_regional_subdomain ? 1 : 0
  name  = local.public_domain
}