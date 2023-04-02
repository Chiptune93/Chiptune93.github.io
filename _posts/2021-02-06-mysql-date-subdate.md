---
title: MYSQL - 특정일 + - 일 수 이전 상태 조회 SUBDATE
categories: [Database]
tags: [mysql, subdate, mysql date]
---


특정 테이블에 대하여 특정 시간 전 데이터를 보고자 할 때 사용.12시간 전 테이블 상태를 알고싶다거나 등등..

```sql
# 12시간 전 시간 조회
SELECT SUBDATE(NOW(), INTERVAL 12 HOUR);

# 1개월 전 데이터 조회
SELECT
    *
FROM
    `테이블`
WHERE
    `시간` > SUBDATE(NOW(), INTERVAL 1 MONTH);
```
