---
layout: post
title: Spring Boot Gradle - Hikari CP MAX Connection Pool 설정하기
description: >
  [Spring Boot Gradle] Hikari CP MAX Connection Pool 설정하기

hide_last_modified: true
categories: [Spring]
tags: [SpringBoot, Gradle, Hikari, Connection Pool]
---

- Table of Contents
{:toc .large-only}

기존 DataSource 가 Hikari CP 기본으로 사용 중, Max Connection Pool 설정이 필요하게 되어 설정 시도를 함.

## try#1 - 설정만 추가

application.yml

```yml
datasource:
  url: jdbc:log4jdbc:url
  driver-class-name: net.sf.log4jdbc.sql.jdbcapi.DriverSpy
  username: username
  password: password
  # DB Connection Pool for local
  hikari:
    connectionTimeout: 30000
    maximumPoolSize: 2
    #maxLifetime : 1800000
    #poolName : HikariCP
    #readOnly : false
    #connectionTestQuery : SELECT 1
```

DataSource Bean 따로 존재하지 않음.

> 해당 설정이 동작하지 않음.

Why ?

> DataSource 생성 시, 따로 명시하지 않아 기본적인 설정만 가져가게 되는데 이는 spring.datasrouce 의 url,driver-class-name,username,password 만 가져가고 maximumPoolSize 의 경우 spring.datasource.hikari 밑으로 들어가므로 인식하지 않는다.

## try#2 - 설정 추가 후, ds Bean 등록.

application.yml

```yml
datasource:
  hikari:
    jdbc-url: jdbc:log4jdbc:url
    driver-class-name: net.sf.log4jdbc.sql.jdbcapi.DriverSpy
    username: username
    password: password
    maximumPoolSize: 2
```

```java
dbConfig.java
@Bean(name = "dataSource")
  @ConfigurationProperties(prefix = "spring.datasource.hikari")
  public DataSource dataSource() {
    HikariDataSource ds = (HikariDataSource) DataSourceBuilder.create().build();
    return ds;
  }
@ConfigurationProperties 어노테이션을 통해, 프로퍼티의 spring.datasource.hikari 밑의 설정을 참조하도록 변경.
```

> 해당 설정이 동작하지 않음.

Why ?

> DataSource 를 사용하는 곳에서 해당 데이터 소스를 사용한다고 해도, 캐스팅 하지 않은 HikariDataSource 이기 때문에 설정이 사용된 ds 여도 실제 사용하는 곳에서는 해당 ds 가 적용되지 않는다.

## try#3 - Hikari 설정을 빈에 등록 후, 베이스 Ds에서 해당 설정 가져와 DataSource로 캐스팅하여 사용.

참고 : https://dotheright.tistory.com/188

dbConfig.java

```java
/**
   * hikari cp config 명시 conf prop -> application.yml
   */
  @Bean
  @ConfigurationProperties("spring.datasource.hikari")
  public HikariConfig hikariConfig() {
    return new HikariConfig();
  }

  /**
   * mybatis에 hikari cp 등록
   */
  @Bean
  public DataSource dataSource() {
    DataSource dataSource = new HikariDataSource(hikariConfig());
    return dataSource;
  }
```

> 실제로 동작하는 것으로 확인!
