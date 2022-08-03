---
layout: post
title: NoSuchMethodError - org.apache.commons.codec.binary.hex.encodehexstring
description: >
    NoSuchMethodError - org.apache.commons.codec.binary.hex.encodehexstring
sitemap: false
hide_last_modified: true
categories: [Error]
tags: [Java Error, NoSuchMethodError]
---

- Table of Contents
{:toc .large-only}

## NoSuchMethodError : org.apache.commons.codec.binary.hex.encodehexstring 에러 해결

- commons-codec 라이브러리 여러 버전이 충돌해서 발생하는 문제였음 
- 라이브러리 빌드 경로에 1개 이상의 codec 라이브러리가 있는지 확인 후,
사용하는 것만 남긴 후 다시 빌드하니 정상 작동 함.

