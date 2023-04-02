---
title: Java Early Return 을 이용한 리팩토링
categories: [Backend, Java]
tags: [Java, Early Return]
---

## **early return**
- 조건문에서 리턴을 이용하여 중첩 구문을 줄이고 가독성을 높이는 리팩토링 기법 중 하나입니다.
- 조건이 부합하지 않으면 곧바로 return을 하도록 하는 코딩 패턴입니다.
이렇게 작성함으로써, 가독성이 좋은 코드가 될 수 있습니다.

## **Example**

### Early Return이 적용되지 않은 코드
다음은 Early Return이 적용되지 않은 코드 예시입니다.

```java
public int calculateTotalPrice(List<Product> products) {
    int totalPrice = 0;
    for (Product product : products) {
        if (product.getPrice() > 0) {
            totalPrice += product.getPrice();
        } else {
            totalPrice = 0;
            break;
        }
    }
    return totalPrice;
}
```

위의 코드에서는 calculateTotalPrice 메소드를 정의하고, 제품 목록(products)의 가격 총합(totalPrice)을 계산합니다.

if 문에서는 제품 가격이 0보다 작은 경우에는 총합을 0으로 초기화하고, 루프를 종료합니다. 이렇게 하면, 가격이 유효하지 않은 제품이 포함되어 있을 때 총합 계산을 중지할 수 있습니다.

하지만, 위의 코드에서는 불필요한 else 블록이 있으며, 중첩된 if-else 문이 사용되어 코드의 가독성이 떨어집니다.

### Early Return이 적용된 코드 예시 1
다음은 Early Return이 적용된 코드 예시입니다.

```java
public int calculateTotalPrice(List<Product> products) {
    int totalPrice = 0;
    for (Product product : products) {
        if (product.getPrice() <= 0) {
            return 0;
        }
        totalPrice += product.getPrice();
    }
    return totalPrice;
}
```
위의 코드에서는 Early Return을 사용하여 중첩된 if-else 문을 없앴습니다. if 문에서는 제품 가격이 0보다 작거나 같은 경우에는 총합을 계산하지 않고, 0을 반환합니다. 이렇게 하면, 가격이 유효하지 않은 제품이 포함되어 있을 때 총합 계산을 하지 않아도 됩니다.

### Early Return이 적용된 코드 예시 2
다음은 Early Return이 적용된 더 복잡한 코드 예시입니다.

```java
public int calculateTotalPrice(List<Product> products) {
    int totalPrice = 0;
    for (Product product : products) {
        if (product.getPrice() <= 0) {
            return 0;
        } else {
            totalPrice += product.getPrice();
        }
    }
    if (totalPrice > 100) {
        return totalPrice * 0.9;
    } else {
        return totalPrice;
    }
}
```
위의 코드에서는 Early Return을 사용하여 중첩된 if-else 문을 없앴습니다. if 문에서는 제품 가격이 0보다 작거나 같은 경우에는 총합을 계산하지 않고, 0을 반환합니다. 이렇게 하면, 가격이 유효하지 않은 제품이 포함되어 있을 때 총합 계산을 하지 않아도 됩니다.