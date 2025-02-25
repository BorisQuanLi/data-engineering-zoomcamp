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
  project = "verdant-cargo-406919"  # Changed from "zoomcamp-data-engineering"
  region  = "us-east1"              # Changed to region we know works
  zone    = "us-east1-b"            # Changed to zone we know works
  # We don't need credentials here since we're using GOOGLE_APPLICATION_CREDENTIALS
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = false  # Set to false if you want to manage subnets manually
  
  # Add routing_mode based on what we saw in terraform show earlier
  routing_mode = "REGIONAL"
}

# Add explicit subnet
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "terraform-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.id

  # Add these options based on our earlier learnings
  private_ip_google_access = true  # Allow private Google API access
  
  # Add a secondary IP range for future services if needed
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.0.2.0/24"
  }
}

# Add service account configuration if needed
resource "google_service_account" "vpc_service_account" {
  account_id   = "vpc-service-account"
  display_name = "VPC Service Account"
}

# Add necessary IAM roles to the service account
resource "google_project_iam_member" "vpc_service_account_roles" {
  project = "verdant-cargo-406919"
  role    = "roles/compute.networkAdmin"
  member  = "serviceAccount:${google_service_account.vpc_service_account.email}"
}
