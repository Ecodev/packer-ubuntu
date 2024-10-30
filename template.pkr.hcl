packer {
  required_plugins {
    vagrant = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

##################################################################################
# VARIABLES
##################################################################################

variable "build_directory" {
  type = string
  default = "builds"
}
variable "cpus" {
  type = number
  default = 2
}
variable "description" {
  type = string
  default = "This box includes chef-client 17.10.3, Ubuntu Live Server 22.04.1, Virtualbox 7.0 Guest Additions and common APT packages to speed up Chef converge"
}
variable "disk_size" {
  type = number
  default = 65536
}
variable "guest_additions_url" {
  type = string
  default = ""
}
variable "headless" {
  type = bool
  default = false
}
variable "http_proxy" {
  type = string
  default = "${env("http_proxy")}"
}
variable "https_proxy" {
  type = string
  default = "${env("https_proxy")}"
}
variable "iso_checksum" {
  type = string
  default = "10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
}
variable "iso_name" {
  type = string
  default = "ubuntu-22.04.1-live-server-amd64.iso"
}
variable "memory" {
  type = number
  default = 1024
}
variable "mirror" {
  type = string
  default = "https://releases.ubuntu.com"
}
variable "mirror_directory" {
  type = string
  default = "releases/jammy"
}
variable "no_proxy" {
  type = string
  default = "${env("no_proxy")}"
}
variable "preseed_path" {
  type = string
  default = "preseed.cfg"
}
variable "template" {
  type = string
  default = "ubuntu-22.04-live-amd64"
}
variable "vagrantcloud_token" {
  type = string
  default = "${env("VAGRANTCLOUD_TOKEN")}"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# All locals variables are generated from variables that uses expressions
# that are not allowed in HCL2 variables.
# Read the documentation for locals blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/locals
locals {
  http_directory = "${path.root}/http"
  version        = "1.0.${local.timestamp}"
}

##################################################################################
# SOURCE
##################################################################################

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "virtualbox-iso" "ubuntu" {
  boot_command = [
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    " <wait>",
    "c",
    "<wait>",
    "set gfxpayload=keep",
    "<enter><wait>",
    "linux /casper/vmlinuz quiet<wait>",
    " autoinstall<wait>",
    " ds=nocloud-net<wait>",
    "\\;s=http://<wait>",
    "{{.HTTPIP}}<wait>",
    ":{{.HTTPPort}}/<wait>",
    " ---",
    "<enter><wait>",
    "initrd /casper/initrd<wait>",
    "<enter><wait>",
    "boot<enter><wait>"
  ]
  boot_wait               = "5s"
  cpus                    = "${var.cpus}"
  disk_size               = "${var.disk_size}"
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_additions_url     = "${var.guest_additions_url}"
  guest_os_type           = "Ubuntu_64"
  hard_drive_interface    = "sata"
  headless                = "${var.headless}"
  http_directory          = "${local.http_directory}"
  iso_checksum            = "${var.iso_checksum}"
  iso_url                 = "${var.mirror}/${var.mirror_directory}/${var.iso_name}"
  memory                  = "${var.memory}"
  output_directory        = "${var.build_directory}/packer-${var.template}-virtualbox"
  sata_port_count         = "4"
  shutdown_command        = "echo 'vagrant' | sudo -S shutdown -P now"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_timeout             = "10000s"
  ssh_username            = "vagrant"
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.template}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    environment_vars  = ["HOME_DIR=/home/vagrant", "http_proxy=${var.http_proxy}", "https_proxy=${var.https_proxy}", "no_proxy=${var.no_proxy}"]
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    expect_disconnect = true
    scripts           = ["${path.root}/scripts/update.sh", "${path.root}/_common/sshd.sh", "${path.root}/scripts/networking.sh", "${path.root}/scripts/sudoers.sh", "${path.root}/scripts/vagrant.sh", "${path.root}/_common/virtualbox.sh", "${path.root}/scripts/cleanup.sh", "${path.root}/scripts/ecodev_deps.sh", "${path.root}/_common/minimize.sh"]
  }

  post-processors {
    post-processor "vagrant" {
    }
    post-processor "vagrant-cloud" {
      access_token        = "${var.vagrantcloud_token}"
      box_tag             = "Ecodev/ubuntu-server-2204"
      version             = "${local.version}"
      version_description = "${var.description}"
    }
  }
}
