---

title: Python - Request 라이브러리 사용
description: >
  파이썬 Request 라이브러리 사용방법에 대한 간단한 정리

categories: [Python]
tags: [Python, 파이썬, Request]
---




# Request 라이브러리 사용

## 기본 사용 방법

```python
import requests
URL = 'https://google.com'
response = requests.get(URL)
response.status_code
response.text

print(response)
print(response.status_code)
print(response.text)

# <Response [200]>
# 200
# <!doctype html><html itemscope="" itemtype=...</body></html>
```

## GET 요청 시, 파라미터 전달 방법

```python
import requests
URL = 'https://google.com'

params = {'param1': 'value1', 'param2': 'value'}
res = requests.get(URL, params=params)

```

## POST 요청 시, 파라미터 전달 방법

- 일반적인 방법

```python
import requests
URL = 'https://google.com'

data = {'param1': 'value1', 'param2': 'value'}
res = requests.post(URL, data=data)
```

- Json 전달

```python
import requests, json

data = {'outer': {'inner': 'value'}}
res = requests.post(URL, data=json.dumps(data))
```

## 헤더 또는 쿠키의 추가

```python
headers = {'Content-Type': 'application/json; charset=utf-8'}
cookies = {'session_id': 'sorryidontcare'}

# GET
res = requests.get(URL, headers=headers, cookies=cookies)
# POST
res = requests.post(URL, data=json.dumps(data), headers=headers, cookies=cookies)
```