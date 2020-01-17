FROM trion/ng-cli:8.3.22
MAINTAINER Jason Potter <jason@rewardle.com>
USER root

# RUN apt-get -yq update 

RUN apt-get install python3-pip

RUN pip3 install awscli 
RUN pip3 install boto3 
RUN pip3 install docker-compose 


RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
RUN aws configure set region ap-southeast-2

WORKDIR /app
ENV GOPATH /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
