data "digitalocean_domain" "this" {
  count = var.root_domain_name == "" ? 0 : 1
  name  = "${var.root_domain_name}."
}

resource "digitalocean_domain" "root_private" {
  count = var.create_internal_domain ? 1 : 0
  name  = "${var.namespace}.${var.internal_tld}"
}

resource "digitalocean_domain" "region_public" {
  count = var.create_public_regional_subdomain ? 1 : 0
  name  = join(".", [var.environment, var.root_domain_name])
}