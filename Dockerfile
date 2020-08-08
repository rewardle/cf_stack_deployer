FROM amazonlinux
MAINTAINER Jason Potter <jason@rewardle.com>

Run yum update -y
RUN yum install awscli -y
RUN yum install python3 -y
RUN yum install git -y
RUN pip3 install git+https://github.com/rewardle/rainbow.git
RUN pip3 install boto3

RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN install nodejs -y
RUN npm install -g npm@latest
RUN npm install -g serverless@1.74.1
RUN npm install -g serverless-plugin-lambda-dead-letter@1.2.1
RUN npm install -g serverless-pseudo-parameters@2.5.0
RUN npm install -g serverless-plugin-log-retention@2.0.0
RUN npm install -g serverless-latest-layer-version@2.1.0
RUN npm install -g serverless-domain-manager@3.3.2

RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
RUN yum install dotnet-sdk-2.1 -y

  
RUN aws configure set region ap-southeast-2

WORKDIR /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
