#!/bin/bash -e

STACKNAME=$1
EXITCODE=1
PARAMS=""
[ -f /app/params.json ] && PARAMS="--parameters=file:///app/params.json"

cf_update() {
  aws cloudformation update-stack \
    --stack-name $STACKNAME \
    --template-body file:///app/stack.json \
    --capabilities=CAPABILITY_IAM \
    $PARAMS
}

cf_create() {
  aws cloudformation create-stack \
    --stack-name $STACKNAME \
    --template-body file:///app/stack.json \
    --capabilities=CAPABILITY_IAM \
    $PARAMS
}

cf_events() {
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack=$1
  aws cloudformation describe-stack-events --stack-name $stack --query 'sort_by(StackEvents, &Timestamp)[].[Timestamp, LogicalResourceId, ResourceStatus, ResourceType]' --output text
}

cf_tail() {
  # Thanks, https://github.com/realestate-com-au/bash-my-aws/
  if [ -z "$1" ] ; then echo "Usage: $FUNCNAME stack"; return 1; fi
  local stack=$1
  local previous=""
  local current=""
  until echo "$current" | tail -1 | egrep -q "${stack}.*_(COMPLETE|FAILED)"
  do
    current=$(cf_events $stack)
    if [ -z "$current" ]; then sleep 1; continue; fi

    if [ -z "$previous" ]; then
      echo "$current"
    elif [ "$current" != "$previous" ]; then
      comm --nocheck-order -13 <(echo "$previous") <(echo "$current")
    fi
    previous="$current"
    sleep 1
    $(echo "$current" | tail -1 | egrep -q "${stack}.*(CREATE|UPDATE)_COMPLETE") && EXITCODE=0
  done
}

if $(aws cloudformation describe-stacks --stack-name $STACKNAME >/dev/null 2>&1); then
  $(cf_update 2>&1) | grep "No updates are to be performed" && EXITCODE=0
else
  cf_create
fi

[[ $EXITCODE -eq 0 ]] || cf_tail $STACKNAME
exit $EXITCODE
