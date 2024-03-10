---
title: 간단히 보는 스프링 시큐리티 동작 과정과 필터 순서
categories: [Backend, Spring]
tags: [SpringSecurity, SecurityFilter]
---

## 스프링 시큐리티 필터 체인의 동작 과정

참고 : [https://docs.spring.io/spring-security/reference/servlet/architecture.html](https://docs.spring.io/spring-security/reference/servlet/architecture.html)

![Files](/assets/img/Spring/springsecurity1.png)

## 필터 체인 내의 필터 동작 순서

스프링 시큐리티에서 필터 체인에 등록되는 시큐리티 필터의 경우, 전부 동작하는 것이 아닌(기본 동작 제외)
사용자가 구현한 필터가 등록 됨으로써 동작한다. 아래의 순서는 [여기](https://github.com/spring-projects/spring-security/blob/6.2.2/config/src/main/java/org/springframework/security/config/annotation/web/builders/FilterOrderRegistration.java) 에서 참고한 기본적으로 제공되는 순서를 정의한 것을 바탕으로 
다시 정리한 것이다.

이 중, 중요한 필터의 경우 간단히 정리를 하였다.

1. DisableEncodeUrlFilter.class
2. ForceEagerSessionCreationFilter.class
3. ChannelProcessingFilter.class
4. WebAsyncManagerIntegrationFilter.class
5. **SecurityContextHolderFilter.class**
6. **SecurityContextPersistenceFilter**.class
  - **`SecurityContext`의 저장 및 복원:** 요청이 시작될 때, 이 필터는 세션에서 `SecurityContext`를 찾아  `SecurityContextHolder`에 설정합니다. 요청 처리가 끝난 후, 현재의 `SecurityContext`를 세션에 저장하고 `SecurityContextHolder`를 정리(clear)합니다.
  - **익명 사용자 처리:** 인증 정보가 없는 경우, 이 필터는 설정에 따라 익명 사용자로 `SecurityContext`를 초기화할 수 있습니다.
7. HeaderWriterFilter.class
8. **CorsFilter.class**
9. **CsrfFilter.class**
10. **LogoutFilter.class**
  - **로그아웃 요청 감지:** `LogoutFilter`는 특정 URL(기본적으로 `/logout`)에 대한 요청을 감지하고, 이를 로그아웃 요청으로 처리합니다. 이 URL은 구성을 통해 변경할 수 있습니다.
  - **로그아웃 처리:** 사용자의 세션을 무효화하고, `SecurityContext`를 정리합니다. 필요에 따라 쿠키를 삭제하거나 다른 보안 관련 처리를 수행할 수 있습니다.
  - **리다이렉션 또는 커스텀 로직 실행:** 로그아웃 처리 후, 사용자를 로그아웃 성공 페이지나 어플리케이션의 다른 부분으로 리다이렉션할 수 있습니다. 또한, 로그아웃 성공 핸들러를 통해 커스텀 로직을 실행할 수도 있습니다.
11. X509AuthenticationFilter.class
12. AbstractPreAuthenticatedProcessingFilter.class
13. **UsernamePasswordAuthenticationFilter.class**
  - **인증 요청 감지:** 사용자가 로그인 폼을 통해 사용자 이름과 비밀번호를 제출하면, `UsernamePasswordAuthenticationFilter`가 이를 감지합니다.
  - **인증 정보 추출:** 필터는 HTTP 요청에서 사용자 이름과 비밀번호를 추출합니다.
  - **인증 프로세스 수행:** 추출한 인증 정보를 사용하여 `AuthenticationManager`를 통해 인증을 시도합니다. `AuthenticationManager`는 등록된 `AuthenticationProvider` 중 하나를 사용하여 사용자의 인증 정보를 검증합니다.
  - **인증 성공 또는 실패 처리:** 인증이 성공하면, 사용자는 지정된 성공 URL로 리다이렉션됩니다. 인증에 실패하면, 사용자는 로그인 폼으로 다시 리다이렉션되며, 실패 메시지를 볼 수 있습니다.
14. DefaultLoginPageGeneratingFilter.class
15. DefaultLogoutPageGeneratingFilter.class
16. **ConcurrentSessionFilter.class**
  - **세션 동시성 제어:** 애플리케이션에 정의된 동시 세션 수를 초과하지 않도록 합니다. 사용자가 허용된 세션 수를 초과하여 로그인하려고 시도하면, 기존 세션 중 하나를 무효화하거나 새 세션 생성을 차단할 수 있습니다.
  - **세션 만료 처리:** 동시 로그인 제한을 초과할 경우, 가장 오래된 세션을 자동으로 만료시키거나 사용자에게 오류 메시지를 보여주는 등의 행동을 취할 수 있습니다.
17. DigestAuthenticationFilter.class
18. BasicAuthenticationFilter.class
19. RequestCacheAwareFilter.class
20. SecurityContextHolderAwareRequestFilter.class
21. JaasApiIntegrationFilter.class
22. **RememberMeAuthenticationFilter.class**
  - **자동 인증:** 사용자가 로그인 세션을 종료한 후에도, "기억하기" 쿠키가 존재하는 경우, 해당 쿠키를 통해 사용자를 자동으로 인증합니다.
  - **쿠키 관리:** 사용자의 브라우저에 "기억하기" 쿠키를 생성하고 관리합니다. 이 쿠키에는 사용자를 식별할 수 있는 정보와 유효 기간이 포함됩니다.
  - **보안:** 쿠키에 저장되는 정보는 암호화되어야 하며, 쿠키를 통한 인증은 추가적인 보안 검사를 거쳐야 합니다.
23. AnonymousAuthenticationFilter.class
24. SessionManagementFilter.class
25. **ExceptionTranslationFilter.class**
  - **인증 예외 처리:** `AuthenticationException`이 발생했을 때, 이 필터는 사용자를 로그인 페이지로 리다이렉션합니다. 로그인 페이지 URL은 스프링 시큐리티 설정에서 지정할 수 있습니다.
  - **접근 거부 예외 처리:** `AccessDeniedException`이 발생했을 때, 인증된 사용자가 허용되지 않은 리소스에 접근하려고 시도하면, 이 필터는 접근 거부 페이지로 리다이렉션하거나 `403 Forbidden` 응답을 반환합니다.
26. **FilterSecurityInterceptor.class**
  - **접근 제어 결정:** `FilterSecurityInterceptor`는 요청이 도달한 리소스(URL, 메소드)에 대해 현재 인증된 사용자가 접근할 수 있는지 여부를 결정합니다. 이는 `AccessDecisionManager`를 사용하여 수행되며, 사용자의 권한(Granted Authority)과 리소스에 대한 접근 제어 설정(Security Metadata)을 비교 분석합니다.
  - **보안 메타데이터 소스 연동:** 이 필터는 보안 메타데이터 소스(`SecurityMetadataSource`)와 연동하여 각 리소스에 대한 보안 정책(예: 필요한 권한)을 조회합니다.
  - **접근 거부 처리:** 사용자가 리소스에 대한 접근 권한이 없는 경우 `AccessDeniedException`을 발생시키며, 이는 `ExceptionTranslationFilter`에 의해 처리됩니다.
27. AuthorizationFilter.class
28. SwitchUserFilter.class
