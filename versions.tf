terraform {
  required_version = ">= 0.13"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.37.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 1.4.0"
    }
  }
}
