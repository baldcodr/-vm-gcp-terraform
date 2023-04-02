# Generate random id
resource "random_id" "instance_id" {
  byte_length = 4
}

# Virtual machine instance
resource "google_compute_instance" "vm_instance" {
  name = "${var.app_name}-vm-${random_id.instance_id.hex}"
  machine_type = "e2-small"
  zone = var.gcp_zone
  tags = ["ssh","http"]
  deletion_protection = false
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  metadata_startup_script = <<-EOF
  sudo apt-get upgrade
  sudo apt-get update
  sudo apt install mysql-client-core-8.0
  EOF

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_global_address.private_ip.network
    # subnetwork = google_compute_global_address.private_ip.network
  }
}

module "iap_tunneling" {
  source = "terraform-google-modules/bastion-host/google//modules/iap-tunneling"

  project                    = var.app_project
  network                    = google_compute_network.vpc_network.name

  instances = [{
    name = google_compute_instance.vm_instance.name
    zone = var.gcp_zone
      depends_on = [
    google_compute_instance.vm_instance
  ]  
  },]

  members = ["user:candidate19@ostendere.net",]
}


