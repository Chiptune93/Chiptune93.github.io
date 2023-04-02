---
title: Python - cmd에서 테이블 형태 표현하기
categories: [Python]
tags: [Python, 파이썬, cmd, cmd line table, cmd table, 콘솔, 콘솔 테이블]
---

# 파이썬 환경 cmd(console)에서 테이블 형태 표현하기

파이썬으로 개발하다보면 로깅이나 다른 표현 등을 위해 데이터를 테이블 형태로 표현하고 싶을 때가 있습니다.

보통, 결과를 다른 쪽으로 요청하거나 파일로 떨구거나 등등 작업을 하지만 이 와 연계 혹은 확인용으로 
콘솔 환경에서 테이블 형태로 데이터를 보고싶을 때도 있습니다.

이 때, 간편하게 테이블 형태로 데이터를 표현하는 라이브러리를 소개합니다.

## format() 을 활용한 데이터 표현

format() 을 활용한 데이터 표현입니다.
여기서는 데이터에 대한 자릿수 등을 감안하여 표현할 때 정수로 주어진 열의 너비를
일일히 지정해주어야 합니다.

각 열에 있는 숫자의 최대 길이를 지정해주어야 합니다. 화살표는 ^ , > , < 로 되어있는데
이는 '가운데','오른쪽','왼쪽' 정렬을 의미합니다.

```python
table = [[1, 2222, 30, 500], [4, 55, 6777, 1]]
for row in table:
    print('| {:1} | {:^4} | {:>4} | {:<3} |'.format(*row))

# 결과
| 1 | 2222 |   30 | 500 |
| 4 |  55  | 6777 | 1   |
```
별도의 라이브러리 추가 없이도 정렬을 할 수 있지만 일일히 이렇게 지정하는 것은
단순 작업에 대한 복잡성을 추가하게 됩니다.

## pandas 

Pandas 라이브러리를 활용한 표현 방식입니다.

컬럼과 인덱스 명을 지정할 수 있습니다.

```python
import pandas as pd
table = [[1, 2222, 30, 500], [4, 55, 6777, 1]]
df = pd.DataFrame(table, columns = ['a', 'b', 'c', 'd'], index=['row_1', 'row_2'])
print(df)

# 결과
       a     b     c    d
row_1  1  2222    30  500
row_2  4    55  6777    1
```

그냥 단순히 인덱스를 제외하고 보고싶어서 아래와 같이 실행해도 인덱스는 표현됩니다.

```python
import pandas as pd
table = [[1, 2222, 30, 500], [4, 55, 6777, 1]]
df = pd.DataFrame(table, columns = ['a', 'b', 'c', 'd'])
print(df)

# 결과
   a     b     c    d
0  1  2222    30  500
1  4    55  6777    1
```

더 많은 옵션이나 가이드는 이 주소를 참고하세요 (https://pandas.pydata.org/docs/user_guide/index.html)

## tabulate

해당 라이브러리에서 기본적으로는 아래와 같이 사용하면 테이블 형태를 표현할 수 있습니다.

```python
from tabulate import tabulate
table = [[1, 2222, 30, 500], [4, 55, 6777, 1]]
print(tabulate(table))

# 결과
-  ----  ----  ---
1  2222    30  500
4    55  6777    1
-  ----  ----  ---
```

테이블 헤더가 있거나 다른 옵션을 주고 싶은 경우에는 ```tablefmt``` 을 사용하여 
옵션을 주면 다음과 같이 표현할 수도 있습니다.

```python
from tabulate import tabulate
table = [['col 1', 'col 2', 'col 3', 'col 4'], [1, 2222, 30, 500], [4, 55, 6777, 1]]
print(tabulate(table, headers='firstrow', tablefmt='fancy_grid'))

# 결과
╒═════════╤═════════╤═════════╤═════════╕
│   col 1 │   col 2 │   col 3 │   col 4 │
╞═════════╪═════════╪═════════╪═════════╡
│       1 │    2222 │      30 │     500 │
├─────────┼─────────┼─────────┼─────────┤
│       4 │      55 │    6777 │       1 │
╘═════════╧═════════╧═════════╧═════════╛
```

해당 라이브러리에서 제공되는 많은 기능 중 한가지 특징 적인 것은 html 에서 사용할 수 있도록 기능을 제공해준다는 것입니다. 데이터를 마크업으로 제공하여, 웹에 게시할 때 조금 더 효과적으로 제공할 수 있습니다.

```tablefmt``` 옵션을 ```html``` 으로 주게 되면 다음과 같은 결과가 나옵니다.

```python
from tabulate import tabulate
table = [['col 1', 'col 2', 'col 3', 'col 4'], [1, 2222, 30, 500], [4, 55, 6777, 1]]
print(tabulate(table, headers='firstrow', tablefmt='html'))

# 결과
<table>
<thead>
<tr><th style="text-align: right;">  col 1</th><th style="text-align: right;">  col 2</th><th style="text-align: right;">  col 3</th><th style="text-align: right;">  col 4</th></tr>
</thead>
<tbody>
<tr><td style="text-align: right;">      1</td><td style="text-align: right;">   2222</td><td style="text-align: right;">     30</td><td style="text-align: right;">    500</td></tr>
<tr><td style="text-align: right;">      4</td><td style="text-align: right;">     55</td><td style="text-align: right;">   6777</td><td style="text-align: right;">      1</td></tr>
</tbody>
</table>
```

## prettytable

해당 라이브러리는 테이블 형태를 표현할 때 row 옵션이나 정렬을 각각 지정할 수 있으며
상세하게 옵션을 조정할 수 있습니다.

```python
from prettytable import PrettyTable
table = [['col 1', 'col 2', 'col 3', 'col 4'], [1, 2222, 30, 500], [4, 55, 6777, 1]]
tab = PrettyTable(table[0])
tab.add_rows(table[1:])

print(tab)

# 결과
+-------+-------+-------+-------+
| col 1 | col 2 | col 3 | col 4 |
+-------+-------+-------+-------+
|   1   |  2222 |   30  |  500  |
|   4   |   55  |  6777 |   1   |
+-------+-------+-------+-------+
```

위 결과에서 컬럼 하나를 추가해보겠습니다.

```python
from prettytable import PrettyTable
table = [['col 1', 'col 2', 'col 3', 'col 4'], [1, 2222, 30, 500], [4, 55, 6777, 1]]
tab = PrettyTable(table[0])
tab.add_rows(table[1:])
tab.add_column('col 5', [-123, 43], align='r', valign='t')
print(tab)

# 결과
+-------+-------+-------+-------+-------+
| col 1 | col 2 | col 3 | col 4 | col 5 |
+-------+-------+-------+-------+-------+
|   1   |  2222 |   30  |  500  |  -123 |
|   4   |   55  |  6777 |   1   |    43 |
+-------+-------+-------+-------+-------+
```

이런 식으로 컬럼의 추가 및 정렬 옵션 제공이 row 별로 가능하여 
원하는 형식을 쉽게 표현할 수 있습니다.

또한, 한 가지 장점으로 csv 파일을 읽어 표현할 수 있습니다.

```python
from prettytable import from_csv
with open('data_file.csv') as table_file:
    tab = from_csv(table_file)
```

이 외에도 데이터베이스 조회한 데이터를 가져오는 방법 등 다양한 방법이나 옵션을 제공합니다.
추가적인 정보를 원하시면 여기(https://pypi.org/project/prettytable/) 를 참고하세요.


<br/><br/><br/><br/><br/>






> 참고 : https://learnpython.com/blog/print-table-in-python/