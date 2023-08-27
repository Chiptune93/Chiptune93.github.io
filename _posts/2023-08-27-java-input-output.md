---
title: Java IO
categories: [Backend, Java]
tags: [Input, Output, IO, Stream]
---


## 기본 입출력 개념

![이미지](/assets/img/Java/io.png)

데이터를 외부 장치를 통해 읽고(키보드,마우스) 이를 받아들여 처리를 하고 외부 장치(모니터 등)에 내보내는 기본 과정을 입출력이라고 한다.

입력과 출력은 스트림(Stream)이라는 것에 의해 전달되고 처리되는데, 스트림은 장치와 프로그램 사이의 일종의 다리 역할을 한다.

스트림이란 단방향 성을 지닌 흐름으로, 출발지에서 도착지로 가는 데이터의 흐름을 의미한다.

단방향성을 지닌 스트림이기에 데이터를 보내고 받으려면 입력과 출력 스트림이 각각 존재해야 한다.

## Java I/O 클래스 및 패키지

- [Oracle JDK IO package](https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/io/package-summary.html)

### 바이트 기반 I/O와 문자 기반 I/O
자바 I/O에서는 데이터를 다루는 데 두 가지 주요 유형의 스트림이 있습니다 이 두 가지 스트림은 데이터를 다루는 방식과 사용되는 데이터의 유형에 따라 선택됩니다.

#### 1. 바이트 기반 스트림 (Byte Streams)
   바이트 기반 스트림은 데이터를 바이트(byte)의 형태로 처리하는 스트림입니다. 이 스트림은 모든 종류의 데이터, 예를 들면 이미지, 오디오, 텍스트 파일, 이진 파일 등을 처리할 수 있습니다. 바이트 스트림은 InputStream과 OutputStream 클래스를 기반으로 합니다.

- InputStream: 바이트 기반 입력 스트림을 처리합니다. 파일을 읽거나 네트워크에서 데이터를 받아올 때 주로 사용됩니다.
- OutputStream: 바이트 기반 출력 스트림을 처리합니다. 파일에 데이터를 쓰거나, 네트워크로 데이터를 보낼 때 사용됩니다.

**주요 바이트 기반 스트림 클래스**

- FileInputStream: 파일로부터 바이트 데이터를 읽는 데 사용됩니다.
- FileOutputStream: 파일에 바이트 데이터를 쓰는 데 사용됩니다.
- BufferedInputStream 및 BufferedOutputStream: 입출력 성능을 향상시키기 위한 버퍼링을 제공합니다.
- DataInputStream 및 DataOutputStream: 원시 데이터 유형 (int, double 등)을 읽고 쓸 수 있게 합니다.

#### 2. 문자 기반 스트림 (Character Streams)
   문자 기반 스트림은 문자(character) 데이터를 처리하는 스트림입니다. 이 스트림은 텍스트 데이터를 처리하는 데 특화되어 있으며, 문자의 인코딩 및 디코딩에 관련된 작업을 수행할 수 있습니다. 문자 스트림은 Reader와 Writer 클래스를 기반으로 합니다.

  - Reader: 문자 기반 입력 스트림을 처리합니다. 주로 텍스트 파일을 읽을 때 사용됩니다. 
  - Writer: 문자 기반 출력 스트림을 처리합니다. 주로 텍스트 파일에 데이터를 쓸 때 사용됩니다.

**주요 문자 기반 스트림 클래스**

- FileReader: 파일로부터 문자 데이터를 읽는 데 사용됩니다.
- FileWriter: 파일에 문자 데이터를 쓰는 데 사용됩니다.
- BufferedReader 및 BufferedWriter: 입출력 성능을 향상시키기 위한 버퍼링을 제공합니다.
- InputStreamReader 및 OutputStreamWriter: 바이트 스트림을 문자 스트림으로 변환하거나 문자 스트림을 바이트 스트림으로 변환하는 데 사용됩니다.
- PrintWriter: 텍스트 데이터를 형식화하여 출력할 수 있는 클래스입니다.

바이트 기반 스트림은 모든 종류의 데이터를 다룰 수 있지만, 문자 데이터를 처리할 때는 문자 기반 스트림을 사용하는 것이 유용합니다. 문자 스트림은 문자 인코딩과 관련된 문제를 다루기 쉽게 해주며, 텍스트 데이터를 다룰 때 더 효과적입니다.

### 왜 용도에 맞게 사용해야 하는가?
어차피 데이터를 다루는 것은 바이트든 문자열이든 다 처리할 수 있는데, 왜 굳이 나누어서 사용해야 할까?

