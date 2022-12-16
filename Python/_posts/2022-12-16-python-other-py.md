---
layout: post
title: Python - 다른 python 파일 포함 시키기
description: >
    파이썬 파일에서 다른 파이썬 파일의 함수 등을 사용하는 방법을 기술합니다.
    
hide_last_modified: true
categories: [Python]
tags: [import python, other python function, Python, 파이썬]
---

- Table of Contents
{:toc .large-only}

## 다른 파이썬 파일의 함수 포함시키기
- function.py
```python
import os
import sys

def func(parameter1,parameter2):
    print(parameter1)
    print(parameter2)

    return True
```

- main.py
```python
import os
import sys

import function
function.func(1,2)
> 1
> 2

----------------------------------

from function import func
func(1,2)
> 1
> 2

```

- import function
    - function 파일을 포함 시키는 방법
    - 내부 함수는 파일명.함수명 으로 사용한다.


- from function import func
    - 파일명.함수명으로 사용하기 번거로울 때 사용.
    - 함수를 임포트 시킨다고 보면 된다.