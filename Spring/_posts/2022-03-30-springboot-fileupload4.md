---
layout: post
title: Spring Boot - 파일 업로드 만들기 -4-
description: >
  [Spring Boot] 파일 업로드 만들기 -4-
sitemap: false
hide_last_modified: true
categories: [Spring]
tags: [fileupload, springboot, springboot fileupload]
---

- Table of Contents
{:toc .large-only}

지난 게시글에 이어서, 파일 업로드 관련 작업을 다시 진행했다. 이번에 중점을 둔 것은 다중 파일 업로드 지원이다.

해당 파일 업로드 기능을 다른 Boot 프로젝트에서 가져다 사용했는데, 해당 서비스에서는 파일 업로드 후 업로드한 파일 리스트를 리턴하여, 정보를 표현해주어야 했기에 이번 다중 파일 업로드 함수에서는 파일 정보들을 리턴하도록 작성하였다.



- FileUploadController.java
```java
@PostMapping("/upload4.do")
    public HashMap upload4(@RequestParam MultipartFile[] files) {
        System.out.println("＃＃＃＃＃＃＃＃＃＃＃ [LOG] : " + files + "＃＃＃＃＃＃＃＃＃＃＃");
        return fsvc.save4(files);
    }
```

기존 MultipartRequest 를 받던 것과는 달리, Multipart 파일 배열을 @RequestParam을 통해 전달받는다.



- FIleUploadService.java
```java
@Override
    public HashMap save4(MultipartFile[] files) {
        // 최종 결과 담을 맵 객체
        HashMap result = new HashMap();
        // 업로드된 파일 리스트 객체
        List<HashMap> uploadFileList = new ArrayList<HashMap>();
        // 업로드 경로 설정
        Path uploadPath = fu.getUploadPath("image");
        // 다중 파일 업로드 관리를 위한 master file seq
        int masterSeq = fu.getMasterSeq();
        // Array 반복 하여 파일 업로드 실행
        Arrays.asList(files).stream().forEach(file -> {
            uploadFileList.add(fu.multipleUpload(file, uploadPath, masterSeq));
        });
        // 결과를 담아 result 리턴.
        result.put("fileMasterSeq", masterSeq);
        result.put("uploadFileList", uploadFileList);
        return result;
    }
```

서비스에서는 파일 배열을 받아, 개수 만큼 반복하며 파일을 업로드 하고, 각 파일을 업로드 함으로써 리턴되는 파일 정보들을 객체에 담아 리턴하게끔 한다.



- FIleUtil.java
```java
public HashMap<String, String> multipleUpload(MultipartFile file, Path path, int masterSeq) {
        HashMap result = new HashMap();
        // 파일 정보
        String fileName = file.getOriginalFilename();
        String fileSize = Long.toString(file.getSize());
        String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);
        String fileType = file.getContentType();
        String filePath = "";
        // 결과 정보
        String status = "";
        String message = "";
        String fileSeq = "";
        // 예외처리 하기

        // 1. 파일 사이즈
        if (file.getSize() > MAX_SIZE) {
            status = "fail";
            message = "file over max upload size";
            result.put("status", status);
            result.put("message", message);
            return result;
        }

        // 2. 파일 확장자
        // 화이트 리스트 방식으로 파일 확장자 체크
        if (!Arrays.asList("jpg", "png", "gif", "jpeg", "bmp", "xlsx", "ppt", "pptx", "txt", "hwp")
                .contains(fileExt.toLowerCase())) {
            status = "fail";
            message = "file type is not allowed";
            result.put("status", status);
            result.put("message", message);
            return result;
        }

        // 3. 저장 파일 이름 랜덤화
        String tempName = fileName.substring(0, fileName.lastIndexOf("."));
        String encFileName = Base64.getEncoder().encodeToString(tempName.getBytes());
        // 암호화된 경로로 패스 설정
        filePath = path.toString() + File.separator + encFileName + "." + fileExt;

        // 4. 파일정보 맵에 담기.
        HashMap fileInfo = new HashMap<String, String>();
        HashMap<String, String> uploadedFileInfo = new HashMap<String, String>();

        fileInfo.put("fileName", fileName);
        fileInfo.put("encFileName", encFileName);
        fileInfo.put("fileSize", fileSize);
        fileInfo.put("fileExt", fileExt);
        fileInfo.put("fileType", fileType);
        fileInfo.put("filePath", filePath);
        fileInfo.put("fileMasterSeq", masterSeq);

        try {
            InputStream is = file.getInputStream();
            Files.copy(is, path.resolve(encFileName + "." + fileExt), StandardCopyOption.REPLACE_EXISTING);

            // 파일 저장에 성공하면 DB에 저장하기
            fileSeq = Integer.toString(rpt.insertFile(fileInfo));
            uploadedFileInfo = rpt.info(Integer.parseInt(fileSeq));

            status = "success";
            message = "upload complete";

        } catch (Exception e) {
            e.printStackTrace();
            status = "fail";
            message = "upload fail";
        }
        result.put("status", status);
        result.put("message", message);
        result.put("fileMasterSeq", masterSeq);
        result.put("fileInfo", uploadedFileInfo);
        return result;
    }
```

실제 업로드 하는 함수이다. 기존과 다른 점은, 여러개의 파일을 한 요청에 의해 올린것을 표시 및 다른 데이터와 연동시에 그룹으로 찾기 쉽도록 file_master 테이블을 추가하고, master_seq 를 가지도록 하여 파일간 그룹을 구분 했다는 것이다.

이렇게하면 사용자가 파일업로드를 할때 일반적인 게시판이라고 한다면, 게시판에서 여러 개 혹은 단일 파일업로드 시 발생한 master_seq 를 가지고 있으면 해당 게시글 작성 시, 업로드 된 모든 파일 정보를 조회할 수 있다.



해당 프로젝트는 아래에서 다운로드가 가능하다.

https://github.com/Chiptune93/spring-example/tree/main/FileUpload








