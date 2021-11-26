[![Build Workflow](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions/workflows/build.yaml/badge.svg?style=flat)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions)
[![lint](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions/workflows/lint.yaml/badge.svg)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/actions)
[![release](https://badgen.net/github/release/pavlovic-ivan/ephemeral-github-runner-image-gcp?icon=github&color=cyan)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/releases/tag/v2.283.3)
[![releases](https://badgen.net/github/releases/pavlovic-ivan/ephemeral-github-runner-image-gcp?icon=github&color=orange)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/releases)
[![licence](https://badgen.net/github/license/pavlovic-ivan/ephemeral-github-runner-image-gcp?icon=github)](https://github.com/pavlovic-ivan/ephemeral-github-runner-image-gcp/blob/main/LICENSE.md)
[![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

# Introduction

This repository is used to build GCP Machine Image for Github Ephemeral Runner using Packer. Image is based on Debian 10, with CUDA v1.13 installed. This repository bakes in the Github Runner `v2.283.3`, with its dependencies installed. Check [Usage](#usage) section for how to use this image within your IaaC.

# Guidelines

Github Workflow is run only on tag push. Tags are based on main branch. After accepting a pull request, tag should be created and named in the format `v<github_runner_version>`, eg: `v2.283.3`. Workflow will read the tag name, and use it to build the artifact image. Github Runner versions are available in the [download section](https://github.com/actions/runner/releases).

# Usage

This VM Machine Image will:
- create `ghrunner` user and it's home directory
- create working directory inside the home directory: `/home/ghrunner/workdir/actions-runner`
- inside the working directory unpack the Github Runner package with available bash scripts:
    - `config.sh`
    - `run.sh`

Here is the example systemd service that registers and runs the Github Runner in Ephemeral mode:
```
[Unit]
Description=Register GitHub Runner

[Service]
User=ghrunner
Type=oneshot
WorkingDirectory=/home/ghrunner/workdir/actions-runner
ExecStartPre=-/bin/bash -c "/home/ghrunner/workdir/actions-runner/config.sh \
    --url https://github.com/{{repoOwner}}/{{repo}} \
    --token {{token}} \
    --name {{ghRunnerName}} \
    --work _work \
    --runnergroup default \
    --labels self-hosted \
    --ephemeral"
ExecStart=-/bin/bash -c "/home/ghrunner/workdir/actions-runner/run.sh"

[Install]
WantedBy=multi-user.target
```