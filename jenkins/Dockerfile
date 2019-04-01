ARG jenkins_ver=lts
ARG terraform_ver="0.11.13"

FROM jenkins/jenkins:${jenkins_ver}

# To run apt
USER root

RUN apt-get update && apt-get install -y apt-transport-https && rm -rf /var/lib/apt/lists/*

# configure Microsoft's repository
RUN set -x \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list' \
    && apt-get update



# install docker
RUN apt-get update -qq \
    && apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update  -qq \
    && apt-get install docker-ce=17.12.1~ce-0~debian -y \
    && usermod -aG docker jenkins

# install .net core
RUN apt-get install -y apt-transport-https \
    && apt-get install -y dotnet-sdk-2.2 \
    dotnet --version

# Install PowerShell
RUN apt-get install -y powershell \
    && mv /usr/bin/pwsh /usr/bin/powershell \
    && powershell -version


# install terraform
RUN set -x \
  && tf_version="0.11.13" \
  && curl -O "https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip" \
  && unzip terraform_${tf_version}_linux_amd64.zip \
  && rm -rf terraform_${tf_version}_linux_amd64.zip \
  && mv terraform /usr/bin \
  && terraform version

# install npm
RUN apt-get install curl software-properties-common \
    && curl -sL https://deb.nodesource.com/setup_10.x | sudo bash - \
    && apt-get install nodejs \
    && node -v


# configure jenkins
RUN /usr/local/bin/install-plugins.sh git \
                                      matrix-auth \
                                      workflow-aggregator \
                                      docker-workflow \
                                      credentials-binding \
                                      blueocean \
                                      blueocean-github-pipeline \ 
                                      workflow-durable-task-step

ENV JENKINS_USER admin
ENV JENKINS_PASS admin

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/


USER jenkins