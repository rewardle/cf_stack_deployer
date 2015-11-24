#!/bin/bash -ex

STACKNAME=$1
shift
PARAMS=""
[ -f /app/params.yaml ] && PARAMS="-d=yaml:params.yaml"

STATUS=$(aws cloudformation describe-stacks --region ${AWS_REGION:-ap-southeast-2} --stack-name $STACKNAME | jq '.Stacks[0].StackStatus')

[ "$STATUS" -eq "CREATE_FAILED" ] && aws cloudformation delete-stack --region ${AWS_REGION:-ap-southeast-2} --stack-name $STACKNAME

rainbow --update-stack-if-exists -v -r ${AWS_REGION:-ap-southeast-2} $PARAMS --block $STACKNAME stack.json "$@"
