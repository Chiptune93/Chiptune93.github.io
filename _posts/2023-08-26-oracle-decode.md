---
title: Oracle DECODE
categories: [Backend, Database]
tags: [oracle, decode]
---


# Oracle의 DECODE 함수: 데이터 값을 변환하고 비교하기

Oracle 데이터베이스에서는 데이터를 비교하고 변환하는 데 유용한 `DECODE` 함수를 제공합니다. 이 함수는 특정 값과 일치하는 경우 다른 값을 반환하거나 변환할 수 있으며, SQL 쿼리에서 유연한 데이터 처리를 가능하게 합니다.

## DECODE 함수 개요

`DECODE` 함수는 다음과 같은 구문을 가지고 있습니다:

```sql
DECODE(expr, search1, result1, search2, result2, ..., default)
```

- `expr`: 비교할 값
- `search1`, `search2`, ...: 비교 대상 값들
- `result1`, `result2`, ...: `expr`이 `search1`, `search2`, ...와 일치하는 경우 반환할 값들
- `default` (옵션): 어떤 `search` 값과도 일치하지 않을 때 반환할 기본 값

`DECODE` 함수는 `expr`과 `search` 값들을 비교하고, `expr`이 `search` 값 중 하나와 일치하면 해당 `result` 값을 반환합니다. 일치하는 값이 없을 경우 `default` 값을 반환합니다.

## DECODE 함수 예제

다음은 `DECODE` 함수를 사용한 간단한 예제입니다. 이 예제에서는 사원의 직무를 기준으로 보너스를 지급하는 경우를 가정합니다.

```sql
SELECT employee_name, job,
       DECODE(job,
              'MANAGER', salary * 0.2,
              'SALESMAN', salary * 0.1,
              'CLERK', salary * 0.05,
              salary * 0.15) AS bonus
FROM employees;
```

이 쿼리는 각 사원의 직무(`job`)를 비교하고, 해당 직무에 따라 보너스를 계산합니다. 만약 직무가 'MANAGER', 'SALESMAN', 또는 'CLERK'가 아니면 15%의 보너스를 적용합니다.

## DECODE 함수 복합 예제

`DECODE` 함수는 여러 개의 비교 조건을 함께 사용하여 더 복잡한 로직을 구현할 수 있습니다. 예를 들어, 다음 쿼리는 과목 점수를 기준으로 학점을 부여하는 복합 예제입니다:

```sql
SELECT student_name, subject, score,
       DECODE(
           WHEN score >= 90 THEN 'A+'
           WHEN score >= 80 THEN 'A'
           WHEN score >= 70 THEN 'B'
           WHEN score >= 60 THEN 'C'
           ELSE 'F'
       ) AS grade
FROM student_scores;
```

이 쿼리는 각 학생의 과목 점수(`score`)를 비교하고, 해당 점수에 따라 학점(`grade`)을 부여합니다. 복합적인 조건을 `DECODE` 함수 내부에서 정의하여 간결하게 로직을 처리할 수 있습니다.

## DECODE 함수의 심화 내용: NULL 처리와 CASE 문

### NULL 처리

`DECODE` 함수는 NULL 값을 처리할 때 주의해야 합니다. NULL 값을 비교할 때는 추가적인 처리가 필요할 수 있으며, `NVL` 또는 `CASE` 문을 함께 사용하여 처리할 수 있습니다. 예를 들어:

```sql
SELECT employee_name,
       DECODE(NVL(salary, 0),
              0, 'No Salary',
              10000, 'Low Salary',
              50000, 'Average Salary',
              'High Salary') AS salary_category
FROM employees;
```

이 쿼리에서는 급여(`salary`)가 NULL인 경우 'No Salary'로 처리되고, 특정 급여 범위에 따라 다른 카테고리로 분류됩니다.

### CASE 문 활용

복잡한 비교 로직을 다룰 때 `DECODE` 함수는 가독성을 해치기 쉽습니다. 이런 경우 `CASE` 문을 사용하거나 별도의 PL/SQL 블록을 고려할 수 있습니다. `CASE` 문을 사용하면 보다 명확하고 가독성 있는 코드를 작성할 수 있습니다.

예를 들어, 위의 학점 부여 예제를 `CASE` 문으로 작성하면 다음과 같습니다:

```sql
SELECT student_name, subject, score,
       CASE
           WHEN score >= 90 THEN 'A+'
           WHEN score >= 80 THEN 'A'
           WHEN score >= 70 THEN 'B'
           WHEN score >= 60 THEN 'C'
           ELSE 'F'
       END AS grade
FROM student_scores;
```

`CASE` 문을 사용하면 비교 로직을 더 명시적으로 표현할 수 있습니다.

`DECODE` 함수는 데이터를 비교하고 변환하는 간단한 함수로 시작할 수 있으며, 복잡한 로직에도 적용할 수 있습니다. 그러나 가독성과 유지 관리 측면에서 주의가 필요하며, 쿼리의 복잡성이 증가할 때는 다른 방법을 고려해야 할 수 있습니다.

