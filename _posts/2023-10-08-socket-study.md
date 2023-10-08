---
title: 객체를 사용하는 과정
categories: [Etc, JustChat]
tags: [java, Socket, 객체, 코드사용, 라이브러리, 자바]
---

## 서론

우리가 사용하는 프로그래밍 언어는 고수준의 프레임워크이다.  
Java의 경우에도 코드로 작성한 대부분의 것들이 기계어로 컴파일되고 나서야 JVM을 통해 동작한다. 그 중에는 운영체제의 자원을 사용하는 일련의 것들.  
예를 들어 IO, 프로세스 등이 존재하며 이러한 것들은 유저 모드에서 동작하는 일종의 프로그램이다. 따라서, 이러한 것들이 독자적으로 운영체제의 자원을 실행하거나 종료하거나 등을 할 수 없다.

우리가 이해해야 하는 것은 과연, 어떤 라이브러리, 소스코드 등을 사용했을 때에 어떻게 동작하고 자원이 어떻게 소모되며, OS에서 이를 어떻게 처리하는가이다.

1.  이 코드를 실행했을 때, 어떤 형태로 OS에 전달되고 실행되는가?

2.  그 형태가 실행되었을 때, 자원은 어떻게 소모되며 효율적인 것인가?

3.  만약 비효율 적이라면 어떤 다른 방법을 통해 비효율을 개선할 수 있는가?


## 본론

### Java Socket

그렇다면 나는 여기서 자바 소켓에 관련해서 위 내용을 한 번 적용해보고자 한다.  
Socket을 통해 연결 될 때, 과연 어떻게 되는 것이며 OS에서는 무슨일이 일어나는 걸까?

### 고수준의 언어에서 따라가보기

기본적으로 소켓을 사용하여 서버측에서 연결을 한다고 하면 다음과 같은 코드를 사용한다.

```java
// 포트 오픈 및 리스닝
Socket socket = serverSocket.accept();
```

그럼 여기서 저 `Socket` 을 따라가보자.

![](/assets/img/SocketStudy/27918337/28278785.png?width=340)

그럼 이렇게, 자바 버전에 맞게 내부 소켓 클래스에 대해 정의된 것을 볼 수 있다. 여기서 생성자인 `Socket()` 을 보면 `setImpl()` 을 이용하여 소켓 객체를 생성한다.  
더 따라가보자.

![](/assets/img/SocketStudy/27918337/28311553.png)

무엇인지 모르겠지만, 팩토리가 있다면 `SocketImpl`을 생성하여 세팅하고, 없다면 새로운 `SocksSocketImpl` 객체를 생성하여 세팅한다.  
그럼 `SocksSocketImpl` 이 무엇인지 찾아보자.

![](/assets/img/SocketStudy/27918337/28344321.png)

소켓을 이용한 연결에서 보아온 대로, IP주소와 포트 등을 이용해서 무언가 연결 객체를 만들고 있다.  
이 객체를 이용해서 통신하기 위한 준비를 하고 있다는 것을 알 수 있다.

그럼 이제 이 `Socket` 객체를 이용해서 `connect` 하는 부분을 살펴 보자.

Socket.java 파일에 다음과 같은 내용이 정의되어 있다.

```java
    public void connect(SocketAddress endpoint, int timeout) throws IOException {
        if (endpoint == null)
            throw new IllegalArgumentException("connect: The address can't be null");

        if (timeout < 0)
          throw new IllegalArgumentException("connect: timeout can't be negative");

        if (isClosed())
            throw new SocketException("Socket is closed");

        if (!oldImpl && isConnected())
            throw new SocketException("already connected");

        if (!(endpoint instanceof InetSocketAddress))
            throw new IllegalArgumentException("Unsupported address type");

        InetSocketAddress epoint = (InetSocketAddress) endpoint;
        InetAddress addr = epoint.getAddress ();
        int port = epoint.getPort();
        checkAddress(addr, "connect");

        SecurityManager security = System.getSecurityManager();
        if (security != null) {
            if (epoint.isUnresolved())
                security.checkConnect(epoint.getHostName(), port);
            else
                security.checkConnect(addr.getHostAddress(), port);
        }
        if (!created)
            createImpl(true);
        if (!oldImpl)
            impl.connect(epoint, timeout);
        else if (timeout == 0) {
            if (epoint.isUnresolved())
                impl.connect(addr.getHostName(), port);
            else
                impl.connect(addr, port);
        } else
            throw new UnsupportedOperationException("SocketImpl.connect(addr, timeout)");
        connected = true;
        /*
         * If the socket was not bound before the connect, it is now because
         * the kernel will have picked an ephemeral port & a local address
         */
        bound = true;
    }
```

