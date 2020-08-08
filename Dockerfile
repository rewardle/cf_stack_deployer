FROM amazonlinux
MAINTAINER Jason Potter <jason@rewardle.com>

RUN yum install awscli -y
RUN yum install python3 -y
RUN yum install git
RUN pip3 install git+https://github.com/rewardle/rainbow.git
RUN pip3 install boto3

  
RUN aws configure set region ap-southeast-2

WORKDIR /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
