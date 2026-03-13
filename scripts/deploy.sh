#!/usr/bin/env bash
#########################################################################################
# Deployment script for CloudFormation and Terraform                                    #
# Input format: DEPLOYMENT/ACTION/ENVIRONMENT                                           #
#   - DEPLOYMENT: cfn (CloudFormation), tf (Terraform)                                  #
#   - ACTION: deploy, plan, destroy, output                                             #
#   - ENVIRONMENT: dev, qa, prod                                                        #
#########################################################################################
set -o nounset

SRC=${PWD}

# Parse input
DEPLOYMENT=$(echo $1 | awk -F\/ '{print $1}')
ACTION=$(echo $1 | awk -F\/ '{print $2}')
ENV=$(echo $1 | awk -F\/ '{print $3}')

# AWS account check
AWS_REGION=${AWS_DEFAULT_REGION}
source scripts/aws_account_check.sh
aws_account_check

# CloudFormation configuration
CFN_CONF_FILE="cloudformation/config/${ENV}.json"
PROJECT=$(jq -r '.Parameters.Project' < "${CFN_CONF_FILE}")
STACK_NAME="${PROJECT}-${ENV}"

# Default example directory (override with TF_EXAMPLE env var)
TF_EXAMPLE=${TF_EXAMPLE:-'examples/ec2_backend'}


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
    EXAMPLE_DIR="${SRC}/${TF_EXAMPLE}"
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

    export TF_VAR_aws_region=${AWS_REGION}
    export TF_IN_AUTOMATION=true

    echo "TF Example: ${TF_EXAMPLE}"
    echo "TF State Bucket: ${S3_TF_STATE}"
    echo "TF State Key: ${PROJECT}/${ENV}/terraform.tfstate"
    echo "TF State DDB Table: ${DDB_TF_STATE}"
    echo "TF AWS Region: ${AWS_REGION}"
}


function tf_init {
    echo "Terraform Init"
    if [ ! -d "${EXAMPLE_DIR}" ]; then
        echo "Example directory not found: ${EXAMPLE_DIR}"
        exit 1
    fi

    VAR_FILE="${EXAMPLE_DIR}/config/${ENV}.tfvars"
    if [ ! -f "${VAR_FILE}" ]; then
        echo "Terraform variables file not found: ${VAR_FILE}"
        exit 1
    fi

    cd "${EXAMPLE_DIR}"
    terraform init -input=false \
        -backend-config="bucket=${S3_TF_STATE}" \
        -backend-config="key=${ENV}/terraform.tfstate" \
        -backend-config="region=${AWS_REGION}" \
        -backend-config="dynamodb_table=${DDB_TF_STATE}"

    terraform validate
    cd ${SRC}
}


function tf_plan {
    echo "Terraform Plan"
    cd "${EXAMPLE_DIR}"
    terraform plan -out=plan.out \
        -var-file=${VAR_FILE} \
        -compact-warnings \
        -lock=true \
        -parallelism=100 \
        -input=false
    cd ${SRC}
}


function tf_deploy {
    echo "Terraform Apply"
    cd "${EXAMPLE_DIR}"
    terraform apply -var-file=${VAR_FILE} \
        -auto-approve \
        -compact-warnings
    cd ${SRC}
}


function tf_destroy {
    echo "Terraform Destroy"
    cd "${EXAMPLE_DIR}"
    terraform destroy -var-file=${VAR_FILE} -auto-approve
    cd ${SRC}
}


function tf_output {
    echo "Terraform Output"
    cd "${EXAMPLE_DIR}"
    terraform output
    cd ${SRC}
}


function tf_cleanup {
    cd "${EXAMPLE_DIR}"
    rm -f plan.out plan.out.json
    rm -rf .terraform.*
    cd ${SRC}
}


# Deploy flow
case ${DEPLOYMENT} in
    cfn)
        case ${ACTION} in
            deploy) cfn_deploy ;;
            *) echo "CloudFormation action not supported: ${ACTION}"; exit 1 ;;
        esac
        ;;
    tf)
        case ${ACTION} in
            plan|deploy|destroy)
                tf_init_vars
                tf_init
                tf_plan
                [ "${ACTION}" == 'deploy' ] && tf_deploy
                [ "${ACTION}" == 'destroy' ] && tf_destroy
                tf_cleanup
                ;;
            output)
                tf_init_vars
                tf_init
                tf_output
                tf_cleanup
                ;;
            *) echo "Terraform action not supported: ${ACTION}"; exit 1 ;;
        esac
        ;;
esac
