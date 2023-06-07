#!/bin/bash -ex

NEXUS_IMAGE_VERSION=3.52.0
CRED_FILE_PATH=/nexus-data/admin.password

install_docker() {
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt update && apt-cache policy docker-ce && apt-get install -y docker-ce
}

check_nexus_creds() {
    CREDS="docker exec -it nexus /bin/cat $1"
    while ! $CREDS; do
        echo "Secrets not found, sleep 15 ..."
        sleep 15
    done
    echo $CREDS | sed 's/\(.*\)docker.*/\1/' > ~/nexus-creds
}

start_nexus() {
    docker pull sonatype/nexus3:$NEXUS_IMAGE_VERSION
    docker run -d --name=nexus -p 8081:8081 -p 8085:8085 sonatype/nexus3:$NEXUS_IMAGE_VERSION
    check_nexus_creds $CRED_FILE_PATH
}

apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common

install_docker
systemctl start docker
start_nexus

# docker build . -t localhost:8085/test:latest
# docker push localhost:8085/test:latest
# test for pipeline