바이트 기반 스트림과 문자 기반 스트림을 용도에 맞게 사용해야 하는 이유는 주로 데이터의 형태와 문자 인코딩을 처리하기 위함입니다. 시간 소요도 일부 영향을 미치지만, 주요 이유는 다음과 같습니다.

- **데이터 형태 처리 (Data Type Handling)**
  - 바이트 기반 스트림: 이진 데이터 또는 바이너리 데이터 (이미지, 오디오, 이진 파일 등)를 처리할 때 사용됩니다. 바이트 스트림은 데이터를 그대로 읽고 쓰므로 데이터의 형태나 구조를 변경하지 않습니다.
  - 문자 기반 스트림: 텍스트 데이터를 처리할 때 사용됩니다. 문자 스트림은 문자 데이터를 올바르게 처리하고 문자 인코딩을 관리할 수 있습니다. 이로써 텍스트 데이터의 해석 및 편집이 용이해집니다.
 
- **문자 인코딩 관리 (Character Encoding Handling)**
  - 바이트 기반 스트림: 텍스트 데이터를 바이트 단위로 다루므로, 문자 인코딩을 명시적으로 처리해야 합니다. 문자열을 바이트 배열로 변환할 때, 인코딩과 관련된 문제를 주의해야 합니다. 잘못된 인코딩 설정은 데이터 손실이나 오류를 유발할 수 있습니다.
  - 문자 기반 스트림: 문자 기반 스트림은 문자 인코딩을 내부적으로 관리합니다. 예를 들어 FileReader는 기본적으로 시스템의 기본 문자 인코딩을 사용하며, 이로 인해 문자열을 제대로 읽을 수 있습니다.

- **편의성과 가독성 (Convenience and Readability)**
  - 바이트 기반 스트림: 이진 데이터를 처리하는 데 사용되며, 이진 데이터의 의미를 이해하기 어려울 수 있습니다. 텍스트 데이터를 처리하는 데는 적합하지 않습니다.
  - 문자 기반 스트림: 텍스트 데이터를 처리하기 위한 고수준의 API를 제공하므로 데이터를 읽고 쓰는 데 훨씬 편리하고 가독성이 높습니다. 문자 스트림을 사용하면 문자열을 직접 다룰 수 있어 코드가 더 명확해집니다.

- **국제화 (Internationalization)**
  - 문자 기반 스트림: 다국어 텍스트 데이터를 처리할 때 필요한 유니코드 지원과 관련된 작업을 효과적으로 수행할 수 있습니다. 이로써 국제화 및 로컬화 작업이 용이해집니다.
  - 요약하면, 바이트 기반 스트림은 모든 종류의 데이터를 처리할 수 있지만, 문자 기반 스트림은 특히 텍스트 데이터를 다룰 때 유용합니다. 문자 인코딩 관리와 데이터 해석을 간편하게 처리할 수 있으며, 가독성과 유지보수성을 높일 수 있습니다.
   
따라서 데이터의 종류와 처리 방식에 따라 적절한 스트림을 선택하는 것이 중요합니다.

## 스트림 연결 및 사용
결국 스트림을 사용한다는 것을 어디선가 데이터를 “읽고” 처리를 한 다음에 해당 데이터를 어디에 “출력” 해주기 위한 작업이라고 할 수 있다.

그리하여 스트림을 열고, 닫는 작업이 있어야 하며 이를 처리하기 위한 과정 또한 존재한다.

**1. 데이터 소스 생성 (Data Source Creation)**
   
  자바 I/O에서 데이터 소스는 파일, 네트워크 연결, 키보드, 메모리 버퍼 등 다양한 유형의 데이터 소스를 나타냅니다.
  예를 들어, 파일에서 데이터를 읽기 위해서는 File 클래스를 사용하여 파일을 나타내고, 네트워크에서 데이터를 읽기 위해서는 Socket 클래스를 사용할 수 있습니다.

**2. 스트림 생성 (Stream Creation)**

  데이터 소스로부터 데이터를 읽거나 데이터를 쓰기 위해 스트림을 생성합니다. 스트림을 생성하는 메서드는 데이터 소스의 유형에 따라 다릅니다.
  파일에서 데이터를 읽을 때는 FileInputStream 또는 FileReader를 사용하고, 파일에 데이터를 쓸 때는 FileOutputStream 또는 FileWriter를 사용할 수 있습니다.

