---
layout: post
title: SpringBoot - H2 Database CSV 데이터 Import 하기
description: >
  [SpringBoot] H2 Database CSV 데이터 Import 하기

hide_last_modified: true
categories: [Spring]
tags: [h2database, csv import, h2 csv]
---

- Table of Contents
{:toc .large-only}

SpringBoot 2.7.2 , Java11 사용

## 1. H2 Database 사용 설정

- build.gradle

```gradle
dependencies {
	...
	// https://mvnrepository.com/artifact/com.h2database/h2
	implementation group: 'com.h2database', name: 'h2', version: '2.1.214'
	// https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-starter-data-jdbc
	implementation group: 'org.springframework.boot', name: 'spring-boot-starter-data-jdbc', version: '2.7.1'
    ...
}
```

- application.yml

```yml
spring:
  application:
    name: sample
  datasource:
    hikari:
      # 메모리 사용하여 구동
      jdbc-url: jdbc:h2:mem:h2-test
      driver-class-name: org.h2.Driver
      username: sa
      password:
      maximum-pool-size: 10
  h2:
    console: # h2 콘솔 사용 옵션
      enable: true
      path: /h2-console
```

## 2. CSV 파일 경로

![h2csv1](/assets/img/Spring/h2csv1.png)

csv 파일 위치 시킬 곳

src/resources 밑에 schema.sql 이 존재한다고 가정 시, 해당 파일과 동일한 위치에 파일을 작성한다.

- 파일 구조 예시

![h2csv2](/assets/img/Spring/h2csv2.png)

## 3. Schema.sql 작성

예시) 데이터베이스 테이블 생성 하면서 데이터 밀어넣음.

- H2 Database 'CSVREAD' 함수 활용(http://h2database.com/html/tutorial.html#csv)

- Schema.sql

```sql
CREATE TABLE IF NOT EXISTS bank_user AS SELECT * FROM CSVREAD('classpath:bank_user.csv');
```

클래스패스(classpath) 를 사용하여 지정된 위치에서 파일을 찾아올 수 있게끔 구성.

"D:\test.csv" 와 같이 절대 경로도 사용 가능하나, 본인만 사용할 것이 아니라면 이렇게 구성하면 불편하기 때문에

상대 경로로 작성하여 불편함을 덜 수 있도록 했다.

- 결과 확인

http://localhost:8080/h2-console 로 접속하여 확인.

![h2csv3](/assets/img/Spring/h2csv3.png)
