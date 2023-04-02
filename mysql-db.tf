resource "google_sql_database_instance" "db_instance" {
  name             = "db-instance"
  database_version = "MYSQL_8_0"
  deletion_protection = false
  depends_on = [
    google_service_networking_connection.private_vpc_connection
    # google_compute_global_address.private_ip
  ]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = false
      private_network = google_compute_network.vpc_network.id
    }
  }
}

resource "google_sql_user" "users" {
  name     = var.db_user
  instance = google_sql_database_instance.db_instance.name
  password = var.db_pwd
}
