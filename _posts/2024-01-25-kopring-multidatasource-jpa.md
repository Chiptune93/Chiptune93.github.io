---
title: Kopring, JPA 멀티 데이터 소스 구현 하기
categories: [Backend, Spring]
tags: [Kopring, Kotlin, multi-datasource, jpa]
---

## Kopring 환경에서 JPA를 이용한 멀티 데이터 소스 환경 구축

### 버전 정보

- Spring Boot 3.2.2
- JPA
- Java 17
- Kotlin

## 기본 개념 알기

스프링 부트에서는 아래의 순서대로 데이터 소스를 찾고 연결하려고 시도한다.

1. HikariCP
2. Tomcat Pooling
3. Common DPCP
4. Oracle UCP

데이터 소스 빌더에 의해 지원되는 커넥션 풀은 아래와 같다.

- HikariCP
- Tomcat pooling Datasource
- Commons DBCP2
- Oracle UCP & OracleDataSource
- Spring Framework’s SimpleDriverDataSource
- H2 JdbcDataSource
- PostgreSQL PGSimpleDataSource
- C3P0

Spring Data 의존성에는 기본적으로 HikariCP가 내장되어 있어, 이를 의존성에 포함한다면 기본적으로 HIkariCP를 통해 데이터소스를 구성하려 시도한다.

기본적으로 Spring Boot는 spring.datasource.* 접두어가 붙은 구성 속성을 사용하여 기본 DataSource를 인스턴스화한다.

`implementation("org.springframework.boot:spring-boot-starter-data-*")`

SpringBoot 에서 데이터 소스를 생성할 때, 기본적으로 참조되는 설정 경로는 spring.datasource 이다.

최소한 spring.datasource.url속성을 설정하여 URL을 지정해야 한다. 그렇지 않으면 Spring Boot는 내장된 데이터베이스를 자동 구성하려고 시도한다.

Spring Boot는 URL에서 대부분의 데이터베이스에 대한 JDBC 드라이버 클래스를 추론할 수 있습니다. 특정 클래스를 지정해야 하는 경우 spring.datasource.driver-class-name속성을 사용할 수 있습니다.

build.gradle.kts

```kts
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "3.2.2"
    id("io.spring.dependency-management") version "1.1.4"
    kotlin("jvm") version "1.9.22"
    kotlin("plugin.spring") version "1.9.22"
}

group = "kopring"
version = "0.0.1-SNAPSHOT"

java {
    sourceCompatibility = JavaVersion.VERSION_17
}

configurations {
    compileOnly {
        extendsFrom(configurations.annotationProcessor.get())
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    testImplementation("org.springframework.boot:spring-boot-starter-test")

    // devtools
    developmentOnly("org.springframework.boot:spring-boot-devtools")

    // jakson
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")

    // lombok
    compileOnly("org.projectlombok:lombok")
    annotationProcessor("org.projectlombok:lombok")

    // jpa
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")

    // database driver what you required
    implementation("org.postgresql:postgresql")
    implementation("com.mysql:mysql-connector-j")
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs += "-Xjsr305=strict"
        jvmTarget = "17"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

```

## 2개의 데이터 소스 구성하기

여러 개의 데이터 소스가 존재할 때는, @Primary 어노테이션을 통해 어떤 데이터 소스 빈을 먼저 등록할 것인지 지정해야 한다.
커스텀 데이터 소스를 생성하면 자동 구성이 되지 않는다.
그리고, 기본 설정을 자동 구성으로 하지 않도록 설정해 놓고 소스를 구성해야 한다.

이 예제에서는 Primary 데이터베이스로 MYSQL, Secondary 데이터베이스로 Postgres를 연결하는 상황을 가정해서
드라이버 세팅을 진행했다.

필요한 설명은 각 소스에 주석 처리로 설명을 대신한다.

### application.yml