내용을 전부 이해하진 못하겠지만, 중간에 보면 `impl.connect(epoint, timeout);` 라는 부분이 있다. 해당 부분이 아마 실제 연결을 하기 위한 작업으로 보인다.  
이 것을 따라가 보면 `Socket`에 아래와 같이 정의되어 있다.

```java
    /**
     * Connects this socket to the specified port number on the specified host.
     * A timeout of zero is interpreted as an infinite timeout. The connection
     * will then block until established or an error occurs.
     *
     * @param      address   the Socket address of the remote host.
     * @param     timeout  the timeout value, in milliseconds, or zero for no timeout.
     * @exception  IOException  if an I/O error occurs when attempting a
     *               connection.
     * @since 1.4
     */
    protected abstract void connect(SocketAddress address, int timeout) throws IOException;
```

인텔리제이에서 제공하는 구현을 찾는 부분을 클릭해보면 아래와 같이 나온다.

![](/assets/img/SocketStudy/27918337/28377089.png)

위 3가지 파일에서 해당 메소드를 구현했다고 나온다. 이 중 `SocksSocketImpl`을 살펴보자.

그러면 다음과 같이 엄청 긴 구현을 마주하게 된다.

```java
    /**
     * Connects the Socks Socket to the specified endpoint. It will first
     * connect to the SOCKS proxy and negotiate the access. If the proxy
     * grants the connections, then the connect is successful and all
     * further traffic will go to the "real" endpoint.
     *
     * @param   endpoint        the {@code SocketAddress} to connect to.
     * @param   timeout         the timeout value in milliseconds
     * @throws  IOException     if the connection can't be established.
     * @throws  SecurityException if there is a security manager and it
     *                          doesn't allow the connection
     * @throws  IllegalArgumentException if endpoint is null or a
     *          SocketAddress subclass not supported by this socket
     */
    @Override
    protected void connect(SocketAddress endpoint, int timeout) throws IOException {
        final long deadlineMillis;

        if (timeout == 0) {
            deadlineMillis = 0L;
        } else {
            long finish = System.currentTimeMillis() + timeout;
            deadlineMillis = finish < 0 ? Long.MAX_VALUE : finish;
        }

        SecurityManager security = System.getSecurityManager();
        if (endpoint == null || !(endpoint instanceof InetSocketAddress))
            throw new IllegalArgumentException("Unsupported address type");
        InetSocketAddress epoint = (InetSocketAddress) endpoint;
        if (security != null) {
            if (epoint.isUnresolved())
                security.checkConnect(epoint.getHostName(),
                                      epoint.getPort());
            else
                security.checkConnect(epoint.getAddress().getHostAddress(),
                                      epoint.getPort());
        }
        if (server == null) {
            // This is the general case
            // server is not null only when the socket was created with a
            // specified proxy in which case it does bypass the ProxySelector
            ProxySelector sel = java.security.AccessController.doPrivileged(
                new java.security.PrivilegedAction<>() {
                    public ProxySelector run() {
                            return ProxySelector.getDefault();
                        }
                    });
            if (sel == null) {
                /*
                 * No default proxySelector --> direct connection
                 */
                super.connect(epoint, remainingMillis(deadlineMillis));
                return;
            }
            URI uri;
            // Use getHostString() to avoid reverse lookups
            String host = epoint.getHostString();
            // IPv6 litteral?
            if (epoint.getAddress() instanceof Inet6Address &&
                (!host.startsWith("[")) && (host.indexOf(':') >= 0)) {
                host = "[" + host + "]";
            }
            try {
                uri = new URI("socket://" + ParseUtil.encodePath(host) + ":"+ epoint.getPort());
            } catch (URISyntaxException e) {
                // This shouldn't happen
                assert false : e;
                uri = null;
            }
            Proxy p = null;
            IOException savedExc = null;
            java.util.Iterator<Proxy> iProxy = null;
            iProxy = sel.select(uri).iterator();
            if (iProxy == null || !(iProxy.hasNext())) {
                super.connect(epoint, remainingMillis(deadlineMillis));
                return;
            }
            while (iProxy.hasNext()) {
                p = iProxy.next();
                if (p == null || p.type() != Proxy.Type.SOCKS) {
                    super.connect(epoint, remainingMillis(deadlineMillis));
                    return;
                }

                if (!(p.address() instanceof InetSocketAddress))
                    throw new SocketException("Unknown address type for proxy: " + p);
                // Use getHostString() to avoid reverse lookups
                server = ((InetSocketAddress) p.address()).getHostString();
                serverPort = ((InetSocketAddress) p.address()).getPort();
                useV4 = useV4(p);

                // Connects to the SOCKS server
                try {
                    privilegedConnect(server, serverPort, remainingMillis(deadlineMillis));
                    // Worked, let's get outta here
                    break;
                } catch (IOException e) {
                    // Ooops, let's notify the ProxySelector
                    sel.connectFailed(uri,p.address(),e);
                    server = null;
                    serverPort = -1;
                    savedExc = e;
                    // Will continue the while loop and try the next proxy
                }
            }

            /*
             * If server is still null at this point, none of the proxy
             * worked
             */
            if (server == null) {
                throw new SocketException("Can't connect to SOCKS proxy:"
                                          + savedExc.getMessage());
            }
        } else {
            // Connects to the SOCKS server
            try {
                privilegedConnect(server, serverPort, remainingMillis(deadlineMillis));
            } catch (IOException e) {
                throw new SocketException(e.getMessage());
            }
        }

        // cmdIn & cmdOut were initialized during the privilegedConnect() call
        BufferedOutputStream out = new BufferedOutputStream(cmdOut, 512);
        InputStream in = cmdIn;

        if (useV4) {
            // SOCKS Protocol version 4 doesn't know how to deal with
            // DOMAIN type of addresses (unresolved addresses here)
            if (epoint.isUnresolved())
                throw new UnknownHostException(epoint.toString());
            connectV4(in, out, epoint, deadlineMillis);
            return;
        }

        // This is SOCKS V5
        out.write(PROTO_VERS);
        out.write(2);
        out.write(NO_AUTH);
        out.write(USER_PASSW);
        out.flush();
        byte[] data = new byte[2];
        int i = readSocksReply(in, data, deadlineMillis);
        if (i != 2 || ((int)data[0]) != PROTO_VERS) {
            // Maybe it's not a V5 sever after all
            // Let's try V4 before we give up
            // SOCKS Protocol version 4 doesn't know how to deal with
            // DOMAIN type of addresses (unresolved addresses here)
            if (epoint.isUnresolved())
                throw new UnknownHostException(epoint.toString());
            connectV4(in, out, epoint, deadlineMillis);
            return;
        }
        if (((int)data[1]) == NO_METHODS)
            throw new SocketException("SOCKS : No acceptable methods");
        if (!authenticate(data[1], in, out, deadlineMillis)) {
            throw new SocketException("SOCKS : authentication failed");
        }
        out.write(PROTO_VERS);
        out.write(CONNECT);
        out.write(0);
        /* Test for IPV4/IPV6/Unresolved */
        if (epoint.isUnresolved()) {
            out.write(DOMAIN_NAME);
            out.write(epoint.getHostName().length());
            out.write(epoint.getHostName().getBytes(StandardCharsets.ISO_8859_1));
            out.write((epoint.getPort() >> 8) & 0xff);
            out.write((epoint.getPort() >> 0) & 0xff);
        } else if (epoint.getAddress() instanceof Inet6Address) {
            out.write(IPV6);
            out.write(epoint.getAddress().getAddress());
            out.write((epoint.getPort() >> 8) & 0xff);
            out.write((epoint.getPort() >> 0) & 0xff);
        } else {
            out.write(IPV4);
            out.write(epoint.getAddress().getAddress());
            out.write((epoint.getPort() >> 8) & 0xff);
            out.write((epoint.getPort() >> 0) & 0xff);
        }
        out.flush();
        data = new byte[4];
        i = readSocksReply(in, data, deadlineMillis);
        if (i != 4)
            throw new SocketException("Reply from SOCKS server has bad length");
        SocketException ex = null;
        int len;
        byte[] addr;
        switch (data[1]) {
        case REQUEST_OK:
            // success!
            switch(data[3]) {
            case IPV4:
                addr = new byte[4];
                i = readSocksReply(in, addr, deadlineMillis);
                if (i != 4)
                    throw new SocketException("Reply from SOCKS server badly formatted");
                data = new byte[2];
                i = readSocksReply(in, data, deadlineMillis);
                if (i != 2)
                    throw new SocketException("Reply from SOCKS server badly formatted");
                break;
            case DOMAIN_NAME:
                byte[] lenByte = new byte[1];
                i = readSocksReply(in, lenByte, deadlineMillis);
                if (i != 1)
                    throw new SocketException("Reply from SOCKS server badly formatted");
                len = lenByte[0] & 0xFF;
                byte[] host = new byte[len];
                i = readSocksReply(in, host, deadlineMillis);
                if (i != len)
                    throw new SocketException("Reply from SOCKS server badly formatted");
                data = new byte[2];
                i = readSocksReply(in, data, deadlineMillis);
                if (i != 2)
                    throw new SocketException("Reply from SOCKS server badly formatted");
                break;
            case IPV6:
                len = 16;
                addr = new byte[len];
                i = readSocksReply(in, addr, deadlineMillis);
                if (i != len)
                    throw new SocketException("Reply from SOCKS server badly formatted");
                data = new byte[2];
                i = readSocksReply(in, data, deadlineMillis);
                if (i != 2)
                    throw new SocketException("Reply from SOCKS server badly formatted");
                break;
            default:
                ex = new SocketException("Reply from SOCKS server contains wrong code");
                break;
            }
            break;
        case GENERAL_FAILURE:
            ex = new SocketException("SOCKS server general failure");
            break;
        case NOT_ALLOWED:
            ex = new SocketException("SOCKS: Connection not allowed by ruleset");
            break;
        case NET_UNREACHABLE:
            ex = new SocketException("SOCKS: Network unreachable");
            break;
        case HOST_UNREACHABLE:
            ex = new SocketException("SOCKS: Host unreachable");
            break;
        case CONN_REFUSED:
            ex = new SocketException("SOCKS: Connection refused");
            break;
        case TTL_EXPIRED:
            ex =  new SocketException("SOCKS: TTL expired");
            break;
        case CMD_NOT_SUPPORTED:
            ex = new SocketException("SOCKS: Command not supported");
            break;
        case ADDR_TYPE_NOT_SUP:
            ex = new SocketException("SOCKS: address type not supported");
            break;
        }
        if (ex != null) {
            in.close();
            out.close();
            throw ex;
        }
        external_address = epoint;
    }
```

