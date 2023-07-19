FROM python:3.9-slim
LABEL org.opencontainers.image.authors="Jason Potter <jason@rewardle.com>"

RUN apt-get -yq update 
RUN apt-get -yq install git zip groff less wget curl npm ca-certificates gnupg lsb-release
RUN apt-get -yq remove docker docker.io containerd runc
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
RUN pip3 install awscli 
RUN pip3 install boto3 
RUN pip3 install docker-compose 
RUN touch ~/.bashrc && chmod +x ~/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
# RUN . ~/.nvm/nvm.sh && . ~/.bashrc && nvm install --lts && nvm install 14 && nvm install 15 && nvm install 16 && nvm install 17 && nvm install 18 && nvm install 19 && nvm install 20
RUN . ~/.nvm/nvm.sh && . ~/.bashrc && nvm install --lts  && nvm install 16
RUN . ~/.nvm/nvm.sh && . ~/.bashrc && nvm use 16
RUN npm install -g serverless@3.28.1

# Node Packages Install- END
RUN sh -c 'echo bust cache 1234567890123'

RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
RUN aws configure set region ap-southeast-2

WORKDIR /app
ENV GOPATH /app

ADD deploy.sh /app/deploy.sh
ADD boto.cfg /etc/boto.cfg
RUN chmod 755 /app/deploy.sh

ENTRYPOINT ["/app/deploy.sh"]
