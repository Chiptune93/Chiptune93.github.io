---
title: 커스텀 객체 리스트를 중복 없이 합치는 방법
categories: [Backend, Java]
tags: [java, 자바, Stream, Collection, Custom Object Merge, Custom Object Stream, Stream, collect, collectors, reduce, groupingBy]
---

# 서론

여기서 설명하고자 하는 작업은 아래와 같다.

1. 동일한 타입을 갖는 리스트 2개에 대하여
2. 특정 값 기준으로 그룹화 한다.
3. 그룹화 하면서, 타입 내 특정 값에 대한 작업이 들어간다. (합계)

# 본론

위 작업을 하기 위해 몇 가지 세팅을 하겠다.
작업에 필요한 타입은 아래와 같다.

### Item Class

```java
public class Item {

    private String itemCode;
    private String itemName;
    private Integer price;
    private Integer quantity;

    @Override
    public String toString() {
        return "Item{" +
                "itemCode='" + itemCode + '\'' +
                ", itemName='" + itemName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                '}';
    }

    public static Item merge(Item item1, Item item2) {
        return new Item(item1.itemCode, item1.itemName, (item1.getPrice() + item2.getPrice()) / 2, (item1.getQuantity() + item2.getQuantity()));
    }
    
    // getter & setter & constructor 생략
}
```

우리는 이 `item` 이라는 타입으로 이루어진 리스트 2개를 합칠 것이다.

예제로 이 타입을 갖는 리스트 2개가 있다고 가정한다.

```java
Item item1 = new Item("ITEM_CODE_1", "아이템1", 1000, 10);
Item item2 = new Item("ITEM_CODE_1", "아이템1", 1000, 20);
Item item3 = new Item("ITEM_CODE_2", "아이템2", 1200, 15);
Item item4 = new Item("ITEM_CODE_2", "아이템2", 1200, 5);
Item item5 = new Item("ITEM_CODE_3", "아이템3", 1030, 9);
Item item6 = new Item("ITEM_CODE_4", "아이템4", 1050, 7);
Item item7 = new Item("ITEM_CODE_5", "아이템5", 1500, 33);
Item item8 = new Item("ITEM_CODE_5", "아이템5", 1500, 27);
Item item9 = new Item("ITEM_CODE_5", "아이템5", 1500, 1);
Item item10 = new Item("ITEM_CODE_6", "아이템6", 2200, 8);

List<Item> itemList1 = List.of(item1, item3, item5, item7, item9);
List<Item> itemList2 = List.of(item2, item4, item6, item8, item10);
```

이 상태에서 우리가 원하는 작업은 2개의 리스트를 합치며
중복을 제거(그룹화)하고, 아이템의 **수량**을 합치는 작업을 하고 싶다.

단순 데이터 상으로 결과를 예상하면 아래와 같은 리스트가 나오게 하고 싶은 것이다.

```java
Item{itemCode='ITEM_CODE_1', itemName='아이템1', price=1000, quantity=30}
Item{itemCode='ITEM_CODE_4', itemName='아이템4', price=1050, quantity=7}
Item{itemCode='ITEM_CODE_5', itemName='아이템5', price=1500, quantity=61}
Item{itemCode='ITEM_CODE_2', itemName='아이템2', price=1200, quantity=20}
Item{itemCode='ITEM_CODE_3', itemName='아이템3', price=1030, quantity=9}
Item{itemCode='ITEM_CODE_6', itemName='아이템6', price=2200, quantity=8}
```

이 작업을 하기 위해 어떤 것이 필요할까?

## 리스트를 하나로 합치기.

우선 각 리스트에서 그룹화 하기는 힘들다.
하나로 합쳐야 한다. 어찌되었건 2개의 리스트가 다 동일한 타입이니
아래 처럼 1개의 리스트로 합친다.

```java
List<Item> mergedList = new ArrayList<>();
mergedList.addAll(itemList1);
mergedList.addAll(itemList2);
```

새로운 리스트를 선언하여 2개 리스트를 전부 넣어주었다.

## 리스트를 그룹화 하기.

하나의 리스트에서 직접적인 값 변경이 없는 작업을 하기 위해 `stream` 을 활용할 것이며
그룹화를 하기 위해 `Collectors.groupingBy` 를 사용한다.

### groupingBy

`public static <T,K> Collector<T,?,Map<K,List<T>>> groupingBy(Function<? super T,? extends K> classifier, Collector<? super T,A,D> downstream)`

> T 유형의 입력 요소에 대해 계단식 "group by" 작업을 구현하는 Collector를 반환하고, 분류 함수에 따라 요소를 그룹화한 다음 지정된 다운스트림 Collector를 사용하여 지정된 키와 관련된 값에 대해 축소 작업을 수행합니다.
분류 함수는 요소를 일부 Key type K에 매핑합니다. 다운스트림 수집기는 Type의 요소에 대해 연산하고 D타입의 결과를 생성합니다. 결과 수집기는 Map<K, D>를 생성합니다.

위는 메소드 주석에 존재하는 메소드 설명이다. 쉽게 얘기하면 `groupingBy` 함수의 첫번째 인자로는 어떤 값을 기준으로 그룹화 할 껀지에 대한 기준이 들어가야 하고
두번째는 그룹핑 기준으로 요소를 컬렉트 할 때, 어떤 작업 또는 연산을 할 것인지 지정할 수 있다.

### reduce

