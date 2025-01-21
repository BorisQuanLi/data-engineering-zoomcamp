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
  project     = var.project           // Use the project variable
  credentials = file(var.credentials) // Use the credentials variable
  region      = var.region            // Use the region variable
  zone        = var.zone              // Use the zone variable
}

resource "google_storage_bucket" "data-lake-bucket-zoomcamp-formulation" {
  name          = var.gcs_bucket_name   // Use the gcs_bucket_name variable
  location      = var.location          // Use the location variable
  storage_class = var.gcs_storage_class // Use the gcs_storage_class variable
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.bq_dataset_name // Use the bq_dataset_name variable
  project    = var.project         // Use the project variable
  location   = var.location        // Use the location variable
}