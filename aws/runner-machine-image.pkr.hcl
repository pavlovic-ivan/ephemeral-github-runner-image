packer {
  required_plugins {
    amazon = {
      version = ">=0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "runner_machine_image" {
  ami_name      = format("%s-%s-%s", var.gr_oss_image_name, replace(trim(var.runner_version, "v"), ".", ""), var.arch)
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = var.source_image
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = [ var.image_owner ]
  }
  ssh_username = "ubuntu"
}


build {
  sources = [
    "source.amazon-ebs.runner_machine_image"
  ]

  provisioner "shell" {
    environment_vars = [
      "RUNNER_VERSION=${trim(var.runner_version, "v")}",
      "NVIDIA_MAJOR_VERSION=${var.nvidia_major_version}",
      "ARCH=${var.arch == "amd64" ? "x64" : var.arch}"
    ]
    script          = "${path.cwd}/scripts/${var.script}"
    execute_command = "chmod +x {{ .Path }}; sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }
}