"""
Hello App - AWS Lambda Handler

Returns a greeting message based on API query parameters.
"""
import json
import logging

from aws_lambda_powertools.utilities.typing import LambdaContext

log = logging.getLogger()
log.setLevel(logging.INFO)


def lambda_handler(event: dict, context: LambdaContext) -> dict:
    """Lambda handler that returns a Hello message."""
    log.info("Function: %s", context.function_name if context else "no-context")
    log.info("Event: %s", event)

    query_params = event.get("queryStringParameters") or {}
    name = query_params.get("Name", "Lambda")

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(f"Hello {name}!"),
    }
