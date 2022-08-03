---
layout: post
title: Spring - Driver net.sf.log4jdbc.sql.jdbcapi.DriverSpy claims to not accept jdbcUrl
description: >
    [Spring] Driver net.sf.log4jdbc.sql.jdbcapi.DriverSpy claims to not accept jdbcUrl
sitemap: false
hide_last_modified: true
categories: [Error]
tags: [Spring, log4jdbc error, DriverSpy not Accept jdbc url, jdbc url error]
---

- Table of Contents
{:toc .large-only}

## 문제
Driver net.sf.log4jdbc.sql.jdbcapi.DriverSpy claims to not accept jdbcUrl 오류를 만났다.

## 현상
최초 발생 과정은 DB 연결 시, application.yml 파일에 DB 주소를 적었으나 해당 오류를 뱉어내던 상황이었다.
환경은 JDK11 / Spring Boot / Mybatis / HikariCp 였으며, IDE는 VS Code 였다.

## 해결
해결 방법은 다음과 같았다.

1. ojdbc 추가. 
2. 주소 지정 형식 변경 ( 나의 경우에는 jdbc:log4jdbc:oracle:thin:@{oracle-db-url} # ex ) localhost:3306:utf8 ) 처럼 형식을 맞추어야 했었다. 

log4j2를 사용하면서, 드라이버 클래스가 단순 oracle 드라이버가 아니라 log4jdbc 를 사용하게 되면서, 주소 지정 형식을 바꾸었어야 했는데 그냥 jdbc:oracle 형식으로 사용해서 발생한 문제였다. 