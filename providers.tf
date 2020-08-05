provider "google" {
  version = "~> 3.33.0"

  credentials = var.credentials
  project     = var.project
  region      = var.region
  zone        = var.zone
}

provider "local" {
  version = "~> 1.4.0"
}
