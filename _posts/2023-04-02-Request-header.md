---
title: RequestHeader Annotation
categories: [Spring]
tags: [Spring, SpringBoot, RequestHeader]
---

# **@RequestHeader란?**
@RequestHeader는 스프링에서 제공하는 어노테이션 중 하나로, HTTP 요청 헤더 값을 컨트롤러 메서드의 매개변수로 받을 수 있게 해줍니다.

# **@RequestHeader 사용 방법**
@RequestHeader는 다음과 같이 사용할 수 있습니다.

```java
@GetMapping("/example")
public String exampleMethod(@RequestHeader("User-Agent") String userAgent) {
    // ...
}
```

위 코드에서는 @RequestHeader 어노테이션을 사용하여 "User-Agent" 헤더 값을 받아와서 userAgent 변수에 저장하고 있습니다.

@RequestHeader 어노테이션에는 다음과 같은 매개변수를 지정할 수 있습니다.

- value : 헤더 이름을 지정합니다. 생략 가능하며, 생략할 경우 매개변수 이름이 헤더 이름으로 사용됩니다.
- required : 헤더 값이 필수인지 여부를 지정합니다. 기본값은 true입니다.
- defaultValue : 헤더 값이 없을 경우 사용할 기본값을 지정합니다.

# **@RequestHeader 사용 예시**

@RequestHeader 어노테이션은 다양한 상황에서 사용할 수 있습니다. 예를 들어 다음과 같은 경우가 있습니다.

1. 인증 토큰 검증

    ```java
    @PostMapping("/example")
    public ResponseEntity<?> exampleMethod(@RequestHeader("Authorization") String authToken) {
        if (!isValidToken(authToken)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // ...
    }
    ```
위 코드에서는 "Authorization" 헤더 값을 받아와서 해당 토큰이 유효한지 검증하고 있습니다.

2. 로깅

    ```java
    @GetMapping("/example")
    public String exampleMethod(@RequestHeader(value = "User-Agent", defaultValue = "unknown") String userAgent) {
        logger.info("User-Agent: " + userAgent);

        // ...
    }
    ```
위 코드에서는 "User-Agent" 헤더 값을 받아와서 해당 값을 로깅하고 있습니다. 이때, defaultValue 매개변수를 사용하여 User-Agent 값이 없을 경우 "unknown" 값을 사용하도록 설정하였습니다.

# **마무리**

이상으로 @RequestHeader 어노테이션에 대한 간단한 소개와 사용 방법에 대해 알아보았습니다. @RequestHeader 어노테이션은 HTTP 요청 헤더 값을 받아와야 하는 상황에서 매우 유용하게 사용될 수 있습니다.