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
  libc6 \
  libgcc1 \
  libgssapi-krb5-2 \
  libicu66 \
  libssl1.1 \
  libstdc++6 \
  zlib1g

RUN pip install --no-cache-dir --upgrade pip awscli

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin -Channel 2.1 -Runtime dotnet -InstallDir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet


RUN npm install -g npm@latest
RUN npm install -g serverless@1.70.1
RUN npm install -g serverless-plugin-lambda-dead-letter@1.2.1
RUN npm install -g serverless-pseudo-parameters@2.5.0
RUN npm install -g serverless-plugin-log-retention@2.0.0
RUN npm install -g serverless-latest-layer-version@2.1.0
RUN npm install -g serverless-domain-manager@3.3.2

ENTRYPOINT ["/bin/bash", "-c"] 
