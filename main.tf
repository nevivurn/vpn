# network
resource "google_compute_network" "network" {
  name                    = "${var.name}-network"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name}-${var.region}-subnet"
  network       = google_compute_network.network.self_link
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
}
resource "google_compute_address" "address" {
  name = "${var.name}-address"
}

# instance
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
      nat_ip                 = google_compute_address.address.address
      public_ptr_domain_name = var.hostname
    }
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  metadata = {
    "disable-legacy-endpoints" = "TRUE"
  }
}

resource "local_file" "inventory" {
  filename        = "${path.root}/inventory.ini"
  content         = "${google_compute_address.address.address}\n"
  file_permission = "0644"
}
