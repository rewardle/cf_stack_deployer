FROM node:12-alpine

RUN apk add --no-cache \
  python \
  py-pip \
  py-setuptools \
  ca-certificates \
  groff \
  less \
  coreutils \
  bash \
  curl \
  zip

# dotnet Core dependencies
RUN apk add --no-cache icu-libs
RUN apk add --no-cache krb5-libs
RUN apk add --no-cache libgcc
RUN apk add --no-cache libintl
RUN apk add --no-cache libssl1.1
RUN apk add --no-cache libstdc++
RUN apk add --no-cache zlib

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin -Channel 2.1 -InstallDir /usr/share/dotnet 
RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# AWS cli
RUN pip install --no-cache-dir --upgrade pip awscli

# Node and serverless
RUN npm install -g npm@6.14.8
RUN npm install -g serverless@1.70.1
RUN npm install -g serverless-plugin-lambda-dead-letter@1.2.1
RUN npm install -g serverless-pseudo-parameters@2.5.0
RUN npm install -g serverless-plugin-log-retention@2.0.0
RUN npm install -g serverless-latest-layer-version@2.1.0
RUN npm install -g serverless-domain-manager@3.3.2

WORKDIR /app

ENTRYPOINT ["/bin/bash", "-c"] 
