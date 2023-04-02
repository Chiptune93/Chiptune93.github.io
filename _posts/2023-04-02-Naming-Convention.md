---
title: Java Naming Conventions & Naming
categories: [Backend, Java]
tags: [Java, Java Naming Conventions]
---

## **Java Naming Conventions**

- 자바 네이밍 컨벤션
  - 패키지 클래스 등에 대한 네이밍 명명 규칙
  - 프로그램을 읽기 쉽도록 하고, 이해하기 쉽게 만든다
  - 코드를 이해하는데 도움이 되는 식별자의 "기능" 에 대한 정보를 제공한다


- [오라클에서 제시하는 명명 규칙](https://www.oracle.com/java/technologies/javase/codeconventions-namingconventions.html)
  - 패키지
    - 고유한 패키지 이름의 접두사는 항상 모두 소문자 ASCII 문자로 작성되며 최상위 도메인 이름(현재 com, edu, gov, mil, net, org 또는 영어 두 문자 코드 중 하나) 중 하나여야 합니다. ISO 표준 3166, 1981에 명시된 대로 국가를 식별합니다.
    - 패키지 이름의 후속 구성 요소는 조직 자체의 내부 명명 규칙에 따라 다릅니다. 이러한 규칙은 특정 디렉토리 이름 구성 요소가 사업부, 부서, 프로젝트, 시스템 또는 로그인 이름임을 지정할 수 있습니다.
      - com.sun.eng
      - com.apple.quicktime.v2
      - edu.cmu.cs.bovik.cheese
  - 클래스
    - 클래스 이름은 대소문자가 혼합된 명사여야 하며 각 내부 단어의 첫 글자는 대문자여야 합니다. 클래스 이름을 간단하고 설명적으로 유지하십시오. 전체 단어를 사용하세요. 약어와 약어는 피하세요(URL이나 HTML과 같은 긴 형식보다 약어가 훨씬 더 널리 사용되는 경우 제외).
      - class Raster;
      - class ImageSprite;
  - 인터페이스
    - 인터페이스 이름은 클래스 이름처럼 대문자여야 합니다.
      - interface Raster;
      - interface ImageSprite;
  - 메소드
    - 메서드는 첫 글자가 소문자와 대소문자가 혼합된 동사여야 하며 각 내부 단어의 첫 글자는 대문자여야 합니다.
      - run();
      - runFast();
      - getBackground();
  - 변수
    - 변수를 제외하고 모든 인스턴스, 클래스 및 클래스 상수는 소문자 첫 글자가 혼합된 대소문자입니다. 내부 단어는 대문자로 시작합니다. 변수 이름은 밑줄 _ 또는 달러 기호 $ 문자로 시작할 수 없습니다. 둘 다 허용되더라도 마찬가지입니다.
    - 변수 이름은 짧지만 의미가 있어야 합니다. 변수 이름의 선택은 니모닉해야 합니다. 즉, 일반적인 관찰자에게 사용 의도를 나타내도록 설계되어야 합니다. 임시 "쓰레기" 변수를 제외하고 한 문자로 된 변수 이름은 피해야 합니다. 임시 변수의 일반 이름은 i, j, k, m및 n정수입니다. c, d, 및 e문자.
      - int             i;
      - char            c;
      - float           myWidth;
  - 상수
    - 클래스 상수로 선언된 변수와 ANSI 상수의 이름은 모두 대문자여야 하며 단어는 밑줄("_")로 구분됩니다. (쉽게 디버깅하려면 ANSI 상수를 피해야 합니다.)
      - static final int MIN_WIDTH = 4;
      - static final int MAX_WIDTH = 999;
      - static final int GET_THE_CPU = 1;

## **Google Java Code Convention**

구글은 많은 개발자들이 사용하고 권장하는 자체 Java 코딩 규칙을 가지고 있습니다. 이러한 규칙은 일관성 있고 가독성이 좋으며 유지보수가 용이한 코드 작성을 돕기 위해 설계되었습니다. 구글 Java 코딩 규칙의 핵심 요소 중 일부는 다음과 같습니다:

- 네이밍 규칙
  - 패키지 이름
    - 모든 패키지 이름은 소문자로 표기하며 회사 도메인 이름을 역순으로 기반으로 작성합니다. Ex) com.google.example.
  - 클래스 이름
    - 클래스 이름은 대문자로 시작하고 CamelCase를 사용합니다. Ex) MyClass.
  - 변수 이름
    - 변수 이름은 소문자로 표기하고 CamelCase를 사용합니다. Ex) myVariable.
  - 상수 이름
    - 상수 이름은 대문자로 표기하고 밑줄로 단어를 구분합니다. Ex) MY_CONSTANT.


