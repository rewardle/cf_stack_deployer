#!/bin/bash

# Internal deployer

REGION="us-west-2"
BASENAME="deployer"
NAME="$BASENAME:$BUILDKITE_BUILD_NUMBER"

echo 'Docker version installed on the box'
docker version

echo 'System Architecture'
uname -i

echo "--- Building $NAME"
docker build -t $NAME .

echo "--- Getting ECR credentials and logging in"
$(docker run -it --entrypoint=aws $NAME ecr get-login --no-include-email --region=$REGION | tr -d '\r')

echo "--- Finding the account id"
ACCT=$(docker run -it --entrypoint=aws $NAME \
  sts get-caller-identity --query "Account" --output text | tr -d '\r')

IMGNAME="$ACCT.dkr.ecr.$REGION.amazonaws.com/$NAME"

echo "--- Tagging $IMGNAME"
docker tag $NAME $IMGNAME

echo "--- Pushing docker image"
docker run -it --entrypoint=aws $NAME \
  ecr create-repository --repository-name $BASENAME --region $REGION
docker push $IMGNAME
