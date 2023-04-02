---
title: postgreSQL - pg lock 조회 및 해제
categories: [Database]
tags: [postgres, postgreSQL, pg lock]
---

## 1. LOCK 조회

```sql
select
	*
from
	pg_catalog.pg_locks a
join
	pg_catalog.pg_stat_all_tables b
on
	a.relation  = b.relid
where
	b.relname = '{tableName}'
```

## 2. PG_CANCEL_BACKEND 로 작업캔슬.

```sql
select
	pg_cancel_backend(a.pid)
from
	pg_catalog.pg_locks a
join
	pg_catalog.pg_stat_all_tables b
on
	a.relation  = b.relid
where
	b.relname = '{tableName}'
```

## 3. 위 방법이 안되는 경우, PG_TERMINATE_BACKEND로 상위 PID까지 캔슬.

```sql
select
	pg_terminate_backend(a.pid)
from
	pg_catalog.pg_locks a
join
	pg_catalog.pg_stat_all_tables b
on
	a.relation  = b.relid
where
	b.relname = '{tableName}'
```
