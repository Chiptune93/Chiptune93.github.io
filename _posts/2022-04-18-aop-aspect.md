---
layout: post
title: AOP - AOP Aspect 를 이용한 로그 처리 하기
description: >
  [AOP] AOP Aspect 를 이용한 로그 처리 하기

hide_last_modified: true
categories: [Spring]
tags: [spring, spring aop]
---

- Table of Contents
{:toc .large-only}

## AOP 및 구성요소 간단 설명

스프링 핵심 구성 요소 중 하나인 AOP 는 로직을 관심사(Aspect)라는 부분으로 나누는 것으로 시작합니다.
OOP에서 모듈화의 핵심 단위는 클래스인 반면, AOP의 모듈화 단위는 Aspect 입니다.

종속성 주입은 애플리케이션 개체를 서로 분리하는데 도움이 되고, AOP는 개체와 횡단 관심사를 분리하는데 도움이 됩니다.

## [용어 설명]

Aspect

- 횡단 관심사를 제공하는 모듈, 예를 들어 지금 작성하려하는 로깅을 위한 모듈을 로깅을 위한 Aspect 라고 한다.

Join Point

- AOP 프로그램을 사용하여 작업할 애플리케이션의 위치

Advice

- 메소드 실행 전이나 후에 취해야 할 실제 조치

Point Cut

- Advice가 실행되는 하나 이상의 Join Point 위치, 표현식이나 패턴을 이용해 지정 가능.

Target Object

- 하나 이상의 Aspect 에서 Advice 가 실행되는 개체. 항상 프록시 객체이다.

Advice Type

- before - 메소드 실행 전
- after - 메소드 실행 후(에러 관계없이)
- after-returning - 메소드 "정상" 실행 후
- after-throwing - 메소드 실행 시, 에러 throwing한 경우
- around - 메소드 실행 전/후

From : https://www.tutorialspoint.com/springaop/springaop_implementations.htm

Spring AOP - Implementations

Spring AOP - Implementations Spring supports the @AspectJ annotation style approach and the schema-based approach to implement custom aspects. XML Schema Based Aspects are implemented using regular classes along with XML based configuration. To use the AOP

www.tutorialspoint.com

Log Aspect 작성
우리가 작성하는 코드의 목적은, 로그 실행 전/후에 로그를 남기며, 에러와 정상 실행을 구분하여 기록에 남기려 한다.
또한, 특정 컨트롤러에만 적용 시키거나 원치 않는 URL 또는 메소드 인 경우 제외하고자 한다.

단순히, 실행 전/후를 구분하여 특정 컨트롤러 Path 로만 Aspect 를 잡게 되면 해당 컨트롤러 내에 있는 제외되어야 하는 혹은 제외하고자 하는 메소드를 구분해내기는 쉽지 않다.

따라서, 아무 작업을 하지 않는 빈 Annotation을 만들어, 해당 Annotation을 Aspect에서 제외 시키면, 상기 목적을 이룰 수 있다.

이는 다음과 같은 PointCut 표현식으로 구현이 가능하다.

- NoLogging.java

```java
@Target({ ElementType.TYPE, ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
public @interface NoLogging {

}
```

- 사용

```java
@NoLogging
@RestController
public void index() {
	...
}
```

그리고 PoingCut에 다음과 같은 표현식을 작성한다

```java
@Pointcut("execution(* com.example.controller..*.*(..)) && !@annotation(com.example.aspect.NoLogging)")
private void cut() {
	// 컨트롤러 경로 내부 모든 메소드 + NoLogging 어노테이션 붙어있는 메소드 제외
}
```

위와 같은 PointCut 을 만들고, Advice에 적용해주면 된다. 아래는 작성한 코드이다.

- LogAspect.java

