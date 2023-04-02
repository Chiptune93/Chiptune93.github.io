---

title: MyBatis Camel Case Configure
description: >
    스프링에서 myBatis Camel Case 옵션 사용 시 주의할 점.


categories: [Spring]
tags: [Spring, SpringBoot, AOP]
---



## MyBatis의 CamelCase 옵션.

마이바티스에서 DB 쿼리 질의 시 가져오는 항목명에 대해 카멜 케이스를 적용하는 옵션이다.

쉽게 말해 아래와 같은 쿼리를 작성하게 되면 

```xml
SELECT USER_ID FROM USER
```

옵션이 적용되어있지 않으면 아래와 같이 나오게 된다.

```java
result = { USER_ID = 'user1' };
```

여기서 옵션을 적용하게 되면 이렇게 변한다.

```java
result = { userId = 'user1' };
```

더 편하게 사용하기 위한 옵션으로 보면 된다.

## MyBatis에서 해당 옵션 작성하기

카멜 케이스를 적용하기 위해 아래의 방법 중 1가지를 택하여 작성한다.

xml 방식에서는 mapUnderscoreToCamelCase 라는 명칭을 사용하고

yml 방식에서는 map-underscore-to-camel-case 명칭을 사용한다.

- config.xml 작성하기.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN" "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
  <settings>
    <setting name="mapUnderscoreToCamelCase" value="true" />
  </settings>
  <typeAliases>
  <!-- ... -->
  </typeAliases>
</configuration>
```

- application.yml 사용하기.

```yml
...
mybatis:
  mapper-locations: mybatis/**/*.xml
  configuration:
    map-underscore-to-camel-case: true
  type-aliases-package: ...
...
```

옵션과 관련하여 더 많은 정보를 알고 싶다면 아래의 링크를 추천한다.

공식 사이트이며, 옵셔닝 관련 정보를 조회할 수 있다.

[mybatis.org](https://mybatis.org/mybatis-3/ko/configuration.html)


## 해당 옵션 사용 시, 주의할 점!

해당 옵션은 자바 빈 스펙이 적용되는 result Type 을 사용할 떄만 적요이 가능하다.

즉, 쿼리에 다음과 같이 작성하였을 경우 옵션이 적용되지 않는다.

```xml
<select id="select" parameterType="HashMap" resultType="HashMap">
    select * from user
</select>
```

이유는, HashMap은 JavaBeans 의 스펙이 아니기 때문이다.

따라서, 해당 옵션을 사용하고자 할 때는 JavaBeans 스펙에 해당하는 

resultType객체를 사용하여야 한다.


