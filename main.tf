provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_floating_ip" "floating_ip" {
  region = "nyc3"
}

resource "digitalocean_droplet" "droplet" {
  image  = "bittorrent-test-seeder-v1"
  name   = "bittorrent-test-seeder"
  region = "lon1"
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_floating_ip_assignment" "my_floating_ip_assignment" {
  droplet_id = digitalocean_droplet.droplet.id
  ip_address = digitalocean_floating_ip.floating_ip.ip_address
}
