FROM debian:jessie
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update \
  && apt-get -yq install git groff less python python-dev python-pip libyaml-dev jq curl golang libunwind8 gettext wget \
  && pip install awscli boto3 \
  && pip install git+https://github.com/rewardle/rainbow.git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget --directory-prefix=/tmp/ http://mirrordirector.raspbian.org/raspbian/pool/main/libu/libunwind/libunwind8_1.1-4.1_armhf.deb \
  && dpkg -I /tmp/libunwind8_1.1-4.1_armhf.deb 

RUN curl -sL https://github.com/apex/apex/releases/download/v0.8.0/apex_linux_amd64 -o /usr/local/bin/apex \
  && chmod +x /usr/local/bin/apex

RUN curl -sSL -o /tmp/dotnet.tar.gz https://go.microsoft.com/fwlink/?linkid=843453 \
  && mkdir -p /opt/dotnet \
  && tar zxf /tmp/dotnet.tar.gz -C /opt/dotnet \
  && ln -s /opt/dotnet/dotnet /usr/local/bin \
  && rm -rf /tmp/*

RUN aws configure set region ap-southeast-2

WORKDIR /app
ENV GOPATH /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]