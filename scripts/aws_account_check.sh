# This file contains a function definition used for AWS account check

function aws_account_check {
    # This function will fail if the AWS_ACCOUNT_ID from the environment
    # does not correspond with the USED_ACCOUNT obtained from the CLI 
    # by using the AWS API Keys context.
    # This should be invoked on ANY script that checks the AWS Environment
    echo "Checking AWS Account Environment..."
    USED_ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text)
    if [[ ! " ${AWS_ACCOUNT_ID} " == " ${USED_ACCOUNT} " ]]; then
        echo "AWS Account does not match with Environment"
        exit 1
    fi
}
