#!/bin/bash -e

STACKNAME=$1
shift
PARAMS=""
[ -f /app/params.yaml ] && PARAMS="-d=yaml:params.yaml"

rainbow --update-stack-if-exists -v $PARAMS --block $STACKNAME stack.json "$@"
