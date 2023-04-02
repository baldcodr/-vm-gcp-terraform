# Traffic for HTTP
resource "google_compute_firewall" "allow-http" {
  name = "${var.app_name}-allow-http"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}

# Traffic for HTTPS
resource "google_compute_firewall" "allow-https" {
  name = "${var.app_name}-allow-https"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}


# Traffic for SSH
resource "google_compute_firewall" "allow-ssh-for-iap_tunneling" {
  name = "${var.app_name}-allow-ssh-for-iap"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [ "35.235.240.0/20" ]

}
