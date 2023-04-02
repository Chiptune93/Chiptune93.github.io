---
title: Java First Class Collection
categories: [Java]
tags: [Java, 일급 컬렉션, java first class collection]
published: true
---

# **자바 일급 콜렉션(First Class Collection)**

일급 콜렉션(first-class collection)은 객체지향 프로그래밍에서 사용되는 용어로, 콜렉션을 하나의 일급 객체로 다루는 것을 의미합니다. 이는 콜렉션을 일반적인 데이터 타입과 동일하게 취급하고, 메서드의 인자나 반환 값으로 사용할 수 있게 됩니다.

자바에서는 JDK 1.5부터 제네릭스(generics)가 추가되어, 제네릭스를 활용한 일급 콜렉션을 쉽게 만들 수 있게 되었습니다. 예를 들어, List<E>, Set<E>, Map<K,V> 등의 제네릭 타입을 사용하여 일급 콜렉션을 만들 수 있습니다.

## 사용 시, 이점

- 타입 안정성(Type safety): 제네릭을 사용하여 컴파일 시점에서 타입 체크를 할 수 있으므로, 타입 안정성이 보장됩니다.
- 가독성(Readability): 일급 콜렉션을 사용하면 코드의 가독성이 좋아집니다. 콜렉션을 하나의 객체로 다루므로, 콜렉션에 대한 다양한 연산을 객체 메서드로 제공할 수 있으며, 이는 코드를 보다 간결하고 직관적으로 만듭니다.
- 유지보수성(Maintainability): 코드의 가독성이 좋아지므로, 유지보수성도 향상됩니다. 또한, 
콜렉션을 일급 객체로 다루면, 코드의 재사용성도 높아집니다.

## 기본 제공되는 일급 콜렉션 예시

- ArrayList<E>: 동적 배열을 구현한 클래스로, 순서가 있는 데이터를 저장합니다.
- LinkedList<E>: 연결 리스트를 구현한 클래스로, 순서가 있는 데이터를 저장합니다.
- HashSet<E>: 해시 테이블을 구현한 클래스로, 중복을 허용하지 않고 순서가 없는 데이터를 저장합니다.
- TreeSet<E>: 이진 검색 트리를 구현한 클래스로, 중복을 허용하지 않고 정렬된 순서로 데이터를 저장합니다.
- HashMap<K,V>: 해시 테이블을 구현한 클래스로, 키와 값으로 구성된 데이터를 저장합니다.
- TreeMap<K,V>: 이진 검색 트리를 구현한 클래스로, 키와 값으로 구성된 데이터를 저장하고 정렬된 순서로 데이터를 반환합니다.

# **자바 일급 콜렉션을 커스텀화 하기**

자바에서 기본적으로 제공되는 콜렉션 클래스들은 대부분 다양한 용도로 사용할 수 있지만, 때로는 우리가 필요로 하는 기능을 제공하지 않을 수도 있습니다. 이때 우리는 자바에서 제공하는 인터페이스를 구현하여 커스텀 콜렉션 클래스를 만들고, 이를 일급 콜렉션으로 래핑하여 사용할 수 있습니다.

이를 통해 얻을 수 있는 이점은 다음과 같습니다.

- 우리가 필요로 하는 기능을 직접 구현하여 사용할 수 있습니다.
- 코드의 가독성이 높아집니다. 우리가 직접 구현한 커스텀 콜렉션 클래스를 일급 콜렉션으로 래핑하면, 해당 콜렉션에 대한 다양한 연산을 객체 메서드로 제공할 수 있습니다. 이는 코드의 가독성을 높이고, 코드를 보다 직관적으로 만들어 줍니다.
- 일급 콜렉션을 사용함으로써 코드의 재사용성이 높아집니다. 우리가 직접 구현한 커스텀 콜렉션 클래스는 일급 콜렉션으로 래핑되므로, 해당 콜렉션을 사용하는 모든 코드에서 동일한 객체를 사용할 수 있습니다.
다음은 ArrayList를 래핑하여 일급 콜렉션으로 사용하는 예시입니다.

```java
import java.util.ArrayList;
import java.util.Collection;

public class CustomCollection<E> {

    private ArrayList<E> list;

    public CustomCollection() {
        list = new ArrayList<>();
    }

    public CustomCollection(Collection<? extends E> c) {
        list = new ArrayList<>(c);
    }

    public boolean add(E e) {
        return list.add(e);
    }

    public boolean remove(Object o) {
        return list.remove(o);
    }

    public int size() {
        return list.size();
    }

    public boolean isEmpty() {
        return list.isEmpty();
    }

    public boolean contains(Object o) {
        return list.contains(o);
    }

    // Add other methods as required

    public ArrayList<E> getWrappedList() {
        return list;
    }
}

```

