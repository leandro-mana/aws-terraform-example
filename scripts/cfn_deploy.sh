#!/usr/bin/env bash
# This script is used to deploy Cloudformation templates
# on multiple enviroments, in automation fashion during CICD.
# This Script will exit if any of bellow happens
# nounset: Attempting to use a variable that is not defined
set -o nounset

# Run AWS Check for Environment and AccountId
ENV=${1}
source scripts/aws_account_check.sh
aws_account_check

# NOTE: Simplified way to deploy Cloudformation based on the minimum requirements
# this is to CREATE|UPDATE, while DESTROY is not supported yet
# the preference to remove a CFN stack is by hand for security.
CONF_FILE="cloudformation/config/${ENV}.json"
PROJECT=$(jq -r '.Parameters.Project' < "${CONF_FILE}")
PARAMETERS=()
PARAMETERS+=($(jq -r '.Parameters | keys[] as $k | "\($k)=\(.[$k])"' "${CONF_FILE}"))
TAGS=($(jq -r '.Tags | keys[] as $k | "\($k)=\(.[$k])"' "${CONF_FILE}"))

aws cloudformation deploy \
    --template-file cloudformation/template.yaml \
    --stack-name ${PROJECT}-${ENV} \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --no-fail-on-empty-changeset \
    --parameter-overrides "${PARAMETERS[@]}" \
    --tags "${TAGS[@]}"
