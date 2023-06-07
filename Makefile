BASE_IMAGE=npm-app:0.1
NEXUS_IMAGE_VERSION=3.52.0
JENKINS_IMAGE_TAG=jenkins:0.0.1

jenkins:
	@docker run -itd --name=jenkins --rm -p 8080:8080 ${JENKINS_IMAGE_TAG}
	@sleep 10 && docker exec -it jenkins /bin/cat /var/jenkins_home/secrets/initialAdminPassword

nexus:
	@docker run -itd --name=nexus -p 8081:8081 -p 8085:8085 sonatype/nexus3:${NEXUS_IMAGE_VERSION}

npm-app:
	@docker run -itd --name=npm-app -p 3000:3000 ${BASE_IMAGE}
