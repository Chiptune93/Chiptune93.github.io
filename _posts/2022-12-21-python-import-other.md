---
title: Python - import other file
categories: [Frontend, Python]
tags: [Python, 파이썬, import, from, from import]
---

### 파이썬의 모듈/패키지 탐색 순서

> sys.module -> built-in module -> sys.path

위 과정에서 모듈/패키지를 찾지 못하는 경우, ModuleNotFoundError를 반환한다.

상위 디렉토리 혹은 특정 위치에 있는 파일을 포함하고자 할 때는
sys.path에 경로를 추가해주어야 한다.

```python
@(2PC)--의-MacBook Pro Chiptune93.github.io % python3
Python 3.9.6 (default, Sep 26 2022, 11:37:49) 
[Clang 14.0.0 (clang-1400.0.29.202)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import sys
>>> print(sys.path)
['', '/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python39.zip', '/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9', '/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/lib-dynload', '/Users//Library/Python/3.9/lib/python/site-packages', '/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/site-packages']
>>> 
```

위에 보이는 path를 기본적으로 순차 탐색 하며, 모듈/패키지가 있는지 확인 한다.

### 파일 포함 시켜 사용하기

- 파이썬에서 파일을 포함시키는 경우 및 방법은 다음과 같다.

```python
import os, sys

## 현재 모듈이 있는 디렉토리 경로
os.path.dirname(__file__)

## 현재 모듈의 상위 디렉토리 경로
os.path.dirname(os.path.abspath(os.path.dirname(__file__)))

## 현재 모듈의 2단계 상위 디렉토리 경로
os.path.dirname(os.path.abspath(os.path.dirname(os.path.abspath(os.path.dirname(__file__)))))

## sys.path에 상위 디렉토리 추가
sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))

## sys.path에 특정 디렉토리 추가
sys.path.append('{dir}')
```

- 같은 경로에 있는 경우

```python
import file # file.function() 으로 사용
## 또는
from file import function # function() 으로 사용
```

- 다른 경로에 있는 경우

```python
import sys
sys.path.append('{dir}') # 이렇게 추가 후, 아래에서 임포트하여 사용한다.

import file # file.function() 으로 사용
## 또는
from file import function # function() 으로 사용

```