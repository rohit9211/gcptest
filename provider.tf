# terraform {

#  backend "gcs" {
#     bucket          = "tf-env-state"
#     prefix          = "terraform.tfstate"
#   }
#}

provider "google" {
  region      = "${var.region}"
  credentials = "${var.gcp_credential}"
  project = "${var.project}"
}