주어진 두 값을 하나로 도출하는 연산을 하는 메소드. `reduce` 에는 3가지 파라미터를 받을 수 있는데, 다음과 같다.

1. 리듀싱 시작 값, 혹은 반환 값(인수가 없을 때)
2. 스트림 요소에서 특정 타입으로 변환하는 함수(변환 함수)
3. 연산 방법(결과 도출 함수)


위 2가지 메소드를 활용하면 다음과 같이 사용하여 그룹화 할 수 있다.
람다를 활용하여 변환 함수를 정의하여 받았다.(여기서는 item 클래스에서 선언된 `merge` 함수)
`groupingBy` 함수는 `Map` 형태로 리턴하기 때문에 `List` 타입으로 바로 받을 수 없다.

```java
Map<String, Optional<Item>> mergeMap = new HashMap<>();

mergeMap = mergedList.stream().collect(
  groupingBy(
    // itemCode 기준으로 그룹핑 한다.
    Item::getItemCode,
    // 1차로 그룹핑 된 결과에 추가적으로 어떤 작업을 해줄 수 있다.
    // 여기서는 reducing을 통해, 그룹핑 결과 2개를 합친다.
    Collectors.reducing((x, y) -> Item.merge(x, y))
  )
);
```

`merge` 함수에서는 스트림에서 순서대로 `Item` 클래스 x,y 가 들어오면
두 클래스의 수량 항목을 합친 새 객체를 리턴한다.

`groupingBy` 함수에서는 그룹화 기준인 `getItemCode` 에 따라, 아이템 코드가 같은 경우에만
리듀싱이 실행되기 때문에 동일 코드를 가진 객체에 대해서만 실행된다.

## 중간 점검

위 상태에서 `mergeMap` 결과를 출력해보면 다음과 같이 출력된다.

```bash
Optional[Item{itemCode='ITEM_CODE_1', itemName='아이템1', price=1000, quantity=30}]
Optional[Item{itemCode='ITEM_CODE_4', itemName='아이템4', price=1050, quantity=7}]
Optional[Item{itemCode='ITEM_CODE_5', itemName='아이템5', price=1500, quantity=61}]
Optional[Item{itemCode='ITEM_CODE_2', itemName='아이템2', price=1200, quantity=20}]
Optional[Item{itemCode='ITEM_CODE_3', itemName='아이템3', price=1030, quantity=9}]
Optional[Item{itemCode='ITEM_CODE_6', itemName='아이템6', price=2200, quantity=8}]
```

리듀싱에 대한 결과 객체는 `Optional` 로 반환되고, 그룹핑에 대한 결과는 `Map` 으로 반환되기 때문에
`Map<String, Optional<Item>>` 이라는 타입의 결과 객체가 반환 되었다.

우리는 이 `Map`을 다시 `List` 로 변환 시켜주면 된다.

## 최종 변환 작업

```java
mergedList = mergeMap.values().stream()
  // 위에 reducing을 통한 집계의 리턴이 Optional 이기 때문에 
  // 값이 없는 경우를 제외하기 위해 isPresent 를 통해 필터링 한다.
  .filter(Optional::isPresent)
  // Optional.get 을 통해 값만 가져와 List 로 Collect 한다.
  .map(Optional::get).collect(Collectors.toList());
```

Optional 객체로 리턴되었기 때문에 혹시나 값이 없는 경우를 제외하기 위해 
`Optional::isPresent` 를 통해 맵을 필터링한다.

필터링 된 `Optional Stream` 을 `map` 을 통해, 값만 가져와 `List` 로 `Collect` 한다.
이렇게 변환 과정을 거치게 된 결과를 출력하면 아래와 같다.

```java
Item{itemCode='ITEM_CODE_1', itemName='아이템1', price=1000, quantity=30}
Item{itemCode='ITEM_CODE_4', itemName='아이템4', price=1050, quantity=7}
Item{itemCode='ITEM_CODE_5', itemName='아이템5', price=1500, quantity=61}
Item{itemCode='ITEM_CODE_2', itemName='아이템2', price=1200, quantity=20}
Item{itemCode='ITEM_CODE_3', itemName='아이템3', price=1030, quantity=9}
Item{itemCode='ITEM_CODE_6', itemName='아이템6', price=2200, quantity=8}
```


# 결론

Stream을 본격적으로 활용할 곳이 많이 없었다.
보통 코딩 알고리즘 문제 같은 곳에서 단순한 자바 원시 타입이나, 이를 래핑한 타입에 대해서
사용한 적은 있었는데, 막상 커스텀 객체에서 사용하려고 하니 나사가 빠져버렸다.

이리저리 검색해서 사용했는데.. 원리만 알면 응용할 수 있는 수준이긴 했다.
이것보다 더 복잡하게 들어가면 다시 찾아봐야 할 지는 모르겠다.

원래 로직 상황에서는 DB 쿼리로 위 작업을 할 수 있는데, 자바에서 필터링 하는 방식으로
시도했다. 그래도 DB 방식와 Java 방식 2가지의 수행 시간 비교나 작업 효율 비교는 해봐야 겠다.

매번 느끼지만 자바로 하는게 무조건 좋은 것은 아니고, DB 에서 처리하는게 효율적일 수 있다.
어느 방식으로 하든 정답은 아니지만, 추구해야 할 것은 사용자 입장에서 
빠른 응답 속도를 갖게하는 처리 방식을 추구해야 한다고 생각한다.
