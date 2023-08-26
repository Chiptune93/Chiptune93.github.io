---
title: Python - Selenium Functions
categories: [Frontend, Python]
tags: [Selenium, Webdriver, Python, 파이썬]
---

## import
- 셀레니움 내 다양한 모듈/함수 등을 포함시키는 방법

```python
from selenium import webdriver

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
```

## Driver Load
- 웹 드라이버를 로드함으로써, 웹 사이트에 접근 가능하게 한다.
- 하기 예시는 크롬드라이버를 예로 사용하며 추가적인 옵션 또한 존재한다.

```python
## 크롬 드라이버 설정
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('headless') # 웹 페이지를 실제로 띄우지 않겠다.
chrome_options.add_argument('--disable-gpu') # GPU를 사용하지 않겠다.
chrome_options.add_argument('lang=ko_KR') # 언어 설정을 ko_KR로 사용하겠다.
chrome_options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36") # 웹 에이전트 지정

## Window
## driver = webdriver.Chrome('C:\chromedriver.exe', chrome_options=chrome_options)

## Mac
driver = webdriver.Chrome('/opt/homebrew/chromedriver', chrome_options=chrome_options)
```

- 현재 URL 가져오기

```python
now_url = driver.current_url
print(now_url)
```

- 드라이버 닫기

```
driver.close()
```

## Wait till Load Webpage(로딩 대기)
- 브라우저에서 요소를 로딩하는데 걸리는 시간이 있기 때문에, 요소가 전부 준비되기 까지 대기하는 과정

### Implict wait (암묵적 대기)
- 찾으려는 요소가 로드 될 때까지 지정된 시간을 대기한다. 드라이버에 전역 설정으로 저장되며 기본값은 0이다.

```python
## 10초 대기를 설정한다.
driver.implicitly_wait(time_to_wait=10)
```

### Explict wait (명시적 대기)
- 대기 하는 조건을 사용하여, 해당 조건이 완료될 때까지 대기 한 후 완료되면 실행되도록 한다.

```python
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

driver = webdriver.Chrome('/opt/homebrew/chromedriver', chrome_options=chrome_options)
driver.get("https://www.google.com")
try:
	element = WebDriverWait(driver, 10).until(
            # element_id 라는 아이디를 가진 요소가 로딩 될 때까지 10초간 기다린 후, 요소를 가져오는 것을 시도한다.
            EC.presence_of_element_located((By.ID, "element_id"))
	)
finally:
	driver.quit()
```


|함수|설명|
|----|---|
title_is|페이지의 title이 일치하면 True, 그렇지 않으면 False를 반환한다.
title_contains|페이지의 title에 대소문자를 구분하여 해당 문자열이 포함되어 있는지 확인한다. 포함되면 True, 그렇지 않으면 False를 반환한다.
presence_of_element_located|페이지의 DOM에 요소가 있는지 확인한다.
visibility_of_element_located|요소가 페이지의 DOM에 있고 볼 수 있는 상태인지 확인한다. 볼 수 있다는 상태는 요소가 표시될 뿐만 아니라 높이와 너비가 0보다 커야 한다.
visibility_of|페이지의 DOM에 있는 요소가 보이는지 확인한다.
presence_of_all_elements_located|페이지에 적어도 하나의 요소가 있는지 확인한다.
text_to_be_present_in_element|주어진 텍스트가 지정된 요소에 있는지 확인한다.
text_to_be_present_in_element_value|주어진 텍스트가 지정된 요소의 로케이터에 있는지 확인한다.
frame_to_be_available_and_switch_to_it|주어진 프레임을 전환할 수 있는지 확인한다.
invisibility_of_element_located|페이지의 DOM에 요소가 보이지 않거나 존재하지 않는지 확인한다. 
element_to_be_clickable|요소가 표시되고 클릭할 수 있는지 확인한다.
staleness_of|요소가 더이상 DOM에 연결되지 않을 때까지 기다린다. 요소가 DOM에 연결이 되어있으면 False를 반환하고, 그렇지 않으면 True를 반환한다.
element_to_be_selected|요소가 선택될 수 있는지 확인한다.
element_located_to_be_selected|요소가 선택될 수 있는 위치에 있는지 확인한다.
element_selection_state_to_be|지정된 요소가 선택되었는지 확인한다.
element_located_selection_state_to_be|요소를 찾고, 요소가 선택된 상태인지 확인한다.
alert_is_present|알림이 있는지 확인한다.


