#!/bin/bash
set -eo pipefail

STACKNAME=$1
DEPLOYMENT_BUCKET_NAME=$2
shift
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

rainbow --update-stack-if-exists -v -r ${AWS_REGION:-ap-southeast-2} --deployment-bucket-name ${DEPLOYMENT_BUCKET_NAME} ${PARAMS} ${STACKNAME} stack.json "$@"
