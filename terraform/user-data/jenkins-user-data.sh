#!/bin/bash -ex

CRED_FILE_PATH=/var/jenkins_home/secrets/initialAdminPassword
JENKINS_IMAGE_VERSION=0.0.1

install_docker() {
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt update && apt-cache policy docker-ce && apt-get install -y docker-ce
}

check_jenkins_creds() {
    CREDS="docker exec -it jenkins /bin/cat $1"
    while ! $CREDS; do
        echo "Secrets not found, sleep 15 ..."
        sleep 15
    done
    echo $CREDS | sed 's/\(.*\)docker.*/\1/' > ~/jenkins-creds
}

start_jenkins() {
    docker pull $JENKINS_IMAGE_VERSION
    docker run -d --name=jenkins -p 8080:8080 dockerddddd12tfgqv/jenkins:$JENKINS_IMAGE_VERSION
    check_jenkins_creds $CRED_FILE_PATH
}

install_docker
systemctl start docker
start_jenkins
