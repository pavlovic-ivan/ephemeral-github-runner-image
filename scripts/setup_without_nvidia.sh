#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "[INFO] > Disable unattended upgrades services"
systemctl disable --now unattended-upgrades.service

echo "[INFO] > Creating user runner with home directory"
/usr/sbin/useradd -m runner
mkdir ~runner/runner

echo "[INFO] > Installing GitHub Actions runner"
curl --silent -fsSL https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz | tar -C ~runner/runner -xzf -
chown -R runner:runner ~runner/runner

echo "[INFO] > Installing packages"
curl --silent -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

curl --silent -LO "https://dl.k8s.io/release/$(curl --silent -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl" 
install -o runner -g runner -m 0755 kubectl /usr/local/bin/kubectl

apt update -qq -y && apt-cache policy docker-ce && apt install -qq -y dotnet-sdk-7.0 dotnet-runtime-7.0 git docker-ce build-essential golang-go unzip -o Dpkg::Options::="--force-confold" 
usermod -aG docker runner

if [ "$(dpkg --print-architecture)" == "amd64" ]; then
  wget https://github.com/magefile/mage/releases/download/v1.15.0/mage_1.15.0_Linux-64bit.tar.gz --quiet
  wget https://github.com/protocolbuffers/protobuf/releases/download/v23.3/protoc-23.3-linux-x86_64.zip --quiet
  tar -xf mage_1.15.0_Linux-64bit.tar.gz
  unzip protoc-23.3-linux-x86_64.zip
elif [ "$(dpkg --print-architecture)" == "arm64" ]; then
  wget https://github.com/magefile/mage/releases/download/v1.15.0/mage_1.15.0_Linux-ARM.tar.gz --quiet
  wget https://github.com/protocolbuffers/protobuf/releases/download/v23.3/protoc-23.3-linux-aarch_64.zip --quiet
  tar -xf mage_1.15.0_Linux-ARM.tar.gz
  unzip protoc-23.3-linux-aarch_64.zip
else
  echo "Unfamiliar architecture - please use `arm64` or `amd64`"
fi

mv mage /usr/local/bin
mv bin/protoc /usr/local/bin/

docker  --version
gcc --version
go version
kubectl version
mage -version
protoc --version
