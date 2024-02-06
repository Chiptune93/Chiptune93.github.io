---
title: Yaml Value to List Object
categories: [Backend, Spring]
tags: [application.yml, yml value, properties to value]
---

application.yml 에서 설정된 List 값을 애플리케이션 내에서 List Object로 받아서 사용하는 방법.

## application.yml 에서 값 설정하기
- 파일 확장자 화이트 리스트를 설정하는 예로 설명한다.
- 다음과 같이 설정되어 있다고 가정한다.

```yaml
file:
 upload-extn-white-list:  
  - "jpg"  
  - "png"  
  - "gif"  
  - "jpeg"  
  - "bmp"  
  - "xlsx"  
  - "ppt"  
  - "pptx"  
  - "txt"  
  - "hwp"
```

yaml 파일에서는 `-`를 통해 구분하여 요소를 구분하고 동일 수준의 들여쓰기를 통해 같은 요소임을 공유한다.
## 애플리케이션에서 사용하기

- 버전 정보
  - Springboot 3.2.X
  - Kotlin with Java 17

```kotlin
...
@Value("\${file.upload-extn-white-list}")  
val uploadExtnWhiteList: List<String>
...
```

위와 같이 `@Value` 어노테이션을 통해 값을 가져와 바인딩 할 수 있다.
List 형태의 오브젝트 외에도 Map 형태로도 값을 가져와 세팅할 수 있다.

### 참고 문서
https://www.baeldung.com/spring-boot-yaml-list