**3. 데이터 읽기 및 쓰기 (Reading and Writing Data)**

  스트림을 통해 데이터를 읽고 쓸 수 있습니다. 바이트 기반 스트림은 바이트 데이터를 처리하고, 문자 기반 스트림은 문자 데이터를 처리합니다.
  read() 및 write() 메서드를 사용하여 데이터를 읽고 쓸 수 있습니다.

**4. 스트림 연결 및 중간 처리 (Stream Chaining and Intermediate Processing)**

  스트림은 연결되어 여러 중간 처리 단계를 거칠 수 있습니다. 중간 처리는 스트림을 변환하거나 필터링하는 작업을 수행합니다.
  예를 들어, BufferedReader는 FileReader 스트림에 연결하여 데이터를 버퍼링하고 효율적으로 읽을 수 있게 합니다.

**5. 스트림 닫기 (Optional)**

  스트림을 사용한 후에는 스트림을 명시적으로 닫을 수 있습니다. 이는 리소스 누수를 방지하기 위해 중요합니다.
  close() 메서드를 호출하여 스트림을 닫을 수 있습니다.

예를 들어, 파일에서 텍스트 데이터를 읽고 출력하는 간단한 예시 코드를 보겠습니다:

```java
import java.io.*;

public class FileIOExample {
public static void main(String[] args) {
try {
// 파일에서 데이터를 읽는 스트림 생성
FileReader reader = new FileReader("input.txt");
BufferedReader bufferedReader = new BufferedReader(reader);

            // 데이터를 출력하는 스트림 생성
            FileWriter writer = new FileWriter("output.txt");
            BufferedWriter bufferedWriter = new BufferedWriter(writer);

            String line;
            while ((line = bufferedReader.readLine()) != null) {
                // 데이터를 읽어와서 가공 또는 필터링
                String modifiedLine = line.toUpperCase();

                // 결과를 출력 스트림에 쓰기
                bufferedWriter.write(modifiedLine);
                bufferedWriter.newLine();
            }

            // 스트림 닫기
            bufferedReader.close();
            bufferedWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

이 코드에서는 파일에서 데이터를 읽는 스트림과 데이터를 출력하는 스트림을 생성하고 연결합니다. 그런 다음 데이터를 읽어와 가공하고 결과를 출력 파일에 씁니다. 마지막으로 스트림을 닫아 리소스를 반환합니다.

## 네트워크 기반 입출력
[Java의 network 패키지](https://docs.oracle.com/en/java/javase/13/docs/api/java.base/java/net/package-summary.html)

### 네트워크 기반 입출력 예시

네트워크 입출력은 자바에서 java.net 패키지의 Socket 및 ServerSocket 클래스를 활용하여 수행된다.

클라이언트 (Client) 예시:


```java
import java.io.*;
import java.net.*;

public class ClientExample {
public static void main(String[] args) {
try {
// 서버에 접속
Socket socket = new Socket("서버 IP 주소", 12345);

            // 출력 스트림 생성
            OutputStream outputStream = socket.getOutputStream();
            PrintWriter writer = new PrintWriter(outputStream, true);

            // 서버로 메시지 전송
            writer.println("안녕하세요, 서버!");

            // 입력 스트림 생성
            InputStream inputStream = socket.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));

            // 서버로부터 메시지 수신
            String response = reader.readLine();
            System.out.println("서버로부터의 응답: " + response);

            // 연결 종료
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```


서버 (Server) 예시:

```java
import java.io.*;
import java.net.*;

public class ServerExample {
public static void main(String[] args) {
try {
// 서버 소켓 생성
ServerSocket serverSocket = new ServerSocket(12345);
System.out.println("서버가 시작되었습니다. 클라이언트를 기다립니다...");

            // 클라이언트 연결 대기
            Socket clientSocket = serverSocket.accept();
            System.out.println("클라이언트가 연결되었습니다.");

            // 입력 스트림 생성
            InputStream inputStream = clientSocket.getInputStream();
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));

            // 클라이언트로부터 메시지 수신
            String message = reader.readLine();
            System.out.println("클라이언트로부터의 메시지: " + message);

            // 출력 스트림 생성
            OutputStream outputStream = clientSocket.getOutputStream();
            PrintWriter writer = new PrintWriter(outputStream, true);

            // 클라이언트에 응답 전송
            writer.println("안녕하세요, 클라이언트!");