위의 코드에서는 ArrayList를 래핑하여 CustomCollection 클래스를 만들었습니다. CustomCollection 클래스는 ArrayList의 기능을 그대로 사용할 수 있으면서, add(), remove(), size(), isEmpty(), contains() 등의 메서드를 일급 콜렉션으로 사용할 수 있습니다. 또한, getWrappedList() 메서드를 통해 래핑된 ArrayList 객체를 반환할 수 있습니다.

# **커스텀 일급 콜렉션 사용예시**

예를 들어, 사용자 객체가 있고 이 사용자의 객체를 만든다고 합시다.

```java
public class Person {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return this.name;
    }
    
    public int getAge() {
        return this.age;
    }
}
```

그리고, 이 사용자들이 타는 자동차 객체가 있다고 하자.

```java
public class Car {
    private List<Person> person;

    public Car(List<Person> person) {
        this.person = person;
    }
}
```

그런데, 자동차에는 4명 이상 탈 수 없다고 한다. 
그래서 검증하는 로직을 구현한다고 하자.

```java
public class Car {
    private List<Person> person;

    public Car(List<Person> person) {
        validateCarPersonNumber(person);
        this.person = person;
    }

    public validateCarPersonNumber() {
        if(this.person.size() >= 4) {
            new throw IlligalArgumentException("4명 이상 탑승 불가합니다.");
        }
    }
}
```

이 상태에서 자동차에 사람만 타는게 아닌, 똑같이 제한을 받는 짐이나 동물 등이 탄다고 생각해보자.
그러면, 자동차 객체에서 모든 검증을 진행해야 한다.

```java
public class Car {
    private List<Person> person;
    private List<Animal> animal;
    private List<Package> package;

    public Car(List<Person> person) {
        validateCarPersonNumber(person);
        validateCarAnimalsNumber(animals);
        validateCarPackageNumber(package);
        this.person = person;
    }

    public validateCarPersonNumber() {
        if(this.person.size() >= 4) {
            new throw IlligalArgumentException("4명 이상 탑승 불가합니다.");
        }
    }
    ...
    ...
}
```

이렇게 되면 자동차 객체에 책임이 너무 많고, 코드가 복잡해지며 유지보수가 힘들게 된다.
이 때, 여기에 멤버변수로 있는 사람,동물, 짐 객체 등을 일급컬렉션화하여 상태와 관리를 하도록 변경한다.

```java
public class persons {
    private List<Person> person;

    public Persons(List<Person> person) {
        this.person = person;
    }

    public List<Person> getPerson() {
        validateCarPersonNumber()
        return this.person;
    }

    public validateCarPersonNumber() {
        if(this.person.size() >= 4) {
            new throw IlligalArgumentException("4명 이상 탑승 불가합니다.");
        }
    }
}
```

List<Person> 을 멤버 변수로 가지면서, 생성자에서 생성할 때, 체크를 한다.
이렇게 되면 자동차 객체 코드는 다음과 같이 바뀔 수 있다.

```java
public class Car {
    private Persons persons;
    private Animals animals;
    private Packages packages;

    public Car(Persons persons, Animals animals, Packages packages) {
        this.persons = persons;
        this.animals = animals;
        this.packages = packages;
    }
}
```

자동차 객체에서 진행했던 체크 로직의 책임을 각 일급 컬렉션에게 위임하였다.
이 상태에서 다른 종류의 객체들이 들어와도 자동차 객체에서는 할 일이 없으며, 일급 컬렉션에서 
체크를 처리하게 된다.

# **일급콜렉션에서 불변성을 유지하기 위한 방법**
또한, 불변성을 가지기 위해 각 객체에서 setter 메서드를 구현하지 않는다고 하지만
사실, 객체 주소값을 통해서라면 불변성이 보장되지 않을 수 있다.

따라서, 불변성을 띄고 싶다면 다음과 같이 코드를 작성해야 한다.

## 생성자 대입 시, 새로운 생성자를 이용해 객체를 생성하여 대입
- 객체 주소의 값이 똑같아 지는 것을 방지 하기 위하여 사용한다.
- 새로운 객체를 생성하여 일급 콜렉션 객체를 생성한다.

## unmodifiableList 를 활용한 객체 생성(불변성 보장 메서드)
- getter 를 통해서 리턴받는 객체의 불변성을 확보한다.


```java
public class Persons {
    private List<Person> persons;

    public Persons(List<Person> person) {
        this.person = new ArrayList<>(person);
    }

    public List<Person> getPersons() {
        return Collections.unmodifiableList(person);
    }
}
```


# 참고
- [일급 콜렉션](https://tecoble.techcourse.co.kr/post/2020-05-08-First-Class-Collection/)