---
title: Java this vs this()
categories: [Backend, Java]
tags: [Java, this, this(), constructor]
---

### this vs this()

자바에서 생성자(constructor)는 객체를 생성할 때 호출되는 특별한 메서드입니다. 객체 생성 시에 필요한 초기화 작업을 수행할 수 있습니다.

- this는 클래스의 인스턴스를 가리키는 키워드로, 같은 클래스 내에서 멤버 변수와 지역 변수의 이름이 같을 때 둘을 구분하기 위해 사용됩니다.

- this()는 생성자에서 다른 생성자를 호출할 때 사용되는 특별한 형태의 this입니다. 즉, 같은 클래스 내에 다른 생성자를 호출하기 위한 것입니다.

예를 들어, 다음과 같은 Person 클래스가 있다고 가정해 봅시다.

```java
public class Person {
    private String name;
    private int age;
    private String address;

    // 생성자
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // 생성자
    public Person(String name, int age, String address) {
        this(name, age);  // 다른 생성자 호출
        this.address = address;
    }
}

```

위의 Person 클래스에서 this()를 이용하여 생성자를 호출하는 예시를 볼 수 있습니다. Person 클래스는 두 개의 생성자를 가지고 있습니다. 두 번째 생성자에서는 첫 번째 생성자를 호출하여 중복 코드를 줄였습니다.

따라서, this는 클래스의 인스턴스를 가리키는 키워드이며, this()는 같은 클래스의 다른 생성자를 호출하기 위한 특별한 형태의 this입니다.

### 사용 시, 이점

- 가독성 향상
    - 번거롭게 일일히 적는 것은 코드가 길어질 경우, 의미를 바로 파악하기 힘드나, 생성자 호출을 통해 공통되는 부분을 최소화 하여 어떤 파라미터로 작업이 이루어지는지 한 눈에 파악할 수 있다.
- 중복 코드 최소화
    - 위와 마찬가지로 중복되는 코드를 최소화 할 수 있다.
    - 단, 이렇게 호출되는 생성자는 생성자 호출 시, 첫 부분에 위치하여야 한다.
        (파라미터가 더 적은 생성자가 위에 와야 한다.)


### 참고
- [java this vs this()](https://zoosso.tistory.com/704)