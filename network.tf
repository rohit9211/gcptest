resource "google_compute_network" "vpc_network" {
  name = "${var.env}-network"
}

resource "google_compute_subnetwork" "terraform-subnet1" {
  name          = "${var.env}-subnet1"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc_network.name
  }

resource "google_compute_subnetwork" "terraform-subnet2" {
     name          = "${var.env}-subnet2"
     ip_cidr_range = "10.1.0.0/16"
     network       = google_compute_network.vpc_network.name

    }
