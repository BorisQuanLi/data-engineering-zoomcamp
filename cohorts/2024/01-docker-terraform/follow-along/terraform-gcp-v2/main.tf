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
  project     = "verdant-cargo-406919"
  region      = "us-east1"    # Changed to us-east1
  zone        = "us-east1-b"  # Changed to us-east1-b (which we know exists from earlier)
  # credentials = "gcp_keys/verdant-cargo-406919-2fdfe25d9f90.json"
  # Make sure force_destroy is set to true for any storage resources
  # to allow terraform destroy to work without manual intervention
}

resource "google_compute_instance" "data_engineering_vm" {  # Changed from "ga-instance" to "data_engineering_vm"
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-east1-b"  # Changed to us-east1-b

  deletion_protection = false

  service_account {
    email  = "terraform-provisioner-zoomcamp@verdant-cargo-406919.iam.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute"
    ]
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"    # Changed from debian-10 to debian-11
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
