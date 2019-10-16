FROM debian:stretch
LABEL Maintainer="Kevin Littlejohn <kevin@littlejohn.id.au>" 

RUN apt-get -yq update
RUN apt-get -yq install python-pip
RUN apt-get -yq install git jq
RUN pip install awscli boto3 docker-compose
RUN aws configure set region ap-southeast-2

RUN pip install git+https://github.com/rewardle/rainbow.git@2a61cf9fa5f5238b51d2970cfbf1332a7cf6e817
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
