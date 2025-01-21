terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.50.0"
    }
  }

  required_version = ">= 0.14.0"
}

provider "google" {
  project     = "zoomcamp-data-engineering"
  region      = "us-east1"
  zone        = "us-east1-b"
  credentials = "gcp_keys/verdant-cargo-406919-2fdfe25d9f90.json"
}

resource "google_compute_instance" "ga-instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  service_account {
    email  = "terraform-provisioner-zoomcamp@verdant-cargo-406919.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
