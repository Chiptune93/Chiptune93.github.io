---
layout: post
title: DynamoDB - 파티션 키/정렬 키/필터 정리
description: >
    [DynamoDB] 파티션 키/정렬 키/필터 정리
sitemap: false
hide_last_modified: true
categories: [AWS]
tags: [AWS,DynamoDB,DynamoDB Key]
---

- Table of Contents
{:toc .large-only}

MYSQL 이나 ORACLE 과는 다른 개념을 갖는 다이나모 DB 에 대한 개인적인 정리.

[참고] https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html﻿

- 기본적으로 키 값으로 잡는 항목들을 제외한 나머지 항목(컬럼)에 대해서는 자유롭게 작성이 가능하다.

- 기존 키 값들 외 A,B,C 컬럼이 존재하는데, D 컬럼을 갖는 데이터가 들어오는 경우, D 컬럼이 자동으로 생성되며 기존 데이터에는 빈 값으로 존재하게 된다.

![dynamokey1](/assets/img/AWS/dynamokey1.png)

1. 파티션 키 : 일종의 키 값으로 데이터 조회 시, 해당 키값과 정확히 일치하는 데이터들을 조회하게 됨

일반적으로 RDB에서 질의하던 select * from .. 이 기본적으로 사용되지 않으며, 기본조회 시 파티션 키와 정렬 키를 가지고 조회한다.

2. 정렬 키 :  파티션키와 함께 사용되는 조건으로 범위 또는 크기 비교 등의 간단한 조건을 가지고 조회할 수 있다.
다이나모에서는 파티션키와 정렬키로 지정된 항목이 동일한 데이터가 존재하려고 하는 경우, 같은 데이터로 취급한다.

예를 들어 파티션키가 id, 정렬키가 timestamp 인 경우
다이나모에 id가  1 , timestamp 가 210923 100312 인 데이터가 있는데
이후 해당 항목이 동일한 데이터를 갖는 행이 들어오면 데이터가 추가되는 것이 아닌 기존에 있던 데이터를 업데이트 하게된다. (해당 항목 외 다른 항목 값이 다르더라도)

3. 필터 : 위 2가지 키 값은 필수 조건이고, 필터는 추가적인 조건 개념으로 데이터 조회 시 사용이 가능하다. 



대용량 데이터를 관리 및 조회하는 특성 상, 위와 같은 특징을 갖는게 아닌가 한다.