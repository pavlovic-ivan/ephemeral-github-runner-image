packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
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
  machine_type              = var.machine_type
  preemptible               = "true"
}

build {
  sources = [ "source.googlecompute.runner_machine_image" ]

  provisioner "shell" {
    environment_vars  = [ 
      "RUNNER_VERSION=${trimprefix(var.ghrunner_version, "v")}",
      "DRIVERS_URL=${var.drivers_url}",
      "DRIVERS_SCRIPT=${var.drivers_script}"
    ]
    script            = "scripts/setup.sh"
    execute_command   = "chmod +x {{ .Path }}; sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }

}