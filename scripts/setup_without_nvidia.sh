#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "[INFO] > Disable unattended upgrades services"
systemctl disable --now unattended-upgrades.service

echo "[INFO] > Creating user runner with home directory"
/usr/sbin/useradd -m runner
mkdir ~runner/runner

echo "[INFO] > Installing GitHub Actions runner"
curl -fsSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz | tar -C ~runner/runner -xzf -
chown -R runner:runner ~runner/runner

echo "[INFO] > Installing GitHub Actions runner dependencies"
~runner/runner/bin/installdependencies.sh