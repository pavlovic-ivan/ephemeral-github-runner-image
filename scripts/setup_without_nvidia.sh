#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "[INFO] > Disable unattended upgrades services"
systemctl disable --now unattended-upgrades.service

echo "[INFO] > Creating user runner with home directory"
/usr/sbin/useradd -m runner
mkdir ~runner/runner

echo "[INFO] > Installing GitHub Actions runner"
curl -fsSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz | tar -C ~runner/runner -xzf -
chown -R runner:runner ~runner/runner

echo "[INFO] > Installing packages"
# curl -L -o /tmp/powershell.tar.gz https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/powershell-7.3.6-linux-arm64.tar.gz
# mkdir -p /opt/microsoft/powershell/7
# tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
# chmod +x /opt/microsoft/powershell/7/pwsh
# ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
# chown -R runner:runner /usr/bin/pwsh

mkdir -p /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION}
curl -fsSL https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_FULL_VERSION}/powershell-${POWERSHELL_FULL_VERSION}-linux-${ARCH}.tar.gz | tar -C /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION} -xzf -
chown -R root:root /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION}
ln -s /opt/microsoft/powershell/${POWERSHELL_MAJOR_VERSION}/pwsh /usr/bin/
chmod -h 755 /usr/bin/pwsh
chown -R runner:runner /usr/share