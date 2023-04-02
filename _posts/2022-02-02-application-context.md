---
title: Spring Boot - Application Context 사용하기
categories: [Spring]
tags: [applicationContext, SpringBoot]
---


## Application Context

어플리케이션 구성에 대한 접근을 가능케 하는 인터페이스 (설명)

Spring Boot 에서는 ApplicationContextAware 가 사용되며, 해당 인터페이스는 ApplicationContext에 대한 정보를 받고자 하는 개체에 의해 구현된다. 지금 살펴보고자 하는 것은, Beans에 액세스 하여 특정 Bean을 get 또는 set 하기 위한 방법이다.

```java
package helloworld;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.support.RootBeanDefinition;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.support.GenericApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;
import org.springframework.stereotype.Component;

@Component
public class Beans implements ApplicationContextAware {
	private static ApplicationContext applicationContext = null;

	public static ApplicationContext getApplicationContext() {
		return applicationContext;
	}

	public static GenericApplicationContext getGenericContext() {
		return (GenericXmlApplicationContext) applicationContext;
	}

	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.applicationContext = applicationContext;
	}

}
```

위 코드를 통해 ApplicationContext를 가져올 수 있으며, 빈에 액세스 할 수 있게된다.

`getApplicationContext().getBean()` 을 통해 원하는 곳에서 빈을 가져와 사용한다.

\*\* Spring 구동 시, ApplicationContextAware 구현이 발견되면 setApplicationContext를 실행한다.

참고 : https://stackoverflow.com/questions/34088780/how-to-get-bean-using-application-context-in-spring-boot
