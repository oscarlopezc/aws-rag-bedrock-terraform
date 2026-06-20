import json
import os
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

bedrock = boto3.client("bedrock-agent-runtime")


def lambda_handler(event, context):

    try:

        body = json.loads(event.get("body", "{}"))

        question = body.get("question")

        if not question:
            return {
                "statusCode": 400,
                "headers": {
                    "Access-Control-Allow-Origin": "*",
                    "Content-Type": "application/json"
                },
                "body": json.dumps({
                    "error": "The field 'question' is required."
                })
            }

        prompt = f"{os.environ['CONTEXT']}\n\n{question}"

        response = bedrock.retrieve_and_generate(

            input={
                "text": prompt
            },

            retrieveAndGenerateConfiguration={

                "type": "KNOWLEDGE_BASE",

                "knowledgeBaseConfiguration": {

                    "knowledgeBaseId": os.environ["KNOWLEDGE_BASE_ID"],

                    "modelArn": f"arn:aws:bedrock:us-east-1::foundation-model/{os.environ['MODEL_ID']}"

                }

            }

        )

        answer = response["output"]["text"]

        return {

            "statusCode": 200,

            "headers": {

                "Access-Control-Allow-Origin": "*",

                "Content-Type": "application/json"

            },

            "body": json.dumps({

                "question": question,

                "answer": answer

            })

        }

    except Exception as e:

        logger.exception(e)

        return {

            "statusCode": 500,

            "headers": {

                "Access-Control-Allow-Origin": "*",

                "Content-Type": "application/json"

            },

            "body": json.dumps({

                "error": str(e)

            })

        }