- 코드 서식
  - 들여쓰기
    - 들여쓰기에는 2칸의 공백을 사용합니다.
  - 줄 길이
    - 한 줄의 길이는 100자 이하로 제한합니다.
  - 중괄호
    - 중괄호는 K&R 스타일을 사용합니다. Ex) 다음과 같은 형태입니다:

      ```java
      if (condition) {
        // do something
      } else {
        // do something else
      }
      ```

  - 가져오기
    - 적절한 경우에만 단일 정적 가져오기를 사용하고 가져오기를 블록으로 그룹화합니다.


- 주석

  - 클래스, 메서드, 필드를 문서화하기 위해 Javadoc 스타일 주석을 사용합니다.
  코드의 간단한 설명에 대해서는 한 줄 주석을 사용합니다.


- 프로그래밍 관행
  - 적절한 경우 인터페이스를 사용합니다.
  - 와일드 카드 가져오기를 사용하지 않습니다.
  - 정수 상수 대신 열거형을 사용합니다.
  - synchronized 키워드 대신 java.util.concurrent 패키지를 선호합니다.

## **좋은 변수명 짓기**

1. 의도를 분명히 밝힌다
  - 따로 주석이 필요 없을 정도로
  - 구체적으로 표현해야 한다
2. 협업을 염두한 작성을 한다
  - 숫자와 같은 상수는 헷갈리기 때문에 이름을 붙인다.
3. 맥락을 고려한다
  - 이름이 너무 짧으면 용도를 알기 어렵다
  - 맥락을 고려한 긴 변수 이름이 더 좋다
4. boolean 타입에 대한 작성
  - 참이나 거짓을 의미하는 이름을 사용한다.
    ( fileUploadSuccess, ResponseOK ... )
  - not ~ 보다는 is ~ 를 사용한다. 단, 접두어가 없는 것이 더 이해하기 쉬울 수 있다.

## **좋은 메소드 명 짓기**

### 고려해야할 사항
- 왜 존재하는 메소드인가?
- 어떤 동작을 하는가?
- 어떻게 사용하는가?

### 명명 규칙 
- lowerCamelCase로 작성하기
  - toString()
  - fileUpload()

### 자주 사용되는 동사
- get/set
  - getter & setter 에 주로 사용됨
- init 
  - 초기화를 뜻함.
- is/has/can
  - boolean 값을 리턴하는 동사
  - is : 맞다/틀리다 판단
  - has : 가지공 있다/없다 판단
  - can : 할 수 있는지/없는지 판단
- create 
  - 새로운 객체를 만들어 리턴하는 명칭
- find
  - 데이터를 찾는 명칭
- to
  - 해당 객체를 다른 객체로 변환할 때 사용



## 참고
- [자바 작명소](https://velog.io/@bosl95/%EC%9E%90%EB%B0%94-%EC%9E%91%EB%AA%85%EC%86%8C#%EB%A9%94%EC%84%9C%EB%93%9C-%EC%9D%B4%EB%A6%84%EC%9C%BC%EB%A1%9C-%EC%9E%90%EC%A3%BC-%EC%82%AC%EC%9A%A9%EB%90%98%EB%8A%94-%EB%8F%99%EC%82%AC)
- [GoogleJavaCodeStyle](https://google.github.io/styleguide/javaguide.html)
