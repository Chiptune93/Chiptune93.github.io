---
title: Spring Boot - Tag Library 사용하기
categories: [Spring]
tags: [tag library, SpringBoot]
---

## 1. TagLibrary build.gradle 추가

```gradle
// taglibs
implementation group: 'org.apache.taglibs', name: 'taglibs-standard-impl', version: '1.2.5'
```

## 2. tld 설정 파일 추가

WEB-INF/tlds 폴더에 사용할 커스텀 태그 라이브러리 파일 생성

```xml
<?xml version="1.0" encoding="UTF-8"?>
<taglib version="2.1" xmlns="http://java.sun.com/xml/ns/javaee" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-jsptaglibrary_2_1.xsd">

    <display-name>JSTL functions</display-name>
    <tlib-version>1.2.5</tlib-version>
    <short-name>cLibrary</short-name>
    <uri>http://java.sun.com/jsp/jstl/functions</uri>

    <function>
        <name>{사용할 이름}</name>
        <function-class>{사용할 클래스 파일 위치( com.demo.lib.name )}</function-class>
        <function-signature>{클래스 파일 내 리턴타입 + 메소드 명( String getString() )}</function-signature>
    </function>


</taglib>
```

## 3. 사용예시

사용하고자 하는 jsp 파일 내부 상단에 선언하여 사용

```jsp
<%@ taglib prefix="test" uri="/WEB-INF/tlds/test.tld"%>
...
${test:getString()} // usage
```
