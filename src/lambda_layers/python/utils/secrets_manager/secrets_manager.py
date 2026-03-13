"""AWS Secrets Manager utility functions."""
import base64

import boto3
from botocore.exceptions import ClientError


def get_secret(secret_name: str) -> str:
    """
    Retrieve a secret value from AWS Secrets Manager.

    Args:
        secret_name: The secret identifier.

    Returns:
        The secret string value.

    Raises:
        ValueError: If secret_name is not provided.
        ClientError: If the AWS API call fails.
    """
    if not secret_name:
        raise ValueError("secret_name not provided")

    session = boto3.session.Session()
    client = session.client(service_name="secretsmanager")

    try:
        response = client.get_secret_value(SecretId=secret_name)
    except (ClientError, ValueError) as exc:
        raise exc

    if "SecretString" in response:
        return response["SecretString"]
    return base64.b64decode(response["SecretBinary"])
