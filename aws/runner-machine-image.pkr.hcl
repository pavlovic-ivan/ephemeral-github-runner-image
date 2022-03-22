packer {
  required_plugins {
    amazon = {
      version = ">=0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "runner_machine_image" {
  ami_name      = format("%s-ghr%s-nv%s", regex_replace(var.source_image, "(ubuntu/images/\\*)|(-\\*)|(\\.)", "" ), replace(var.runner_version, ".", ""), replace(var.nvidia_version, ".", ""))
  instance_type = var.instance_type
  region        = var.region
  source_ami_filter {
    filters = {
      name                = var.source_image
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
  run_tags = {
      Name = "ghrunner"
  }
  tags = {
      Name = "ghrunner"
  }

}


build {
  name = "ghrunner"
  sources = [
    "source.amazon-ebs.runner_machine_image"
  ]

  provisioner "shell" {
    environment_vars = [
      "RUNNER_VERSION=${var.runner_version}",
      "NVIDIA_VERSION=${var.nvidia_version}"
    ]
    script          = "../scripts/setup.sh"
    execute_command = "chmod +x {{ .Path }}; sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }
}