## 요소 찾기(XPATH)

### 요소 가져오는 방법

- 웹 크롤링 시, 혹은 웹에서 요소를 찾을 때 사용하는 방법 중 Xpath 라는 것이 있다.
- 요소를 다음과 같이 찾는 것 처럼 하나의 속성으로써 찾아올 수 있다.

```python
## 클래스로 요소 찾기
elem = driver.find_element(By.CLASS_NAME, "class")
## 아이디로 찾기
elem = driver.find_element(By.ID, "id")
## CSS에서 selector 지정하는 것 처럼 사용
elem = driver.find_element(By.CSS_SELECTOR, "p.content")
## 링크에서 지정한 URL 로 찾기
elem = driver.find_element(By.LINK_TEXT, "link_text")
## 태그 명으로 찾기
elem = driver.find_element(By.TAG_NAME, "tag_name")
...
```


### XPath 가져오기
- 이런 경로들을 구조만 보고도 알 수 있다면 바로 사용할 수 있겠지만 불행하게도 그렇게까지 복잡한 구조를 바로 인식할 만큼 우리는 똑똑하지 않아서 
아래와 같은 기능을 이용해 간단히 XPath를 가져올 수 있다.

- 크롬 > 개발자 도구 > 요소 선택
    - 가져 오고 싶은 요소를 선택한다.

![이미지1](/assets/img/Python/selenium/xpath1.png)

- 해당 요소를 우클릭 > 복사 > XPath 가져오기

![이미지2](/assets/img/Python/selenium/xpath2.png)

- 해당 기능을 이용하면 바로 XPath를 가져올 수 있다.

```python
elem = driver.find_element(By.XPATH, "/html/body/div[1]/div[3]/center/div/form[1]/div[1]/div/table/tbody/tr[2]/td[5]/input[1]")
```
- DOM Element 구조에 따르는 경로를 표시한 것이다 [3] 같은 것은 3번째 요소라는 뜻이다.

- 표현식

    |표현식|설명|
    |----|---|
    |nodename|nodename을 name으로 갖는 모든 요소 선택|
    |/|root 요소에서 선택|
    |//|현재 요소의 자손 요소를 선택|
    |.|현재 요소를 선택|
    |..|현재 요소의 부모 요소를 선택|
    |@|속성(attibutes)를 선택|
    |*|모든 요소에 매치됨|
    |@*|모든 속성 요소에 매치됨|
    |node()|모든 종류의 모든 요소에 매치됨|
    |\||OR 조건의 기능|

