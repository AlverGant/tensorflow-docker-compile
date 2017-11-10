#!/bin/bash
# Author: Alvinho - P&D - DTPD

# Ubuntu 16.04 x86-64 - Xenial Xerus - minimum RAM 4GB

# Update OS
sudo apt -y update
sudo apt -y upgrade

# Install Base image pre-requisites
sudo apt install -y python-dev \
software-properties-common git vim \
cmake libfreetype6-dev feh \
apt-transport-https ca-certificates curl

# Install docker Community Edition
cd ~
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt -y update
sudo apt install -y docker-ce

sudo apt-get -y autoremove

# Create project directory
mkdir "$HOME"/tensorflow-cpu
cd "$HOME"/tensorflow-cpu
# Create DockerFile
wget -c https://raw.githubusercontent.com/AlverGant/tensorflow-docker-compile/master/Dockerfile -O Dockerfile

# "compile" docker images
sudo docker build -t tensorflow-cpu .

# Create directories and populate with test images
mkdir "$HOME"/images_input
cd "$HOME"/images_input
# Grab some test images, keep the largest ones
wget -nd -H -p -A jpg -e robots=off epicantus.tumblr.com/page/{1..1}
rm *500.jpg
mkdir "$HOME"/images_output

# Run docker with GPU support, removing old instances and mapping ~/images_input to /input inside container as read-only
# map ~/images_output to /output inside container
# This container stylizes images on ~/images_input to ~/images_output and gracefully exits
cd "$HOME"/tensorflow-cpu
sudo docker run --rm -v "$HOME"/images_input:/input:ro -v "$HOME"/images_output:/output -it tensorflow-cpu

# When using docker toolbox, reset base machine resources
# docker-machine rm default
# docker-machine create -d virtualbox --virtualbox-cpu-count=12 --virtualbox-memory=12288 --virtualbox-disk-size=50000 default
# docker-machine stop
# exit