            // 연결 종료
            clientSocket.close();
            serverSocket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

이것은 클라이언트와 서버 사이의 간단한 텍스트 메시지를 주고받는 기본적인 네트워크 통신을 보여준다.
클라이언트가 서버에 연결하고 메시지를 보내면 서버는 해당 메시지를 읽어 응답을 보내는 방식이다.
네트워크 입출력은 실제 응용 프로그램에서 다양한 데이터 형식 및 프로토콜을 사용하여 복잡한 통신을 구현할 때 사용된다.

## 예외 처리

자바 I/O(입출력) 작업 중 발생할 수 있는 예외(exception)를 처리하는 것은 중요합니다. I/O 연산은 외부 리소스와 상호 작용하므로 예외 처리는 프로그램의 안정성을 보장하고 예상치 못한 문제를 처리하는 데 필수적입니다.

**FileNotFoundException**: 파일이나 디렉터리를 찾을 수 없는 경우에 발생합니다.


```java
try {
    // 파일을 열거나 읽거나 쓸 때 예외 발생 가능
    FileInputStream fileInputStream = new FileInputStream("file.txt");
} catch (FileNotFoundException e) {
    // 파일을 찾을 수 없는 경우의 예외 처리
    e.printStackTrace();
}
```

**IOException**: I/O 작업 중에 발생하는 일반적인 예외입니다. 파일 읽기, 쓰기, 닫기, 네트워크 통신 등 다양한 I/O 작업에서 발생할 수 있습니다.


```java
try {
    // I/O 작업 수행
} catch (IOException e) {
    // I/O 예외 처리
    e.printStackTrace();
}
```

**EOFException**: 스트림의 끝(End of File)에 도달했을 때 발생하는 예외입니다. 보통 데이터를 읽는 중에 끝을 만났을 때 발생합니다.


```java
try {
    // 파일 끝에 도달할 때까지 데이터 읽기
} catch (EOFException e) {
    // 파일의 끝에 도달한 경우 처리
    e.printStackTrace();
}
```

**SecurityException**: 보안 관련 문제로 I/O 작업이 허용되지 않는 경우 발생합니다.


```java
try {
    // 보안 관련 작업 수행
} catch (SecurityException e) {
    // 보안 예외 처리
    e.printStackTrace();
}
```

**IllegalArgumentException**: 잘못된 인수가 전달된 경우 발생합니다. 예를 들어, 부적절한 파일 경로 또는 옵션을 전달한 경우입니다.


```java
try {
// 부적절한 인수 사용
} catch (IllegalArgumentException e) {
// 잘못된 인수 처리
e.printStackTrace();
}
```

**ClosedChannelException**: 닫힌 채널에서 작업을 시도하는 경우 발생합니다.


```java
try {
// 닫힌 채널에서 작업 시도
} catch (ClosedChannelException e) {
// 닫힌 채널에서 작업 시도 시 예외 처리
e.printStackTrace();
}
```

**Exception**: 자바 I/O 작업에서 발생하는 다른 예외도 처리해야 합니다. 물론, 가능한 구체적인 예외를 처리하는 것이 좋습니다.


```java
try {
// 다른 I/O 예외 처리
} catch (Exception e) {
// 일반적인 I/O 예외 처리
e.printStackTrace();
}
```

I/O 예외를 처리할 때 주의할 점은 예외를 처리하는 방법이 실제 애플리케이션의 요구사항 및 로깅 및 오류 처리 메커니즘과 일치해야 한다는 것입니다. 또한 자원을 올바르게 해제하고 리소스 누수를 방지하기 위해 finally 블록을 사용하여 정리 작업을 수행해야 합니다.

### 가이드 라인
자바 I/O 작업에서 예외를 처리하고 자원을 올바르게 해제하는 방법에 대한 구체적인 가이드라인은 다음과 같습니다:

#### **예외 처리**

I/O 작업을 try-catch 블록으로 래핑하여 예외를 처리합니다.

예외가 발생하면 예외 유형에 따라 적절한 조치를 취합니다. 이때 예외 메시지를 기록하거나 오류 처리 로직을 실행할 수 있습니다.

  ```java
  try {
    // I/O 작업 수행
  } catch (IOException e) {
    // I/O 예외 처리
    e.printStackTrace();
    // 또는 로깅 라이브러리를 사용하여 로그에 예외 기록
  }
  ```

#### **자원 해제**

I/O 작업에 사용한 자원을 올바르게 해제해야 합니다. 이것은 특히 파일, 스트림, 소켓 및 리소스와 관련된 경우 중요합니다.

finally 블록을 사용하여 자원 해제 코드를 작성하면 자원 누출을 방지할 수 있습니다.

try-with-resources 구문을 사용하여 자동으로 자원을 해제하는 것이 더 좋은 방법입니다. 이를 위해 AutoCloseable 인터페이스를 구현한 클래스를 사용합니다.

