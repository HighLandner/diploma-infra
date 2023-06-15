#!/bin/bash -ex

install_docker() {
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt update && apt-cache policy docker-ce && apt-get install -y docker-ce
}

install_docker
systemctl start docker

