---
title: "Expressjs의 'middleware' terminology"
date: 2022-04-13T00:29:13+09:00
categories:
- STUDY
- NODEJS
tags:
- middleware
thumbnailImage: https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Middleware_Schema.svg/1280px-Middleware_Schema.svg.png
---

SUBJECT: 미들웨어와 Express의 Router
------------------------------------

express의 router는 진짜 middleware라고 할 수 있을까?

middleware의 개념은 software와 hardware사이에 데이터를 전달하는 과정에서 개입하는(전처리 혹은 후처리) 프로그램들을 일컬어 말합니다.


WIKI.MiddleWare
---------------
{{< figure src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Middleware_Schema.svg/1280px-Middleware_Schema.svg.png" title="middleWare의 아키텍쳐" >}}

   middleware는 컴퓨터 소프트웨어의 타입으로, software applications에게 OS가 제공하는 서비스를 제공하는 소프트웨어를 말합니다.
   이것은 *shoftware glue* 라고 불려집니다.

   - 소프트웨어 개발자에게 입출력과 데이터 전달을 쉽게 구현할 수 있도록 도와줍니다.
   - 이로 인해 개발자들은 프로그램 작성이라는 목적에 집중 할 수 있게 됩니다.
   - 이것은 1980년대에, 새로운 어플리케이션과 오래된 시스템을 어떻게 연결할 수 있을까에 대한 해결책으로 인기를 얻게 되었습니다.

Type of middleware
------------------

많은 정의들이 존재하지만 메인 카테고리는 아래와 같습니다.

   - Transactional

      많은 동기적인, 비동기적인 transaction을 수행합니다.
      은행 입출금, 카드거래와 같은 분산시스템들에서 관련된 요청들의 클러스터와 같은 역할을 합니다.

   - Message-oriented

      동기적/비동기적 통신을 지원하는 메세지 큐와 메게지 전달 아키텍쳐

   - Procedural (:무언가를 하기 위한 공식적인 방식 혹은 성립된 방식, 줄여서 절차)

     원격, 로컬 아키텍쳐가 연결, 전달하거나 추적해야할 비동기적인 소프트웨어 response대화 시스템의 커뮤니케이션 지원

   - Object-oriented

      절차적인 지원을 하는 미들웨어와 비슷하지만, 이 타입의 미들웨어는 객체지향 프로그래밍 디자인 원칙을 포함합니다.

      분석적으로, 이것의 소프트웨어 요소는 분산된 객체 request를 통해 객체 레퍼런스, 예외, 상속등의 속성을 포함합니다. (HEAP쪽에 동적할당된 Object참조 등을 지원하는 언어의 컴파일러등을 얘기하는 것 같습니다.)

Express.router
--------------

위 정의로 보았을 때, express의 router는 3번째 카테고리에 속하는 미들웨어의 성격을 가집니다.

``express()``로 실행한 http listening하는 객체는 아래와 같은 property를 지닙니다.

- ``app.inflate``:

   - 압축된 body데이터를 허용하거나 disable합니다. (default: true)
- ``app.limit``:

   - 최대 request body의 size를 조정합니다.
   - 만약 이것이 숫자라면, 값은 바이트 수를 의미합니다. 만약 문자열이라면 숫자로 변환합니다. (default: 100kb)
- ``app.reviver``:

   - 이 옵션은 직접적으로 ``JSON.parse`` 의 두번째 매개변수로 전달됩니다.
   - MDN문서에서 JSON.parse부분을 참고해주세요.(문자열을 json형식 object로 변환하는 Callback함수)
    ``(key, value) => value가 숫자인 문자면? 숫자로.. 등등``
- ``app.strict``:

   - arrays나 Object를 json에서 Value값을 인정할지 인정하지 않은지 결정합니다. (default: true)

- ``app.type``

   - 어떤 media type을 미들웨어가 parse(해석)할지 결정합니다.
   - header에 *Content-Type:mimetype*을 지정하는 것인데, \*/\*, \*/json등으로 광범위하게 content negotiation을 선택할 수도 있습니다. (defualt: application/json)
   - 이 부분은 아래와 같이 실습해보았습니다.
      ```bash
      $ curl --http1.1 -X POST -d content=hi -d title=title -d author=june 127.0.0.1:3000/api/post/ --verbose

      REQUEST 내용
      > POST /api/post/ HTTP/1.1
      > Host: 127.0.0.1:3000
      > User-Agent: curl/7.82.0
      > Accept: */*
      > Content-Length: 34
      > Content-Type: application/x-www-form-urlencoded

      RESPONSE 내용
      * Mark bundle as not supporting multiuse
      < HTTP/1.1 200 OK
      < X-Powered-By: Express
      < Content-Type: application/json; charset=utf-8
      < Content-Length: 140
      < ETag: W/8c-VzO9NjxEYYtsIKIsfwqNbARRxko
      < Date: Tue, 12 Apr 2022 16:23:56 GMT
      < Connection: keep-alive
      < Keep-Alive: timeout=5
      <
      * Connection #0 to host 127.0.0.1 left intact
      ```

      - Content-Type이 다른데도 200을 반환하며 데이터를 저장해주고 있습니다.
      - 이 상태에서 ``app.use(express.json())`` 을 주석처리 하였습니다.

      ```bash
      // app.use(express.json()); <- 주석처리

      POST /api/post/ HTTP/1.1" 500 764 "-" "curl/7.82.0"
      ValidationError: POST validation failed: content: Path `content` is required., title: Path `title` is required., author: Path `author` is required.
      ```

      - 기본 요청을 application/x-www-form-urlencoded로 컨텐츠를 제시했으나, express.json()이 해당 요청의 content를 json으로 변조처리해주었나 봅니다. 이걸 보니 미들웨어라고 부르는 감이 좀 더 오는 것 같습니다.

- ``app.verify``
    
   - 이 옵션은 만약, 기본값인 undefined가 아닌 ``verify(req, res, buf, encoding``으로 호출된다면, body를 해석하는 방식이 전환됩니다.
   - 따라서 body를 잘못해석하게 되면 ``throw error``를 하게 됩니다.

다른 서버 어플리케이션과 프로그램과의 차이
------------------------------------------

1. 일반적인 웹서비스의 개념에서는 많은 서버프로그램이 요청이 들어왔을 때 nginx, apache같은 데몬프로세스가 멀티쓰레딩, 혹은 멀티프로세스, 즉 worker개념을 도입하여 요청당 해당 서버를 동작시키는 방식으로 동작합니다.

   - 따라서 프로그램이 실행되면서 프로그램 내부에서 url을 파싱하는 단계를 거치기 때문에 middleware라고 부르지 않습니다.

2. 반면 node진영에서 express를 사용한 서버는 application이 모든 세팅이 완료된 상태로 대기하고 있는 점에서 차이가 있습니다.

   - application 입장에서는 동작중인 서버프로그램이 이미 동작중인 상태의 것이고 본격적으로 request를 처리할 준비가 되어 있는 입장입니다.
   - 그렇기 때문에 라우터도 동작중인 프로그램이 응답처리 하기 전에 전처리의 개념으로 이해 가능합니다.
   - 정확히는 미들웨어 소프트웨어가 아니기 때문에, 애매할 수 있지만, 이미 동작 중이고 request에 대한 정보만 입력으로 들어오면 바로 출력을 줄 수 있는 상태의 프로그램의 동작지점으로 이해하면 미들웨어 개념이 맞습니다.

EXPRESS Guide.Using middleware
------------------------------

1. Express는?

   - routing과 middleware 웹 프레임웤입니다.
   - **Express application은 본질적으로 middleware 함수 호출의 연속인 개체입니다.**

2. Middleware함수란?

   - ``request object``와 ``response object`` 그리고 request-resopnse 싸이클 속에 존재하는 ``next middleware function`` 에 대한 접근권한을 가진 함수입니다. 
   - next middleware 함수는 일반적으로 ``next`` 변수로 표현됩니다.

3. Middleware함수의 역할은?

   - 어떤 코드건 실행이 가능합니다.
   - request, reponse 객체에 대해서 변화를 줄 수 있습니다.
   - request-response 싸이클을 종료시킬 수 있습니다.
   - stack내부에 다음 middleware함수를 호출할 수 있습니다.

4. Express에서 인정하는 Middleware 타입

   - application-level middleware
   - Router-level middleware *(application level과 동일하다고 합니다.)*
   - Error-handling middleware
   - Built-in middleware
   - Third-party middleware

결론
---

- 동작 중인 프로그램으로 이미 요청을 listening하는 상태로 idle하게 기다리면서 요청이 들어오면 middleware들에 대해 Cycle을 동작시킨다 라는 것이 express에 대한 자신의 소개입니다.
- 따라서 express는 미들웨어를 등록하면 cycle을 도는게 주 목적이며, request를 response로 전환해서 리턴하는 이전에 작업들은 express app의 동작시점에서 전처리과정으로 분류할 수 있다는 이유에서 미들웨어 라우터를 사용하고 있다고 말합니다.


