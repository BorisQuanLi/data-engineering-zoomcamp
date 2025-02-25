terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  # Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  #  credentials = 
  project = "verdant-cargo-406919"  # Change this to match your service account's project
  region  = "us-east1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name     = "data_engineering_zoomcamp_module_01_exercise"
  location = "US"
  project  = "verdant-cargo-406919"  # Add explicit project ID

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

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

  force_destroy = true

  labels = {
    environment = "development"
    project     = "data-engineering-zoomcamp"
    creator     = "terraform"
  }

  # Ensure consistent lifecycle rules
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "imaginary_dataset_de_zoomcamp_module_01"
  project    = "verdant-cargo-406919"  # Add explicit project ID
  location   = "US"

  description = "Dataset for Data Engineering Zoomcamp Module 1"
  
  default_table_expiration_ms = 7776000000  # 90 days

  labels = {
    environment = "development"
    project     = "data-engineering-zoomcamp"
    creator     = "terraform"
  }
}