위 코드를 쭉 보다보면 17line 부터 135line 까지 일련의 조건 및 과정을 거쳐 연결을 수립하는 과정이라고 유추할 수 있다.  
위에서부터 Connect와 관련된 부분을 계속 찾아서 넘어가다보면, 구현체를 찾을 수 없는 경우가 있는데 이런 경우 jdk dev 버전이 아니라서 그렇다.

예를 들어, 81 line 의 `super.connect(epoint, remainingMillis(deadlineMillis));` 를 따라가보면 `AbstractPlainSocketImpl` 이 나오고

여기서 `connectToAddress` → `doConnect` → `socketConnect` 를 차례로 따라가 보면 `PlainSocketImpl` 의 `socketConnect` 로 연결되는데  
구현부가 존재하지 않는다. 이를 DEV 버전에서 살펴보면 아래와 같이 구현되어 있다.

```java
@Override
    void socketConnect(InetAddress address, int port, int timeout)
        throws IOException {
        int nativefd = checkAndReturnNativeFD();

        if (address == null)
            throw new NullPointerException("inet address argument is null.");

        if (preferIPv4Stack && !(address instanceof Inet4Address))
            throw new SocketException("Protocol family not supported");

        int connectResult;
        if (timeout <= 0) {
            connectResult = connect0(nativefd, address, port);
        } else {
            configureBlocking(nativefd, false);
            try {
                connectResult = connect0(nativefd, address, port);
                if (connectResult == WOULDBLOCK) {
                    waitForConnect(nativefd, timeout);
                }
            } finally {
                configureBlocking(nativefd, true);
            }
        }
        /*
         * We need to set the local port field. If bind was called
         * previous to the connect (by the client) then localport field
         * will already be set.
         */
        if (localport == 0)
            localport = localPort0(nativefd);
    }
```

