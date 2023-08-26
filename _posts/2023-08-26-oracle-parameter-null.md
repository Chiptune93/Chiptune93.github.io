---
title: Database 검색 조건이 NULL 일 때, 어떻게 할까?
categories: [Backend, Database]
tags: [where, parameter is null, 검색조건, 검색조건이 NULL 일 때, oracle, NVL]
---

# 데이터베이스 검색조건이 NULL 일 때

SQL 쿼리 작성 중, 조건 절에서 검색조건이 없을 때 해당 구문을 타지 않게 하는 방법에 대해서 설명합니다.

1. **COALESCE 또는 NVL 함수 사용**:
  - `COALESCE` 또는 `NVL` 함수를 사용하여 파라미터를 검사하고, 파라미터가 NULL인 경우 기본값을 사용하도록 검색 조건을 설정할 수 있습니다. 예를 들어, 다음과 같이 사용할 수 있습니다:

   ```sql
   SELECT *
   FROM your_table
   WHERE column_name = COALESCE(:your_parameter, column_name);
   ```

   이 쿼리는 `:your_parameter`가 NULL이면 검색 조건을 제외하고 모든 레코드를 반환합니다. 파라미터가 NULL이 아닌 경우 해당 파라미터 값과 열 값을 비교합니다.

2. **CASE 문 사용**:
  - `CASE` 문을 사용하여 조건부로 검색 조건을 추가하거나 제외할 수 있습니다. 예를 들어:

   ```sql
   SELECT *
   FROM your_table
   WHERE
     CASE
       WHEN :your_parameter IS NULL THEN 1
       WHEN column_name = :your_parameter THEN 1
       ELSE 0
     END = 1;
   ```

   위의 쿼리는 `:your_parameter`가 NULL이면 검색 조건을 제외하고, 그렇지 않으면 `column_name`과 `:your_parameter`를 비교합니다.

3. **IS NULL 조건 사용**:
  - 파라미터가 NULL이라면 해당 열이 NULL인 레코드를 검색하는 조건을 사용할 수 있습니다. 예를 들어:

   ```sql
   SELECT *
   FROM your_table
   WHERE
     (:your_parameter IS NULL OR column_name = :your_parameter);
   ```

   이렇게 하면 `:your_parameter`가 NULL이면 검색 조건이 아예 적용되지 않으며, NULL이 아닌 경우 해당 파라미터 값과 열 값을 비교합니다.


# Oracle NVL vs NVL2

## NVL 함수

`NVL` 함수는 Oracle에서 파라미터가 NULL인 경우 대체 값을 사용하는 데 사용됩니다. 이 함수는 다음과 같은 구문을 가지고 있습니다:

```sql
NVL(expr1, expr2)
```

- `expr1`: 검사할 값
- `expr2`: `expr1`이 NULL인 경우 대체할 값

예를 들어, `NVL` 함수를 사용하여 파라미터가 NULL인 경우 검색 조건을 제외하도록 다음과 같이 작성할 수 있습니다:

```sql
SELECT *
FROM your_table
WHERE column_name = NVL(:your_parameter, column_name);
```

이 쿼리는 `:your_parameter`가 NULL이면 검색 조건을 제외하고 모든 레코드를 반환합니다. 파라미터가 NULL이 아닌 경우 해당 파라미터 값과 열 값을 비교합니다.

## NVL2 함수

`NVL2` 함수는 `NVL` 함수와 다르게, 파라미터가 NULL이 아닌 경우와 NULL인 경우에 대해 서로 다른 처리를 할 수 있습니다. 이 함수는 다음과 같은 구문을 가지고 있습니다:

```sql
NVL2(expr1, expr2, expr3)
```

- `expr1`: 검사할 값
- `expr2`: `expr1`이 NULL이 아닌 경우 실행할 표현식
- `expr3`: `expr1`이 NULL인 경우 실행할 표현식

예를 들어, `NVL2` 함수를 사용하여 파라미터가 NULL인 경우와 NULL이 아닌 경우에 대해 서로 다른 검색 조건을 설정할 수 있습니다:

```sql
SELECT *
FROM your_table
WHERE NVL2(:your_parameter, column_name = :your_parameter, 1) = 1;
```

이 쿼리는 `:your_parameter`가 NULL이면 검색 조건을 제외하고, NULL이 아닌 경우 해당 파라미터 값과 열 값을 비교합니다.

## 예제

다음은 `NVL` 및 `NVL2` 함수를 사용한 예제 입니다.

```sql
-- NVL 함수 사용
SELECT *
FROM employees
WHERE hire_date = NVL(:hire_date_param, hire_date);

-- NVL2 함수 사용
SELECT *
FROM employees
WHERE NVL2(:hire_date_param, hire_date = :hire_date_param, 1) = 1;
```

이러한 함수를 사용하면 파라미터가 NULL인 경우 검색 조건을 적절하게 처리할 수 있습니다. 데이터베이스 시스템과 요구 사항에 따라 더 적합한 함수를 선택할 수 있습니다.
