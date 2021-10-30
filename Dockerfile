FROM nikolaik/python-nodejs:python3.7-nodejs10
LABEL org.opencontainers.image.authors="Jason Potter <jason@rewardle.com>"

RUN apt-get -yq update 
RUN apt-get -yq install git zip groff less wget curl 
RUN apt-get -yq install libyaml-dev libssl-dev libunwind8 
RUN apt-get -yq install jq golang  gettext build-essential


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

RUN wget --directory-prefix=/tmp/ http://mirrordirector.raspbian.org/raspbian/pool/main/libu/libunwind/libunwind8_1.1-4.1_armhf.deb \
  && dpkg -I /tmp/libunwind8_1.1-4.1_armhf.deb

RUN curl -sL https://github.com/apex/apex/releases/download/v0.8.0/apex_linux_amd64 -o /usr/local/bin/apex \
  && chmod +x /usr/local/bin/apex

# Dotnet SDK Install - START

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget -q https://packages.microsoft.com/config/debian/9/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN apt-get -yq update
RUN apt-get -yq install dotnet-sdk-2.1

# Dotnet SDK Install - END

# Node Packages Install- START

RUN npm install -g serverless@1.53.0 

# Node Packages Install- END
RUN sh -c 'bust cache'
RUN pip3 install git+https://github.com/rewardle/rainbow.git@python3port

RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
RUN aws configure set region ap-southeast-2

WORKDIR /app
ENV GOPATH /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
