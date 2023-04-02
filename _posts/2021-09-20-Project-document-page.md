---
title: Document Page
categories: [Project]
tags: [spa, project]
---

# 1. 개요

## 1. 필요성

함수나, 기타 정리가 필요한 부분이 생겼을 때, 보통 문서나 스프레드 시트에 저장하는 것이 보통이었는데 이렇다 보니 체계적으로 정리가 되지 않을 뿐더러, 찾기가 힘들고 평소에 어떤 내용이 담겨져 있는지 확인이 불가능 하였다. 개인적인 용도나 혹은 사내에 공유하기 위한 API Developer Document 처럼 정리할 수 있는 서비스가 있으면 좋겠다고 생각하였다.

## 2. 목적

목적은 필요성과 같은 맥락으로, 정리가 필요한 함수나 기타 클래스 등을 정리하여 빠르게 내부 인원에게 공유하거나 외부 인원에게 공유가 가능하도록 프로젝트 별 혹은 프레임워크 별로 정리된 문서를 작성 및 공유 하기 위함이다.

## 3. 사용 기술 스택

- Front : HTML & Vue.js

- Back : Spring Boot Framework + Gradle

- DB : RDB ( MYSQL / ORACLE ) or etc.

## 4. 서비스 구조 (초안)

![1-1](/assets/img/Project/1-1.png)

Spring Boot Framework 구성 시, 트랜잭션과 스프링 시큐리티 정도는 포함하여 구성하려고 생각 중이다.

또한 로그 처리 같은 기본적인 부분도 Boot Project 는 처음이라 공부하면서 진행할 예정이다.

그 외에 추가적으로 서비스를 SPA 방식으로 구성을 할까 생각 중인데, 적용을 할 수 있을 지 의문이다.

위 개념을 가지고 접근해볼 생각이며, 화면설계 부터 차근차근 진행해볼 예정이다.

# 2. 간단한 화면 설계

간단하게 생각났던 아이디어 및 화면 내용을 간단하게 파워포인트로 설계해보았다.

추후 진행 또는 한번 더 보면서 수정해 나갈 예정이다.

![1-2](/assets/img/Project/1-2.png)

![1-3](/assets/img/Project/1-3.png)

![1-4](/assets/img/Project/1-4.png)

![1-5](/assets/img/Project/1-5.png)

![1-6](/assets/img/Project/1-6.png)

![1-7](/assets/img/Project/1-7.png)

![1-8](/assets/img/Project/1-8.png)

![1-9](/assets/img/Project/1-9.png)

![1-10](/assets/img/Project/1-10.png)

![1-11](/assets/img/Project/1-11.png)

# 3. Spring Boot 기반 프로젝트 진행

프로젝트에 DB를 연동해야 해서, 고민을 해본 결과 ...

저장될 데이터가 많지 않고, 테이블도 많이 필요한게 아니라서 No SQL 쪽을 알아보았는데 사실상 요금문제가 있어서 어느정도 테스트와 간단한 구현 느낌으로 진행하는데에는 적합하지 않은 것 같아 RDB를 그냥 연동하기로 하였다.

DB는 ORACLE 이며, 우선 ORACLE 로 연결 되는 부분을 확인 후에, MYSQL 까지 연동 가능하게 수정할 예정이다.

우선, 프로젝트 환경은 다음과 같다.

- JDK11
- Spring Boot

기본적으로 vscode extension 에서 생성하는 부트 프로젝트를 기본적으로 사용하였다.

DB 환경은 HikariCP를 이용하여 Oracle 과 Connection 을 맺고, log4j 를 통해 DB 로그를 출력하는 것으로 하였다. 그리고, DB mapper 연동은 MyBatis 를 통해 진행한다.

## 1. 필요 Dependency 추가.

