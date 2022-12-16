---
layout: post
title: Python - URL Encoding
description: >
  파이썬을 이용한 URL Encoding
hide_last_modified: true
categories: [Python]
tags: [URL Encoding, urllib, Python, 파이썬]
---

- Table of Contents
  {:toc .large-only}

# URL 인코딩

- URL 인코딩은 퍼센트 인코딩이라고도 불리며 URL에 문자를 표현하는 문자 인코딩 방법입니다. 알파벳이나 숫자 등 몇몇 문자를 제외한 나머지는 1바이트 단위로 묶인 16진수로 인코딩하는 방식입니다.

## 인코딩을 하는 이유

- GET 방식을 통해 HTTP 요청을 할 때 쿼리 파라미터가 붙는 경우가 생기는데 URL은 아스키 코드값만 사용됩니다. 이 쿼리 파라미터에 한글이 포함될 경우, 아스키 코드만으로 표현을 할 수 없어서 인코딩을 진행해야 합니다. 호출하는 API마다 쿼리 파라미터에 한글 문자 그대로를 지원하는 경우도 있지만 그렇지 않은 경우도 있으므로 미리 인코딩을 거친 형식으로 전송하는 것이 바람직합니다.

## urllib

- 파이썬 내장함수로 제공되는 urllib을 통해 URL Encoding이 가능합니다.

```python
from urllib import parse

url = parse.urlparse('https://google.com/search?q=검색어')

query = parse.parse_qs(url.query)
result = parse.urlencode(query, doseq=True)

print(query)
print(result)

#{'q': ['검색어']}
#q=%EA%B2%80%EC%83%89%EC%96%B4
```

- 인코딩 시, 캐릭터셋을 지정하고 싶은 경우 아래와 같이 작성합니다.

```python
from urllib import parse

url = parse.urlparse('https://google.com/search?q=검색어')

query = parse.parse_qs(url.query)
result = parse.urlencode(query, encoding='UTF-8', doseq=True)

print(query)
print(result)

# {'q': ['검색어']}
# q=%EA%B2%80%EC%83%89%EC%96%B4
```

## 단순 문자열 인코딩/디코딩

- 단순 문자열을 인코딩/디코딩 하고싶은 경우 아래와 같이 작성합니다.

```python
from urllib import parse


text = '검색어'

encode = parse.quote(text)
decode = parse.unquote(encode)

print(encode)
print(decode)

# %EA%B2%80%EC%83%89%EC%96%B4
# 검색어
```

## urlparse 시, 속성 값

- urlparse 시, 사용할 수 있는 속성 값은 아래와 같습니다.

```python
from urllib import parse

# scheme://username:password@host:port/path;params?query#fragment
parse_result = parse.urlparse('https://google.com/search?q=검색어&params=999#id123')
print(parse_result)

print(parse_result.scheme)
print(parse_result.username)
print(parse_result.password)
print(parse_result.hostname)
print(parse_result.port)
print(parse_result.netloc)
print(parse_result.path)
print(parse_result.params)
print(parse_result.query)
print(parse_result.fragment)

#ParseResult(scheme='https', netloc='google.com', path='/search', params='', query='q=검색어&params=999', #fragment='id123')
#https
#None
#None
#google.com
#None
#google.com
#/search
#
#q=검색어&params=999
#id123
```

- scheme: http, https, ftp, smtp 등등 스키마
- username: 사용자 명
- password: 비밀번호
- hostname: 호스트 명
- port: 포트 번호
- netloc: 네트워크 정보
- path: 경로
- params: url 파라미터
- query: 쿼리 스트링
- fragment: fragment 식별자