내용을 자세히 모르겠지만! connect 에 대한 결과를 `connect0` 메소드를 호출한 것으로 받는다. 그리고 이는 하단에

```java
static native int connect0(int fd, InetAddress remote, int remotePort)
        throws IOException;
```

로 정의되어 있고 더 이상 소스에서는 뭐가 나오지 않는다. 그래서 해당 메소드를 구글링 해보니 원하는 내용을 찾을 수 없어 GPT에 도움을 요청하니 아래와 같은 답변을 주었다.

> `connect0` 메소드는 Java 소켓 라이브러리 내부에서 사용되는 네이티브 메소드로, 소켓 연결을 설정하는 작업을 처리합니다. 이 메소드는 실제로 Java 언어로 구현되지 않고, 네이티브 코드로 작성되어 있으며, Java Native Interface (JNI)를 통해 운영 체제의 네트워크 스택과 상호 작용합니다.
>
> `connect0` 메소드가 하는 주요 작업은 다음과 같습니다:  
> 1\. **소켓 연결 설정:** `connect0` 메소드는 클라이언트 소켓이 서버로의 연결을 설정하는 역할을 합니다. 이때 클라이언트 소켓이 서버의 IP 주소와 포트 번호에 연결됩니다.  
> 2\. **TCP/IP 핸드셰이크:** TCP/IP 기반의 소켓에서는 연결 설정 과정 중에 핸드셰이크를 수행해야 합니다. 핸드셰이크는 연결을 설정하고 통신의 신뢰성을 보장하기 위한 과정으로, `connect0` 메소드는 이 핸드셰이크를 처리합니다.  
> 3\. **연결 결과 반환:** `connect0` 메소드는 연결 결과를 반환합니다. 연결이 성공하면 연결된 소켓 객체를 반환하고, 실패하면 예외를 발생시킵니다.

