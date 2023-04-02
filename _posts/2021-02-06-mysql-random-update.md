---
layout: post
title: MYSQL - 특정 컬럼에 대해 일정 범위 내 랜덤 값 업데이트
description: >
  MYSQL - 특정 컬럼에 대해 일정 범위 내 랜덤 값 업데이트

hide_last_modified: true
categories: [Database]
tags: [mysql, random]
---

- Table of Contents
{:toc .large-only}

테이블 내의 특정 컬럼에 대해 일정 범위 정수 값을 업데이트 하는 구문입니다.

```sql
UPDATE TARGET_TABLE
SET TARGET_COLUMN = ( SELECT Floor({최소값} + rand() * ({최대값} - {최소값} + 1)) AS RANDOM FROM DUAL )
WHERE 1=1
```

해당 컬럼에 최소값~최대값 사이의 랜덤 정수를 업데이트 합니다.
