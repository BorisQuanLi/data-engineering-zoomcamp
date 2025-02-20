# https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "zoomcamp-data-engineering"
  region  = "us-east5"
  zone    = "us-east5-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
