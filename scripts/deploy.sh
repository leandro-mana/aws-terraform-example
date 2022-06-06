#!/usr/bin/env bash
#########################################################################################
# This script is used to deploy the following supported technologies:                   #
#   - Cloudformation templates                                                          #
#   - Terraform manifests                                                               #
# on multiple enviroments, in automation fashion during CICD.                           #
# as STRING INPUT usually expected from Makefile, in the following form                 #
# DEPLOYMENT/ACTION/ENVIRONMENT                                                         #
#    - DEPLOYMENT: The deployment type supported, cfn (Cloudformation), tf (Terraform)  #
#    - ACTION: The supported action depending on TYPE (check case statement at the end) #
#    - ENVIRONMENT: The environment to deploy, and AWS Account check will be run        #
# This Script will exit if any of bellow happens                                        #
# nounset: Attempting to use a variable that is not defined                             #
# EXPLAIN INPUT STRING                                                                  #
#########################################################################################
set -o nounset

# Repo Source Dir, its expected that the invocation of this wrapper whether if its
# via Make or straight happens from the source folder of the repo
# any directory used will be relative to that
SRC=${PWD}

# Deployment type, action and environment
DEPLOYMENT=$(echo $1 | awk -F\/ '{print $1}')
ACTION=$(echo $1 | awk -F\/ '{print $2}')
ENV=$(echo $1 | awk -F\/ '{print $3}')

# Run AWS Check for Environment and AccountId
AWS_REGION=${AWS_DEFAULT_REGION}
source scripts/aws_account_check.sh
aws_account_check

# As the base infrastructure is via Cloudformation for Terraform State
# then the minimum set of variables needed to glue both infrastructure providers
# comes from the Cloudformation configuration definition
CFN_CONF_FILE="cloudformation/config/${ENV}.json"
PROJECT=$(jq -r '.Parameters.Project' < "${CFN_CONF_FILE}")
STACK_NAME="${PROJECT}-${ENV}"

# Function definitions
function cfn_deploy {
    PARAMETERS=()
    PARAMETERS+=($(jq -r '.Parameters | keys[] as $k | "\($k)=\(.[$k])"' "${CFN_CONF_FILE}"))
    TAGS=($(jq -r '.Tags | keys[] as $k | "\($k)=\(.[$k])"' "${CFN_CONF_FILE}"))

    aws cloudformation deploy \
        --template-file cloudformation/template.yaml \
        --stack-name ${STACK_NAME} \
        --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --no-fail-on-empty-changeset \
        --parameter-overrides "${PARAMETERS[@]}" \
        --tags "${TAGS[@]}"

}


function tf_init_vars {
    TF_REPO_DIR=${TF_REPO_DIR:-'terraform'}
    MANIFESTS="${SRC}/${TF_REPO_DIR}/manifests"
    S3_TF_STATE_EXPORT_NAME=${STACK_NAME}-tf-state-s3-name
    DDB_TF_STATE_EXPORT_NAME=${STACK_NAME}-tf-state-ddb-name
    S3_TF_STATE=$(aws cloudformation describe-stacks \
        --no-paginate \
        --stack-name ${STACK_NAME} \
        --query "Stacks[0].Outputs[?ExportName == \`${S3_TF_STATE_EXPORT_NAME}\`].OutputValue" \
        --output text)

    DDB_TF_STATE=$(aws cloudformation describe-stacks \
        --no-paginate \
        --stack-name ${STACK_NAME} \
        --query "Stacks[0].Outputs[?ExportName == \`${DDB_TF_STATE_EXPORT_NAME}\`].OutputValue" \
        --output text)

    ## TF Global Variables Declaration
    export TF_VAR_aws_region=${AWS_REGION}
    export TF_IN_AUTOMATION=true

    echo "TF Manifests folder: ${MANIFESTS}"
    echo "TF State Bucket: ${S3_TF_STATE}"
    echo "TF State Bucket Key: ${PROJECT}/${ENV}/terraform.tfstate"
    echo "TF State DDB Table: ${DDB_TF_STATE}"
    echo "TF CICD AWS Region: ${AWS_REGION}"

}


function tf_init {
    # Function to initialize TF and validate static syntax
    echo "Terraform Init"
    if [ ! -d "${MANIFESTS}" ]; then
        echo "Terraform Local Directory Not Found: ${MANIFESTS}"
        exit 1
    fi

    VAR_FILE="${SRC}/${TF_REPO_DIR}/config/${ENV}.tfvars"
    if [ ! -f "${VAR_FILE}" ]; then
        echo "Terraform environment variables definition not found: ${VAR_FILE}"
        exit 1
    fi

    cd "${MANIFESTS}"
    terraform init -input=false \
        -backend-config="bucket=${S3_TF_STATE}" \
        -backend-config="key=${ENV}/terraform.tfstate" \
        -backend-config="region=${AWS_REGION}" \
        -backend-config="dynamodb_table=${DDB_TF_STATE}"

    terraform validate
    cd ${SRC}

}


function tf_plan {
    # Function to run TF Plan
    echo "Terraform Plan"
    cd "${MANIFESTS}"
    TF_PLAN_FILE='plan.out'
    terraform plan -out=${TF_PLAN_FILE} \
        -var-file=${VAR_FILE} \
        -compact-warnings \
        -lock=true \
        -parallelism=100 \
        -input=false

    cd ${SRC}
}


function tf_deploy {
    # Function to TF Deploy
    echo "Terraform Apply"
    cd "${MANIFESTS}"
    terraform apply -var-file=${VAR_FILE} \
        -auto-approve \
        -compact-warnings

    cd ${SRC}
}


function tf_destroy {
    # Function to Destroy TF infrastructure
    echo "Terraform Destroy"
    cd "${MANIFESTS}"
    terraform destroy -var-file=${VAR_FILE} -auto-approve
    cd ${SRC}
}


function tf_cleanup {
    # Function to clean files as part of init/plan
    cd "${MANIFESTS}"
    rm -f plan.out
    rm -f plan.out.json
    rm -rf .terraform.*
    cd ${SRC}
}


# Deploy flow definition
case ${DEPLOYMENT} in
    cfn)
        case ${ACTION} in
            deploy)
                cfn_deploy
            ;;
            *)
                echo "Cloudformation Action: ${ACTION} Not Supported"
                exit 1
            ;;
        esac
        ;;
    tf)
    case ${ACTION} in
        plan|deploy|destroy)
            tf_init_vars
            tf_init
            tf_plan
            if [ "${ACTION}" == 'deploy' ]; then
                tf_deploy
            fi

            if [ "${ACTION}" == 'destroy' ]; then
                tf_destroy
            fi
            tf_cleanup
        ;;
        *)
            echo "Terraform Action: ${ACTION} Not Supported"
            exit 1
        ;;
    esac
    ;;
esac