```java
import java.lang.reflect.Method;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LogAspect {
    private static final Logger logger = LoggerFactory.getLogger(LogAspect.class);

    // 로그 저장용 서비스
    @Autowired
    LogSvc svc;

    /**
     * Log Aspect를 적용할 패키지/타입/경로
     *
     * ex) controller 경로 / service 경로 / 메소드 등
     * 특정 폴더(패키지) : com.example.controller.menuMngt..*.*(..)
     * 특정 메소드(파라미터포함) : com.example.service.findId(HashMap<String, Object>)
     *
     * [구조]
     * 1. * : 리턴 타입 지정 (*:anything | public string | ...)
     * 2. com.acaas.admin.controller..*.* : 패키지 경로 및 메소드 명 등
     * 3. (..) : 파라미터 타입
     *
     * .. 더 많은 정보 : https://www.baeldung.com/spring-aop-pointcut-tutorial
     *
     * '!@annotation(com.acaas.admin.aspect.NoLogging)'
     * NoLogging 어노테이션이 붙은 메소드는 제외한다.
     */
    @Pointcut("execution(* com.acaas.admin.controller..*.*(..)) && !@annotation(com.acaas.admin.aspect.NoLogging)")
    private void cut() {
    }

    /**
     * 메소드 전 구역
     *
     * @param jp
     */
    @Around("cut()")
    public void Around(JoinPoint jp) {
        logInsert(jp);
    }

    /**
     * 메소드 실행 전
     *
     * @param jp
     */
    @Before("cut()")
    public void Before(JoinPoint jp) {
        String logType = "Before";
        logInsert(jp, logType, "-", "");
    }

    /**
     * 메소드 실행 후 <기본>
     * !! AfterReturning 과 Throwing 을 사용한다면, 기본 After는 사용하지 말아야 중복 실행 방지 가능함. !!
     *
     * @param jp
     */
    /*
     * @After("cut()")
     * public void After(JoinPoint jp) {
     * String logType = "After";
     * logInsert(jp, logType);
     * }
     */

    /**
     * 메소드 정상 종료 후
     *
     * @param jp
     */
    @AfterReturning("cut()")
    public void AfterReturning(JoinPoint jp) {
        String logType = "AfterReturning";
        logInsert(jp, logType, "200", "");
    }

    /**
     * 메소드 에러 ( Exception ) 리턴 경우
     *
     * @param jp
     */
    @AfterThrowing(value = "cut()", throwing = "e")
    public void AfterThrowing(JoinPoint jp, Exception e) {
        String logType = "AfterThrowing";
        logInsert(jp, logType, "500", e.getMessage());
    }

    /**
     * 실행된 메소드 명 가져오기
     *
     * @param joinPoint
     * @return
     */
    private Method getMethod(JoinPoint joinPoint) {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        return signature.getMethod();
    }

    /**
     * 로그 작업 구간
     * 커스터마이징 구간
     *
     * @param jp
     * @param logType
     * @param status
     * @param errorLog
     * @return
     */
    private int logInsert(JoinPoint jp, String logType, String status, String errorLog) {
        // 메소드 명 : 필요한 경우 사용
        Method method = getMethod(jp);
        // 메소드 실행 시 입력된 파라미터 가져오기
        Object[] args = jp.getArgs();
        // 파라미터 내용 가져오기
        HashMap<String, Object> paramMap = new HashMap<String, Object>();
        for (Object arg : args) {
            String type = arg.getClass().getSimpleName();
            // 특정 타입만 가져오기
            if (type.equals("HashMap<String, Object>")) {
                paramMap.putAll((HashMap<String, Object>) arg);
            }
        }
        // url check
        String chkUrl = paramMap.getStr("mappingUrl");
        boolean pass = this.chkUrl(chkUrl, paramMap);

        // url pass ?
        if (pass) {
            // 로그 테이블에 저장
            HashMap<String, Object> logMap = new HashMap<String, Object>();

            String userId = "";
            String userNm = "";
            if (JavaUtil.NVL(paramMap.get("session"), "").equals("")) {
                userId = "No Session :: userId";
                userNm = "No Session :: userNm";
            } else {
                userId = paramMap.get("session").getStr("id");
                userNm = paramMap.get("session").getStr("nm");
            }
            String url = paramMap.getStr("mappingUrl");
            String description = this.getDescription(url, paramMap);
            String urlParameter = paramMap.toString();

            logMap.put("logType", logType);
            logMap.put("userId", userId);
            logMap.put("userNm", userNm);
            logMap.put("url", url);
            logMap.put("description", description);
            logMap.put("urlParameter", urlParameter);
            logMap.put("status", status);
            logMap.put("errorLog", errorLog);
            logger.info("[Aspect] " + logType + " logMap : " + logMap);
            return svc.logInsert(logMap);
        } else {
            // none
            return -500;
        }
    }

    /**
     * URL check <DB>
     *
     * @param url
     * @param paramMap
     * @return
     */
    public boolean chkUrl(String url, HashMap<String, Object> paramMap) {
        String splitUrl = url.split("/admin")[1];
        logger.info("[LOG] chkUrl : " + splitUrl);
        // 1. 블랙리스트 방식으로 제외 URL 체크
        if (svc.chkTask(splitUrl, "black") > 0) {
            return false;
        } else {
            // 2. 화이트리스트 방식으로 DB에 등록된 task와 일치하는지 체크
            if (svc.chkTask(splitUrl, "white") > 0) {
                return true;
            } else {
                return false;
            }
        }
    }

    /**
     * 해당 작업 매핑된 작업내용 가져오기 <DB>
     *
     * @param url
     * @param paramMap
     * @return
     */
    public String getDescription(String url, HashMap<String, Object> paramMap) {
        String splitUrl = url;
        return svc.getDescription(splitUrl);
    }

}
```
