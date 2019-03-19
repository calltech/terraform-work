variable "zone" 	     { default = "us-east1-b" } # zone
variable "tags" 	     { default = ["r-demo"] } # Ritesh demo r-demo (machine name will be followed by index number from the loop below)
variable "image" 	     { default = "debian-9-stretch-v20190213" } # OS for our vm. If you want to choose a different image then run: ' gcloud compute images list ' and you will get a list all available os images 
variable "machine_type"      { default = "g1-small" } # type of vm we want to provision, You can get a list of all available machine types by running the following command from CLI. ' gcloud compute machine-types list '


// Creating vm instance by looping through "tags"
resource "google_compute_instance" "r-demo" {
    count = "${length(var.tags)}"
    name = "r-demo-${count.index+1}"
    machine_type = "${var.machine_type}"
    zone = "${var.zone}"
    tags = ["${var.tags[count.index]}"]


    # Creating boot disk from the image defined in the var section
    boot_disk {
        initialize_params {
        image = "${var.image}"
        }
    }



    # Default network interface
    network_interface {
      network = "default"
      access_config {
         nat_ip = "${google_compute_address.static.address}"

      }
    }



    // Adding ssh key to the newly created vm
    metadata {
    sshKeys = "gecko:${file("~/.ssh/id_rsa.pub")}"
    }

}



# Firewall rules
resource "google_compute_address" "r-demo" {
    name = "r-demo-address"
}

resource "google_compute_target_pool" "r-demo" {
  name = "r-demo-target-pool"
  instances = ["${google_compute_instance.r-demo.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.http.name}"]
}

resource "google_compute_forwarding_rule" "http" {
  name = "r-demo-http-forwarding-rule"
  target = "${google_compute_target_pool.r-demo.self_link}"
  ip_address = "${google_compute_address.r-demo.address}"
  port_range = "80"
}

resource "google_compute_forwarding_rule" "tcp" {
  name = "r-demo-tcp-forwarding-rule"
  target = "${google_compute_target_pool.r-demo.self_link}"
  ip_address = "${google_compute_address.r-demo.address}"
  port_range = "8080"
}

resource "google_compute_forwarding_rule" "https" {
  name = "tf-sample-https-forwarding-rule"
  target = "${google_compute_target_pool.r-demo.self_link}"
  ip_address = "${google_compute_address.r-demo.address}"
  port_range = "443"
}


#   Performing http health chceck
resource "google_compute_http_health_check" "http" {
  name = "r-demo-http-basic-check"
  request_path = "/"
  check_interval_sec = 1
  healthy_threshold = 1
  unhealthy_threshold = 10
  timeout_sec = 1
}

resource "google_compute_firewall" "r-demo" {
  name = "r-demo-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["r-demo-node"]
}
resource "google_compute_address" "static" {
  name = "ipv4-address"
}