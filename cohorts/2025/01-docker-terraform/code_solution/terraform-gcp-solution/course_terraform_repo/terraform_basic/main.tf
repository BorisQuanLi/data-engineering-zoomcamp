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
  project = "zoomcamp-data-engineering"
  region  = "us-central1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name     = "data_engineering_zoomcamp_module_01_exercise"
  location = "US"

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
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id = "imaginary_dataset_de_zoomcamp_module_01"
  project    = "zoomcamp-data-engineering"
  location   = "US"
}
