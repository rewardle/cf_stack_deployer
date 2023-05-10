FROM mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim
LABEL org.opencontainers.image.authors="Jason Potter <jason@rewardle.com>"

RUN apt-get -yq update 
RUN apt-get -yq install git zip groff less wget curl npm ca-certificates gnupg lsb-release
RUN apt-get -yq remove docker docker.io containerd runc
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN apt-get -yq install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev
RUN apt-get -yq install python3
RUN apt-get -yq install python3-pip
RUN apt-get -yq install python3-venv
RUN pip3 install awscli 
RUN pip3 install boto3 
RUN pip3 install docker-compose 
RUN touch ~/.bashrc && chmod +x ~/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN . ~/.nvm/nvm.sh && . ~/.bashrc && nvm install --lts

RUN dotnet tool install -g Amazon.Lambda.Tools
ENV PATH="${PATH}:/root/.dotnet/tools"

RUN npm install -g serverless@3.28.1

# Node Packages Install- END
RUN sh -c 'echo bust cache 1234567890123'

RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
RUN aws configure set region ap-southeast-2

WORKDIR /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