```yml
spring:
  datasource:
    # example mysql database
    first:
      driver-class-name: com.mysql.cj.jdbc.Driver
      url: jdbc:mysql://{host}:{port}/{databaseName}
      username: { id }
      password: { password }
      configuration:
        maximum-pool-size: 30
      # jpa config
      jpa:
        hibernate:
          dialect: org.hibernate.dialect.MySQLDialect
          format_sql: true
          ddl-auto: none
          show_sql: true
    # example postgres database
    second:
      driver-class-name: org.postgresql.Driver
      url: jdbc:postgresql://{host}:{port}/{databaseName}
      username: { id }
      password: { password }
      # jpa config
      jpa:
        hibernate:
          dialect: org.hibernate.dialect.PostgreSQLDialect
          format_sql: true
          ddl-auto: none
          show_sql: true
          # 특정 스키마로 접속할 때 사용하는 옵션.
          default_schema: {schema-name}
          physical_naming_strategy: org.hibernate.boot.model.naming.CamelCaseToUnderscoresNamingStrategy


# logging이 필요한 경우 활성화
#logging:
#  level:
#    root: DEBUG
#  org:
#    springframework: DEBUG
#  console:
#    enabled: true


```

### PrimaryConfig

```kotlin
package kopring.project.config

import com.zaxxer.hikari.HikariDataSource
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import org.springframework.core.env.Environment
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.orm.jpa.JpaTransactionManager
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter
import org.springframework.transaction.PlatformTransactionManager
import java.util.*

@Configuration // 설정 클래스로 지정한다.
@EnableAutoConfiguration(exclude = [DataSourceAutoConfiguration::class]) // 데이터베이스 자동 설정 기능을 이용하지 않는다. (커스텀 데이터 소스 구성)
// 자동 설정 기능을 키게 되면, 스프링은 기본 데이터 소스를 어떤 것으로 지정해야 될 지 모르기 때문에, 기능을 꺼야 한다.
// 기본 데이터 소스를 히카리를 사용해서 @Primary를 통해 올려도 이를 기본 데이터 소스로 인식하지 않는 듯 하다.
// 아마. 자동으로 올리는 기능으로 인하여 새로 데이터 소스가 생성되어 설정 값이 존재하지 않아 그러는 듯 하다.
@EnableJpaRepositories( // Jpa Repository 스캔 및 엔티티/트랜잭션 매니저를 지정하기 위한 설정이다.
    basePackages = ["kopring.project.repo.primary"],
    entityManagerFactoryRef = "primaryEntityManagerFactory",
    transactionManagerRef = "primaryTransactionManager"
)
class PrimaryDatabaseConfig(private val env: Environment) {

    /**
     * 커스텀 데이터 소스 설정 가져오기. (설정 방식은 application.yml 에서 하는 방식, 자바에서 직접 하는 방식 등이 있다.)
     */
    @Bean
    @Primary
    @ConfigurationProperties("spring.datasource.first")
    fun firstDataSourceProperties(): DataSourceProperties {
        return DataSourceProperties()
    }

    /**
     * 데이터 소스 생성, 설정 프로퍼티를 가져와 hikariCP 데이터 소스를 생성한다.
     */
    @Bean
    @Primary
    @ConfigurationProperties("spring.datasource.first.configuration")
    fun firstDataSource(firstDataSourceProperties: DataSourceProperties): HikariDataSource {
        return firstDataSourceProperties.initializeDataSourceBuilder().type(HikariDataSource::class.java).build()
    }

    /**
     * SessionFactoryBean과 동일하게 DataSource와 Hibernate Property, Entity가 위치한 package를 지정
     * Hibernate 기반으로 동작을 지정하는 JpaVendor를 설정
     * Hibernate vendor과 JPA 간의 Adapter를 설정
     */
    @Bean
    @Primary
    fun primaryEntityManagerFactory(): LocalContainerEntityManagerFactoryBean {
        val em = LocalContainerEntityManagerFactoryBean()
        // 데이터 소스 사용 지정
        em.dataSource = firstDataSource(firstDataSourceProperties())
        // 해당 엔티티 매니저가 관리할 패키지 지정
        em.setPackagesToScan(*arrayOf("kopring.project.entity.primary"))

        // JPA Adapter 지정
        val vendorAdapter = HibernateJpaVendorAdapter()
        vendorAdapter.setShowSql(true)
        vendorAdapter.setGenerateDdl(true)
        em.jpaVendorAdapter = vendorAdapter
        // JPA Properties 설정.
        em.setJpaProperties(primaryJpaProperties())

        return em
    }

    /**
     * @Transactional이 포함된 메서드가 호출될 경우, PlatformTransactionManager를 사용하여 트랜잭션을 시작하고,
     * 정상 여부에 따라 Commit 또는 Rollback 한다.
     */
    @Bean
    @Primary
    fun primaryTransactionManager(): PlatformTransactionManager {
        val transactionManager = JpaTransactionManager()
        transactionManager.entityManagerFactory = primaryEntityManagerFactory().getObject()
        return transactionManager
    }

    /**
     * primary database config 의 JPA 설정 값 로드
     */
    fun primaryJpaProperties(): Properties {
        val properties = Properties()
        properties.setProperty("hibernate.ddl-auto", env.getProperty("spring.datasource.first.jpa.hibernate.ddl-auto"))
        properties.setProperty("hibernate.dialect", env.getProperty("spring.datasource.first.jpa.hibernate.dialect"))
        properties.setProperty("hibernate.format_sql", env.getProperty("spring.datasource.first.jpa.hibernate.format_sql"))
        properties.setProperty("hibernate.show_sql", env.getProperty("spring.datasource.first.jpa.hibernate.show_sql"))
        return properties
    }

}

```

