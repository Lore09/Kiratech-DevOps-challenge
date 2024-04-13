variable "region" {
  description = "Default region"
  default = "eu-central-1"
  type = string
}

variable "availability_zones" {
  description = "Availability zones"
  default = ["eu-central-1a"]
  type = list(string)
}

variable "access_key" {
  description = "AWS auth"
  sensitive = true
  type = string
}

variable "secret_key" {
  description = "AWS auth"
  type = string
  sensitive = true
}

variable "trusted_ip" {
  description = "Trusted IP"
  type = string
}