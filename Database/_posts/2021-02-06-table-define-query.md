---
layout: post
title: MYSQL/ORACLE - 테이블 정의서 간단하게 뽑는 쿼리
description: >
  MYSQL/ORACLE - 테이블 정의서 간단하게 뽑는 쿼리

hide_last_modified: true
categories: [Database]
tags: [mysql, oracle, table, 테이블정의서]
---

- Table of Contents
{:toc .large-only}

## MySQL

```sql
SELECT
	a.TABLE_NAME '테이블명',
	b.ORDINAL_POSITION '순번',
	b.COLUMN_NAME '필드명',
	b.DATA_TYPE 'DATA TYPE',
	b.COLUMN_TYPE '데이터길이',
	b.COLUMN_KEY 'KEY',
	b.IS_NULLABLE 'NULL값여부',
	b.EXTRA '자동여부',
	b.COLUMN_DEFAULT '디폴트값',
	b.COLUMN_COMMENT '필드설명'
from
	information_schema.TABLES a
join
	information_schema.COLUMNS b
on
	a.TABLE_NAME = b.TABLE_NAME
    and a.TABLE_SCHEMA = b.TABLE_SCHEMA
where
	a.TABLE_SCHEMA = '{스키마명}'
ORDER BY
	a.TABLE_NAME, b.ORDINAL_POSITION
```

## Oracle

```sql
SELECT tab_columns.TABLE_NAME,
                       tab_columns.COLUMN_ID,
                       tab_columns.COLUMN_NAME,
                       (
                           CASE
                               WHEN DATA_TYPE LIKE '%CHAR%'
                               THEN DATA_TYPE || '(' || DATA_LENGTH || ')'
                               WHEN DATA_TYPE = 'NUMBER'
                                   AND DATA_PRECISION > 0
                                   AND DATA_SCALE > 0
                               THEN DATA_TYPE || '(' || DATA_PRECISION || ',' || DATA_SCALE || ')'
                               WHEN DATA_TYPE = 'NUMBER'
                                   AND DATA_PRECISION > 0
                               THEN DATA_TYPE || '(' || DATA_PRECISION || ')'
                               WHEN DATA_TYPE = 'NUMBER'
                               THEN DATA_TYPE
                               ELSE DATA_TYPE
                           END
                       )
                       COLUMN_TYPE,
                       NULLABLE IS_NULLABLE,
                       DATA_DEFAULT,
                       (SELECT decode( sum
                              (
                                     (SELECT decode(CONSTRAINT_TYPE, 'P', 1, 'R', 2, 0)
                                       FROM USER_CONSTRAINTS
                                      WHERE CONSTRAINT_NAME = cons_columns.CONSTRAINT_NAME
                                     )
                                 )
                                 , 1, 'PRI', 2, 'FK', 3, 'PRI, FK', '')
                            FROM USER_CONS_COLUMNS cons_columns
                           WHERE TABLE_NAME = tab_columns.TABLE_NAME
                                 AND COLUMN_NAME = tab_columns.COLUMN_NAME
                          ) AS COLUMN_KEY,
                          COMMENTS.COMMENTS AS COLUMN_COMMENT
                     FROM USER_TAB_COLUMNS tab_columns,
                          USER_COL_COMMENTS comments
                    WHERE tab_columns.TABLE_NAME = comments.TABLE_NAME(+)
                          AND tab_columns.COLUMN_NAME = comments.COLUMN_NAME(+)
                          AND tab_columns.TABLE_NAME =  #{tableName}
                 ORDER BY COLUMN_ID
```
