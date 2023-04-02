# create VPC
resource "google_compute_network" "vpc_network" {
  name = "${var.app_name}-vpc"
  auto_create_subnetworks = "true"
  routing_mode = "GLOBAL"
}

#Private IP addresses
resource "google_compute_global_address" "private_ip" {
  name         = "private-ip"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  prefix_length = 20
  network       = google_compute_network.vpc_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip.name]
}

resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh"
  network     = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]

  }
  target_tags = ["ssh"]
  source_tags = ["vpc"]
}


resource "google_compute_router" "router" {
  project = var.app_project
  name    = "nat-router"
  network = google_compute_network.vpc_network.name
  region  = var.gcp_region
}

module "cloud-nat" {
  source                             = "terraform-google-modules/cloud-nat/google"
  version                            = "~> 2.0.0"
  project_id                         = var.app_project
  region                             = var.gcp_region
  router                             = google_compute_router.router.name
  name                               = "nat-config"
}


