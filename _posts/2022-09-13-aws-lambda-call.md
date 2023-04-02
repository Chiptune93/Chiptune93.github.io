---
title: AWS Lambda - Lambda 내부에서 다른 람다 함수 호출하기
categories: [AWS]
tags: [AWS, Lambda, Functions]
---

## Lambda 에서 다른 Lambda 호출하기

- 람다 함수 내부에서 또 다른 람다 함수를 호출한다.
- 'boto3' 라이브러리가 필요하다.

### 1. 실행 권한 확인


 - Lambda 에서 구성 -> 권한으로 이동하여 권한을 클릭

     ![이미지1](/assets/img/AWS/0913-1.png)

 - 권한 내 우측 권한 추가 버튼 클릭 후, 정책 연결 클릭.

     ![이미지2](/assets/img/AWS/0913-2.png)

 - 검색에서 ' AWSLambda_FullAccess ' 를 검색하여 찾기

     ![이미지3](/assets/img/AWS/0913-3.png)

 - AWSLambda_FullAccess 를 체크 후 정책 연결

     ![이미지4](/assets/img/AWS/0913-4.png)


### 2. 에제 코드 작성 및 함수 등록

- test1 함수에서 test2 함수를 호출하는 예제

- test1 람다 함수

    ```python
    import json
    import boto3

    def lambda_handler(event, context):
        
        # service_name 에는 lambda
        # region_name 에는 자신의 region
        lan = boto3.client(service_name='lambda', region_name="ap-northeast-2")
        # FunctionName -> 호출하고자 하는 람다 함수명
        # InvocationType -> 동기/비동기 호출 결정 -> Event : 비동기 호출
        # Payload -> 전달할 파라미터
        lan.invoke(FunctionName="test2", InvocationType='Event', Payload=json.dumps(event))
        
        # TODO implement
        return {
            'statusCode': 200,
            'body': json.dumps('Hello from Lambda!')
        }

    ```

- test2 람다 함수

    - 마찬가지로 권한 동일하게 부여해야 함.

    ```python
    import json

    def lambda_handler(event, context):
    # TODO implement
    
    print('this is test2 lambda function !')
    print('event : ', event)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

    ```

### 3. 각 함수의 동작 테스트 

- test1 함수를 테스트

    - 테스트는 적당히 json 형식 아무거나 지정하여 진행

        ![이미지5](/assets/img/AWS/0913-5.png)
    
    - 테스트를 진행하면 result 탭에서 결과가 출력 됨. 200OK 이면 정상 동작한 것.

        ![이미지6](/assets/img/AWS/0913-6.png)

- test2 가 실제 호출되었는지 확인

    - test2 함수에서 모니터링 탭 > cloud watch 에서 보기 클릭.

        ![이미지7](/assets/img/AWS/0913-7.png)

    - 가장 최근 스트림을 클릭하여 로그 확인.

        ![이미지8](/assets/img/AWS/0913-8.png)

    - 실제 test2 함수에서 프린트한 문장이 찍힌 것을 확인하여 호출 됨을 확인한다.

        ![이미지9](/assets/img/AWS/0913-9.png)



