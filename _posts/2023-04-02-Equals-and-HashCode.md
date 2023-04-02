---

title: Java equals() and hashCode()
description: >
  자바 equals() 메소드와 hashCode() 를 이용한 비교 방법


categories: [Java]
tags: [Java, equals, hashcode, java equals(), java hashcode()]
published: true
---



# **hashCode() & equals()**
hashCode() 메소드는 객체의 해시 코드를 반환하는 메소드이며, equals() 메소드는 두 객체가 동등한지 비교하는 메소드입니다. 이 두 메소드는 객체 동등성 비교를 위해 필수적으로 구현되어야 합니다.

- hashCode() 는 객체가 매핑되는 해시 테이블에서 검색 속도를 높이기 위해 사용됩니다. 객체의 hashCode() 메소드는 동일한 객체에 대해 항상 같은 정수 값을 반환해야 하며, 동일한 객체가 아니라면 서로 다른 정수 값을 반환해야 합니다.

- equals() 메소드는 두 객체가 동등한지 비교하는 메소드입니다. 객체의 equals() 메소드는 다음과 같은 규칙을 따라야 합니다.

  1. 반사성: 객체는 자기 자신과 동등해야 합니다.
  2. 대칭성: a.equals(b)가 참이면 b.equals(a)도 참이어야 합니다.
  3. 추이성: a.equals(b)가 참이고, b.equals(c)가 참이면 a.equals(c)도 참이어야 합니다.
  4. 일관성: 객체의 내용이 변경되지 않았다면, 여러 번 호출해도 항상 같은 결과를 반환해야 합니다.
  5. null 비교: 어떤 객체와 비교할 때, null을 전달하면 false를 반환해야 합니다.

마지막으로, hashCode()와 equals() 메소드는 서로 관련성이 있습니다. equals() 메소드가 참을 반환하면, 두 객체의 해시 코드는 같아야 합니다. 그렇지 않으면 동등하지 않은 객체가 동일한 해시 코드를 가질 수 있기 때문입니다.

# **Example**

```java
public class Employee {
    private String firstName;
    private String lastName;
    private int employeeId;

    public Employee(String firstName, String lastName, int employeeId) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.employeeId = employeeId;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + employeeId;
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Employee other = (Employee) obj;
        if (employeeId != other.employeeId)
            return false;
        return true;
    }
}

```

위의 코드에서는 Employee 클래스를 정의하고, 해당 클래스의 객체들을 비교하기 위해 hashCode()와 equals() 메소드를 구현합니다.

hashCode() 메소드는 employeeId 필드를 사용하여 객체의 해시 코드를 생성합니다. 이 때, 상수 값 31을 사용하여 해시 코드를 계산합니다.

equals() 메소드는 객체의 클래스 타입과 employeeId 필드 값을 비교하여 동등성을 검사합니다.

이 예시 코드는 hashCode()와 equals() 메소드를 구현하여 객체 동등성 비교를 수행하는 방법을 보여줍니다.

```java
public class Book {
    private String title;
    private int id;

    public Book(String title, int id) {
        this.title = title;
        this.id = id;
    }

    @Override
    public int hashCode() {
        return id;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof Book)) {
            return false;
        }
        Book other = (Book) obj;
        return this.id == other.id;
    }
}

```

위의 코드에서는 Book 클래스를 정의하고, 해당 클래스의 객체들을 비교하기 위해 hashCode()와 equals() 메소드를 구현합니다.

hashCode() 메소드는 id 필드를 사용하여 객체의 해시 코드를 생성합니다.

equals() 메소드는 객체의 클래스 타입과 id 필드 값을 비교하여 동등성을 검사합니다.

이 예시 코드에서는 id 값을 통해 객체를 비교하여 동등성을 판단합니다. 만약 두 객체의 id 값이 같으면 같은 객체로 판단합니다.

# 참고
[Java hashCode() 및 equals() 메소드](https://howtodoinjava.com/java/basics/java-hashcode-equals-methods/)
