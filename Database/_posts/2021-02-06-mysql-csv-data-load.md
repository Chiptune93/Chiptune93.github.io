---
layout: post
title: MYSQL - CSV 파일에서 데이터 가져오기 시, 설정
description: >
    MYSQL CSV 파일에서 데이터 가져오기 시, 설정
sitemap: false
hide_last_modified: true
categories: [Database]
tags: [mysql, csv data, csv data load]
---

- Table of Contents
{:toc .large-only}

> 엑셀에 데이터 > 모든 열을 "texst" 로저장 -> csv 형식으로저장

heidsql 에서, 가져오기 할 때

- 필드종결자 ,
- 감싸는 구분자 "
- 벗어나는 구분자 "
- 줄 종결자 \n

설정 후 data import  사용.