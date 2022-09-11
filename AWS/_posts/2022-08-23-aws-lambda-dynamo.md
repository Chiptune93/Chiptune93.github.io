---
layout: post
title: AWS Lambda - Dynamo DB / Postgre Access
description: >
  AWS 람다에서 다이나모 DB / Postgre 액세스 및 처리

hide_last_modified: true
categories: [AWS]
tags: [AWS, Lambda, DynamoDB, Postgre]
---

- Table of Contents
{:toc .large-only}

## 람다에서 다이나모 또는 Postgre 액세스

1. 람다에서 Postgre DB 작업 하기

    람다에서 Postgre DB 작업을 하기 위해서는 [psycopg2](https://pypi.org/project/psycopg2/) 라이브러리가 필요하다.

    해당 라이브러리를 사용하여 연결 및 결과를 가져와 작업한다.

2. 다이나모에 액세스 하기

    람다에서 다이나모에 액세스 하기 위해서는 파이썬으로 작성된 다이나모 객체 가져오는 함수를 작성해야 한다.

    아래는 예시이고, 공식 문서에 해당 설명이 더 자세히 나와있다. 

    - [다이나모 코드 샘플](https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/example_dynamodb_CreateTable_section.html)

    - [다이나모 공식 문서](https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html)

    - [boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)


### 예제 코드

```python
import psycopg2
import os
import boto3
from boto3.dynamodb.types import TypeSerializer, TypeDeserializer
from botocore.vendored import requests

def lambda_handler(event, context):

    # 1. RDB 연결 후 결과 가져오기
    # 람다의 옵션 값으로 연결 정보 가져옴.

    try:
            db_name = os.environ['db_name']
            db_user = os.environ['db_user']
            db_pass = os.environ['db_pass']
            db_host = os.environ['db_host']
            db_port = 5432

            #connection
            conn = psycopg2.connect("dbname='%s' user='%s' host='%s' password='%s'" % (db_name, db_user, db_host, db_pass))
            cursor = conn.cursor()

            #parameter
            userSeq = 1

            #query execute
            cursor.execute("select * from user where user_seq != '%s'" % (userSeq))
            result = cursor.fetchone() # select one row
            # result = cursor.fetchAll() # select all row

            for rs in result:
                # process
     except Exception as e:
        ...
        ...

    # 2. Dynamo Access
    dyClient = boto3.client('dynamodb')
    queryPgr = dyClient.get_paginator('query')
    sdclient = boto3.client('servicediscovery')

    isRecord = False

    try:
        page_iterator = queryPgr.paginate(
            TableName='dynamo_table_name', # table name
            IndexName='index_name', # index name (if use)
            KeyConditionExpression = '#keyAttribute = :v1', # condition
            ExpressionAttributeValues = { 
                ':v1': {'N': seq} # value for condition
            },
            ExpressionAttributeNames = {
                '#keyAttribute': 'seq' # column name
            },
            ScanIndexForward = True
        )
        results = []
        for page in page_iterator:
            results.extend(page['Items'])

        print('###### dynamodb.query Total Itmes Count', len(results), ' #####')
        print(results)

        for result in results:

    except Exception as e:
        ...
        ...
```