네이티브 코드로 구성된 영역이며, OS의 네트워크 스택과 상호작용을 하여 연결 설정 및 Handshake를 통해 연결 후, 결과를 반환한다고 되어있다.  
조금 더 자세하게 어떤 일을 하는 지 물어보았다.

> `connect0` 메소드는 Java에서 네트워크 소켓 연결을 설정하는데 있어서 네이티브 메소드로서 다음과 같은 시스템 관련 작업을 수행합니다:  
> 1\. **네트워크 스택 호출:** `connect0` 메소드는 운영 체제의 네트워크 스택을 호출하여 소켓 연결 설정을 시작합니다. 이 과정에서 네트워크 스택은 소켓을 특정 IP 주소와 포트 번호에 연결하고 네트워크 라우팅 및 패킷 전송을 관리합니다.  
> 2\. **IP 주소와 포트 번호 바인딩:** `connect0` 메소드는 소켓을 지정된 서버의 IP 주소와 포트 번호에 바인딩합니다. 이를 통해 연결을 설정하고 데이터를 교환할 목적지를 설정합니다.  
> 3\. **TCP/IP 핸드셰이크:** 만약 TCP/IP 기반의 소켓 연결이라면, `connect0` 메소드는 핸드셰이크 과정을 시작합니다. 이 과정은 클라이언트와 서버 간의 연결을 설정하고 통신의 신뢰성을 보장하는 중요한 단계입니다.  
> 4\. **연결 결과 반환:** `connect0` 메소드는 연결 결과를 반환합니다. 연결이 성공하면 연결된 소켓 객체를 반환하고, 연결이 실패하면 예외를 발생시킵니다. 이 결과는 Java 애플리케이션에 반환되어 사용됩니다.  
> 5\. **오류 처리 및 예외 발생:** 네트워크 통신은 다양한 오류 상황을 다룰 수 있으므로, `connect0` 메소드는 오류를 검출하고 예외를 발생시켜 Java 애플리케이션에 오류 상황을 보고합니다.

