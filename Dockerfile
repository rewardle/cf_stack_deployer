FROM debian:jessie
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update \
  && apt-get -yq install git groff less python python-pip \
  && pip install awscli \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN aws configure set region ap-southeast-2

WORKDIR /app

ADD deploy.sh /app/deploy.sh
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
