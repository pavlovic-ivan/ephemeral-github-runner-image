#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "[INFO] > Disable unattended upgrades services"
systemctl disable --now unattended-upgrades.service

echo "[INFO] > Install base packages"
apt-get update
apt-get install -y sudo build-essential ubuntu-drivers-common

echo "[INFO] > Installing NVIDIA drivers"
ubuntu-drivers autoinstall
apt install -y nvidia-driver-${NVIDIA_MAJOR_VERSION}
apt autoremove -y

echo "[INFO] > Creating user runner with home directory"
/usr/sbin/useradd -m runner
mkdir ~runner/runner
echo "runner ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/runner

echo "[INFO] > Installing GitHub Actions runner"
curl -fsSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz | tar -C ~runner/runner -xzf -
chown -R runner:runner ~runner/runner

echo "[INFO] > Installing GitHub Actions runner dependencies"
~runner/runner/bin/installdependencies.sh


echo "[INFO] > Creating dotnet install directory with the correct permissions"
mkdir -p /usr/share/dotnet
chown -R runner:runner /usr/share/dotnet