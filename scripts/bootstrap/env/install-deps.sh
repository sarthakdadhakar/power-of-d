#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

remote_home=$1
sudo apt-get update
sudo apt --yes install libevent-dev
echo "----------------- Running rdma script ------------------------"
echo "rdma script: $remote_home/scripts/env/setup-rdma.sh"
bash $remote_home/scripts/env/setup-rdma.sh

sudo apt-get --yes install libgflags-dev
sudo apt-get --yes install cmake

#cd /tmp/
#wget https://github.com/fmtlib/fmt/releases/download/6.1.2/fmt-6.1.2.zip
#rm -rf fmt-6.1.2
#unzip fmt-6.1.2.zip
#cd fmt-6.1.2/ && cmake . && make -j32 && sudo make install