```gradle
// https://mvnrepository.com/artifact/org.mybatis.spring.boot/mybatis-spring-boot-starter
implementation group: 'org.mybatis.spring.boot', name: 'mybatis-spring-boot-starter', version: '2.1.4'

// log4j2
implementation group: 'org.bgee.log4jdbc-log4j2', name: 'log4jdbc-log4j2-jdbc4.1', version: '1.16'

// https://mvnrepository.com/artifact/com.oracle.database.jdbc/ojdbc8
implementation group: 'com.oracle.database.jdbc', name: 'ojdbc8', version: '21.1.0.0'
```

DB 커넥션을 위해서는 ojdbc 또한 필요하다. 버전마다 지원하는 JDK 버전이 다르니 확인이 필요하다.

## 2. application.yml 작성

보통 프로젝트 생성 후에는 application.properties 로 되어있지만, 편의를 위해 yml 파일로 바꾸었다. 그대로 properties 로 진행해도 상관 없으나, 표기법이 다르다.

# /resource/application.yml

```yml
spring:
  application:
    name: springboot-project-name

  # DB Connection
  datasource:
    hikari:
      jdbc-url: jdbc:log4jdbc:oracle:thin:@{oracle-db-url} # ex ) localhost:3306:utf8
      driver-class-name: net.sf.log4jdbc.sql.jdbcapi.DriverSpy
      username: { user-name }
      password: { user-password }
      maximum-pool-size: { connection-pool-size }
```

DB연결 정보를 작성한다.

## 3. log4j properties 작성

log4j 프로퍼티를 작성한다. 자세한 건 모르겠으나, 보통 이렇게 세팅하고 써서 그대로 가져왔다.

# /resource/log4j. log4jdbc.log4j2.properties.yml

```yml
log4jdbc.spylogdelegator.name = net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator
log4jdbc.dump.sql.maxlinelength = 0

#Disable - Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
log4jdbc.auto.load.popular.drivers = false
```

## 4. logback 작성

로그를 어떤 형식으로 어떻게 출력할 것이며, 로그 레벨을 지정한다.

# /resource/logback-spring.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
	<appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
		<layout class="ch.qos.logback.classic.PatternLayout">
			<Pattern>%d{HH:mm} %-5level %logger{36} - %msg%n</Pattern>
		</layout>
	</appender>
	<appender name="SAMPLE" class="ch.qos.logback.core.ConsoleAppender">
		<encoder>
			<pattern>[%d{yyyy-MM-dd HH:mm:ss}:%-3relative][%thread] %-5level %logger{35} - %msg%n</pattern>
		</encoder>
	</appender>

	<logger name="{project-package-dir}" level="DEBUG" additivity="false">
		<appender-ref ref="SAMPLE" />
	</logger>
	<root level="INFO">
		<appender-ref ref="STDOUT" />
	</root>
	<logger name="jdbc" level="OFF" />
	<logger name="jdbc.sqlonly" level="OFF" />
	<logger name="jdbc.sqltiming" level="DEBUG" />
	<logger name="jdbc.audit" level="OFF" />
	<logger name="jdbc.resultset" level="OFF" />
	<logger name="jdbc.resultsettable" level="DEBUG" />
	<logger name="jdbc.connection" level="OFF" />
</configuration>
```

## 5. mybatis config 작성

Mybatis 설정을 작성한다. 필요한 옵션만 검색하여 작성하였다.

# /resource/mybatis/mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <settings>
    <setting name="mapUnderscoreToCamelCase" value="true" />
    <!-- column이 NULL 일 경우에도 출력 -->
    <setting name="callSettersOnNulls" value="true" />
    <!-- row가 NULL 일 경우에도 출력 -->
    <setting name="returnInstanceForEmptyRow" value="true" />
  </settings>
</configuration>
```

## 6. DB config java 파일 작성

실제로 커넥션 시, 사용할 DataSource 와 Sql Session Template 을 사용하도록 작성한다.

mapper 와 설정 파일 경로를 지정하여 불러오고 찾을 수 있도록 한다.

# {package-dir}/config/DBconfig.java

