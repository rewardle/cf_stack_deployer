FROM debian:jessie
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update 
RUN apt-get -yq install git zip groff less python python-dev libyaml-dev jq curl golang libunwind8 gettext wget build-essential libssl-dev nodejs-legacy apt-transport-https

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get -yq update
RUN apt-get -yq install google-chrome-stable

RUN apt-get -yq install python-pip && easy_install -U pip
RUN pip install awscli boto3 docker-compose 
RUN pip install git+https://github.com/rewardle/rainbow.git
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --directory-prefix=/tmp/ http://mirrordirector.raspbian.org/raspbian/pool/main/libu/libunwind/libunwind8_1.1-4.1_armhf.deb \
  && dpkg -I /tmp/libunwind8_1.1-4.1_armhf.deb

RUN curl -sL https://github.com/apex/apex/releases/download/v0.8.0/apex_linux_amd64 -o /usr/local/bin/apex \
  && chmod +x /usr/local/bin/apex


# dotnet install - START

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
  && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-jessie-prod jessie main" > /etc/apt/sources.list.d/dotnetdev.list'

RUN apt-get -yq update
RUN apt-get -yq install dotnet-sdk-2.0.3
RUN apt-get -yq install dotnet-sdk-2.1.4

# dotnet install - END

# comment to trigger build

ENV NODE_6_VERSION 6.10.0
ENV NODE_4_VERSION 4.8.0
ENV NVM_DIR=/usr/local/nvm 
ENV CHROME_BIN=/usr/bin/google-chrome

RUN curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh -o /tmp/install_nvm.sh \
  &&  bash /tmp/install_nvm.sh -D=$NVM_DIR \
  && . ~/.bashrc \
  && nvm install $NODE_6_VERSION \
  && npm install serverless@1.32.0 -g \
  && nvm install $NODE_4_VERSION \
  && nvm alias default $NODE_6_VERSION \
  && ln -s /usr/local/nvm/versions/node/v6.10.0/bin/npm /usr/bin/npm \
  && rm -rf /tmp/*

RUN npm install -g @angular/cli@1.0.0
  
RUN aws configure set region ap-southeast-2

WORKDIR /app
ENV GOPATH /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
