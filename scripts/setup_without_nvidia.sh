#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "[INFO] > Disable unattended upgrades services"
systemctl disable --now unattended-upgrades.service

echo "[INFO] > Install base packages"
apt-get update
apt-get install -y sudo

echo "[INFO] > Creating user runner with home directory"
/usr/sbin/useradd -m runner
mkdir ~runner/runner
echo "runner ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/runner

echo "[INFO] > Installing GitHub Actions runner"
curl -fsSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz | tar -C ~runner/runner -xzf -
chown -R runner:runner ~runner/runner

echo "[INFO] > Installing packages"
mkdir -p /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION}
curl -fsSL https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_FULL_VERSION}/powershell-${POWERSHELL_FULL_VERSION}-linux-${ARCH}.tar.gz | tar -C /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION} -xzf -
chown -R root:root /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION}
ln -s /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION}/pwsh /usr/bin/
chmod -h 755 /usr/bin/pwsh
chown -R runner:runner /usr/share
echo "[INFO] > Creating dotnet install directory with the correct permissions"
mkdir -p /usr/share/dotnet
chown -R runner:runner /usr/share/dotnet
