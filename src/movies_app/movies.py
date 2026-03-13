"""
Movies App - AWS Lambda Handler

Loads movie titles into a DynamoDB table via API Gateway.
"""
import json
import logging
import os

from boto3 import client
from aws_lambda_powertools.utilities.typing import LambdaContext

log = logging.getLogger()
log.setLevel(logging.INFO)
dynamodb_client = client("dynamodb")


def lambda_handler(event: dict, context: LambdaContext) -> dict:
    """Lambda handler that loads movies into DynamoDB."""
    log.info("Function: %s", context.function_name if context else "no-context")
    log.info("Event: %s", event)

    table = os.environ.get("DDB_TABLE")
    log.info("Table: %s", table)

    if event.get("body"):
        item = json.loads(event["body"])
        log.info("Payload: %s", item)
        ddb_item = {
            "year": {"N": str(item["year"])},
            "title": {"S": str(item["title"])},
        }
    else:
        log.info("No payload, using default")
        ddb_item = {
            "year": {"N": "2012"},
            "title": {"S": "The Amazing Spider-Man 2"},
        }

    dynamodb_client.put_item(TableName=table, Item=ddb_item)

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"message": "Successfully inserted data!"}),
    }