  ```java
  // try-with-resources를 사용한 자동 자원 해제
  try (InputStream inputStream = new FileInputStream("file.txt")) {
    // inputStream을 사용하여 작업 수행
  } catch (IOException e) {
    e.printStackTrace();
  }
  // 여기서 inputStream은 자동으로 닫힘
  ```

#### **예외 전파 또는 처리**

예외를 처리하거나 다시 던질지를 결정해야 합니다. 때로는 예외를 상위 호출자에게 다시 던져야 할 수도 있습니다.


```java
public void readData(String fileName) throws IOException {
  try (InputStream inputStream = new FileInputStream(fileName)) {
    // 파일에서 데이터 읽기
  } catch (IOException e) {
    // 예외 처리 또는 다시 던지기
    e.printStackTrace();
    throw e; // 또는 다른 예외로 감싸서 던질 수 있음
  }
}
```

#### **로그 기록**

예외가 발생하면 로그에 예외 정보를 기록하여 디버깅 및 모니터링에 도움이 되도록 합니다.

```java
catch (IOException e) {
    // 로깅 라이브러리를 사용하여 예외 로그 기록
    logger.error("I/O 예외 발생: " + e.getMessage(), e);
}
```

### **종합적인 오류 처리**

I/O 작업의 실패에 대한 전략을 정의하고 예외 처리 코드에 해당 전략을 구현합니다. 실패 시 복구 또는 예외를 더 상위 수준으로 전달하여 프로그램의 안정성을 보장합니다.

자바의 I/O 예외 처리는 실제 애플리케이션의 요구사항과 일치하도록 설계되어야 합니다. 종종 예외를 다시 던지거나 예외를 처리하는 방법은 프로그램의 특정 상황에 따라 다를 수 있으므로 주의 깊게 고려해야 합니다.

자원 관리
자바 I/O에서 자원 관리는 메모리 누수와 같은 문제를 방지하고 안정성을 유지하기 위해 매우 중요합니다. 자원 관리를 효과적으로 수행하려면 다음과 같은 방법을 고려해야 합니다:

#### try-with-resources 사용

Java 7부터 도입된 try-with-resources 문법을 사용하면 자원을 자동으로 해제할 수 있습니다.

AutoCloseable 인터페이스를 구현한 클래스를 사용하여 자원을 열고 try 블록 내에서 사용한 후 자동으로 닫히게 됩니다.

이를 사용하면 명시적인 finally 블록을 사용하지 않아도 됩니다.


```java
try (FileInputStream inputStream = new FileInputStream("example.txt")) {
    // inputStream 사용
} catch (IOException e) {
    e.printStackTrace();
}
// 여기서 inputStream은 자동으로 닫힘
```

#### 명시적인 자원 해제

try-with-resources를 사용할 수 없는 경우 자원을 수동으로 해제해야 합니다.

finally 블록 내에서 자원을 닫고 해제하는 코드를 작성합니다.


```java
FileInputStream inputStream = null;
try {
  inputStream = new FileInputStream("example.txt");
  // inputStream 사용
} catch (IOException e) {
  e.printStackTrace();
} finally {
  try {
    if (inputStream != null) {
      inputStream.close();
    }
  } catch (IOException e) {
    e.printStackTrace();
  }
}
```

#### 자원을 열었는지 확인

자원을 닫기 전에 해당 자원이 이미 열려 있는지 확인하는 것이 좋습니다.

null 체크를 통해 자원을 열었는지 여부를 확인할 수 있습니다.


```java
FileInputStream inputStream = null;
try {
    inputStream = new FileInputStream("example.txt");
    // inputStream 사용
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (inputStream != null) {
        try {
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

#### 자원 해제 순서

여러 자원을 사용하는 경우, 열었던 자원을 역순으로 닫아야 합니다.

이는 자원 간에 종속성이 있는 경우 중요합니다.


```java
try (FileInputStream inputStream = new FileInputStream("input.txt");
    FileOutputStream outputStream = new FileOutputStream("output.txt")) {
    // inputStream과 outputStream 사용
} catch (IOException e) {
    e.printStackTrace();
}
// try-with-resources를 사용하면 역순으로 자원이 닫힘
```


#### 예외 처리

자원 해제 중 예외가 발생할 수 있으므로 이러한 예외를 적절하게 처리해야 합니다.

닫기 동작에서 발생한 예외를 적절히 처리하거나 로그에 기록합니다.


```java
FileInputStream inputStream = null;
try {
    inputStream = new FileInputStream("example.txt");
    // inputStream 사용
} catch (IOException e) {
    e.printStackTrace();
} finally {
    try {
        if (inputStream != null) {
            inputStream.close();
        }
    } catch (IOException e) {
        // 닫기 동작에서 발생한 예외 처리
        e.printStackTrace();
    }
}
```

자원 관리는 프로그램의 안정성과 성능에 중요한 영향을 미칩니다. 따라서 자원을 올바르게 관리하고 릴리즈하는 것이 중요합니다. 가능하면 try-with-resources를 사용하여 자원 해제를 자동화하고, 그렇지 않은 경우 명시적인 자원 관리 코드를 작성해야 합니다.

## 스트림이 해제되었는지 확인하는 방법

### 일반 Input/Output Stream
스트림이 닫혔는지 판단하려면 isClosed() 메서드 또는 IOException을 통한 예외 처리를 사용할 수 있습니다. 스트림의 종류에 따라 이를 확인하는 방법이 약간 다를 수 있습니다.

#### isClosed() 메서드 사용 (Java 11 이상):

Java 11부터 InputStream 및 OutputStream 클래스에 isClosed() 메서드가 추가되었습니다.

isClosed() 메서드는 스트림이 닫혔는지 여부를 확인하는 데 사용됩니다.


```java
FileInputStream inputStream = new FileInputStream("example.txt");
// inputStream 사용
inputStream.close(); // 스트림 닫음
boolean closed = inputStream.isClosed(); // 스트림이 닫혔는지 확인
이 메서드를 사용하려면 Java 11 이상 버전을 사용해야 합니다.
```

#### IOException 예외 처리:

스트림이 이미 닫혔다면 스트림 관련 작업을 시도할 때 IOException이 발생합니다.

이를 활용하여 스트림이 닫혔는지 여부를 판단할 수 있습니다.


```java
FileInputStream inputStream = null;
try {
    inputStream = new FileInputStream("example.txt");
    // inputStream 사용
} catch (IOException e) {
    e.printStackTrace();
} finally {
    if (inputStream != null) {
        try {
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// 스트림이 이미 닫혔는지 여부 확인
boolean isClosed = (inputStream == null) || (inputStream instanceof ClosedInputStream);
```

*주의: ClosedInputStream은 Apache Commons IO 라이브러리의 클래스이며, Java 표준 라이브러리에는 포함되어 있지 않습니다. 사용하려면 해당 라이브러리를 추가해야 합니다.

스트림이 닫혔는지 여부를 판단할 때는 프로그램의 안정성을 고려하여 적절한 방법을 선택하십시오. Java 11 이상을 사용하는 경우 isClosed() 메서드를 사용하는 것이 더 간단합니다. 그렇지 않은 경우 IOException 예외 처리를 활용할 수 있습니다.

### BufferedStream
Buffered 스트림은 내부에 사용한 기본 스트림을 관리하며, buffered 스트림을 닫을 때 내부 기본 스트림도 함께 닫힙니다.
따라서 buffered 스트림을 닫으면 관련된 기본 스트림도 자동으로 닫히므로 별도로 buffered 스트림을 닫을 필요는 없습니다.
Buffered 스트림을 사용한 후에는 그냥 buffered 스트림을 닫기만 하면 됩니다.

예를 들어, 다음과 같이 buffered 스트림을 사용하고 닫을 수 있습니다:


```java
import java.io.*;

public class Example {
public static void main(String[] args) {
try {
// 파일을 읽기 위한 FileInputStream을 BufferedInputStream으로 래핑
FileInputStream fileInputStream = new FileInputStream("example.txt");
BufferedInputStream bufferedInputStream = new BufferedInputStream(fileInputStream);

            // bufferedInputStream을 사용하여 파일 읽기
            int data = bufferedInputStream.read();
            while (data != -1) {
                System.out.print((char) data);
                data = bufferedInputStream.read();
            }

            // bufferedInputStream을 닫으면 내부 fileInputStream도 닫힘
            bufferedInputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

위의 코드에서 bufferedInputStream.close()를 호출하면 buffered 스트림과 내부의 fileInputStream이 함께 닫히게 됩니다. 따라서 별도로 내부 스트림을 닫을 필요는 없습니다.
