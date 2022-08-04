---
layout: post
title: MS-SQL - 드라이버가 SSL(Secure Sockets Layer) 암호화를 사용하여 SQL Sever로 보안 연결을 설정할 수 없습니다.
description: >
  [MS-SQL] 드라이버가 SSL(Secure Sockets Layer) 암호화를 사용하여 SQL Sever로 보안 연결을 설정할 수 없습니다. 오류: "PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid c..
sitemap: false
hide_last_modified: true
categories: [Error]
tags: [mssql, mssql ssl, ssl error, pkix error]
---

- Table of Contents
{:toc .large-only}

## 문제

JDK 11 버전 이상 사용하는 프로젝트에서 MSSQL 연결 시도 시 아래의 메세지 출력.

> 드라이버가 SSL(Secure Sockets Layer) 암호화를 사용하여 SQL Sever로 보안 연결을 설정할 수 없습니다. 오류: "PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target"

## 원인

jdk11 을 지원하는 mssql 드라이버 버전(10.2이상)부터 기본적으로 암호화를 사용하도록 변경됨.
<br/> [관련 링크](https://docs.microsoft.com/en-us/sql/connect/jdbc/release-notes-for-the-jdbc-driver?view=sql-server-ver16)

따라서, SQL서버와 통신 시 암호화를 false로 주는 옵션을 통해 연결 시도를 해야 한다.

```yml
datasource:
  hikari:
    jdbc-url: jdbc:sqlserver://{url:port};DatabaseName={dbName};encrypt=false
    driver-class-name: com.microsoft.sqlserver.jdbc.SQLServerDriver
```

방법은 위와 같이 뒤에 인수로 "encrypt=false" 를 준다.