### SecondaryConfig

```kotlin
package kopring.project.config

import com.zaxxer.hikari.HikariDataSource
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.env.Environment
import org.springframework.data.jpa.repository.config.EnableJpaRepositories
import org.springframework.orm.jpa.JpaTransactionManager
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter
import org.springframework.transaction.PlatformTransactionManager
import java.util.*


@Configuration
@EnableAutoConfiguration(exclude = [DataSourceAutoConfiguration::class])
@EnableJpaRepositories(
    basePackages = ["kopring.project.repo.secondary"],
    entityManagerFactoryRef = "secondaryEntityManagerFactory",
    transactionManagerRef = "secondaryTransactionManager"
)
class SecondaryDatabaseConfig(private val env: Environment) {

    /**
     * 커스텀 데이터 소스 설정 가져오기. (설정 방식은 application.yml 에서 하는 방식, 자바에서 직접 하는 방식 등이 있다.)
     */
    @Bean
    @ConfigurationProperties("spring.datasource.second")
    fun secondDataSourceProperties(): DataSourceProperties {
        return DataSourceProperties()
    }

    /**
     * 데이터 소스 생성, 설정 프로퍼티를 가져와 hikariCP 데이터 소스를 생성한다.
     */
    @Bean
    @ConfigurationProperties("spring.datasource.second.configuration")
    fun secondDataSource(secondDataSourceProperties: DataSourceProperties): HikariDataSource {
        return secondDataSourceProperties.initializeDataSourceBuilder().type(HikariDataSource::class.java).build()
    }

    /**
     * SessionFactoryBean과 동일하게 DataSource와 Hibernate Property, Entity가 위치한 package를 지정
     * Hibernate 기반으로 동작을 지정하는 JpaVendor를 설정
     * Hibernate vendor과 JPA 간의 Adapter를 설정
     */
    @Bean
    fun secondaryEntityManagerFactory(): LocalContainerEntityManagerFactoryBean {
        val em = LocalContainerEntityManagerFactoryBean()
        em.dataSource = secondDataSource(secondDataSourceProperties())
        em.setPackagesToScan(*arrayOf("kopring.project.entity.secondary"))

        val vendorAdapter = HibernateJpaVendorAdapter()
        vendorAdapter.setShowSql(true)
        vendorAdapter.setGenerateDdl(true)
        em.jpaVendorAdapter = vendorAdapter
        // JPA Properties 설정.
        em.setJpaProperties(secondaryJpaProperties())

        return em
    }

    @Bean
    fun secondaryTransactionManager(): PlatformTransactionManager {
        val transactionManager = JpaTransactionManager()
        transactionManager.entityManagerFactory = secondaryEntityManagerFactory().getObject()
        return transactionManager
    }

    /**
     * secondary database config 의 JPA 설정 값 로드
     */
    fun secondaryJpaProperties(): Properties {
        val properties = Properties()
        properties.setProperty("hibernate.ddl-auto", env.getProperty("spring.datasource.second.jpa.hibernate.ddl-auto"))
        properties.setProperty("hibernate.dialect", env.getProperty("spring.datasource.second.jpa.hibernate.dialect"))
        properties.setProperty("hibernate.format_sql",env.getProperty("spring.datasource.second.jpa.hibernate.format_sql"))
        properties.setProperty("hibernate.show_sql", env.getProperty("spring.datasource.second.jpa.hibernate.show_sql"))
        properties.setProperty("hibernate.default_schema", env.getProperty("spring.datasource.second.jpa.hibernate.default_schema"))
        properties.setProperty("hibernate.physical_naming_strategy", env.getProperty("spring.datasource.second.jpa.hibernate.physical_naming_strategy"))
        return properties
    }


}

```