```java
import javax.sql.DataSource;

import com.zaxxer.hikari.HikariDataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

@Configuration
@MapperScan(basePackages = "{repositoey-dir}")
public class DatabaseConfig {

    @Bean
    @ConfigurationProperties("spring.datasource.hikari")
    public DataSource dataSource() {
        return DataSourceBuilder.create().type(HikariDataSource.class).build();
    }

    @Bean
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
        sessionFactory.setDataSource(dataSource);
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
        sessionFactory.setMapperLocations(resolver.getResources("classpath:mapper/*.xml"));
        Resource myBatisConfig = new PathMatchingResourcePatternResolver()
                .getResource("classpath:mybatis/mybatis-config.xml");
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

여기까지 작성하고, 각 Service 와 Repository 를 작성하여 실행하면 바로 테스트 및 실행이 가능했다.

각 내용들은 깃헙에 정리하여 올려놓았다.

무언가 바로바로 프로젝트를 생성하여 진행하고 싶을 때, 이런 퀵 스타팅이 가능한 채로 세팅이 되어있으면 좋겠다고 생각해서 이런 내용들을 정리할 때마다 깃헙에 올려놓고 쓰면 좋을 것 같다.

https://github.com/Chiptune93/Library/tree/main/Spring/QuickStart/SpringBoot/JDK11/Mybatis%2BHikariCP%2BOracle

# 4. 프로젝트 완성 및 운영환경 결정

프로젝트 기능 구성을 끝내고, 퍼블 작업을 부탁했다. 생각보다 심플하게 나와서 화면 설계 만큼 복잡하게 구성하지 않아도 되었고

로그인 같은 기능도 빼고 대신 관리 기능의 변환을 키보드 입력을 통해 하기로 했다.

![1-12](/assets/img/Project/1-12.png)

이런 식으로 페이지는 완성이 되었고, 이를 이제 어떻게 운영할 것인가에 대한 문제가 남았었다.

최근, 프로젝트 하나를 진행하면서 Docker를 Study 하기도 했고, 회사 내부에서도 이를 위한 서버를 하나 마련한 상태였다. 따라서, 나는 이 프로젝트를 Docker 이미지화 하여 Docker 서버에 올려 운영하기로 했다. 그리고 DB 또한 최근 진행한 프로젝트에서 사용한 Postgresql 을 사용하기로 하고 이것 또한, 서버에 올려놓고 사용하기로 했다.

간단하게 서버에서 작업한 내용은 다음과 같았다.

1. Docker & Docker Compose 설치.

2. Docker Image pull 받기 > Postgresql, 만든 프로젝트의 image

3. Docker run으로 run 시키기.

- Dockerfile

```dockerfile
FROM adoptopenjdk/openjdk11
EXPOSE 8080:8080
ARG WAR_FILE=build/libs/api.war
COPY ${WAR_FILE} api.war
ENTRYPOINT [ "java", "-jar", "/api.war" ]
```

단순하게 war로 말린 이미지를 run 하는 것이다.

- 사용한 Command

1. build

```
docker build -t api:1.0 .
```

2. docker run

```
docker run -d -p 8080:8080 --name syworks-api api:1.0
```

3. docker push

```
docker push api:1.0
```

이로써 뭔가 빠르게 빠르게 첫 Spring Boot + Vuejs 프로젝트는 Docker기반으로 운영하기로 하는 바람에 생각보다 금방 끝나게 되었다.

추가적으로, 이번 프로젝트를 운영에 올리면서 nginx를 올려서 여러개 프로젝트를 운영할 수 있게 하는 것을 내부에서 제안하셔서 그것도 고려해보게 되었다. 아마 다음번 개인 프로젝트를 진행하게 된다면 고려해보아야 겠다.

# 5. 완료 및 공유

https://github.com/Chiptune93/DocumentsPage

해당 프로젝트는 개발 종료 하고, 다음 프로젝트를 구상해보겠습니다 :D
