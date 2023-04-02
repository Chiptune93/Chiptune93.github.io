---
title: Spring/SpringBoot AOP 클래스 사용하기
categories: [Spring]
tags: [Spring, SpringBoot, AOP]
---


스프링과 스프링 부트에서는 AspectJ를 통한 AOP 등록방법이 상이하다.

따라서, 여기서는 기본적은 AOP 어드바이저를 등록하기 위해 어떤 설정을 해야하는지 살펴 볼 것이다.

## Spring AOP

등록 방식은 크게 2가지로 나뉜다.

- XML( 스키마 기반 방식 )
- @AspectJ ( 어노테이션 기반 방식)

## XML(스키마) 방식

제일 먼저 aspect 를 작성한다.

- 예제 소스 : 실행 시간을 계산하는 AOP 클래스

```java
public class RunningTimeAspect {
	public Object around(ProceedingJoinPoint jp) throws Throwable {
		long start = System.currentTimeMillis();
		try {
			return jp.proceed();
		} finally {
			long finish = System.currentTimeMillis();
			long time = finish - start;
			DecimalFormat df = new DecimalFormat("#.###");
			double time_d = time;
			System.out.println("- Finish Method Name : " + jp.toString() + " ◀");
			System.out.println("- Time Record Chk    : " + df.format(time_d / 1000) + " 초 ◀");
		}
	}
}
```

XML로 Aspect를 정의하기 위해서는 스프링이 제공하는 aop 태그를 사용해야 한다.

context 관련 XML에 아래의 요소들을 정의한다.

- xml 빈 설정

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:tx="http://www.springframework.org/schema/tx"
xmlns:aop="http://www.springframework.org/schema/aop" <- 추가됨.
xsi:schemaLocation="http://www.springframework.org/schema/beans
http://www.springframework.org/schema/beans/spring-beans-4.0.xsd
http://www.springframework.org/schema/tx 
http://www.springframework.org/schema/tx/spring-tx-4.0.xsd
http://www.springframework.org/schema/aop <- 추가됨.
http://www.springframework.org/schema/aop/spring-aop-4.0.xsd" <- 추가됨.
>
...
```

- aop config 등록

```xml
...
<!-- 해당 클래스를 빈으로 등록 -->
<bean id="aspectName" class="com.example.aspect"></bean>
<!-- aop 설정 시작 -->
<aop:config>
    <!-- aspect name 지정 -->
		<aop:aspect ref="aspectName">
      <!-- 해당 aspect 의 pointcut (실행기준) 지정 -->
			<aop:pointcut id="pointcutName" expression="execution(* com.example..*Service.*(..))" />
      <!-- 해당 aspect 의 정책 지정 -->
      <!-- 메소드는 지정한 클래스의 메소드 명을 작성한다 -->
			<aop:around method="methodName" pointcut-ref="pointcutName" />
		</aop:aspect>
	</aop:config>
...
```


## @AspectJ 어노테이션 방식

Spring AOP의 Runtime-weaving 으로 동작하는 방식.

자동 프록싱 설정이 필요한데, 여기서 AutoProxying이란 

Spring이 bean에 대해서 Aspect에 의해 advice를 받는지 판단하고 Proxy Object를 생성해주는 개념이다

### AutoProxying 활성화

Spring AOP에선 두 가지 방법을 통해 autoproxying 설정할 수 있다.

```
1. <aop:aspectj-autoproxy />
2. @Configuration, @EnableAspectJAutoProxy
```

XML에서 <aop:aspectj-autoproxy /> 태그를 작성하는 방법과 순수 Java 코드로 autoproxying 환경을 설정하는 방법이 있다.

```java
@Configuration
@EnableAspectJAutoProxy
@Import(RunningTimeAspect.class) /* bean import */
public class AspectJAutoProxyConfig {
    @Bean
    public RunningTimeAspect aspect() {
        return new RunningTimeAspect();
    }
}
```

Spring Boot에선 자체적으로 autoproxying 설정이 내장되어 있어

 @Aspect와 함께 @Component를 설정하여 Aspect를 자체적으로 bean으로 등록하여 사용한다.


- 예제 소스

```java
@Aspect /* Aspect 사용하겠다는 의미 */
@Component /* 컴포넌트 어노테이션을 통해 빈 등록 */
public class RunningTimeAspect {

    /* 포인트 컷 생성, 여기서는 com.exam.service 패키지 내 메소드에 대해 실행하겠다는 의미 */
    @Pointcut("execution(* com.exam.service..*.*(..))")
    private void cut() {
    }

    /* Around 정책으로 포인트컷에 대해 지정 */
    @Around("cut()")
    public Object Around(ProceedingJoinPoint jp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            /* ProceedingJoinPoint를 받아, 메소드 실행 후 다시 아래 finally 구문으로 복귀 */
            return jp.proceed();
        } finally {
            long finish = System.currentTimeMillis();
            long time = finish - start;
            DecimalFormat df = new DecimalFormat("#.##");
            double time_d = time;
            System.out.println("▶ Finish Method Name : " + jp.toString() + " ◀");
            System.out.println("▶ Time Record Chk    : " + df.format(time_d / 1000) + " 초 ◀");
        }
    }

}
```

## 마치며

아무래도 스키마 방식 보다는 어노테이션을 통한 관리가 좀 더 쉽게 느껴진다.

스키마 방식의 경우, 소스와 별개로 관리포인트가 한 곳 더 생기게 되어 불편하다.

어노테이션을 통한 방식이 좀 더 직관적이고 관리상 편리하다는 생각이 든다.