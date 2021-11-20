#!/bin/bash

echo "[INFO] > Disabling google-c2d-startup.service"
systemctl disable --now google-c2d-startup.service
dpkg --configure -a

echo "[INFO] > Installing deeplearning drivers"
/opt/deeplearning/install-driver.sh

echo "[INFO] > Creating user ghrunner with home directory"
/usr/sbin/useradd -m ghrunner
cd /home/ghrunner
mkdir -p workdir/actions-runner && cd workdir/actions-runner

echo "[INFO] > Downloading runner tar archive from Github"
curl -O -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
tar xzf ./actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
rm actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
chown -R ghrunner ~ghrunner

echo "[INFO] > Installing runner dependencies"
/home/ghrunner/workdir/actions-runner/bin/installdependencies.sh