#!/bin/bash

sudo /usr/sbin/useradd -m ghrunner
cd /home/ghrunner
sudo mkdir -p workdir/actions-runner && cd workdir/actions-runner
sudo curl -O -L https://github.com/actions/runner/releases/download/v$RUNNER_VERSION/actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
sudo tar xzf ./actions-runner-linux-x64-$RUNNER_VERSION.tar.gz
sudo chown -R ghrunner ~ghrunner

sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*
sudo dpkg --configure -a

sudo /home/ghrunner/workdir/actions-runner/bin/installdependencies.sh