FROM debian:jessie
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update \
  && apt-get -yq install git groff less python python-dev python-pip libyaml-dev \
  && pip install awscli \
  && pip install git+https://github.com/rewardle/rainbow.git \
  #&& pip install rainbow-cfn \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN aws configure set region ap-southeast-2

WORKDIR /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
