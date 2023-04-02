---

title: Notion API - Query Database (Simple)
description: >
  Notion 데이터베이스를 웹 요청을 통해 가져와 사용할 수 있는 방법에 대해 알아본다.


categories: [Etc]
tags: [Notion, Notion API]
---



# Notion Database 생성

1. 디스코드 페이지에서 데이터베이스를 만들기
![이미지](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%201.56.04.png)

2. 데이터베이스를 만든 후, 데이터를 채워 넣기
![이미지2](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%201.57.07.png)

3. 데이터베이스 제목 옆 '...' 를 클릭하여, '데이터베이스 보기' 를 클릭하여 상세로 들어간다.
![이미지3](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%201.57.25.png)

4. 주소 표시창의 URL 데이터를 복사하여 가지고 있는다. (추후, 데이터베이스를 가져올 때 사용 됨)
![이미지4](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%201.57.33.png)

# Notion Integrations 생성

1. https://www.notion.so/my-integrations 로 접속하여 인테그레이션을 조회한다.
![이미지5](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%202.03.36.png)

2. '새 API 통합 생성' 을 통해 새 인테그레이션을 생성한다.
![이미지6](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%202.04.43.png)

3. 인테그레이션 이름을 입력하고, 권한 체크 (처음엔 기본으로 사용해도 됨) 후, 제출을 클릭하여 저장한다.
![이미지7](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%202.04.53.png)

4. API 키를 '표시' 버튼을 누르면 값이 나오는데 해당 값을 저장하여 가지고 있는다. (조회 시, 키 값 사용을 위함)
![이미지8](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%202.05.20.png)

# Integration 과 Database를 연결

1. 데이터베이스 상세보기 화면에서 우측 상단의 더보기를 클릭하여 '연결 추가' 를 클릭해
방금 생성한 인테그레이션을 조회 후, 클릭한다.
![이미지9](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%202.10.04.png)

2. 클릭하면 해당 인테그레이션이 해당 데이터베이스에 권한을 갖는다는 알림이 뜨는데, 확인을 클릭해준다.
![이미지10](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%202.10.29.png)

3. 다시 연결을 조회하면 해당 페이지에 인테그레이션이 어떤 권한을 가지고 있는지 나온다.
해당 작업을 통해 인테그레이션이 데이터베이스에 접근 권한을 가짐으로써, 인테그레이션 API 키를 통해 해당 데이터베이스에 액세스 하고 자료를 조회할 수 있게 된다.
![이미지11](/assets/img/Etc/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202023-01-23%20%EC%98%A4%EC%A0%84%202.10.40.png)

# request 를 통해 데이터 베이스의 데이터를 가져오기

해당 데이터베이스의 데이터를 가져오는 샘플 코드는 파이썬을 통해 가져오는 방법을 사용한다.
샘플 코드는 아래와 같다.

토큰 값은 인테그레이션 토큰 값을 사용하며,
데이터베이스 아이디는 데이터베이스 상세보기 화면에서 주소를 보면
'https://www.notion.so/fc459867984576dsjfkhsfdjbf?v=43sdgkjhgs90gds' 와 같은 형식으로 되어있는데
이 중, ? 앞에 부분을 사용한다.

```python
import requests

# Intergration API Token
t = '{아까 위에서 저장한 인테그레이션 토큰 값}'
# Database query base url
b = "https://api.notion.com/v1/databases/"
# Database id
d = "{데이터베이스 아이디}"
# header
header = {"Authorization": t, "Notion-Version": "2022-06-28"}
# query 조건문
query = {"filter": ""}

# request 라이브러리로 요청.
response = requests.post(b + d + "/query", headers=header, data=query)
print(response.json()["results"])
# 결과 조회 및 파싱
dataLen = len(response.json()["results"])
data = []

for q in response.json()["results"]:
    row = []
    row.append(q["properties"]["이름"]["title"][0]["text"]["content"])
    row.append(q["properties"]["태그"]["multi_select"][0]["name"])
    row.append(q["properties"]["텍스트"]["rich_text"][0]["text"]["content"])
    data.append(row)

print("데이터 가져온 결과 -> ", data)
# 데이터 가져온 결과 ->  [['테스트3', '태그', '테스트 용 데이터3'], ['테스트2', '태그', '테스트 용 데이터2'], ['테스트1', '태그', '테스트 용 데이터1']]
```

