---
title: POI Excel 현재 컬럼(열)에 셀 스타일 전체 적용하기
categories: [Backend, Java]
tags: [Java, POI, Excel, Style]
---

### 자바로 구성된 엑셀 시트에 셀 스타일 동일하게 적용하기

workbook을 사용한 엑셀 생성 코드 내에서 사용할 수 있습니다.

##### Source Code

```java
// cell style 정의
XSSFCellStyle wrapStyle = wb.createCellStyle();
wrapStyle.setWrapText(true);
wrapStyle.setQuotePrefixed(true);
XSSFFont font = wb.createFont();
font.setBold(true);
wrapStyle.setAlignment(HorizontalAlignment.LEFT);
XSSFDataFormat cellFormat = wb.createDataFormat();
wrapStyle.setDataFormat(cellFormat.getFormat("@"));
XSSFCell cell7 = row.createCell(7, CellType.FORMULA);
cell7.setCellStyle(wrapStyle);


// [해당 column 모든 열에 스타일 적용]
// setColDefaultStyle(columnIndex , style)
((XSSFSheet) sheet).getColumnHelper().setColDefaultStyle(7, wrapStyle);
```
