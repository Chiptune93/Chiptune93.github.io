---
title: DynamoDB - Attribute name is a reserved keyword
categories: [Error]
tags: [AWS, DynamoDB]
---

DynamoDB Java SDK 를 사용하여 Table 스캔 도중 해당 에러가 발생하였다.

## 원인

- Dynamo Scan/GetItem 등 쿼리 및 표현식 등에서 사용된 명칭(항목명 등)이 DynamoDB 예약어와 충돌하여 발생하는 문제.

- 에러 발생 했던 구문

```java
 ItemCollection<ScanOutcome> items = table.scan("join_date >= :from and join_date <= :to","user_id, user_name, join_date", null, expressionAttributeValues);
```

> 필터 변수인 :from :to 가 예약어와 겹쳐 발생한 문제.

## 해결방법

- 아래 링크의 예약어를 참고하여 최대한 겹치치 않게 작성한다.<br/>

  [DynamoDB의 예약어](https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/ReservedWords.html)

- expressionAttributeValues를 사용하여 예약어를 사용할 수도 있는데 <br/> 위 처럼 scan 구문에 예약어가 들어가는 경우에도 해당 에러가 발생하는 것으로 보인다. <br/>
  아래 링크에서 표현식에 대해 확인이 가능하다.<br/>

  [표현식 속성 이름 대체하기](https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/Expressions.ExpressionAttributeNames.html)
