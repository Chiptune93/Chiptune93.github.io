---

title: Spring Boot - Spring Boot 2.6.2 Interceptor 추가
description: >
  [Spring Boot] Spring Boot 2.6.2 Interceptor 추가


categories: [Spring]
tags: [Interceptor, SpringBoot]
---



## 1. Interceptor 생성

```java
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class defaultInterceptor implements HandlerInterceptor {
    private Logger logger = LoggerFactory.getLogger(this.getClass());

    /* 컨트롤러 실행 전 수행 */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        logger.info("[LOG] interceptor prehandle");
        return true;
    }

    /* 컨트롤러 실행 후, 뷰 렌더링 전 실행 */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        logger.info("[LOG] interceptor postHandle");
    }

    /* 컨트롤러 실행 후, 뷰 렌더링 후 실행 */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
            throws Exception {
        logger.info("[LOG] interceptor afterCompletion");
    }

}
```

## 2. 설정 적용하기

```java
import com.docker.bootsample.interceptor.defaultInterceptor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/* spring framework 에서 Bean 에서 하던 설정을 java로 하게 되며 설정을 이 곳에서 한다. */
@Configuration
public class MvcConfig implements WebMvcConfigurer {

    /* 실행 시, defaultInterceptor를 가져와 주입하여 사용 */
    @Autowired
    private defaultInterceptor defaulInterceptor;

    /* 인터셉터 추가하는 메소드 */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(defaulInterceptor) // 인터셉터 추가
                .addPathPatterns("/**") // 적용할 패턴 추가
                .excludePathPatterns(); // 제외할 패턴 추가
    }
}
```
