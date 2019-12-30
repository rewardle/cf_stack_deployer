#!/bin/bash
set -eo pipefail

echo "--- printing all arguments before"
echo $@
echo "StackName = $STACKNAME"
echo "DeploymentBucketName = $DEPLOYMENT_BUCKET_NAME"
echo "Params = $PARAMS"

STACKNAME=$1
shift 1
DEPLOYMENT_BUCKET_NAME=$1
shift 1

PARAMS=""
[ -f /app/params.yaml ] && PARAMS="-d=yaml:params.yaml"

JSON=$(aws cloudformation describe-stacks --region ${AWS_REGION:-ap-southeast-2} --stack-name $STACKNAME)
if [ -n "${JSON}" ]; then
  STATUS=$(echo ${JSON} | jq -r '.Stacks[0].StackStatus')
  if [ "${STATUS}" == "CREATE_FAILED" ]; then
    aws cloudformation delete-stack --region ${AWS_REGION:-ap-southeast-2} --stack-name ${STACKNAME}
    while [ -n "$(aws cloudformation describe-stacks --region ${AWS_REGION:-ap-southeast-2} --stack-name $STACKNAME)" ]; do
      sleep 5
    done
  fi
fi

echo "--- printing all arguments after"
echo $@
echo "StackName = $STACKNAME"
echo "DeploymentBucketName = $DEPLOYMENT_BUCKET_NAME"
echo "Params = $PARAMS"

if [ ! -z "$DEPLOYMENT_BUCKET_NAME" ];
  echo "deployment bucket is set."
  rainbow --update-stack-if-exists -v -r ${AWS_REGION:-ap-southeast-2} --deployment-bucket-name ${DEPLOYMENT_BUCKET_NAME} ${PARAMS} ${STACKNAME} stack.json "$@"
else
  echo "deployment bucket is not set or empty."
  rainbow --update-stack-if-exists -v -r ${AWS_REGION:-ap-southeast-2} --deployment-bucket-name '' ${PARAMS} ${STACKNAME} stack.json "$@"
fi
