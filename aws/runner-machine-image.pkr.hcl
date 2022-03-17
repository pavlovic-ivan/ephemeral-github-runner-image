packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-instance" "runner_machine_image" {
  region                          = var.region
  source_ami                      = var.source_ami
  instance_type                   = var.instance_type
  s3_bucket                       = var.bucket_name
  ami_name                      = format("%s-ghr%s-nv%s", var.source_image, replace(var.runner_version, ".", ""), replace(var.nvidia_version, ".", ""))
  image_family                    = var.image_family
  ssh_username                    = "packer"
}

build {
  sources = ["source.amazon-instance.runner_machine_image"]

  provisioner "shell" {
    environment_vars = [
      "RUNNER_VERSION=${var.runner_version}",
      "NVIDIA_VERSION=${var.nvidia_version}"
    ]
    script          = "../scripts/setup.sh"
    execute_command = "chmod +x {{ .Path }}; sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }

}