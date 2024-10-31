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

variable "http_proxy" {
  type = string
  default = "${env("http_proxy")}"
}
variable "https_proxy" {
  type = string
  default = "${env("https_proxy")}"
}
variable "no_proxy" {
  type = string
  default = "${env("no_proxy")}"
}
variable "template" {
  type = string
  default = "ubuntu-22.04-live-amd64"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# All locals variables are generated from variables that uses expressions
# that are not allowed in HCL2 variables.
# Read the documentation for locals blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/locals
locals {
  version = "1.0.${local.timestamp}"
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
  cpus                    = 2
  disk_size               = 65536
  guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type           = "Ubuntu_64"
  hard_drive_interface    = "sata"
  headless                = false
  http_directory          = "${path.root}/http"
  iso_url                 = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"
  iso_checksum            = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"
  memory                  = 2048
  output_directory        = "builds/packer-${var.template}-virtualbox"
  sata_port_count         = "4"
  shutdown_command        = "echo 'vagrant' | sudo -S /sbin/halt -h -p"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_timeout             = "15m"
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
    scripts           = [
      "${path.root}/scripts/update.sh",
      "${path.root}/_common/sshd.sh",
      "${path.root}/scripts/networking.sh",
      "${path.root}/scripts/sudoers.sh",
      "${path.root}/_common/vagrant.sh",
      "${path.root}/scripts/systemd.sh",
      "${path.root}/_common/virtualbox.sh",
      "${path.root}/scripts/cleanup.sh",
      "${path.root}/scripts/ecodev_deps.sh",
      "${path.root}/_common/minimize.sh"
    ]
  }

  post-processors {
    post-processor "vagrant" {
    }
    post-processor "vagrant-registry" {
      box_tag             = "Ecodev/ubuntu-server-2204"
      version             = "${local.version}"
      version_description = "This box includes cinc-client 17.10.165, Ubuntu Live Server 22.04.5, Virtualbox 7.0 Guest Additions and common APT packages to speed up Cinc converge"
    }
  }
}
