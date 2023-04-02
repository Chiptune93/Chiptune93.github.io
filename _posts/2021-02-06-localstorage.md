---
title: Javascript - localstorage 사용하기
categories: [Frontend, Scripts]
tags: [localstorage, Javascript]
---

`localstorage. `으로 사용

| 이름                | 구분   | 기능                                        |
| ------------------- | ------ | ------------------------------------------- |
| setItem(key, value) | 메소드 | 해당 키 값으로 데이터를 저장한다.           |
| getItem(key)        | 메소드 | 해당 키 값의 이름을 가진 데이터를 가져온다. |
| removeItem(key)     | 메소드 | 해당 키 값의 이름을 가진 데이터를 삭제한다. |
| key(index)          | 메소드 | 해당 인덱스 값을 가진 키의 이름을 가져온다. |
| clear()             | 메소드 | 모든 데이터를 삭제한다.                     |
| length              | 속성   | 저장된 데이터 수를 가져온다.                |

- 크롬에서 동작, 익플에서는 버전문제로 호환안되는 경우 있음. 모바일 상황인 경우에만 활용가능하지 않을까 생각함.
