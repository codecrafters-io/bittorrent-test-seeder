variable "do_token" {
  type = string
}

variable "heroku_email" {
  type = string
}

variable "heroku_api_key" {
  type = string
}

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
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

provider "heroku" {
  email   = var.heroku_email
  api_key = var.heroku_api_key
}

data "digitalocean_droplet_snapshot" "base_seeder_image" {
  name        = "bittorrent-test-seeder-base-v1"
  most_recent = true
  region      = "lon1"
}

data "digitalocean_droplet_snapshot" "magnet_seeder_image" {
  name        = "bittorrent-test-seeder-magnet-v1"
  most_recent = true
  region      = "lon1"
}

resource "digitalocean_droplet" "base_seeder" {
  count      = 3
  image      = data.digitalocean_droplet_snapshot.base_seeder_image.id
  name       = "bittorrent-test-seeder-base-${count.index}"
  region     = "lon1"
  size       = "s-1vcpu-1gb"
  monitoring = true

  ssh_keys = ["28:77:85:1e:fa:ab:dd:45:23:3a:3b:c3:30:90:d6:7c"]
}

resource "digitalocean_droplet" "magnet_seeder" {
  count      = 3
  image      = data.digitalocean_droplet_snapshot.magnet_seeder_image.id
  name       = "bittorrent-test-seeder-magnet-${count.index}"
  region     = "lon1"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ssh_keys   = ["28:77:85:1e:fa:ab:dd:45:23:3a:3b:c3:30:90:d6:7c"]
}

data "heroku_app" "bittorrent_test_tracker" {
  name = "bittorrent-test-tracker"
}

resource "heroku_app_config_association" "server" {
  app_id = data.heroku_app.bittorrent_test_tracker.id

  vars = {
    EXPOSED_CLIENT_IPS = join(",", digitalocean_droplet.base_seeder.*.ipv4_address, digitalocean_droplet.magnet_seeder.*.ipv4_address)
  }
}

output "base_seeder_ip_1" {
  value = digitalocean_droplet.base_seeder[0].ipv4_address
}

output "base_seeder_ip_2" {
  value = digitalocean_droplet.base_seeder[1].ipv4_address
}

output "base_seeder_ip_3" {
  value = digitalocean_droplet.base_seeder[2].ipv4_address
}

output "magnet_seeder_ip_1" {
  value = digitalocean_droplet.magnet_seeder[0].ipv4_address
}

output "magnet_seeder_ip_2" {
  value = digitalocean_droplet.magnet_seeder[1].ipv4_address
}

output "magnet_seeder_ip_3" {
  value = digitalocean_droplet.magnet_seeder[2].ipv4_address
}
