FROM node:10-jessie
MAINTAINER Jason Potter <jason@rewardle.com>

RUN apt-get -yq update 
RUN apt-get -yq install git zip groff less wget curl 
RUN apt-get -yq install libyaml-dev libssl-dev libunwind8 
RUN apt-get -yq install jq golang  gettext build-essential nodejs-legacy apt-transport-https

# python 3.6.9
# install prerequisite packages for pyathon 3.6.9
RUN apt-get install -yq make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev

# download, build and install python 3.6.9
RUN wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz \
    && tar xvf Python-3.6.9.tgz \
    && cd Python-3.6.9 \
    && ./configure --enable-optimizations --with-ensurepip=install \
    && make -j2 \
    && make altinstall

RUN apt-get -yq install python3-setuptools

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get -yq update
RUN apt-get -yq install google-chrome-stable

#RUN apt-get -yq install python-pip && easy_install -U pip
RUN pip3 install --upgrade virtualenv
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools 
RUN pip3 install awscli 
RUN pip3 install boto3 
RUN pip3 install docker-compose 
RUN pip3 install git+https://github.com/rewardle/rainbow.git


RUN wget --directory-prefix=/tmp/ http://mirrordirector.raspbian.org/raspbian/pool/main/libu/libunwind/libunwind8_1.1-4.1_armhf.deb \
  && dpkg -I /tmp/libunwind8_1.1-4.1_armhf.deb

RUN curl -sL https://github.com/apex/apex/releases/download/v0.8.0/apex_linux_amd64 -o /usr/local/bin/apex \
  && chmod +x /usr/local/bin/apex

# Dotnet SDK Install - START

#RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
#  && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

#RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-jessie-prod jessie main" > /etc/apt/sources.list.d/dotnetdev.list'

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget -q https://packages.microsoft.com/config/debian/8/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN apt-get -yq update
RUN apt-get -yq install dotnet-sdk-2.1

# Dotnet SDK Install - END

# Node Install - START

#WORKDIR /home/download
#ARG NODEREPO="node_10.x"
#ARG DISTRO="jessie"
# Only newest package kept in nodesource repo. Cannot pin to version using apt!
# See https://github.com/nodesource/distributions/issues/33
#RUN curl -sSO https://deb.nodesource.com/gpgkey/nodesource.gpg.key
#RUN apt-key add nodesource.gpg.key
#RUN echo "deb https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" > /etc/apt/sources.list.d/nodesource.list
#RUN echo "deb-src https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" >> /etc/apt/sources.list.d/nodesource.list
#RUN apt-get update -q && apt-get install -y 'nodejs=10.11.0*' && npm i -g npm

# Node Install - END

# Node Packages Install- START

RUN npm install -g serverless@1.40.0 
RUN npm install -g @angular/cli@6.2.3

# Node Packages Install- END

RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
RUN aws configure set region ap-southeast-2

WORKDIR /app
ENV GOPATH /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
