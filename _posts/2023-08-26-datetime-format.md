---
title: 다양한 DateTime Format
categories: [Backend, Java]
tags: [date, time, datetime, format, formatter]
---



# 자바에서의 다양한 날짜 및 시간 형식

자바에서 날짜와 시간을 다룰 때, `java.time` 패키지와 `DateTimeFormatter` 클래스를 사용하여 다양한 형식의 날짜 및 시간 문자열을 파싱하고 포맷할 수 있습니다.

## 1. 날짜(Year, Month, Day)

- `y`: 연도를 나타냅니다.
  - 예: `yyyy` - 4자리 연도, `yy` - 뒤 2자리 연도

- `M`: 월을 나타냅니다.
  - 예: `MM` - 2자리 숫자로 월, `MMM` - 월의 약어(영어로), `MMMM` - 월의 전체 이름(영어로)

- `d`: 일을 나타냅니다.
  - 예: `dd` - 2자리 숫자로 일

## 2. 시간(Hour, Minute, Second)

- `H`: 0에서 23까지의 시간을 나타냅니다.
- `h`: 1에서 12까지의 시간(AM/PM 표기법과 함께 사용).
  - 예: `HH` - 2자리 숫자로 24시간 형식, `hh` - 2자리 숫자로 12시간 형식

- `m`: 분을 나타냅니다.
  - 예: `mm` - 2자리 숫자로 분

- `s`: 초를 나타냅니다.
  - 예: `ss` - 2자리 숫자로 초

## 3. 기타

- `S`: 밀리초를 나타냅니다.
  - 예: `SSS` - 3자리 숫자로 밀리초

- `a`: 오전(AM) 또는 오후(PM)를 나타냅니다.

- `E`: 요일을 나타냅니다.

- `z`: 시간대를 나타냅니다.
- `Z`: UTC 오프셋을 나타냅니다.

## 예제 코드

```java
import java.time.*;
import java.time.format.DateTimeFormatter;

public class DateTimeFormatExample {
    public static void main(String[] args) {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter customFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDateTime = now.format(customFormatter);
        System.out.println("Formatted DateTime: " + formattedDateTime);

        String dateTimeString = "2023-08-26 14:30:00";
        LocalDateTime parsedDateTime = LocalDateTime.parse(dateTimeString, customFormatter);
        System.out.println("Parsed DateTime: " + parsedDateTime);
    }
}
```

이 예제에서는 "yyyy-MM-dd HH:mm:ss" 형식을 사용하여 날짜와 시간을 문자열로 포맷하고 파싱합니다. 패턴 문자열을 조정하여 원하는 형식으로 날짜 및 시간을 다룰 수 있습니다.

자바에서는 `DateTimeFormatter`를 사용하여 날짜 및 시간을 다루는 많은 기능을 제공하므로 프로젝트에 맞게 형식을 사용자 정의할 수 있습니다.


# [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601)

날짜와 시간은 컴퓨터 시스템과 통신 시스템에서 핵심 데이터 유형 중 하나입니다. 그러나 날짜와 시간 형식은 국가 및 시스템마다 다를 수 있으며, 이로 인해 혼란이 발생할 수 있습니다. 이러한 혼란을 해결하기 위해 국제 표준화 기구(ISO)는 ISO 8601을 개발했습니다.

## ISO 8601이란?
ISO 8601은 날짜와 시간을 표현하는 국제 표준입니다. 이 표준은 다음과 같은 주요 특징을 가지고 있습니다:

1. 날짜 표현
   ISO 8601은 날짜를 "YYYY-MM-DD" 형식으로 나타냅니다. 이 형식은 해, 월, 일을 연속적인 숫자로 표현하므로 혼란을 방지합니다.

예: 2023년 8월 26일은 "2023-08-26"로 표현됩니다.

2. 시간 표현
   시간은 "HH:MM:SS" 형식으로 나타냅니다. 이 형식은 시, 분, 초를 나타내며, 24시간 형식을 사용합니다.

예: 오후 2시 30분 15초는 "14:30:15"로 표현됩니다.

3. 날짜 및 시간 표현
   날짜와 시간을 조합하여 "YYYY-MM-DDTHH:MM:SS" 형식으로 나타낼 수 있습니다. 이 형식은 날짜와 시간을 함께 나타내며, 데이터 표현의 일관성을 제공합니다.

예: 2023년 8월 26일 오후 2시 30분 15초는 "2023-08-26T14:30:15"로 표현됩니다.

4. 시간대 표현
   ISO 8601은 시간대 정보를 추가하여 "YYYY-MM-DDTHH:MM:SS±hh:mm" 형식으로 나타낼 수 있습니다. 이렇게하면 UTC와의 시간 차이를 명시적으로 표시할 수 있습니다.

예: 2023년 8월 26일 오후 2시 30분 15초를 독일 시간대로 나타내면 "2023-08-26T14:30:15+02:00"입니다.

## 자바에서의 ISO 8601
자바에서는 java.time.format.DateTimeFormatter 클래스를 사용하여 ISO 8601 형식을 다룰 수 있습니다. "yyyy-MM-dd'T'HH:mm:ssXXX"와 같은 패턴으로 날짜 및 시간을 포맷하고 파싱할 수 있습니다. 이를 통해 다양한 시스템 간에 데이터 교환을 보다 쉽게 수행할 수 있습니다.


# 표현 가능한 종류의 포맷들

1. `yyyy-MM-dd`: 1969년 12월 31일
2. `yyyy-MM-dd`: 1970년 01월 01일
3. `yyyy-MM-dd HH:mm`: 1969년 12월 31일 16:00
4. `yyyy-MM-dd HH:mm`: 1970년 01월 01일 00:00
5. `yyyy-MM-dd HH:mmZ`: 1969년 12월 31일 16:00 -0800
6. `yyyy-MM-dd HH:mmZ`: 1970년 01월 01일 00:00 +0000
7. `yyyy-MM-dd HH:mm:ss.SSSZ`: 1969년 12월 31일 16:00:00.000 -0800
8. `yyyy-MM-dd HH:mm:ss.SSSZ`: 1970년 01월 01일 00:00:00.000 +0000
9. `yyyy-MM-dd'T'HH:mm:ss.SSSZ`: 1969년 12월 31일 16:00:00.000 -0800
10. `yyyy-MM-dd'T'HH:mm:ss.SSSZ`: 1970년 01월 01일 00:00:00.000 +0000


