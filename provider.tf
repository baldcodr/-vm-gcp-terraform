terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.90.1"
    }
  }
}


provider "google" {
  project = var.app_project
  region      = "europe-west2"
  zone        = "europe-west2-a"
}

