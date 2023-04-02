---
title: Spring Multi DataSource - Read / Write Dynamic DataSource
categories: [Backend, Spring]
tags: [spring, datasource, dynamic datasouce]
---

AWS 사용 중, READ 와 READ/WRITE DB가 분리되면서, 현재 사용중인 1개의 DataSource 를 분리하여 READ전용 ds 와 READ/WRITE 전용 ds 를 구분하여 사용해야 하는 상황이 되었다.

구글링을 하면서 다음과 같은 글을 참고하여 작성하였다.

https://taes-k.github.io/2020/03/11/sprinig-master-slave-dynamic-routing-datasource/
https://mudchobo.github.io/posts/spring-boot-jpa-master-slave

### 1. SQLConfig.java

```java
package com.test;

import java.util.HashMap;
import java.util.Map;

import javax.sql.DataSource;

import com.zaxxer.hikari.HikariDataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.LazyConnectionDataSourceProxy;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@MapperScan(basePackages = "com.test.repo.postgreSQL")
@EnableTransactionManagement
public class PostgreSQLConfig {

  @Bean
  @ConfigurationProperties("spring.datasource.hikari.master")
  public DataSource dataSourceMaster() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }

  @Bean
  @ConfigurationProperties("spring.datasource.hikari.slave")
  public DataSource dataSourceSlave() {
    return DataSourceBuilder.create().type(HikariDataSource.class).build();
  }

  @DependsOn({"dataSourceMaster","dataSourceSlave"})
  @Bean
  public DataSource routingDataSource(@Qualifier("dataSourceMaster") DataSource dataSourceMaster,
      @Qualifier("dataSourceSlave") DataSource dataSourceSlave) {

    Map<Object, Object> dataSourceMap = new HashMap<>();
    dataSourceMap.put("master", dataSourceMaster);
    dataSourceMap.put("slave", dataSourceSlave);

    PostgreSQLRoutingDataSource routingDataSource = new PostgreSQLRoutingDataSource();
    routingDataSource.setTargetDataSources(dataSourceMap);
    routingDataSource.setDefaultTargetDataSource(dataSourceMaster);
    return routingDataSource;
  }

  @Primary
  @DependsOn({"routingDataSource"})
  @Bean
  public DataSource dataSource(@Qualifier("routingDataSource") DataSource routingDataSource) {
    return new LazyConnectionDataSourceProxy(routingDataSource);
  }

  @Bean
  public SqlSessionFactory sqlSessionFactory(@Qualifier("routingDataSource") DataSource dataSource) throws Exception {
    final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
    sessionFactory.setDataSource(dataSource);
    PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
    sessionFactory.setMapperLocations(resolver.getResources("classpath:mybatis/mapper/postgreSQL/*.xml"));
    Resource myBatisConfig = new PathMatchingResourcePatternResolver()
        .getResource("classpath:mybatis/config/mybatis-config.xml");
    sessionFactory.setConfigLocation(myBatisConfig);

    return sessionFactory.getObject();
  }

  @Bean
  public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception {
    final SqlSessionTemplate sqlSessionTemplate = new SqlSessionTemplate(sqlSessionFactory);
    return sqlSessionTemplate;
  }

}
```

작성하다가 어노테이션에 대한 것도 새로이 알게되었다.

- Qualifier : 동일한 타입을 갖는 빈 객체를 주입 시, 스프링에서는 알 수 없기 때문에 명시해주는 것.

- DependsOn : 스프링 순환 오류 발생 시, 의존성 순서를 지정하여 순환 오류가 발생하지 않도록 명시, DependsOn 뒤에 오는 Name 을 갖는 빈 주입 후, 다음 순서로 주입되게끔 함.

### 2. RoutingDataSource.java

```java
package com.test.config;

import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;
import org.springframework.transaction.support.TransactionSynchronizationManager;

public class PostgreSQLRoutingDataSource extends AbstractRoutingDataSource {

    @Override
    protected Object determineCurrentLookupKey() {
        boolean isReadOnly = TransactionSynchronizationManager.isCurrentTransactionReadOnly();
        if (isReadOnly) {
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃");
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃ DB Connection now is - slave - ＃＃＃＃＃＃＃＃＃＃＃");
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃");
            return "slave";
        } else {
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃");
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃ DB Connection now is - master - ＃＃＃＃＃＃＃＃＃＃＃");
            System.out.println("＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃＃");
            return "master";
        }
    }

}
```

### 3. application.yml

```yml

---
datasource:
  hikari:
    master:
      jdbc-url: jdbc:log4jdbc:postgresql://{url}
      driver-class-name: net.sf.log4jdbc.sql.jdbcapi.DriverSpy
      username: master
      password: master
    slave:
      jdbc-url: jdbc:log4jdbc:postgresql://{url}
      driver-class-name: net.sf.log4jdbc.sql.jdbcapi.DriverSpy
      username: slave
      password: slave
```

간단하게 설명하자면, Service 에 선언된 @Transactional 태그에 readOnly 가 true 냐 false 냐 에 따라 적용되는 ds가 달라지는 형태이다.

```java
@Transactional
or
@Transactional(readOnly = true)
```

미리 생성된 master 와 slave ds 객체를 맵 형태로 가지고 있다가, 호출 시 readOnly 여부를 판단하여 적절한 ds 를 리턴하여 sqlSession을 구성하게 된다.

- DependsOn 은 제거 후 빌드 시, 스프링 순환 오류가 발생하여 이를 막기 위해 추가하였다. 근데 다른 프로젝트에 동일하게 적용하면 빌드 시, 에러가 나지 않아 해당 구문을 가져갈 지, 고쳐야할 지 고민 중이다.
