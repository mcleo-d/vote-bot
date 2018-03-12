#!/bin/bash

BRANCH_NAME=$1
TRAVIS_PULL_REQUEST=$2

# NodePorts must be within 30000-32767 range - read more on https://docs.openshift.com/container-platform/latest/dev_guide/expose_service/expose_internal_ip_nodeport.html

if [[ $BRANCH_NAME =~ master ]]; then
	export SYMPHONY_POD_HOST="foundation.symphony.com"
	export SYMPHONY_API_HOST="foundation-api.symphony.com"
    export BOT_NAME="votebot-prod"
    export OC_PROJECT_NAME="ssf-prod"
    export OC_PROJECT_NAME="ssf-prod"
    export JOLOKIA_NODE_PORT=30010

elif [[ $BRANCH_NAME =~ develop ]]; then
	# Reset Openshift env on every build, for testing purposes
	export OC_DELETE_LABEL="app=votebot-dev"
	export SYMPHONY_POD_HOST="foundation-dev.symphony.com"
	export SYMPHONY_API_HOST="foundation-dev-api.symphony.com"
    export BOT_NAME="votebot-dev"
    export OC_PROJECT_NAME="ssf-dev"
    export JOLOKIA_NODE_PORT=30011
else
	echo "Skipping deployment for branch $BRANCH_NAME"
	exit 0
fi

export OC_BINARY_FOLDER="vote-bot-service/target/oc"
export OC_ENDPOINT="https://api.pro-us-east-1.openshift.com"
export OC_TEMPLATE_PROCESS_ARGS="BOT_NAME,SYMPHONY_POD_HOST,SYMPHONY_API_HOST"

if [[ "$TRAVIS_PULL_REQUEST" = "false" ]]; then
	curl -s https://raw.githubusercontent.com/symphonyoss/contrib-toolbox/master/scripts/oc-deploy.sh | bash
fi