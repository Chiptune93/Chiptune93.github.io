---
title: Spring AOP Joinpoint 와 ProceedingJoinPoint
categories: [Spring]
tags: [Spring, SpringBoot, AOP]
---


## Joinpoint

joinpoint는 메서드 매개변수, 리턴 값, throw 된 예외 같은 조인 지점에서 사용할 수 있는 상태에 대한 액세스를 제공하는
AspectJ 인터페이스 이다.

또한, 해당 메서드에 대한 정적 정보를 제공한다.

아래의 Pointcut 과 함께 사용이 가능하다.

- @Around : 메소드 실행 전/후에 실행.
- @Before : 메소드 실행 전 실행.
- @After : 메소드 실행 후 실행.
- @AfterThrowing : 메소드가 "정상" 실행 후, 실행.
- @AfterReturning : 메소드가 "예외" 발생 후, 실행.

## Example For SpringBoot
```java
@Aspect
@Component
public class aop {
  // service 패키지 내 모든 메소드에 대한 포인트 컷 생성.
  @Pointcut(execution(* com.example.service..*(..)))
  public void servicePointCut() { }

  // 포인트 컷에 대해 메소드 실행 전 수행할 내용.
  @Before("servicePointCut()")
  public void beforeAdvice(JoinPoint jp) {
    MethodSignature signature = (MethodSignature) jp.getSignature();
    // 실행할 메소드 명 가져오기
    log.info(signature.getMethod());
  }
}
```

## ProceedingJoinPoint

JoinPoint의 확장으로, proceed() 라는 메소드를 추가 사용할 수 있습니다.
해당 메소드가 실행되게 되면, 다음 어드바이스 혹은 대상 메소드를 실행합니다.

코드의 흐름을 제어하고, 추가 호출을 진행할 지 여부를 결정할 수 있는 권한을 제공합니다.
@Around 를 사용할 때 사용 가능합니다.

## Example For SpringBoot
```java
@Aspect
@Component
public class RunningTimeAspect {
    // 서비스 패키지 내 메소드를 대상으로 함.
    @Pointcut("execution(* com.exam.service..*.*(..))")
    private void cut() { }

    // 메소드 수행 시간을 계산하여 로깅.
    @Around("cut()")
    public Object Around(ProceedingJoinPoint jp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            // proceed() 하게 되면, 대상 메소드를 실행.
            return jp.proceed();
        } finally {
            // 그리고 finally 부분으로 복귀함.
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

위의 예시는 메소드 수행 시간을 계산하는 부분으로 사용되었으나 그 외에 에러 발생시 재시도 등과 같은 방법을
응용하여 사용할 수 있습니다.

[참고 사이트](https://www.baeldung.com/aspectj-joinpoint-proceedingjoinpoint)