import os
import json
import jmespath
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

tag_key = os.environ.get('EXCLUDE_TAG_KEY')
tag_value = os.environ.get('EXCLUDE_TAG_VALUE')


def lambda_handler(event, context):
    # TODO implement
    rds_client = boto3.client('rds')
    rds_instances = rds_client.describe_db_instances()

    regex = "DBInstances[?(DBInstanceStatus==`available` && (TagList[?Key==`{}`] | [].Value != [`{}`])) ].DBInstanceIdentifier".format(tag_key, tag_value)
    
    val  = jmespath.search(regex, rds_instances)
    logger.info("stop rds instances. {}".format(val))
    response = {
        "StopDBInstances": val
    }

    for instance in val:
        logger.info("stop rds instance {}".format(instance))
        rds_client.stop_db_instance(
            DBInstanceIdentifier = instance
        )

    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }

