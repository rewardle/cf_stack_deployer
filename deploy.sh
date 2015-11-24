#!/bin/bash -ex

STACKNAME=$1
shift
PARAMS=""
[ -f /app/params.yaml ] && PARAMS="-d=yaml:params.yaml"

JSON=$(aws cloudformation describe-stacks --region ${AWS_REGION:-ap-southeast-2} --stack-name $STACKNAME)
if [ -n "${JSON}" ]; then
  STATUS=$(echo ${JSON} | jq -r '.Stacks[0].StackStatus')
  if [ "${STATUS}" == "CREATE_FAILED" ]; then
    aws cloudformation delete-stack --region ${AWS_REGION:-ap-southeast-2} --stack-name ${STACKNAME}
  fi
fi

rainbow --update-stack-if-exists -v -r ${AWS_REGION:-ap-southeast-2} ${PARAMS} --block ${STACKNAME} stack.json "$@"
