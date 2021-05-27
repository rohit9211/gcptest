resource "google_compute_address" "static-web" {
  name = "${var.env}-static-ip-web"
}

resource "google_compute_address" "static-db" {
  name = "${var.env}-static-ip-db"
}

resource "google_compute_firewall" "tf-firewall-rdp" {
 name    = "${var.env}-firewall-rdp"
 network = google_compute_network.vpc_network.name 

 allow {
   protocol = "icmp"
 }

 allow {
   protocol = "tcp"
   ports    = ["3389", "5985", "5986", "80"]
 }
 source_ranges = ["0.0.0.0/0"]
 source_tags = ["allow-rdp"]

}

resource "google_compute_firewall" "tf-firewall-db" {
 name    = "${var.env}-firewall-db"
 network = google_compute_network.vpc_network.name

 allow {
   protocol = "icmp"
 }

 allow {
   protocol = "tcp"
   ports    = ["1433"]
 }
 target_tags = ["allow-web"]
 source_tags = ["allow-db"]

}


resource "google_compute_instance" "tf-instance-web" {
    name         = "${var.env}-instance-web"
    machine_type = "${var.machine_type}"
    zone         = "${var.zone}"
    
    tags = ["allow-rdp","allow-web"]
    boot_disk {
        initialize_params{
            image = "windows-cloud/windows-2016"
        }
    }

    
    network_interface {
        network = google_compute_network.vpc_network.name
        access_config {
            nat_ip = "${google_compute_address.static-db.address}"
        }
    }

}

resource "google_compute_instance" "tf-instance-db" {
    name         = "${var.env}-instance-db"
    machine_type = "${var.machine_type}"
    zone         = "${var.zone}"

    tags = ["allow-rdp","allow-db"]
    boot_disk {
        initialize_params{
            image = "windows-cloud/windows-2016"
        }
    }


    network_interface {
        network = google_compute_network.vpc_network.name
        access_config {
            nat_ip = "${google_compute_address.static-web.address}"
        }
    }

}

#// Expose IP of VM
#output "ip" {
# value = "${google_compute_instance.instance_with_ip.network_interface.0.access_config.0.nat_ip}"
#}
