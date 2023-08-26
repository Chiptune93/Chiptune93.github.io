---
title: Builder Pattren
categories: [Backend, Java]
tags: [Builder, Builder Pattern, Builder Annotation, Java]
published: true
---

## Builder 란?

객체를 생성하고 초기화 할 때, 직접 getter/setter 또는 매개변수를 통한 직접 생성을 하지 않고
빌더를 통해 객체를 생성 또는 초기화 하는 방식

```java
// setter 메소드를 이용한 객체 생성 및 초기화
MyObject obj = new obj();
obj.setValue(1);
...
// builder 사용
MyObject.builder builder = new MyObject.Builder(1);
builder.value(2);
...
// builder chain
MyObject obj = new MyObject.Builder()
    .value(1)
    .value2(2)
    ...
    .buiild();

```

## 왜 사용하나?

영문 위키피디아에서는 빌더 패턴에 대한 장단점을 다음과 같이 안내하고 있다. (https://en.wikipedia.org/wiki/Builder_pattern)

빌더 패턴의 장점은 다음과 같습니다.

- 제품의 내부 표현을 변경할 수 있습니다.
- 생성 및 표현을 위해 코드를 캡슐화합니다.
- 구성 프로세스의 단계를 제어할 수 있습니다.

빌더 패턴의 단점은 다음과 같습니다.

- 각 제품 유형에 대해 고유한 ConcreteBuilder를 생성해야 합니다.
- 빌더 클래스는 변경 가능해야 합니다.
- 종속성 주입을 방해/복잡하게 만들 수 있습니다.

이 외에 setter 메소드가 존재하지 않아 불변 객체를 만들 수 있다는 점과 한 번에 객체를 생성하므로 일관성이 꺠지지 않는 다는 장점이 있다. 다만, 값 변경이 자주 일어나는 객체라면 불편할 수 있다. 

우리가 자주 생성해서 사용하는 엔티티 클래스나 특정 데이터를 조회하여 사용하는 객체 보다는 특정 기능을 하는 객체 등에서 사용하는 것이
더 적합해 보인다.
(주문,음식과 같은 비즈니스 로직 상 필요한 객체 보다는 데이터 소스, 웹 소켓 등 과 같은 기능적인 동작을 하는 객체)

## @Builder

사실 기존 Java Bean 이나 일반 클래스 객체에서 빌더를 사용하려면 빌더를 객체마다 구현해주어야 사용이 가능하다.

```java
public class Object {
    private final int value;
    ...
    public static class Builder {
        private int value;
        ...
        public Builder value(int val) {
            value = val
            return this;
        }
        ...
        public Object build() {
            return new Object(this);
        }
        ...
        private Object(Builder builder) {
            value = builder.value;
        }
    }
}
```

이런 식으로 각 기능을 하는 빌더와 메소드 내부 로직을 구현해야 가능하다. 물론, 빌더로 객체를 생성하는 과정에서 추가적인 로직이 필요하다면 직접구현하는 것이 맞으나 보통은 롬복 어노테이션을 이용하면 해당 구간을 생략가능하고 기본구현된 내용으로 사용이 가능하다.

빌더 어노테이션은 생성자 혹은 클래스 선언부에서 사용하면 위와 같은 코드를 자동 생성한다.

```java
@Builder
public class Object {
    private final int value;
}
...
public class Object {
    private final int value;

    @Builder
    public Object(int value) {
        this.value = value;
        return this;
    }
}
```

빌더 패턴은 객체에 대한 구현부를 비즈니스로직과 분리하고 캡슐화 함으로써, 비느지스 로직을 수정하지 않고도 유지보수성이 좋도록 설계가 가능한 패턴이다.