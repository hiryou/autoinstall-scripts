#!/bin/bash
# See NVIDIA driver x CUDA compatibility https://docs.nvidia.com/deploy/cuda-compatibility/index.html#deployment-consideration-forward
# See pytorch versions according to CUDA version https://pytorch.org/

# This script will install: nvidia driver 515 & related packages
# => suggested: CUDA 11.7 => suggested: pytorch 1.13.1
# NVIDIA driver must be installed on the host according to https://docs.docker.com/config/containers/resource_constraints/#gpu
# CUDA & pytorch may/can be installed later on the container

# purge old driver packages to be sure
apt-get purge -y nvidia*
echo '----------------------------------------------------------------------------'
apt-get autoremove -y
apt-get autoclean -y
rm -rf /usr/local/cuda*
echo '----------------------------------------------------------------------------'

# install driver
modprobe -r nouveau
# apt install -y nvidia-driver-515 nvidia-headless-515 nvidia-utils-515 # do NOT need GUI driver for headless server
apt install -y nvidia-headless-515-server nvidia-utils-515-server
modprobe -i nvidia
echo '----------------------------------------------------------------------------'

# Install nvidia-container-runtime. This is to allow containers to access host GPUs
# see https://docs.docker.com/config/containers/resource_constraints/#access-an-nvidia-gpu
# must add NVIDIA repository https://nvidia.github.io/nvidia-container-runtime/
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
  tee /etc/apt/sources.list.d/nvidia-container-runtime.list
apt-get update
echo '----------------------------------------------------------------------------'
apt-get install -y nvidia-container-runtime
echo '----------------------------------------------------------------------------'
which nvidia-container-runtime-hook
service docker restart


