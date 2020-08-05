variable "credentials" {
  type    = string
  default = "service-account.json"
}

variable "project" {
  type = string
}
variable "region" {
  type = string
}
variable "zone" {
  type = string
}

variable "name" {
  type    = string
  default = "vpn"
}

variable "cidr" {
  type    = string
  default = "10.10.10.0/24"
}

variable "hostname" {
  type    = string
  default = ""
}
