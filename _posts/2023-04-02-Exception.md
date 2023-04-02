---
title: Java Exception
categories: [Java]
tags: [Java, Java Exception]
---

# **예외 처리 시, 팁**

## 1. 리소스 정리
- try-catch 구문에서 리소스를 열었다면, finally 블록에서 리소스를 정리하거나 try-with-resource 구문을 이용한다.

  ```java
  // use finally
  FileInputStream inputStream = null;

  try {
      File file = new File("./tmp.txt");
      byte[] buffer = new byte[512];
      inputStream = new FileInputStream(file);
      inputStream.read(buffer, 0, 512);
      inputStream.close();
  } catch (FileNotFoundException e) {
      log.error(e);
  } catch (IOException e) {
      log.error(e);
  } finally {
      if (inputStream != null) {
      try {
          inputStream.close();
      } catch (IOException e) {
          log.error(e);
      }
  }

  // use try-with-resource
  File file = new File("./tmp.txt");

  try (FileInputStream inputStream = new FileInputStream(file);) {            
      byte[] buffer = new byte[512];
      inputStream.read(buffer, 0, 512);
      inputStream.close();
  } catch (FileNotFoundException e) {
      log.error(e);
  } catch (IOException e) {
      log.error(e);
  }
  ```
## 2. 더 자세한 예외 처리
- 메소드에서 리턴하는 예외를 최대한 자세하게 기술한다.

  ```java
  public void exception() throw Exception;
  public void exception() throw NumberFormatException, indexOutBoundException;
  ```
## 3. comment를 달아 정리한다.
- 예외를 발생시키는 경우에 대한 케이스를 기술한다.

  ```java
  /**
   * String으로 된 숫자 값을 변환하는 메소드 
   *
   * @param String으로 된 숫자 값
   * @throws NumberFormatException 숫자 입력 포맷이 안맞으면 발생한다.
   */
  public void stringNumberToInt(String number) throw NumberFormatException{
    ...
  }
  ```
## 4. 메세지를 자세하게 작성한다.
- 아래에서 기술하겠지만, 정보를 최대한 담은 메세지를 발생시켜 파악에 용이하게 한다.

## 5. catch 절 순서를 정리한다.
- 최대한 상세한 예외부터 발생시킨다. 디버깅 시, 유리하기 떄문.

## 6. Throwable은 catch 하지 않는다.
- Throwable은 모든 예외 처리의 슈퍼 클래스이다. 따라서, catch 절에서 잡는다고 해도
사용자가 처리할 수 없다.  또한, 예외 뿐 아니라 에러도 잡기 때문에 JVM에서 예상치 못한 동작을 유발하기도 한다.
- 예를 들어, outOfMemoryError 나 StackOverflowError 는 잡아도 처리가 불가능하다.

## 7. 임시로 예외처리를 하여 단계를 건너뛰지 않는다.
- 단계적으로 예외를 무시하고 테스트, 혹은 실행 시키기 위해 아무처리도 하지않고 넘기는 행위는 지양한다.
- 예외를 제거하거나, 로그라도 찍도록 하고 넘어간다.

## 8. 로그를 찍고 에러를 다시 던지지 않는다.
- 로그를 찍고 상위로 다시 예외를 던지는 것은 가독성이 떨어진다.
- 처리를 했으면 에러를 다시 던지지 않는다.

  ``` java
  try {
      new Long("xyz");
  } catch (NumberFormatException e) {
      log.error(e);
      throw e;
  }

  ```

## 9. 예외를 래핑하는 경우, Cause 예외를 담아서 던진다.
- 컨텍스트를 추가하여 상위로 예외를 던지고 싶을 때, 예외를 래핑처리 한다.
- 이 때, 생성자에 예외를 넘겨주어야 스택정보와 메세지, 컨텍스트 정보 등이 상위로 전달된다.

  ```java
  try {
      method();
  } catch (NumberFormatException e) {
      throw new MyException("New Message", e);
  }
  ```

# **예외 처리 시, 정보 담기**

## Exception Message

- 예외를 잡지 못해 프로그램이 실패하면, 예외 메세지를 자동으로 출력한다.
- 해당 메세지에서 예외를 잡고, 처리해야 하기 떄문에 가능한한 많은 정보를 담아야 하고
메세지를 한눈에 봐도 어떤 내용인 지 알 수 있게 작성하는 것이 필요하다.
- 문제를 분석 및 파악해야 한다는 것을 명심한다.

``` java
public fileUploadException(File FileInfo, String uploadPath) {
  this.fileInfo = fileInfo;
  this.uploadPath = uploadPath;
  logger.debug("File Upload Fail !");
  logger.debug("file info -> ", fileInfo);
  logger.debug("uploadPath -> ", uploadPath);
}
```

- 필요한 실패 관련 정보를 담는다.
- 이런 실패 정보를 얻을 수 있는 접근자 메서드를 적절히 사용한다.
- 비 검사 예외도 정보를 알려주는 메서드를 사용하면 좋다.

# 참고
- [예외처리 코드 작성 방법](https://hbase.tistory.com/157)
- [Effective Java Exception Message](https://codingwell.tistory.com/157?category=1013497)

