variable "do_token" {
  type = string
}

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "remote" {
    organization = "codecrafters"

    workspaces {
      name = "bittorrent-test-seeder"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_floating_ip" "floating_ip" {
  region = "lon1"
}

data "digitalocean_droplet_snapshot" "image" {
  name        = "bittorrent-test-seeder-v3"
  most_recent = true
  region      = "lon1"
}


resource "digitalocean_droplet" "droplet" {
  image  = data.digitalocean_droplet_snapshot.image.id
  name   = "bittorrent-test-seeder"
  region = "lon1"
  size   = "s-1vcpu-1gb"
}

resource "digitalocean_floating_ip_assignment" "my_floating_ip_assignment" {
  droplet_id = digitalocean_droplet.droplet.id
  ip_address = digitalocean_floating_ip.floating_ip.ip_address
}