# 가져온 데이터를 파싱하여 원하는 항목을 가져오기

테스트로 만든 데이터를 조회하였을 때 아래와 같은 구조를 띈다.
물론 어떻게 만들었냐에 따라서 형식은 달라진다.

```
[{'object': 'page', 'id': '{id}', 'created_time': '2023-01-22T16:56:00.000Z', 'last_edited_time': '2023-01-22T16:57:00.000Z', 'created_by': {'object': 'user', 'id': '{id}'}, 'last_edited_by': {'object': 'user', 'id': '{id}'}, 'cover': None, 'icon': None, 'parent': {'type': 'database_id', 'database_id': 'fc802683-53ac-4b4e-81eb-47bb2274bc44'}, 'archived': False, 'properties': {'텍스트': {'id': 'ZECN', 'type': 'rich_text', 'rich_text': [{'type': 'text', 'text': {'content': '테스트 용 데이터3', 'link': None}, 'annotations': {'bold': False, 'italic': False, 'strikethrough': False, 'underline': False, 'code': False, 'color': 'default'}, 'plain_text': '테스트 용 데이터3', 'href': None}]}, '태그': {'id': '%7DTmn', 'type': 'multi_select', 'multi_select': [{'id': '5d58a393-d5c5-45bc-bbe9-47ed110b0338', 'name': '태그', 'color': 'blue'}]}, '이름': {'id': 'title', 'type': 'title', 'title': [{'type': 'text', 'text': {'content': '테스트3', 'link': None}, 'annotations': {'bold': False, 'italic': False, 'strikethrough': False, 'underline': False, 'code': False, 'color': 'default'}, 'plain_text': '테스트3', 'href': None}]}}, 'url': '{url}'}, {'object': 'page', 'id': 'dc932cd6-1e71-4fad-8800-fde6d5bd964e', 'created_time': '2023-01-22T16:56:00.000Z', 'last_edited_time': '2023-01-22T16:57:00.000Z', 'created_by': {'object': 'user', 'id': '{id}'}, 'last_edited_by': {'object': 'user', 'id': '{id}'}, 'cover': None, 'icon': None, 'parent': {'type': 'database_id', 'database_id': 'fc802683-53ac-4b4e-81eb-47bb2274bc44'}, 'archived': False, 'properties': {'텍스트': {'id': 'ZECN', 'type': 'rich_text', 'rich_text': [{'type': 'text', 'text': {'content': '테스트 용 데이터2', 'link': None}, 'annotations': {'bold': False, 'italic': False, 'strikethrough': False, 'underline': False, 'code': False, 'color': 'default'}, 'plain_text': '테스트 용 데이터2', 'href': None}]}, '태그': {'id': '%7DTmn', 'type': 'multi_select', 'multi_select': [{'id': '5d58a393-d5c5-45bc-bbe9-47ed110b0338', 'name': '태그', 'color': 'blue'}]}, '이름': {'id': 'title', 'type': 'title', 'title': [{'type': 'text', 'text': {'content': '테스트2', 'link': None}, 'annotations': {'bold': False, 'italic': False, 'strikethrough': False, 'underline': False, 'code': False, 'color': 'default'}, 'plain_text': '테스트2', 'href': None}]}}, 'url': ''}, {'object': 'page', 'id': 'e587d0fa-ecdb-4101-b523-cc4aa631cac1', 'created_time': '2023-01-22T16:56:00.000Z', 'last_edited_time': '2023-01-22T16:56:00.000Z', 'created_by': {'object': 'user', 'id': '{id}'}, 'last_edited_by': {'object': 'user', 'id': '{id}'}, 'cover': None, 'icon': None, 'parent': {'type': 'database_id', 'database_id': 'fc802683-53ac-4b4e-81eb-47bb2274bc44'}, 'archived': False, 'properties': {'텍스트': {'id': 'ZECN', 'type': 'rich_text', 'rich_text': [{'type': 'text', 'text': {'content': '테스트 용 데이터1', 'link': None}, 'annotations': {'bold': False, 'italic': False, 'strikethrough': False, 'underline': False, 'code': False, 'color': 'default'}, 'plain_text': '테스트 용 데이터1', 'href': None}]}, '태그': {'id': '%7DTmn', 'type': 'multi_select', 'multi_select': [{'id': '5d58a393-d5c5-45bc-bbe9-47ed110b0338', 'name': '태그', 'color': 'blue'}]}, '이름': {'id': 'title', 'type': 'title', 'title': [{'type': 'text', 'text': {'content': '테스트1', 'link': None}, 'annotations': {'bold': False, 'italic': False, 'strikethrough': False, 'underline': False, 'code': False, 'color': 'default'}, 'plain_text': '테스트1', 'href': None}]}}, 'url': ''}]
```

