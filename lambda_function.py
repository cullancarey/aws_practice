import requests
import json
import boto3


def send_sns(msg):
    client = boto3.client('sns')
    response = client.publish(
        TargetArn='arn:aws:sns:us-east-2:{account_id}:woot-results',
        Message=msg,
        Subject='Woot Daily Deals!'
    )


def get_woot_deals(key):
    url = "https://d24qg5zsx8xdc4.cloudfront.net/graphql?query=%7BgetFeaturedEvents%20%7B%20EndDate%20Offers%20%7B%20Title%20%7D%20Title%20%20%7D%20%7D"

    payload = {}
    headers = {
        'Referer': '',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36',
        'x-api-key': str(key)
    }

    response = requests.request(
        "GET", url, headers=headers, data=payload).json()

    items = response['data']['getFeaturedEvents']
    deals = []
    for x in items:
        for i in x['Offers']:
            deals.append(f"{x['Title']}: {i['Title']}")
    return deals


def get_param():
    client = boto3.client('ssm')
    response = client.get_parameter(
        Name='woot-results-apikey',
        WithDecryption=True
    )
    return response['Parameter']['Value']


def lambda_handler(event, context):
    apikey = get_param()
    daily_deals = get_woot_deals(apikey)
    deals = "\n\n".join(daily_deals)
    print(deals)

    send_sns(deals)