- 예시

    |표현식|설명|
    |----|---|
    /div|root 요소의 div 요소
    ./div|현재 요소의 자식 요소 중 div 요소
    /*|name에 상관없이 root 요소를 선택
    ./* 또는 *|context 요소의 모든 자식 요소를 선택
    //div|현재 웹페이지에서 모든 div 요소를 선택
    .//div|현재 요소의 모든 자손 div 요소를 선택
    //*|현재 웹페이지의 모든 요소를 선택
    .//*|현재 요소의 모든 자손 요소를 선택
    /div/p[0]|	root > div > p 요소 중 첫 번째 p 요소를 선택
    /div/p[position()<3]|	root > div > p 요소 중 첫 두 p 요소를 선택
    /div/p[last()]|	root > div > p 요소 중 마지막 p 요소를 선택
    /bookstore/book[price>35.00]|	root > bookstore > book 요소 중 price 속성이 35.00 초과인 요소들을 선택
    //*[@id="tsf"]/div[2]/|	id가 tsf인 모든 요소의 자식 div 요소 중 3번째 요소를 선택
    //title \| //price|	title 또는 price 요소를 선택


- Xpath에 대해 더 자세히 알고자 한다면 아래 링크를 참고하세요

    [참고 링크](https://www.w3schools.com/xml/xpath_syntax.asp)

## 키보드 입력

### 키보드 값 전달 

- 어떤 요소를 선택 후, 키 값을 보낼 수 있다.

```python
## 선택한 요소에 'test' 라는 값을 보냄
elem = driver.find_element(By.ID, "id")
elem.send_keys('test')
```

- 가능한 시스템 키 입력 값

```python
class Keys(object):
    """
    Set of special keys codes.
    """

    NULL = '\ue000'
    CANCEL = '\ue001'  # ^break
    HELP = '\ue002'
    BACKSPACE = '\ue003'
    BACK_SPACE = BACKSPACE
    TAB = '\ue004'
    CLEAR = '\ue005'
    RETURN = '\ue006'
    ENTER = '\ue007'
    SHIFT = '\ue008'
    LEFT_SHIFT = SHIFT
    CONTROL = '\ue009'
    LEFT_CONTROL = CONTROL
    ALT = '\ue00a'
    LEFT_ALT = ALT
    PAUSE = '\ue00b'
    ESCAPE = '\ue00c'
    SPACE = '\ue00d'
    PAGE_UP = '\ue00e'
    PAGE_DOWN = '\ue00f'
    END = '\ue010'
    HOME = '\ue011'
    LEFT = '\ue012'
    ARROW_LEFT = LEFT
    UP = '\ue013'
    ARROW_UP = UP
    RIGHT = '\ue014'
    ARROW_RIGHT = RIGHT
    DOWN = '\ue015'
    ARROW_DOWN = DOWN
    INSERT = '\ue016'
    DELETE = '\ue017'
    SEMICOLON = '\ue018'
    EQUALS = '\ue019'

    NUMPAD0 = '\ue01a'  # number pad keys
    NUMPAD1 = '\ue01b'
    NUMPAD2 = '\ue01c'
    NUMPAD3 = '\ue01d'
    NUMPAD4 = '\ue01e'
    NUMPAD5 = '\ue01f'
    NUMPAD6 = '\ue020'
    NUMPAD7 = '\ue021'
    NUMPAD8 = '\ue022'
    NUMPAD9 = '\ue023'
    MULTIPLY = '\ue024'
    ADD = '\ue025'
    SEPARATOR = '\ue026'
    SUBTRACT = '\ue027'
    DECIMAL = '\ue028'
    DIVIDE = '\ue029'

    F1 = '\ue031'  # function  keys
    F2 = '\ue032'
    F3 = '\ue033'
    F4 = '\ue034'
    F5 = '\ue035'
    F6 = '\ue036'
    F7 = '\ue037'
    F8 = '\ue038'
    F9 = '\ue039'
    F10 = '\ue03a'
    F11 = '\ue03b'
    F12 = '\ue03c'

    META = '\ue03d'
    COMMAND = '\ue03d'
```

### 입력 값 클리어하기
- 입력된 값을 초기화 한다.

```python
elem.clear()
```

### 파일 업로드
- 파일을 업로드한다.
- 파일 업로드 요소(input)를 선택 후, 경로로 지정된 파일을 전송한다.

```python
elem = driver.find_element(By.tag_name,'input')
elem.send_keys(file_path)
```

## 상호작용 하기

### 클릭하기
- 클릭 함수를 사용하여 요소를 클릭한다.

```python
elem = driver.find_element(By.ID,"login_btn")
elem.click()
```

### 옵션 선택 및 Submit

- Select 함수를 import 하여 간단히 사용가능하다.

```python
from selenium.webdriver.support.ui import Select
## 셀렉트 요소 선택
select = Select(driver.find_element(By.NAME,'select_elem_name'))

## 인덱스 번호로 선택
select.select_by_index(index=1)
## 옵션명으로 선택
select.select_by_visible_text(text="option_text")
## 값 내용으로 선택
select.select_by_value(value='1')

## 인덱스 번호로 선택 해제
select.deselect_by_index(index=1)
## 옵션명으로 선택 해제
select.deselect_by_visible_text(text="option_text")
## 값 내용으로 선택 해제
select.deselect_by_value(value='1')

## 전부 해제
select.deselect_all()

## 선택된 옵션 전체 리스트 얻기
select.all_selected_options
## 첫번째 선택된 옵션 가져오기
select.first_selected_option
## 가능한 옵션 모두 보기
select.options
```

- 제출(submit)하려면 요소를 찾은 뒤 click()을 수행해도 되지만, 다음과 같이 써도 된다.
```python
elem.find_element(By.TAG_NAME, "form")
elem.submit()
```

### 드래그 앤 드랍
- ActionChains을 사용하여 source 요소에서 target 요소로 Drag & Drop을 실행한다.

```python
from selenium.webdriver import ActionChains

action_chains = ActionChains(driver)
action_chains.drag_and_drop(source, target).perform()
```

### Window, Frame 이동
- 쉽게 말해 어떤 창 또는 프레임으로 포커싱을 옮긴다고 생각하면 된다.

```python
driver.switch_to_frame('frame')
driver.switch_to_window('window')

## frame 내 서브 프레임으로도 이동 가능하다.
driver.switch_to_frame('frame.0.child')
```

- window name을 통해 이동하는 것은 아래와 같다.
    - 여기서, target 속성의 이름을 기재하여 사용한다. 
```html
<a href="https://google.com" target="window">...</a>
``` 

- 열려있는 브라우저들을 반복하여 포커싱 할 수도 있다.

```python
for handle in driver.window_handles:
    driver.switch_to_window(handle)
```

- frame 밖으로 나가려면 다음과 같이 쓰면 기본 frame으로 되돌아간다.

```python
driver.switch_to_default_content()
```

- 경고창으로 이동할 수도 있다.

```python
alert = driver.switch_to.alert
```

### JavaScript 실행
- driver.execute_script() 함수를 실행할 수 있다.

```python
text = "test value"
driver.execute_script("document.getElementsByName('id')[0].value=\'"+text+"\'")
```

### 브라우저 창 다루기
- 뒤로가기, 앞으로 가기
- 브라우저는 뒤로가기(back)와 앞으로 가기(forward) 기능을 제공한다. 이를 selenium으로 구현이 가능하다.

```python
driver.forward()
driver.back()
```

### 화면 이동(맨 밑으로 내려가기 등)

- 크롤링을 하다 보면 화면의 끝으로 내려가야 내용이 동적으로 추가되는 경우를 자주 볼 수 있다.
- 이런 경우에는 웹페이지의 최하단으로 내려가는 코드를 실행할 필요가 있다.

```python
driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
```

- 물론 전체를 내려가야 할 필요가 없다면 document.body.scrollHeight) 대신 지정된 값만큼 이동해도 된다.

- 특정 요소까지 계속 찾으려면 ActionChain을 써도 된다.

```python
from selenium.webdriver import ActionChains

elem = driver.find_element(By.ID, 'ID')
ActionChains(driver).move_to_element(elem).perform()
```

### 브라우저 최소화/최대화

```python
driver.minimize_window()
driver.maximize_window()
```
### 스크린샷 저장

```python
driver.save_screenshot('screen_shot.png')
```

### Option(ChromeOption)
- 여러 옵션을 설정할 수 있다. 브라우저의 창 크기, 해당 기기의 정보 등을 설정할 수 있다.
- 기본적인 사용법은 다음과 같다. 브라우저가 실행될 때 창 크기를 설정할 수 있다.

```python
options = webdriver.ChromeOptions()
options.add_argument('window-size=1920,1080')

driver = webdriver.Chrome('chromedriver', options=options)
다른 기능들은 여기에 적어 두었다. 코드를 보면 역할을 짐작할 수 있을 것이다.

options.add_argument('headless')
options.add_argument('window-size=1920x1080')
options.add_argument('disable-gpu')

options.add_argument('start-maximized')
options.add_argument('disable-infobars')
options.add_argument('--disable-extensions')

options.add_experimental_option('excludeSwitches', ['enable-automation'])
options.add_experimental_option('useAutomationExtension', False)
options.add_argument('--disable-blink-features=AutomationControlled')

options.add_experimental_option('debuggerAddress', '127.0.0.1:9222')
```

### ActionChains (마우스, 키보드 입력 등 연속 동작 실행)

```python
from selenium.webdriver import ActionChains

menu = driver.find_element_by_css_selector('.nav')
hidden_submenu = driver.find_element_by_css_selector('.nav #submenu1')

ActionChains(driver).move_to_element(menu).click(hidden_submenu).perform()

## 위 한 줄은 아래와 같은 동작을 수행한다.
actions = ActionChains(driver)
actions.move_to_element(menu)
actions.click(hidden_submenu)
actions.perform()
```
- 마우스 클릭, Drag & Drop, 키보드 입력 등을 연속적으로 수행할 수 있다.
    - on_element 인자를 받는 함수는, 해당 인자가 주어지지 않으면 현재 마우스 위치를 기준으로 한다.
    - element 인자를 받는 함수는, 해당 인자가 주어지지 않으면 현재 선택이 되어 있는 요소를 기준으로 한다.
    - key_down, key_up 함수는 Ctrl 등의 키를 누를 때 쓰면 된다.

```python
## Ctrl + C를 누른다.
ActionChains(driver).key_down(Keys.CONTROL).send_keys('c').key_up(Keys.CONTROL).perform()
```


|함수|설명|
|---|---|
click(on_element=None)|	인자로 주어진 요소를 왼쪽 클릭한다.
click_and_hold(on_element=None)	|인자로 주어진 요소를 왼쪽 클릭하고 누르고 있는다.
release(on_element=None)	|마우스를 주어진 요소에서 뗀다.
context_click(on_element=None)|	인자로 주어진 요소를 오른쪽 클릭한다.
double_click(on_element=None)	|인자로 주어진 요소를 왼쪽 더블클릭한다.
drag_and_drop(source, target)	|source 요소에서 마우스 왼쪽 클릭하여 계속 누른 채로 target까지 이동한 뒤 마우스를 놓는다.
drag_and_drop_by_offset(source, xoffset, yoffset)|	위와 비슷하지만 offset만큼 이동하여 마우스를 놓는다.
key_down(value, element=None)|	value로 주어진 키를 누르고 떼지 않는다.
key_up(value, element=None)|	value로 주어진 키를 뗀다.
move_to_element(to_element)	|마우스를 해당 요소의 중간 위치로 이동한다.
move_to_element_with_offset(to_element, xoffset, yoffset)	|마우스를 해당 요소에서 offset만큼 이동한 위치로 이동한다.
pause(seconds)	|주어진 시간(초 단위)만큼 입력을 중지한다.
perform()	|이미 쌓여 있는(stored) 모든 행동을 수행한다(chaining).
reset_actions()|	이미 쌓여 있는(stored) 모든 행동을 제거한다.
send_keys(*keys_to_send)	|키보드 입력을 현재 focused된 요소에 보낸다.
send_keys_to_element(element, *keys_to_send)	|보드 입력을 주어진 요소에 보낸다.


### 경고 창 다루기(alerts)
- 브라우저 얼럿 경고창을 무시하는 등의 처리를 할 수 있는 기능을 제공한다.
- 아래 코드는 경고창에서 수락/거절을 누르거나, 경고창의 내용을 출력, 혹은 경고창에 특정 키 입력을 보낼 수 있다.

```python
from selenium.webdriver.common.alert import Alert

Alert(driver).accept()
Alert(driver).dismiss()

print(Alert(driver).text)
Alert(driver).send_keys(keysToSend=Keys.ESCAPE)
```

### 기타 기능
- Touch Actions: 마우스/키보드 입력과 비슷하게 chaining이 가능하다. 터치와 관련한 여러 기능을 제공한다. selenium.webdriver.common.touch_actions.TouchActions
- Proxy: Proxy 기능을 사용할 수 있다. selenium.webdriver.common.proxy.Proxy
- 쿠키(Cookies): 쿠키를 추가하거나 가져올 수 있다.

```python
## Go to the correct domain
driver.get('http://www.example.com')

## Now set the cookie. This one's valid for the entire domain
cookie = {‘name’ : ‘foo’, ‘value’ : ‘bar’}
driver.add_cookie(cookie)

## And now output all the available cookies for the current URL
driver.get_cookies()
```

참고
- [https://selenium-python.readthedocs.io/index.html](https://selenium-python.readthedocs.io/index.html)
