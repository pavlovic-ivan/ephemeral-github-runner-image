[![Build Workflow](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions/workflows/build.yaml/badge.svg?style=flat)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions)
[![lint](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions/workflows/lint.yaml/badge.svg)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions)
[![release](https://badgen.net/github/release/pavlovic-ivan/ephemeral-github-runner-image-gcp?icon=github&color=cyan)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/releases/tag/v2.283.3)
[![releases](https://badgen.net/github/releases/pavlovic-ivan/ephemeral-github-runner-image-gcp?icon=github&color=orange)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/releases)
[![licence](https://badgen.net/github/license/pavlovic-ivan/ephemeral-github-runner-image-gcp?icon=github)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/blob/main/LICENSE.md)
[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

# Introduction

This repository is used to build a GCP Machine Image for ephemeral Github Actions self-hosted runners using Packer. The image is based on Ubuntu 20.04 v20220308, with NVIDIA drivers v510.47.03 and [GitHub Actions Runner](https://github.com/actions/runner) v2.288.1. Check [Usage](#usage) section for how to use this image within your IaaC.

# Guidelines

## Local development

For local development, you can use Visual Studio Code dev container to [open your local checkout in a container](https://code.visualstudio.com/docs/remote/containers#_quick-start-open-an-existing-folder-in-a-container).

You will then need to init Packer with:
```sh
packer init .
```

The next step is to [create a GCP service account](https://www.packer.io/plugins/builders/googlecompute#running-outside-of-google-cloud) and save its credentials in JSON format as `gcp.json`.

You can then create a local `.env` file with the following content:
```sh
export GOOGLE_APPLICATION_CREDENTIALS=gcp.json
export PKR_VAR_project=<your GCP project ID>
```

Finally you can build the image with:
```sh
packer build .
```

## CI

Github Actions workflow runs only on push to `main`, and will automatically build and publish the new image.

# Usage

This VM Machine Image will:
- create `runner` user and it's home directory
- create working directory inside the home directory: `/home/runner/runner`
- inside the working directory unpack the Github Actions Runner package with available bash scripts:
    - `config.sh`
    - `run.sh`

Here is an example script that registers and runs the Github Actions Runner in ephemeral mode:
```sh
su - runner -c "cd runner && \
                  ./config.sh \
                    --url https://github.com/{{owner}}/{{repo}} \
                    --token {{token}} \
                    --labels {{labels}} \
                    --disableupdate \
                    --unattended \
                    --ephemeral"

cd ~runner/runner
./svc.sh install runner
./svc.sh start
```