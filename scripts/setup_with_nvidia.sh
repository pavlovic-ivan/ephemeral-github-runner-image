#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "[INFO] > Disable unattended upgrades services"
systemctl disable --now unattended-upgrades.service

echo "[INFO] > Prepare the system before installing drivers"
apt-get update
apt-get install -y build-essential

echo "[INFO] > Disable Nouveau drivers"
cat <<EOF > /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
options nouveau modeset=0
EOF
sudo update-initramfs -u

echo "[INFO] > Installing NVIDIA drivers"
curl -o nvidia.run -fsSL https://us.download.nvidia.com/tesla/${NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run
sh nvidia.run --ui=none -q
rm nvidia.run

echo "[INFO] > Creating user runner with home directory"
/usr/sbin/useradd -m runner
mkdir ~runner/runner

echo "[INFO] > Installing GitHub Actions runner"
curl -fsSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz | tar -C ~runner/runner -xzf -
chown -R runner:runner ~runner/runner

echo "[INFO] > Installing GitHub Actions runner dependencies"
~runner/runner/bin/installdependencies.sh