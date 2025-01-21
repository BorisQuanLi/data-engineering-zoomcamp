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
  project = "zoomcamp-data-engineering"
  /* 12:25, record GCP credentials
  https://www.youtube.com/watch?v=Y2ux7gq3Z0o&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=12
  */
  credentials = "./keys/verdant-cargo-406919-2f2e61818566.json"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_instance" "default" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

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

resource "google_storage_bucket" "demo-bucket" {
  name          = "boris-li-data-engineering-zoomcamp" # like AWS S3, the name needs to be "globally unique"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id = "your_data_warehouse"
  location   = "US"
}