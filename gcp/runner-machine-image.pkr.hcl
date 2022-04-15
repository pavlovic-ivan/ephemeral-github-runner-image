packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "runner_machine_image" {
  project_id                      = var.project
  image_name                      = format("%s-ghr%s-nv%s", var.source_image, replace(var.runner_version, ".", ""), replace(var.nvidia_version, ".", ""))
  image_family                    = var.image_family
  ssh_username                    = "packer"
  source_image                    = var.source_image
  source_image_project_id         = [var.source_image_project_id]
  zone                            = var.zone
  machine_type                    = var.machine_type
  preemptible                     = "true"
  disable_default_service_account = "true"
}

build {
  sources = ["source.googlecompute.runner_machine_image"]

  provisioner "shell" {
    environment_vars = [
      "RUNNER_VERSION=${var.runner_version}",
      "NVIDIA_VERSION=${var.nvidia_version}"
    ]
    script          = "scripts/setup.sh"
    execute_command = "chmod +x {{ .Path }}; sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }

}