위 처럼 데이터 소스를 구성한 후, JPA 사용을 위한 
JPA Repository 설정 및 패키징 경로를 구성한다.

## JPA 구성 및 엔티티 설정

### entity > primary > primaryEntity.kt

```kotlin
package kopring.project.entity.primary

import jakarta.persistence.*

@Entity
@Table(name = "primary_entity")
data class PrimaryEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: Int = 0,

    val name: String = "",

    val age: Int = 0,

    val city: String = ""

)

```

### entity > secondary > secondaryEntity.kt

```kotlin
package kopring.project.entity.secondary

import jakarta.persistence.*

@Entity
@Table(name = "secondary_entity")
data class SecondaryEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    val id: Int = 0,

    val name: String = "",

    val age: Int = 0,

    val city: String = ""
)

```

### repo > primary > primaryRepository.kt

```kotlin
package kopring.project.repo.primary
import kopring.project.entity.primary.PrimaryEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

// Primary DataSource Repository
@Repository
interface PrimaryRepository : JpaRepository<PrimaryEntity, Int> { }

```

### repo > secondary > secondaryRepository.kt

```kotlin
package kopring.project.repo.secondary

import kopring.project.entity.secondary.SecondaryEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

// Secondary DataSource Repository
@Repository
interface SecondaryRepository : JpaRepository<SecondaryEntity, Int>

```

위와 같이 엔티티와 JPA 를 구성 했으면 구성 자체는 끝이 난다.
이제 이를 이용하여 실제 접속이 가능한지 테스트를 진행해본다.

## 테스트 메소드 작성

아래 테스트 메소드는 실제 레파지토리가 접속하여 데이터를 가져올 수 있는
상태인지 확인하는 내용을 담고 있다.

### MultiDatasourceTest.kt

```kotlin
import kopring.project.repo.primary.PrimaryRepository
import kopring.project.repo.secondary.SecondaryRepository
import kopring.project.config.PrimaryDatabaseConfig
import kopring.project.config.SecondaryDatabaseConfig
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest


// 패키징 경로의 위치가 실제 설정 클래스 와 동일 하지 않아, 설정 파일을 로드 하도록 설정
@SpringBootTest(classes = [PrimaryDatabaseConfig::class, SecondaryDatabaseConfig::class])
/**
 * 설정한 데이터 소스가 정상적 으로 올라 오는 지 테스트 메소드
 * 1. Primary DB
 * 2. Secondary DB
 */
class MultiDataSourceTest {

    @Autowired
    lateinit var primaryRepository: PrimaryRepository

    @Autowired
    lateinit var secondaryRepository: SecondaryRepository

    @Test
    fun testPrimaryDataSource() {
        Assertions.assertNotNull(primaryRepository)
        // Add your primary data source tests here
        println(primaryRepository.findAll())
        Assertions.assertEquals(0, primaryRepository.count())
    }

    @Test
    fun testSecondaryDataSource() {
        Assertions.assertNotNull(secondaryRepository)
        // Add your secondary data source tests here
        println(secondaryRepository.findAll())
        Assertions.assertEquals(0, secondaryRepository.count())
    }
}

```

### 테스트 결과 확인

![kopring-1.png](..%2Fassets%2Fimg%2Fkopring%2Fkopring-1.png)

테스트가 정상적으로 성공했다.


## 소스 참고

[https://github.com/Chiptune93/kopring.project/tree/feature/multi-datasource-jpa](https://github.com/Chiptune93/kopring.project/tree/feature/multi-datasource-jpa)

## 문서 참고

- [데이터 소스 생성 가이드](https://docs.spring.io/spring-boot/docs/current/reference/html/data.html#data.sql.datasource)
- [데이터 액세스 가이드](https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.data-access)
- [Spring JPA – Multiple Databases | Baeldung](https://www.baeldung.com/spring-data-jpa-multiple-databases)
- [Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto.data-access.configure-two-datasources) 
