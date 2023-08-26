---
title: ORACLE - COMMENT, FOREIGN KEY, PRIMARY KEY 설정
categories: [Backend, Database]
tags: [oracle, comment, foreign key, primary key]
---

```sql
-- 테이블 Comment 설정
-- COMMENT ON TABLE [테이블명] IS [Comment];

-- 테이블 Comment 설정
COMMENT ON TABLE 테이블명 IS '내용';

-- 컬럼 Comment 설정
COMMENT ON COLUMN 테이블명.컬럼명 IS '내용';

-- 테이블 FOREIGN KEY 생성
ALTER TABLE 테이블명
ADD CONSTRAINTS 키이름
FOREIGN KEY(컬럼명)
REFERENCES 참조테이블명(컬럼명);

-- 테이블 PK 생성
ALTER TABLE 테이블명 DROP PRIMARY KEY; -- 기존 기본키 삭제
ALTER TABLE 테이블명 ADD CONSTRAINT 키이름 PRIMARY KEY (키1,키2 ...);   -- PK를 생성한다.
```
