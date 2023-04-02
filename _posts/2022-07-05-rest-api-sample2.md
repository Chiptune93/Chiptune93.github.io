---

title: SpringBoot - Rest Api Sample 만들기 #2
description: >
  [SpringBoot] Rest Api Sample 만들기 #2


categories: [Spring]
tags: [springboot, rest api, api, h2database]
---



## API 에러 처리

에러가 발생할 수 있는 상황부터 정의해보자

서비스 로직 내에서 Exception 이 발생하는 경우.
로직 외 적인 부분 ( 잘못된 URL 호출, 등 ) 에서 에러가 발생하는 경우.
위 두가지 케이스에서 에러가 발생하더라도, 동일한 포맷으로 나가게끔 유도하려고 한다.

우선, 기본적으로 정의한 폼은 다음과 같습니다.

```json
{
 "result_status": "success",
 "result_code": 200,
 "result_message": "요청에 성공하였습니다.",
 "result": { ... }
}
```

그리고 해당 포맷을 위한 응답 객체를 생성합니다. 해당 객체를 통해 컨트롤러에서 응답을 리턴할 때는 `return new ResponseEntity<ApiResFormat>(new ApiResFormat(),HttpStatus.OK);` 과 같이 리턴할 예정입니다.

```java
package rest.api.sample.response;

import java.util.HashMap;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ApiResFormat {
    // result_status -> fail / success
    private String result_status;
    // result_code -> 200 / 4XX / 5XX
    private int result_code;
    // result_message -> NOT ACCEPTED , EXCEPTION ...
    private String result_message;
    // result -> result obj
    private HashMap<String, Object> result = new HashMap<String, Object>();

    /* 결과 예시 */
    /*
    {
        "result_status": "success",
        "result_code": 200,
        "result_message": "요청에 성공하였습니다.",
        "result": {
            ...
        }
    }
    */

    public ApiResFormat() {

    }

    public ApiResFormat(String status, int resultCode, String resultMessage, Object resultObj) {
        this.result_status = status;
        this.result_code = resultCode;
        this.result_message = resultMessage;
        result.put("data", resultObj);
    }

    public ApiResFormat(int resultCode, Object resultObj) {
        this.result_status = "success";
        this.result_code = resultCode;
        this.result_message = "요청에 성공하였습니다.";
        result.put("data", resultObj);
    }

    public ApiResFormat(int resultCode, String resultMessage, Object resultObj) {
        this.result_status = "success";
        this.result_code = resultCode;
        this.result_message = resultMessage;
        result.put("data", resultObj);
    }

    public ApiResFormat(String resultMessage, Object resultObj) {
        this.result_status = "success";
        this.result_code = 200;
        this.result_message = resultMessage;
        result.put("data", resultObj);
    }

    public ApiResFormat(Object resultObj) {
        this.result_status = "success";
        this.result_code = 200;
        this.result_message = "요청에 성공하였습니다.";
        result.put("data", resultObj);
    }
}
```

실패의 경우에는 실패에 맞게 바꿔 줄 생각이다. 이제 1번 케이스의 경우에는 어떻게 처리할 것인가에 대한 내용입니다.

```java
@RestControllerAdvice, @ExceptionHandler
RestControllerAdvice 는 컨트롤러 단의 설정들을 할 수 있게 해주는 ControllerAdvice 의 확장 버전으로 응답 객체를 리턴할 수 있는 것이 특징이고, ExceptionHandler 는 Controller 단에서 발생하는 Exception을 핸들링 할 수 있도록 합니다.

따라서, 엔드포인트 컨트롤러 단에서 발생하는 Exception을 캐치하여 원하는 포맷으로 리턴하기 위해 아래와 같이 설정 했습니다.

package rest.api.sample.error;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import rest.api.sample.response.ApiResFormat;

@RestControllerAdvice
public class GlobalExceptionHandler extends RuntimeException {

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResFormat> globalException(Exception ex) {
        return new ResponseEntity<ApiResFormat>(new ApiResFormat("fail", 500, "요청에 실패하였습니다.", null),
                HttpStatus.INTERNAL_SERVER_ERROR);
    }

}
```

이렇게 하면 컨트롤러를 통해 로직 수행 중 발생하는 Exception 을 캐치하여 리턴해줄 수 있게 됩니다.

다음은, 로직 외 에러 상황에 대한 처리입니다.

## DefaultErrorAttributes.class

DefaultErrorAttributes 는 기본적으로 스프링 부트에서 에러 발생 시 리턴하는 객체를 컨트롤 할 수 있게 해주는 클래스입니다. 기본적으로 스프링 부트는 에러 발생 시, JSON 형태로 에러를 리턴하게 되는데 그 내부의 항목들을 해당 클래스를 통해 제어할 수 있습니다.

```java
package rest.api.sample.error;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.web.error.ErrorAttributeOptions;
import org.springframework.boot.web.servlet.error.DefaultErrorAttributes;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.WebRequest;

@Component
public class RestResponseEntityExceptionHandler extends DefaultErrorAttributes {

    /**
     * @apiNote 에러 발생 시, repsonse 통일을 위한 메소드
     * @param webRequest
     * @param options
     * @return
     *         result_status = FAIL
     *         result_message = 잘못된 요청 URL 입니다.
     */
    @Override
    public Map<String, Object> getErrorAttributes(
            WebRequest webRequest, ErrorAttributeOptions options) {
        HashMap<String, Object> result = new HashMap<String, Object>();
        result.put("data", null);
        Map<String, Object> errorAttributes = super.getErrorAttributes(webRequest, options);
        errorAttributes.put("result_status", "fail");
        errorAttributes.put("result_code", Integer.parseInt(errorAttributes.get("status").toString()));
        errorAttributes.put("result_message", "허용되지 않은 접근 입니다.");
        errorAttributes.put("result", result);
        errorAttributes.remove("timestamp");
        errorAttributes.remove("status");
        errorAttributes.remove("message");
        errorAttributes.remove("error");
        errorAttributes.remove("path");
        if (errorAttributes.containsKey("trace"))
            errorAttributes.remove("trace");
        return errorAttributes;
    }

}
```

따라서, 위 클래스를 통해 필요한 항목은 추가하고 보여줄 필요가 없는 trace 항목이나 다른 항목들은 제외를 시켜 에러 발생시 response 형태를 최대한 통일 시키도록 작성하였습니다.

에러 발생 시 리턴 객체

![restapi4](/assets/img/Spring/restapi4.png)
