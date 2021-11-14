packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

variable "project" {
    type = string
}

variable "zone" {
    type = string
}

variable "source_image_project_id" {
    type = list(string)
}

variable "disk_size" {
    type = number
}

variable "source_image_family" {
    type = string
}

variable "source_image" {
    type = string
}

variable "ghrunner_version" {
    type = string
}

source "googlecompute" "runner_machine_image" {
  project_id                = var.project
  image_name                = format("%s-ghr%s", var.source_image, replace(var.ghrunner_version, ".", ""))
  ssh_username              = "packer"
  source_image              = var.source_image
  source_image_family       = var.source_image_family
  source_image_project_id   = var.source_image_project_id
  zone                      = var.zone
  disk_size                 = var.disk_size
}

build {
  sources = [ "source.googlecompute.runner_machine_image" ]
}