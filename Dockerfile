# Jenkins image setup

FROM gcr.io/kaniko-project/executor:debug AS kaniko

FROM jenkinsci/jenkins:2.154-alpine

USER root

RUN apk -U add docker

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN apk add --update shadow nodejs npm \
    && groupadd -g 50 staff \
    && usermod -a -G staff jenkins
USER jenkins
COPY --from=kaniko /kaniko/ /kaniko/
COPY --from=kaniko /kaniko/warmer /kaniko/warmer
COPY --from=kaniko /kaniko/docker-credential-gcr /kaniko/docker-credential-gcr
COPY --from=kaniko /kaniko/docker-credential-ecr-login /kaniko/docker-credential-ecr-login
# COPY --from=kaniko /kaniko/docker-credential-acr /kaniko/docker-credential-acr
COPY --from=kaniko /kaniko/.docker /kaniko/.docker
COPY --from=busybox:1.32.0 /bin /busybox

ENV PATH $PATH:/usr/local/bin:/kaniko:/busybox
ENV DOCKER_CONFIG /kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG /kaniko/.config/gcloud/docker_credential_gcr_config.json

RUN CREDS=${/bin/cat /var/jenkins_home/secrets/initialAdminPassword} && \
    java -jar ./var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ -auth admin:$CREDS install-plugin git pipeline-utility-steps job-dsl credentials build-environment ssh-agent groovy && \
    java -jar ./var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ -auth admin:${CREDS} safe-restart

COPY resources/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY resources/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
USER root