이제 고수준의 언어에서 뭔가 운영 체제와 연관된 부분까지 내려오게 되었다.  
그렇다면 이제 네트워크 스택 부터 차례로 알아보자

### 소켓의 TCP/IP 통신과 네트워크 스택

위 답변에서 운영 체제의 네트워크 스택과 상호작용 한다고 했다. 그렇다면 네트워크 스택이란 무엇일까?

> **프로토콜 스택**(protocol stack) 또는 **네트워크 스택**(network stsack)은 [컴퓨터 네트워크](https://ko.wikipedia.org/wiki/%EC%BB%B4%ED%93%A8%ED%84%B0_%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC) 프로토콜 스위트 또는 프로토콜 계열의 [구현](https://ko.wikipedia.org/wiki/%EA%B5%AC%ED%98%84)체이다. 이 용어들 중 일부는 상호 번갈아가면서 사용하긴 하지만 정확히 말해 '스위트'는 [통신 프로토콜](https://ko.wikipedia.org/wiki/%ED%86%B5%EC%8B%A0_%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C)의 정의이며 스택은 이들의 [소프트웨어](https://ko.wikipedia.org/wiki/%EC%86%8C%ED%94%84%ED%8A%B8%EC%9B%A8%EC%96%B4) 구현체이다.[\[1\]](https://ko.wikipedia.org/wiki/%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C_%EC%8A%A4%ED%83%9D#cite_note-1)
>
> 스위트 안의 개개의 프로토콜들은 대개 한 가지 목적으로 염두에 두고 설계된다. 이러한 [모듈성](https://ko.wikipedia.org/wiki/%EB%AA%A8%EB%93%88%EC%84%B1_(%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D))을 통해 설계와 평가를 단순화시킬 수 있다. 각 프로토콜 모듈은 보통 다른 2가지와 보통 통신하는데 이것들은 보통 프로토콜 스택 내 [계층](https://ko.wikipedia.org/wiki/%EC%B6%94%EC%83%81%ED%99%94_%EA%B3%84%EC%B8%B5)들로 구상된다. 가장 낮은 위치의 프로토콜은 무조건 통신 하드웨어와의 로우레벨 통신을 다룬다. 더 높은 위치의 각 계층은 추가 기능들을 더하고 있다. 사용자 애플리케이션은 보통 최상위 계층들만 다룬다.[\[2\]](https://ko.wikipedia.org/wiki/%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C_%EC%8A%A4%ED%83%9D#cite_note-2)  
> From Wikipedia([https://ko.wikipedia.org/wiki/%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C\_%EC%8A%A4%ED%83%9D](https://ko.wikipedia.org/wiki/%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C_%EC%8A%A4%ED%83%9D) )

흔히 네트워크에서 자주보던 OSI 7계층 처럼 네트워크와 관련된 구현 스택이라고 볼 수 있겠다.

TCP/IP 통신 과정에서 어떻게 상호작용이 이루어지는지 아래의 그림을 보면 더욱 명확하다.

![](/assets/img/SocketStudy/27918337/28377095.png)

우리가 작성한 `Socket` 을 이용한 코드는 애플리케이션 레이어에서 실행된다. 그렇다면 위에서 보았던 네이티브 코드에서 운영 체제의 네트워크 스택과 상호작용 한다고 하였고  
그를 통해 TCP/IP 통신(핸드셰이크)를 한다고 했다. 그러면 애플리케이션 레이어에서 Kernel Mode로 시스템 콜이 이루어진다.

이 과정을 정리하면 다음과 같다.

1.  **애플리케이션**이 전송할 데이터를 생성하고(User data 상자), **write 시스템 콜을 호출해서 데이터를 보낸다.** (커널영역 전환)

2.  Linux나 Unix를 포함한 POSIX 계열 운영체제는 소켓을 file descriptor로 애플리케이션에 노출한다. POSIX 계열의 운영체제에서 소켓은 파일의 한 종류다. 파일(file) 레이어는 단순한 검사만 하고  
    파일 구조체에 연결된 소켓 구조체를 사용해서 소켓 함수를 호출한다.

3.  커널 소켓은 2개의 버퍼를 가지고 있는데, 송신과 수신용으로 사용하는 send/receive socket buffer 이다. Write 시스템 콜을 호출하면 **유저 영역의 데이터가 커널 메모리로 복사**되고, send socket buffer의 뒷부분에 추가된다.  
    순서대로 전송하기 위해서다. 다음으로 TCP를 호출한다.

4.  현재 TCP 상태가 데이터 전송을 허용하면 새로운 TCP segment, 즉 패킷을 생성한다. Flow control 같은 이유로 데이터 전송이 불가능하면 시스템 콜은 여기서 끝나고, 유저 모드로 돌아간다(즉, 애플리케이션으로 제어권이 넘어간다).

5.  생성된 TCP segment는 IP 레이어로 이동한다(내려 간다). IP 레이어에서는 TCP segment에 IP 헤더를 추가하고, IP routing을 한다.

6.  IP 레이어에서 IP 헤더 checksum을 계산하여 덧붙인 후, Ethernet 레이어로 데이터를 보낸다.

7.  Ethernet 레이어는 ARP(Address Resolution Protocol)를 사용해서 next hop IP의 MAC 주소를 찾는다. 그리고 Ethernet 헤더를 패킷에 추가한다. Ethernet 헤더까지 붙으면 호스트의 패킷은 완성이다.

8.  IP routing을 하면 그 결과물로 next hop IP와 해당 IP로 패킷 전송할 때 사용하는 인터페이스(transmit interface, 혹은 NIC)를 알게 된다. 따라서 transmit NIC의 드라이버를 호출한다.

9.  드라이버는 NIC 제조사가 정의한 드라이버-NIC 통신 규약에 따라 패킷 전송을 요청한다.

10.  NIC는 패킷 전송 요청을 받고, 메인 메모리에 있는 패킷을 자신의 메모리로 복사하고, 네트워크 선으로 전송한다. 이때 Ethernet 표준에 따라 IFG(Inter-Frame Gap), preamble, 그리고 CRC를 패킷에 추가한다.

11.  **NIC가 패킷을 전송할 때** NIC는 호스트 **CPU에 인터럽트(interrupt)를 발생**시킨다. 모든 인터럽트에는 인터럽트 번호가 있으며, 운영체제는 이 번호를 이용하여 이 인터럽트를 처리할 수 있는 적합한 드라이버를 찾는다. 드라이버는 인터럽트를 처리할 수 있는 함수(인터럽트 핸들러)를 드라이브가 가동되었을 때 운영체제에 등록해둔다. 운영체제가 핸들러를 호출하고, 핸들러는 전송된 패킷을 운영체제에 반환한다.


여기서 중요한 부분은 **“애플리케이션이 Write 시스템 콜을 이용해 데이터를 커널로 보내고” → “소켓에서 버퍼에 데이터를 담아” → “하위 레이어로 데이터를 전송하며, 필요한 데이터를 추가” → “패킷 전송 시, CPU에 인터럽트를 발생시켜 이를 처리한다.”** 이다.

**결국 고수준의 언어에서 작성된 소켓 객체는 POSIX 계열 운영 체제에서는 결국 “파일” 인 것이고, 시스템 콜을 이용해 read/write 콜을 함으로써 데이터를 생성하고 송/수신 하는 것이다.**

윈도우 계열에서는 소켓 객체를 어떻게 표현하고 처리하는지 궁금해서 찾아본 결과 다음과 같다.

> POSIX 운영 체제에서는 파일 디스크립터를 통해 파일과 소켓 모두를 다룰 수 있지만, Windows에서는 파일과 소켓을 별도의 개체로 다루는 경향이 있습니다.
>
> Windows에서는 파일을 다루기 위해 `HANDLE` 타입을 사용하고, 소켓을 다루기 위해서도 `SOCKET` 타입을 사용합니다. 이러한 핸들과 소켓을 각각의 함수와 API로 다루게 됩니다. 그러므로 Windows에서는 파일 디스크립터와는 다른 개념인 핸들을 사용하여 파일 및 소켓을 관리합니다.
>
> 예를 들어, Windows에서 파일을 열고 읽고 쓰려면 `CreateFile`, `ReadFile`, `WriteFile` 등의 API 함수를 사용하며, 파일 핸들을 반환합니다. 소켓을 생성하고 통신하기 위해서는 `socket`, `send`, `recv`와 같은 Winsock API 함수를 사용하며, 소켓 핸들을 반환합니다.
>
> 따라서 Windows에서는 파일과 소켓을 별도의 핸들 타입으로 다루며, 각각에 대해 해당하는 함수 및 API를 사용하여 관리합니다. Windows와 POSIX 운영 체제 간의 차이 때문에 이식성 있는 코드를 작성하려면 조건부 컴파일 및 플랫폼 별 코드 작성이 필요할 수 있습니다. `HANDLE`을 사용하여 시스템 리소스에 접근하고 조작할 수 있으며, 핸들을 닫아 리소스 누수를 방지해야 합니다.

답변을 미루어보자면, 윈도우에서는 `HANDLE` 타입과 `SOCKET`타입을 사용하여 시스템 리소스에 접근 및 조작을 한다고 한다.

## 결론

프로그램 내에서 어떤 객체를 사용해서 프로그램을 만들 때, 효율과 성능을 고려하는 과정에서 필요한 것은 이 객체를 이용할 때, 어떻게 OS의 자원을 활용하며, 어떤 과정을 통해 동작하는 것인지를  
알고 사용하는 것이 중요하다고 볼 수 있다.

위의 소켓에서도 볼 수 있듯, 소켓 객체를 생성해서 통신하더라도 결국 해당 객체는 파일로 관리된다. 그러면 소켓에 연결되는 클라이언트가 많으면 많을 수록 OS에서 사용되는 자원은 점점 증가할 것이다.  
그럼 이 때, 시스템의 자원을 효율적으로 사용하기 위해 어떤 방법을 취할 것인가에 대한 고민은 자연스럽게 OS에서 사용되는 자원을 어떻게 하면 효율적으로 관리할 수 있을까가 되어야 한다.

단순히 이렇게 구성해야 한다. 또는 이렇게 하는게 일반적이다. 라고 하는 방법들을 그대로 따라하기 보다는 왜 효율적인지를 한 번 쯤 생각해보고 진행한다면  
어떤 라이브러리, 객체 등을 사용하더라도 프로그램을 구성하는데 크게 어려움이 없을 것이다.

<참고>

[https://d2.naver.com/helloworld/47667](https://d2.naver.com/helloworld/47667)
