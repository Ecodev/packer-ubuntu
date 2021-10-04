variable "build_directory" {
  type    = string
  default = "builds"
}

variable "cpus" {
  type    = number
  default = 2
}

variable "description" {
  type    = string
  default = "This box includes chef-client 16.16.13, Ubuntu Live Server 20.04.2, Virtualbox Guest Additions and common APT packages to speed up Chef converge"
}

variable "disk_size" {
  type    = number
  default = 65536
}

variable "guest_additions_url" {
  type    = string
  default = ""
}

variable "headless" {
  type    = bool
  default = false
}

variable "http_proxy" {
  type    = string
  default = "${env("http_proxy")}"
}

variable "https_proxy" {
  type    = string
  default = "${env("https_proxy")}"
}

variable "iso_checksum" {
  type    = string
  default = "d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
}

variable "iso_name" {
  type    = string
  default = "ubuntu-20.04.2-live-server-amd64.iso"
}

variable "memory" {
  type    = number
  default = 1024
}

variable "mirror" {
  type    = string
  default = "https://old-releases.ubuntu.com"
}

variable "mirror_directory" {
  type    = string
  default = "releases/focal"
}

variable "no_proxy" {
  type    = string
  default = "${env("no_proxy")}"
}

variable "preseed_path" {
  type    = string
  default = "preseed.cfg"
}

variable "template" {
  type    = string
  default = "ubuntu-20.04-live-amd64"
}

variable "vagrantcloud_token" {
  type    = string
  default = "${env("VAGRANTCLOUD_TOKEN")}"
}