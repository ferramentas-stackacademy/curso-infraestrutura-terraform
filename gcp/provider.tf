###################### CONFIGURA O PROVIDER ###########################
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  credentials = "stack-terraform-user.json"
  region      = "us-central1"
}