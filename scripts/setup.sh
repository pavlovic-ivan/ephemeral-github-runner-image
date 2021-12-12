#!/bin/bash

echo "[INFO] > Prepare the system before installing drivers"
apt-get install -y gcc make pkg-config

echo "[INFO] > Installing deeplearning drivers"
curl -O -L $DRIVERS_URL/$DRIVERS_SCRIPT
chmod +x $DRIVERS_SCRIPT
./$DRIVERS_SCRIPT -s

echo "[INFO] > Creating user ghrunner with home directory"
/usr/sbin/useradd -m ghrunner
cd /home/ghrunner
mkdir -p workdir/actions-runner && cd workdir/actions-runner

echo "[INFO] > Downloading runner tar archive from Github"
ARCHIVE=actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
curl -O -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/$ARCHIVE
tar xzf ./$ARCHIVE
rm $ARCHIVE
chown -R ghrunner ~ghrunner

echo "[INFO] > Installing runner dependencies"
/home/ghrunner/workdir/actions-runner/bin/installdependencies.sh