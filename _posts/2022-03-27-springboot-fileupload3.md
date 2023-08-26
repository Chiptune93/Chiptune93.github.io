---
title: Spring Boot - 파일 업로드 만들기 -3-
categories: [Backend, Spring]
tags: [fileupload,springboot,springboot fileupload]
---

지난번에 이어서 파일 업로드 함수에 기능을 추가 하였다.

1. 파일 업로드 함수의 공통화

2. 파일 예외처리 (사이즈,확장자)

3. 파일 이름 암호화

4. 파일 저장 위치를 타입에 따라 변경 및 날짜별로 폴더 구분하기



> FIleUtil.java

```java
package com.file.example.util;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashMap;

import com.file.example.repository.FileUploadRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

/**
 * 파일 유틸 클래스
 */
@Component
public class FileUtil {
    // 서버 업로드 경로
    @Value("${spring.servlet.multipart.location}")
    private String uploadPath;

    // 최대 파일 크기
    private long MAX_SIZE = 52428800;

    // 파일 정보 저장 시, 레파지토리
    @Autowired
    FileUploadRepository rpt;

    /**
     * 업로드 경로 구하기
     * 
     * @param type
     * @return
     */
    public Path getUploadPath(String type) {
        // 파일은 기본적으로 날짜 기준 (yyyymmdd) 으로 폴더를 구분
        LocalDate ld = LocalDate.now();
        String date = ld.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String typeFolder = "";
        // 타입에 따라 날짜 내부에 폴더 구분
        if (type.equals("image")) {
            typeFolder = "image";
        } else if (type.equals("document")) {
            typeFolder = "document";
        } else {
            typeFolder = "";
        }
        // 업로드 경로를 조합
        uploadPath += File.separator + date + File.separator + typeFolder;
        // 조합된 경로 체크
        Path dir = Paths.get(uploadPath);
        // 해당 경로 존재하는지 체크
        if (!Files.exists(dir)) {
            try {
                // 경로가 없다면 생성
                Files.createDirectories(dir);
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        }
        return dir;
    }

    /**
     * 업로드 하기
     * 
     * @param file
     * @param path
     */
    public HashMap<String, String> upload(MultipartFile file, Path path) {
        HashMap<String, String> result = new HashMap<String, String>();
        // 파일 정보
        String fileName = file.getOriginalFilename();
        String fileSize = Long.toString(file.getSize());
        String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);
        String fileType = file.getContentType();
        String filePath = "";
        // 결과 정보
        String status = "";
        String message = "";
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
                .contains(fileType.toLowerCase())) {
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
        HashMap<String, String> fileInfo = new HashMap<String, String>();

        fileInfo.put("fileName", fileName);
        fileInfo.put("encFileName", encFileName);
        fileInfo.put("fileSize", fileSize);
        fileInfo.put("fileExt", fileExt);
        fileInfo.put("fileType", fileType);
        fileInfo.put("filePath", filePath);
        
        try {
            InputStream is = file.getInputStream();
            Files.copy(is, path.resolve(encFileName + "." + fileExt), StandardCopyOption.REPLACE_EXISTING);

            // 파일 저장에 성공하면 DB에 저장하기
            int seq = rpt.insertFile(fileInfo);

            status = "success";
            message = "upload complete";
        } catch (Exception e) {
            e.printStackTrace();
            status = "fail";
            message = "upload fail";
        }
        result.put("status", status);
        result.put("message", message);
        return result;
    }
}
```

>FileUploadService.java

```java
@Override
    public HashMap<String, String> save3(MultipartRequest req) {
        HashMap<String, String> result = new HashMap<String, String>();
        MultipartFile file = req.getFile("singleFile3");
        Path uploadPath = fu.getUploadPath("image");
        result = fu.upload(file, uploadPath);
        return result;
    }
```

위 기능들을 추가하면서 파일 업로드가 점점 그럴듯해보이는데, 아직 할 일은 많다.

우선, 단일 업로드 상황에서 이렇게까지 구현 하였으니 다음에는 아래의 내용을 진행할 생각이다.

1. 다중 업로드 구현.

2. 파일 업로드 라이브러리 (Vuejs) 사용.

3. 파일 다운로드 / 삭제 처리



음.. 2번은 좀 걸릴 것같아 1,3번을 다 처리한 후에 해야 할 것 같다.

나중에 시간이 된다면 운영환경 처럼, 리눅스 서버에 올려서 테스트를 해보아야겠다.

운영 환경에서는 경로가 윈도우나 맥처럼 나오지 않기 때문이기도 하고, 현재 개인 프로젝트로 진행한 Document 사이트에서 현재는 에디터 내에 일반 문자열데이터로 이미지를 저장하고 있어 공간 차지가 심하기 때문에 그쪽에다가 파일 업로드를 한 번 가져가서 적용해볼 생각이다. 



위 프로젝트는 아래에서 받아볼 수 있습니다.

https://github.com/Chiptune93/Library/tree/main/Spring/FileUpload/SpringBoot/example

