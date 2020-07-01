provider "google" {
  version = "~> 3.28"

  credentials = var.credentials
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "network" {
  name = "${var.name}-network"

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name    = "${var.name}-${var.region}-subnet"
  network = google_compute_network.network.self_link

  ip_cidr_range = var.cidr
}

resource "google_compute_firewall" "firewall" {
  name    = "${var.name}-firewall"
  network = google_compute_network.network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  allow {
    protocol = "udp"
    ports    = ["443"]
  }
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_address" "address" {
  name = "${var.name}-address"
}

data "google_compute_image" "image" {
  family  = "debian-10"
  project = "debian-cloud"
}

resource "google_compute_instance" "instance" {
  name         = var.name
  zone         = var.zone
  machine_type = "f1-micro"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      size  = 10
      type  = "pd-standard"
      image = data.google_compute_image.image.self_link
    }
  }

  network_interface {
    network    = google_compute_network.network.self_link
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      nat_ip = google_compute_address.address.address
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  metadata = {
    "disable-legacy-endpoints" = "TRUE"
  }
}

output "address" {
  value = google_compute_address.address.address
}
