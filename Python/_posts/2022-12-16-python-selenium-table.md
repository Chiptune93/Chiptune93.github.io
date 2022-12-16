---
layout: post
title: Python - Selenium Table Parsing
description: >
  파이썬 셀레니움을 이용한 테이블 파싱하는 방법
hide_last_modified: true
categories: [Python]
tags: [Selenium, Table, Table Parsing, Python, 파이썬]
---

- Table of Contents
  {:toc .large-only}

# Selenium 라이브러리에서 테이블 파싱하기

## 테이블 구조 파악

- 다음과 같은 HTML 테이블이 있다고 가정

```html
<!DOCTYPE html>
<html>
   <head>
      <title>Selenium Table</title>
   </head>
   <body>
      <table border="1">
        <thead>
         <tr>
            <th>Name</th>
            <th>Class</th>
         </tr>
        </thead>
        <tbody>
         <tr>
            <td>Vinayak</td>
            <td>12</td>
         </tr>
         <tr>
            <td>Ishita</td>
            <td>10</td>
         </tr>
        </tbody>
      </table>
   </body>
</html>
```

- 행과 열의 개수를 파악하여 반복을 통해 데이터를 가져온다.
- 개수 파악에는 요소의 길이를 세는 것으로 한다.
- 요소 위치는 Xpath를 통해 파악한다.

```python
from selenium import webdriver
from selenium.webdriver.common.by import By
from time import sleep
  
driver = webdriver.Chrome(
    executable_path="C:\selenium\chromedriver_win32\chromedriver.exe")
  
driver.get(
    "https://www.geeksforgeeks.org/find_element_by_link_text-driver-method-selenium-python/")

# 요소 로딩 대기
sleep(2)
  
# row의 개수를 1 + 요소의 길이로 파악한다 -> 전체 개수
rows = 1+len(driver.find_elements(By.XPATH, "/html/body/div[3]/div[2]/div/div[1]/div/div/div/article/div[3]/div/table/tbody/tr"))
  
# column의 개수는 1+ 요소의 길이로 파악한다 -> 전체 개수
cols = len(driver.find_elements(By.XPATH, "/html/body/div[3]/div[2]/div/div[1]/div/div/div/article/div[3]/div/table/tbody/tr[1]/td"))
  
# 행과 열의 수로 2중 반복을 통해 요소의 값을 가져온다.
for r in range(2, rows+1):
    for p in range(1, cols+1):
        
        value = driver.find_element(By.XPATH, "/html/body/div[3]/div[2]/div/div[1]/div/div/div/article/div[3]/div/table/tbody/tr["+str(r)+"]/td["+str(p)+"]").text
        print(value, end='       ')
    print()
```