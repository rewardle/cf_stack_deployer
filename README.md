[![](https://images.microbadger.com/badges/version/rewardle/deployer.svg)](http://microbadger.com/images/rewardle/deployer)

## Purpose ##

This repo provides a docker image that will deploy a stack to CloudFormation.

This repo is auto-built at https://hub.docker.com/r/rewardle/deployer/

However, note, this will only auto-build on a change to this repo. If you change the rainbow deployer (rewardle/rainbow), you
will need to manually trigger a rebuild in the docker hub and in our build system.

## Logging ##

stdout for build server output logging.

## Discussion ##

`docker pull rewardle/deployer`

`docker run -v stack.json:/app/stack.json -v params.json:/app/params.json -e rewardle/deployer mystackname`

You need at a minimum to map in a stack.json and provide a stack name. If you
don't provide a params.json file, then it will just use the stack.json.

Note, we're using https://github.com/rewardle/rainbow internally to do the
actual cloudformation create/update. You can add additional args to that
based on what it accepts - for instance `-d=cfn_outputs:DevelopmentVPC` to
add the outputs from the DevelopmentVPC into your parameters.

The expectation is that this docker container would be run from somewhere
with appropriate permissions, like a build server.

### Recognised environment variables ###

All the standard AWS environment variables should be recognised. We currently
default to 'ap-southeast-2' as our region, because why not.
