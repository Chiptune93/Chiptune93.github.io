---
layout: post
title: ToastUI Editor - 이미지 복사 붙여 넣기 시, 파일 업로드 및 UI처리
description: >
  [ToastUI Editor] 이미지 복사 붙여 넣기 시, 파일 업로드 및 UI처리

hide_last_modified: true
categories: [Frontend]
tags: [paste event handler, toastui editor, image paste]
---

- Table of Contents
{:toc .large-only}

기존에 진행 했던 프로젝트에서는 글 작성 시, Toast UI Editor 를 사용하고 있었다.

따로 파일 업로드 기능은 없었는데, 에디터에서 글 작성 시 에디터 자체 지원으로 이미지를 붙여넣기 하면 blob 데이터를 렌더링 해서 이미지를 그대로 가져올 수 있게 되어있었다.

해당 이미지는 blob 데이터로 그대로 DB에 저장되기 때문에, 이미지를 많이 사용하여 글을 작성하는 경우 데이터의 크기가 어마어마 해진다. 물론 커져봤자 감당이 안될 수준은 아니지만 문제는 해당 데이터를 read 하여 화면 단으로 데이터를 가져오는 경우에 데이터가 너무 커서 로딩이 길어진다는 단점이 존재했다.

따라서, 복사 붙여넣기로 이미지를 가져오는 부분은 유지하되, 파일을 업로드하여 URL을 BLOB데이터가 아닌 download링크로 변경하여 업로드된 파일을 가져오는 기능으로 대체하고자 했다.

1차로 paste 이벤트를 감지하여 파일을 업로드 하는 스크립트를 작성했다.

```js
document.querySelector("#editor").addEventListener("paste", (e) => {
  var items = (e.clipboardData || e.originalEvent.clipboardData).items;
  for (let i of items) {
    var item = i;
    if (item.type.indexOf("image") != -1) {
      var file = item.getAsFile();
      console.log(file);
      //uploadFile(file);
    }
  }
});

function uploadFile(file) {
  var formData = new FormData();
  formData.append("file", file);
  var vm = this;
  comm.post(
    {
      url: "/file/upload.do",
      processData: false,
      contentType: false,
      headers: {
        "Content-Type": "multipart/form-data",
      },
      params: formData,
    },
    function (data) {
      if (data.resultMsg == "FAIL") {
        return false;
      } else {
        console.log(data);
      }
    }
  );
}
```

해당 스크립트로 원하는 기능을 구현하려고 했지만, 실패했다.

이유는 해당 이벤트가 발생시, 아무리 이벤트 중지를 걸어도 붙여넣기가 실행되었다.

원래 계획은 붙여넣기 이벤트 발생 -> 이벤트 중지 -> 파일업로드 후 -> 새로 만든 URL 리턴 이었는데 아무래도 에디터 내에서 캡쳐하여 제공하는 기능이다 보니 외부에서 스크립트로 해당 이벤트를 핸들링 하는 것은 무리였다.

따라서, 에디터에서 이미지 복사 붙여넣기 시, blob를 리턴하는 함수를 찾아야 했다.

찾는 방법은 console.log 를 찍어가면서 현재 생성된 에디터에서 이미지 복사 붙여넣기시 어떤 함수를 call 하는지 일일히 테스트 하면서 찾았다.

toastui editor cdn import file : https://uicdn.toast.com/editor/latest/toastui-editor-all.js

해당 파일에서 이미지 핸들링을 하는 부분은 addDefaultImageBlobHook 이라는 함수였다.

- 기존 소스 : 17600 라인 근처

```js
function addDefaultImageBlobHook(eventEmitter) {
  eventEmitter.listen("addImageBlobHook", function (blob, callback) {
    var reader = new FileReader();
    reader.onload = function (_a) {
      var target = _a.target;
      return callback(target.result);
    };

    reader.readAsDataURL(blob);
  });
}
```

위에 해당 하는 부분을 파일 업로드하고, URL로 변경 리턴 하는 것으로 바꾸었다.

- 변경 소스

```js
function addDefaultImageBlobHook(eventEmitter) {
  eventEmitter.listen("addImageBlobHook", function (blob, callback) {
    var formData = new FormData();
    formData.append("file", blob);
    comm.post(
      {
        url: "/file/upload.do",
        processData: false,
        contentType: false,
        headers: {
          "Content-Type": "multipart/form-data",
        },
        params: formData,
      },
      function (data) {
        if (data.result.status != "success") {
          return false;
        } else {
          var url = "/file/download.do?seq=" + data.result.fileSeq;
          return callback(url);
        }
      }
    );
    /* var reader = new FileReader();
        reader.onload = function (_a) {
            var target = _a.target;
            return callback(target.result);
        };
        
        reader.readAsDataURL(blob); */
  });
}
```

이렇게 하면, 에디터에 작성 시, 이미지를 붙여넣을 때 BLOB데이터 전체가 들어가는 것이 아닌, 파일 다운로드 링크로 들어가도록 변경된다.

![toastui](/assets/img/Frontend/js/toastui1.png)
