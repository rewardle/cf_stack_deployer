FROM node:12-alpine

RUN apk add --no-cache \
  python \
  py-pip \
  py-setuptools \
  ca-certificates \
  groff \
  less \
  coreutils \
  bash 

RUN pip install --no-cache-dir --upgrade pip awscli


RUN npm install -g npm@latest
RUN npm install -g serverless@1.74.1
RUN npm install -g serverless-plugin-lambda-dead-letter@1.2.1
RUN npm install -g serverless-pseudo-parameters@2.5.0
RUN npm install -g serverless-plugin-log-retention@2.0.0
RUN npm install -g serverless-latest-layer-version@2.1.0
RUN npm install -g serverless-domain-manager@3.3.2

ENTRYPOINT ["/bin/bash", "-c"] 
