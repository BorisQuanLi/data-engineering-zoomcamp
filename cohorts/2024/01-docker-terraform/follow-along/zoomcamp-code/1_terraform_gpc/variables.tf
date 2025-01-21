# copied from folder
# /mnt/c/Users/Boris_Li/OneDrive/bootcamps/zoomcamps/ \
# forked-data-engineering-zoomcamp/data-engineering-zoomcamp/ \
# 01-docker-terraform/1_terraform_gcp/terraform/terraform_with_variables/
variable "credentials" {
  description = "Path to the GCP credentials file"
  type        = string
}

variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-east1-b"
}

variable "location" {
  description = "Location for GCS bucket and BigQuery dataset"
  type        = string
}

variable "bq_dataset_name" {
  description = "Name of the BigQuery dataset"
  type        = string
  default     = "taxi_rides_ny" // Use a valid dataset ID
}

variable "gcs_bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
  default     = "nyc-tl-data-boris"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}