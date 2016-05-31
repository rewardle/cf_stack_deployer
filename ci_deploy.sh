#!/bin/bash

# Internal deployer

echo "--- Getting ECR credentials and logging in"
$(docker run -it --entrypoint=aws rewardle/deployer ecr get-login)

echo "--- Finding the account id"
ACCT=$(docker run -it --entrypoint=aws rewardle/deployer \
  cloudformation describe-stack-resource \
    --stack-name ${STACKNAME} \
    --logical-resource-id IoTLambdaRole \
    --region ${AWS_REGION} \
    --query "StackResourceDetail.StackId" \
    --output text | cut -d: -f5)

IMGNAME="$ACCT.dkr.ecr.us-east-1.amazonaws.com/rewardle/deployer:$BUILDKITE_BUILD_NUMBER"
echo "--- Building rewardle/deployer"
docker build -t $IMGNAME .

echo "--- Pushing docker image"
docker push $IMGNAME
