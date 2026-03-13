"""
Secret App - AWS Lambda Handler

Retrieves secrets from AWS Secrets Manager via API Gateway.
"""
import logging

from botocore.exceptions import ClientError
from aws_lambda_powertools.utilities.typing import LambdaContext
from utils.secrets_manager import get_secret

log = logging.getLogger()
log.setLevel(logging.INFO)


def lambda_handler(event: dict, context: LambdaContext) -> dict:
    """Lambda handler that retrieves secret values."""
    log.info("Function: %s", context.function_name if context else "no-context")
    log.info("Event: %s", event)

    try:
        query_params = event.get("queryStringParameters") or {}
        secret_name = query_params.get("Secret")
        if not secret_name:
            raise ValueError("No Secret Name Provided")

        secret = get_secret(secret_name=secret_name)

    except (ClientError, ValueError) as error:
        log.error(error)
        return {
            "statusCode": 404,
            "headers": {"Content-Type": "application/json"},
            "body": f"EXCEPTION RAISED: {error}",
        }

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": secret,
    }