좀 복잡하긴 하지만, 데이터베이스 row를 가져온 것이다. 여기서 만약 첫번째 row의 데이터의 '이름' 항목을 가져오고 싶다면 json 파싱을 통해 규격을 맞춘 후, 찾아가서 가져오면 된다.

위 데이터를 Json Validator(https://jsonformatter.curiousconcept.com/#) 에서 조회하면 아래와 같이 형태가 잡힌다.

```json
[
   {
      "object":"page",
      "id":"2dd1e30c-1c3c-4cc3-b00d-157fcc4bd10f",
      "created_time":"2023-01-22T16:56:00.000Z",
      "last_edited_time":"2023-01-22T16:57:00.000Z",
      "created_by":{
         "object":"user",
         "id":"e6bf5ee1-fa3f-4e6f-be2a-fa03f302fc19"
      },
      "last_edited_by":{
         "object":"user",
         "id":"e6bf5ee1-fa3f-4e6f-be2a-fa03f302fc19"
      },
      "cover":"None",
      "icon":"None",
      "parent":{
         "type":"database_id",
         "database_id":"fc802683-53ac-4b4e-81eb-47bb2274bc44"
      },
      "archived":false,
      "properties":{
         "텍스트":{
            "id":"ZECN",
            "type":"rich_text",
            "rich_text":[
               {
                  "type":"text",
                  "text":{
                     "content":"테스트 용 데이터3",
                     "link":"None"
                  },
                  "annotations":{
                     "bold":false,
                     "italic":false,
                     "strikethrough":false,
                     "underline":false,
                     "code":false,
                     "color":"default"
                  },
                  "plain_text":"테스트 용 데이터3",
                  "href":"None"
               }
            ]
         },
         "태그":{
            "id":"%7DTmn",
            "type":"multi_select",
            "multi_select":[
               {
                  "id":"5d58a393-d5c5-45bc-bbe9-47ed110b0338",
                  "name":"태그",
                  "color":"blue"
               }
            ]
         },
         "이름":{
            "id":"title",
            "type":"title",
            "title":[
               {
                  "type":"text",
                  "text":{
                     "content":"테스트3",
                     "link":"None"
                  },
                  "annotations":{
                     "bold":false,
                     "italic":false,
                     "strikethrough":false,
                     "underline":false,
                     "code":false,
                     "color":"default"
                  },
                  "plain_text":"테스트3",
                  "href":"None"
               }
            ]
         }
      },
      "url":"https://www.notion.so/3-2dd1e30c1c3c4cc3b00d157fcc4bd10f"
   },
   {
      "object":"page",
      "id":"dc932cd6-1e71-4fad-8800-fde6d5bd964e",
      "created_time":"2023-01-22T16:56:00.000Z",
      "last_edited_time":"2023-01-22T16:57:00.000Z",
      "created_by":{
         "object":"user",
         "id":"e6bf5ee1-fa3f-4e6f-be2a-fa03f302fc19"
      },
      "last_edited_by":{
         "object":"user",
         "id":"e6bf5ee1-fa3f-4e6f-be2a-fa03f302fc19"
      },
      "cover":"None",
      "icon":"None",
      "parent":{
         "type":"database_id",
         "database_id":"fc802683-53ac-4b4e-81eb-47bb2274bc44"
      },
      "archived":false,
      "properties":{
         "텍스트":{
            "id":"ZECN",
            "type":"rich_text",
            "rich_text":[
               {
                  "type":"text",
                  "text":{
                     "content":"테스트 용 데이터2",
                     "link":"None"
                  },
                  "annotations":{
                     "bold":false,
                     "italic":false,
                     "strikethrough":false,
                     "underline":false,
                     "code":false,
                     "color":"default"
                  },
                  "plain_text":"테스트 용 데이터2",
                  "href":"None"
               }
            ]
         },
         "태그":{
            "id":"%7DTmn",
            "type":"multi_select",
            "multi_select":[
               {
                  "id":"5d58a393-d5c5-45bc-bbe9-47ed110b0338",
                  "name":"태그",
                  "color":"blue"
               }
            ]
         },
         "이름":{
            "id":"title",
            "type":"title",
            "title":[
               {
                  "type":"text",
                  "text":{
                     "content":"테스트2",
                     "link":"None"
                  },
                  "annotations":{
                     "bold":false,
                     "italic":false,
                     "strikethrough":false,
                     "underline":false,
                     "code":false,
                     "color":"default"
                  },
                  "plain_text":"테스트2",
                  "href":"None"
               }
            ]
         }
      },
      "url":"https://www.notion.so/2-dc932cd61e714fad8800fde6d5bd964e"
   },
   {
      "object":"page",
      "id":"e587d0fa-ecdb-4101-b523-cc4aa631cac1",
      "created_time":"2023-01-22T16:56:00.000Z",
      "last_edited_time":"2023-01-22T16:56:00.000Z",
      "created_by":{
         "object":"user",
         "id":"e6bf5ee1-fa3f-4e6f-be2a-fa03f302fc19"
      },
      "last_edited_by":{
         "object":"user",
         "id":"e6bf5ee1-fa3f-4e6f-be2a-fa03f302fc19"
      },
      "cover":"None",
      "icon":"None",
      "parent":{
         "type":"database_id",
         "database_id":"fc802683-53ac-4b4e-81eb-47bb2274bc44"
      },
      "archived":false,
      "properties":{
         "텍스트":{
            "id":"ZECN",
            "type":"rich_text",
            "rich_text":[
               {
                  "type":"text",
                  "text":{
                     "content":"테스트 용 데이터1",
                     "link":"None"
                  },
                  "annotations":{
                     "bold":false,
                     "italic":false,
                     "strikethrough":false,
                     "underline":false,
                     "code":false,
                     "color":"default"
                  },
                  "plain_text":"테스트 용 데이터1",
                  "href":"None"
               }
            ]
         },
         "태그":{
            "id":"%7DTmn",
            "type":"multi_select",
            "multi_select":[
               {
                  "id":"5d58a393-d5c5-45bc-bbe9-47ed110b0338",
                  "name":"태그",
                  "color":"blue"
               }
            ]
         },
         "이름":{
            "id":"title",
            "type":"title",
            "title":[
               {
                  "type":"text",
                  "text":{
                     "content":"테스트1",
                     "link":"None"
                  },
                  "annotations":{
                     "bold":false,
                     "italic":false,
                     "strikethrough":false,
                     "underline":false,
                     "code":false,
                     "color":"default"
                  },
                  "plain_text":"테스트1",
                  "href":"None"
               }
            ]
         }
      },
      "url":"https://www.notion.so/1-e587d0faecdb4101b523cc4aa631cac1"
   }
]
```

그럼 이제, 해당 규격을 보고 원하는 데이터를 아래와 같이 뽑아서 사용하면 된다.

```python
response.json()["results"]["properties"]["텍스트"]["rich_text"][0]["text"]["content"]
```


참고할만한 페이지

- Notion API Reference
(https://developers.notion.com/reference/intro)

