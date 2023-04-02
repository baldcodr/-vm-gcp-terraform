# Project name
variable "app_project" {
  type = string
  description = "Project name"
}
# region
variable "gcp_region" {
  type = string
  description = "GCP region"
}
# zone
variable "gcp_zone" {
  type = string
  description = "GCP zone"
}

variable "app_name" {
  type = string
  description = "App name"
}

variable "db_user" {
  type = string
  description = "DB username"
}

variable "db_pwd" {
  type = string
  description = "DB password"
}
