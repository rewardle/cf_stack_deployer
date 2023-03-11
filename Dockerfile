FROM python:3.8-slim
LABEL org.opencontainers.image.authors="Jason Potter <jason@rewardle.com>"

RUN apt-get -yq update 
RUN apt-get -yq install git zip groff less wget curl npm ca-certificates gnupg lsb-release
RUN apt-get -yq remove docker docker.io containerd runc
# RUN mkdir -m 0755 -p /etc/apt/keyrings
# RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# RUN chmod a+r /etc/apt/keyrings/docker.gpg
# RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh
#RUN apt-get -yq update
# RUN apt-get -yq install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN pip3 install awscli 
RUN pip3 install boto3 
RUN pip3 install docker-compose 
RUN touch ~/.bashrc && chmod +x ~/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN . ~/.nvm/nvm.sh && . ~/.bashrc && nvm install --lts
# RUN . "$NVM_DIR/nvm.sh"  # This loads nvm
# RUN nvm install --lts 
# Node Packages Install- START

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
