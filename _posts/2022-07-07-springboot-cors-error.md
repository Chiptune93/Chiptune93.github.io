---
title: SpringBoot 2.7+ CORS 이슈 및 해결방법
categories: [Etc, Error]
tags: [springboot, cors]
---

간단하게 만든 API 서버를 테스트 하기 위해 로컬에서 돌리던 도중 해당 이슈를 만났다.

구성은 다음과 같다.

- localhost:8080/users - SpringBoot API Server 에서 유저 데이터를 리턴.
- localhost:8090/index.html - API서버로 요청을 보내는 스크립트가 있는 html 페이지

### index.html

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
  </head>

  <body>
    <div id="app">{{ message }}</div>
    <script>
      var app = new Vue({
        el: "#app",
        data: {
          message: "안녕하세요 Vue!",
        },
        created: function () {
          var vm = this;
          vm.test();
        },
        methods: {
          test: function () {
            axios
              .post("http://localhost:8080/users", {
                params: "",
              })
              .then(function (response) {
                console.log(response);
              })
              .catch(function (error) {
                console.log(error);
              });
          },
        },
      });
    </script>
  </body>
</html>
```

간단하게 nginx Docker로 해당 페이지를 8090포트로 띄웠다.

```dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html
```

그리고 대망의 CORS 이슈를 만났다.

![cors1](/assets/img/Error/cors1.png)

그리고 이를 해결하기 위해 검색해본 결과 아래와 같은 방법이 있다.

제일 간단하게 내 화면에서만 안나오게 하고싶다!

[https://chrome.google.com/webstore/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf?hl=ko ](https://chrome.google.com/webstore/detail/allow-cors-access-control/lhobafahddgcelffkeicbaginigeejlf?hl=ko)

해당 확장프로그램을 깔면 알아서 해당 이슈가 안나오도록 설정해준다. 내 환경에서만 오류를 안나게 하고 싶다면 이렇게 해도 상관 없다.(물론 크롬 한정)

### SpringBoot에서 AllowOrigin 하는 방법

첫번째는 Spring Boot 에서 WebMvcConfigurer를 사용하여 허용해주는 것이다.
해당 방식은 Config 외에도 @CrossOrigin 이라는 어노테이션으로 컨트롤러 마다 설정이 가능하다.

우선 소스는 아래와 같이 적용했다.

```java
package rest.api.sample.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST")
                .maxAge(3000);
    }
}
```

서버에 위 소스를 적용하고 돌려보니, 브라우저마다 반응이 달랐는데 크롬은 여전히 CORS 이슈 때문에 응답을 가져오는 것이 불가능 했고, 사파리에서는 요청에 대한 응답을 가져올 수 있었다.

그렇다고 사파리에서만 할 수도 없는 노릇이라 더 찾아보니 아래와 같은 글을 찾게 되었다.

[https://howtolivelikehuman.tistory.com/191](https://howtolivelikehuman.tistory.com/191)

살펴보니 동일하게 발생하는 상황이었고 위 처럼 설정을 적용해도 할 수 없었다고 하며, SpringSecurity의 WebSecurityConfigurerAdaptor를 사용하라고 했다.

하여 적용 가능한가 살펴보니 버전 이슈가 있었다. 바로 SpringBoot 2.7 이상 버전에서는 해당 클래스를 지원하지 않는 다는 것.

[https://honeywater97.tistory.com/264](https://honeywater97.tistory.com/264)

그래서 이를 해결하기 위해 필터를 통해 해당 이슈를 해결하였다고 하였다.

따라서, CORS 필터를 적용하여 해결한 사례를 찾아보았다.

### CORS Filter를 이용한 방법

##### corsFilter.java

```java
package rest.api.sample.config;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CorsFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse) res;
        HttpServletRequest request = (HttpServletRequest) req;
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Methods",
                "ACL, CANCELUPLOAD, CHECKIN, CHECKOUT, COPY, DELETE, GET, HEAD, LOCK, MKCALENDAR, MKCOL, MOVE, OPTIONS, POST, PROPFIND, PROPPATCH, PUT, REPORT, SEARCH, UNCHECKOUT, UNLOCK, UPDATE, VERSION-CONTROL");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers",
                "Origin, X-Requested-With, Content-Type, Accept, Key, Authorization");

        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            chain.doFilter(req, res);
        }
    }

    public void init(FilterConfig filterConfig) {
        // not needed
    }

    public void destroy() {
        // not needed
    }

}
```

해당 소스는 아래 글에서 찾았다.

[https://stackoverflow.com/questions/40418441/spring-security-cors-filter](https://stackoverflow.com/questions/40418441/spring-security-cors-filter)

위 필터를 적용 후 테스트를 해보았다.

![cors2](/assets/img/Error/cors2.png)

결과는 잘 나오는 것으로 확인 되었다.

왜 WebConfigurer 설정으로는 안되고 필터에서 성공을 하였나 살펴보니 문제는 Response의 헤더에 있었다. 위에 에러에서 나온대로
"CORS(Cross-Origin Resource Sharing)를 하기 위해 header에 보내는 키(Access-Control-Allow-Origin)이 없다" 는 것이었다.

따라서 필터 쪽에서 Response의 응답 헤더에 해당 값을 세팅해 줌으로써 크롬에서도 해당 이슈를 잡지 않도록 설정하는 것이 가능 했다.
해당 필터는 하나쯤 세팅해두고 on/off 또는 주석 처리를 통해 세팅하는 것을 가지고 있는 것이 좋겠다.
