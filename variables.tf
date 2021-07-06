variable "region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type = string
}

variable "repo" {
  type = string
}

variable "database_name" {
  type      = string
  sensitive = true
}

variable "username" {
  type      = string
  sensitive = true
}

variable "password" {
  type      = string
  sensitive = true
}

variable "master_username" {
  type      = string
  sensitive = true
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "user_ip" {
  type      = string
  sensitive = true
}

variable "key_file" {
  type      = string
  sensitive = true
}
