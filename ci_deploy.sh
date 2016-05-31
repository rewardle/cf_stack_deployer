#!/bin/bash

# Internal deployer

REGION="us-west-2"

echo "--- Getting ECR credentials and logging in"
$(docker run -it --entrypoint=aws rewardle/deployer ecr get-login --region=$REGION | tr -d '\r')

echo "--- Finding the account id"
ACCT=$(docker run -it --entrypoint=aws rewardle/deployer \
  cloudformation describe-stack-resource \
    --stack-name ${STACKNAME} \
    --logical-resource-id IoTLambdaRole \
    --region ${AWS_REGION} \
    --query "StackResourceDetail.StackId" \
    --output text | cut -d: -f5)

IMGNAME="$ACCT.dkr.ecr.$REGION.amazonaws.com/rewardle/deployer:$BUILDKITE_BUILD_NUMBER"
echo "--- Building $IMGNAME"
docker build -t $IMGNAME .

echo "--- Pushing docker image"
docker push $IMGNAME
