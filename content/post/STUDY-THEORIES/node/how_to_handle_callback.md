---
title: "how to handle callback?"
date: 2022-04-06T14:17:07+09:00
categories:
- STUDY
- NODEJS
---

callbacks
---------

function는 연속적이지 않은 event를 쉽게 다룰 수 있다.

예를 들어,

   1. user의 행동으로 시퀸스가 시작되고,
   2. server에 request를 생성하고
   3. 최종적으로 server의 응답을 보여준다면,

아래의 경우가 가장 정직한 표현이 될 것이다.

```js
request = prepare_the_request();
response = send_request_synchronously(request);
display(response);
```

이 접근의 문제는, 네트워크IO를 향한 동기적인 request가 client application의 execution context를 frozen state로 한다는 것이다.

만약 network IO나 server application이 느리다면, 응답을 보장할 수 없다.


이에 대한 더 나은 접근은 asynchronous request를 생성하여, callback을 지급해서 server response가 receviced되면 invoke되도록 하는 것이다.

만약 async function이 즉시 return하면, 클라이언트는 block되지 않을 것이다.

```js
request = prepare_the_request();
send_request_async(request, (response) => display(response));
```
___

Bad cases

```js
const CallbackArrow = CallbackArrow || {};

CallbackArrow.root = function() {
    CallbackArrow.first((arg) => {
        CallbackArrow.second((arg) => {
            CallbackArrow.third((arg) => {
              return this //(?)
            };
        }
    }
}


/* FLATTEN CALLBACK */
CallbackArrow.root = function() {
    first_function(callback1);
} 
CallbackArrow.first = function (callback) {
    callback();
}
CallbackArrow.second = function (callback) {
    callback();
}

first_callback = function () {
    CallbackArrow.second(third_callback);
}

```

위의 경우로 악화되는 경우가 있다면 일단 명시적인 프로그래밍 단계로 돌아갈 필요가 있다.

개별적으로 property method를 선언하고 중첩레벨을 제거한다.

콜백패턴의 경우 익명함수로 처리하면, 디버깅이 실행컨텍스트의 네이밍이 없어서 분간하기 어려워진다.
*(특히 익명콜백이 중첩되는 경우는 더욱 그렇다)*

이런 경우에는 모듈패턴을 사용해서 callback을 요구하는 함수를 상위모듈에 놓고 상위모듈이 사용할 callback을 단위 기능 모듈에 정의하고, 상위모듈의 async함수를 실행할 때에 이에 대한 Callback을 주입하는 방식으로 해당 콜백시나리오를 정의하는 것이 도움이 된다.

callback의 존재를 일반함수 처럼 분리할 수 있으며 async코드내의 콜백 의존성 또한 실행 시점 이전까지 제거된 제네릭 콜백을 받는 형태로 코드를 유지할 수 있다.

___

Node js callback pattern
------------------------

```js
const fs = require('fs');
let filename = `${__dirname}/myfile.txt`;
fs.exists(filename, exists => { // 1callback
    if (exists) {
        fs.stat(filename, (err, stats) => { // 2callback
            if (err) {
                throw err;
            }
            if (stats.isFile()) {
                fs.readFile(filename, null, (err, data) => { // 3callback
                    if (err) {
                        throw err;
                    }
                    console.log(data);
                });
            }
            else {
                throw new Error("This location contains not a file");
            }
        });
    }
    else {
        throw new Error("404: file not found");
    }
});
```

callback hell은 callback이후 행동을 계속 구분하여 정의하고 연결할 때 생겨납니다.

어떻게 callback hell을 벗어나는가?

2개의 콜백 중첩을 초과하는 포메팅룰을 팀이 가져간다면 개발속도, 유지보수성 등에서 유의미한 지연이 발생할 수 있다라고 보는 입장이 있는 것 같습니다.

nodejs에서 2개 이상의 콜백을 회피하면서 연속적으로 정의하고 싶다면, distributed events를 사용하는 것을 권유합니다.

```js
// callback chaining with "events" module //
const myEmitter = new MyEmitter();
myEmitter.on('event', () => {
    console.log('an event occurred!');
});
myEmitter.emit('event');
```

그리고 이에 대한 세련되게 콜백을 제어해주는 라이브러리인 async관련 라이브러리를 추천합니다.

```js
// external library "async" //

async.parallel([
    function(callback) { ... },
    function(callback) { ... }
], function(err, results) {
    // optional callback
});

async.series([
    function(callback) { ... },
    function(callback) { ... }
]);
```

- core events: https://nodejs.org/api/events.html
- async lib: https://caolan.github.io/async/v3/


