---
title: Oracle MINUS
categories: [Backend, Database]
tags: [oracle, minus]
---

# Oracle의 MINUS 연산자: 데이터베이스에서 차집합 계산하기

Oracle 데이터베이스에서 `MINUS` 연산자는 두 개의 SQL 집합을 비교하고, 첫 번째 집합에는 있지만 두 번째 집합에는 없는 결과를 반환합니다. 이를 통해 데이터베이스에서 특정 조건을 만족하는 레코드를 선택하거나, 중복 레코드를 제거하는 등의 작업을 수행할 수 있습니다.

## MINUS 연산자 개요

`MINUS` 연산자는 다음과 같은 기본 문법을 가지고 있습니다:

```sql
SELECT column1, column2, ...
FROM table1
MINUS
SELECT column1, column2, ...
FROM table2;
```

첫 번째 `SELECT` 문의 결과에서 두 번째 `SELECT` 문의 결과를 뺍니다.

## MINUS 연산자 예제

다음은 `MINUS` 연산자를 사용한 간단한 예제입니다. 두 개의 테이블을 비교하여 중복되지 않는 레코드를 찾는 쿼리입니다.

```sql
-- 예제 데이터
CREATE TABLE employees1 (
    employee_id NUMBER,
    employee_name VARCHAR2(50)
);

CREATE TABLE employees2 (
    employee_id NUMBER,
    employee_name VARCHAR2(50)
);

INSERT INTO employees1 VALUES (1, 'Alice');
INSERT INTO employees1 VALUES (2, 'Bob');
INSERT INTO employees1 VALUES (3, 'Charlie');

INSERT INTO employees2 VALUES (2, 'Bob');
INSERT INTO employees2 VALUES (3, 'Charlie');
INSERT INTO employees2 VALUES (4, 'David');

-- 중복되지 않는 레코드 찾기
SELECT employee_id, employee_name
FROM employees1
MINUS
SELECT employee_id, employee_name
FROM employees2;
```

이 쿼리는 `employees1` 테이블과 `employees2` 테이블의 데이터를 비교하고, 중복되지 않는 레코드를 반환합니다. 결과로는 `employee_id`가 1인 'Alice' 레코드가 반환됩니다.

## MINUS 연산자 활용

`MINUS` 연산자는 데이터베이스에서 서로 다른 테이블 간의 데이터를 비교하고 중복 데이터를 제거하거나 특정 조건을 만족하는 레코드를 선택하는 데 유용합니다. 예를 들어, 다음과 같은 상황에서 활용할 수 있습니다:

- 두 테이블 간의 차집합을 계산하여 중복 데이터를 제거합니다.
- 특정 시간 범위 내의 로그 데이터를 찾습니다.
- 두 테이블 간의 레코드를 비교하여 변경된 데이터를 식별합니다.

데이터베이스에서 데이터를 비교하고 조작할 때 `MINUS` 연산자는 강력한 도구 중 하나입니다.
