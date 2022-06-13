---
title: "NodeJS가 non-blocking single-thread로 Eventloop 수행하는 방식"
date: 2022-04-14T13:15:39+09:00
categories:
- STUDY
- NODEJS
tags:
- translate
- polling
keywords:
- nodejs
- eventloop
thumbnailImage: http://docs.libuv.org/en/v1.x/_static/logo.png
---

SUBJECT: NODEJS의 Event driven이 무엇인지 정확히 알자
-----------------------------------------------------

Objectives

   - NODEJS Engine이 수행하는 event loop의 순서와 개연성에 대해 이해해보자.

References

   - https://nodejs.org/en/docs/guides/event-loop-timers-and-nexttick/#process-nexttick
   - https://nodejs.org/dist/latest-v17.x/docs/api/process.html#processmemoryusagerss 

What is Event loop?
-------------------

프로세스를 벗어난 작업을 처리하기위해 우리는 OS의 기능에 의존하는데,

(자바스크립트는 single-threaded임을 고려했을 때 완전히 제어권을 잃을 수 밖에 없다.)

이벤트 루프란 Node.js에게 있어서 context-switching에서 blocking을 막는 non-blocking I/O를 수행하기 위해 kernel에 operation에 대한 처리를 위임하는 것을 가능하게 하는 것이다.

현대적인 Kernels가 대부분 Multi-threaed를 구성하기 때문에, 그들이 다수의 operations를 background에서 수행할 수 있다.

   - nonblocking이란 CPU가 여유자원을 thread에게 주기적으로 분배해서 polling하는 것을 기반으로 가능한 것인데,

      - js execution context
      - nodejs core object
      - blocking i/o ABI

   - 위의 사항들이 동시적으로 수행가능한 것은 역시 js 인터프리터가 여러쓰레드를 사용해서가 아니라,
   nodejs의 core중 libuv object가 4개의 쓰레드를 사용하기 때문에 nodejs의 core의 component가 해당 thread를 잘 사용하고있고, *(왜 브라우저 탭당 최대 4개의 ajax를 허용했었는지 우연이 여기에서 잡힌다.)*

   - 프로그래머는 javascript execution context, 즉 interpreter 가 동작하는 내부에서 상위의 추상화는 V8엔진에게 위임하고 프로그램을 동작시키는 논리를 이어서 작성해도 되는 것이다.

systemcall이 종료된 I/O operation들은 nodejs에게 signal을 전달해 micro task queue에 map된 callback을 pollqueue(tick queue)로 이동시켜 결과적으로 수행되는 과정을 거친다.

Event Loop Operation's order: Phases
-------------------------------------

각 단계는 *"phase"* 라는 키워드로 부른다.

   1. timers
   2. peding callbacks
   3. idle, prepare
   4. poll
      - incoming: connection
      - incoming: data
      - incoming: etc
   5. check
   6. close callback
   7. loopback to timers

각 phase는 FIFO queue의 callback 저장소를 지니고 있다.

개별 phase의 callback queue를 모두 소진할 때까지 수행한뒤, 다음 phase로 이동한다.

Phases 설명
-----------

- *timers*

   ``setTimeout, setInterval`` 에 대해 스케쥴 된 callbacks를 수행한다.

- *pending callbacks*

   다음 loop iteration에 수행될 I/O  callbacks를 실행한다.

      예를 들면 TCP socket이 ``ECONNREFUED`` 같은 signal을 받았을 때, 이에 대한 에러를 보고하려고 대기하고 있는데, 이것이 pending callback phase에서 queue된다.

- *idle, prepare*

   내부적으로만 사용되는 상태

- *poll*

   새로운 I/O event를 추적한다. I/O와 관련된 callback을 실행한다.

   1. I/O를 대상으로 poll을 하는데 걸리는 시간, 그에 따라 block의 시간을 계산한다.
   2. poll queue의 events를 처리한다.

   - if pollqueue.isempty() == true?

      - pollqueue의 callback queue를 순회하며 동기적으로 실행한다.

   - if pollqueue.isempty() == false?

      - ``setImmediate`` 에 의해 스케쥴된 스크립트가 있다면, pollphase를 종료하고 check phase로 이동하서 해당 스크립트를 실행한다.
      - ``setImmediate`` 에 의해 스케쥴된 스크립트가 업다면, queue에 들어올 callback을 대기하고 그들을 즉시 실행한다.

   한번 poll queue가 비어진 상태가 되고 나면, event loop는 timers를 체크하여 임계점(thresholds)에 도달한 것을 확인한다.

   만약 한개 이상의 timer가 준비되었다면, event loop는 timer phase로 돌아가서, timers의 callback을 실행한다.

- *check*

   ``setImmediate()`` 의 callback이 여기서 호출된다.
      
- *close callbacks*

   다른 close callbacks. (``socket.on("close", ...``\) 즉, 소켓이나 handle이 지어상적으로 닫혀진 것이라면, ``close`` 이벤트가 이 phase에서 emit된다.

   그렇지 않으면(정상) ``process.nextTick()`` 에 의해서 emit될 것이다.

*각 event loop가 시작하기 이전에, Node.js는 대기하고 있는 asynchronous I/O가 있는지 확인한다.*

process.nextTick()
------------------

상위 명시된 이벤트루프에서 ``process.nextTick()`` 이 누락 되어있는 것을 확인할 수 있는데,

``process.nextTick()`` 대신에 ``nextTickQueue`` 가 현재 명령이 종료되면 phase와 무관하게 진행되게 된다.

```javascript
const server = net.createServer(() => {}).listen(8080);
server.on("listening", () => {});
```

1. port가 전달되고 나면, process에 대한 Port는 바로 열리게 된다.
2. 하지만 listening의 callback은 원래 바로 실행되어야하는데, 문제는,
3. listening에 대한 callback이 port가 열린 순간에는 준비 되지 않았다는 것이다.


이에 기초하여, listening event는 ``nextTick()`` 에 enqueued되어 script가 종료를 향해 동작할 수 있도록 한다.

이것이 유저가 어떤 이벤트 핸들러든 원하는 것을 등록할 수 있도록 하는 것이다.

왜 process.nextTick()을 사용하는가?
-----------------------------------

2가지 이유가 있다.

1. 유저가 error를 컨트롤 할 수 있도록하고, 불필요한 자원을 삭제하거나, 이벤트 루프가 계속되기 이전에 request를 한번 시도할 수 있도록 한다.
2. 때때로, callback들이 callstack이 만들어진 이후, 그리고 event loop가 계속되기 이전에 동작하도록 허락해야할 필요가 있다.

```javascript
const server = net.createServer();
server.on("connection", (conn) => {});
server.listen(8080);
server.on("listening", () => {});
```

이 경우에는 nextTick을 사용하지 않았기 때문에, listening event에 대한 callback이 등록되기 이전에 connection이 일어날 수 있다.

```javascript
const EventEmitter = require("events");
const util = require("util);

function MyEmitter() {
    EventEmitter.call(this);
    this.emit("event"); // 이 부분에서 event는 등록되지 않은 상태. 의미가 없다.
}
util.inherits(MyEmitter, EventEmitter);

const myEmitter = new MyEmitter(); // 의미없는 이벤트 동작
myEmitter.on("event", () => {
    console.log("an event occured!");
}); // 이미 이벤트 지나감
```

```javascript
function MyEmitter() {
    process.netTick(() => { // tickqueue에 enqueue
        this.emit("event");
    });
}
const myEmitter = new MyEmitter(); 
myEmitter.on("event", () => {
    console.log("an event occured!");
});
// 메인이 종료되었기 때문에 Eventloop 검사 -> 발생
```

이해는 잘 안가지만 async 인터페이스에 대한 실행 순서
----------------------------------------------------

```javascript
const process = require("process");
let counter = 0;
process.on("beforeExit", (code) => {
        console.log("Process will be exit with exit: ", code);
});

process.on("exit", (code) => {
        console.log("Process exited with code: ", code);
});

/* Your code goes... */
function write(d) {
        process.stdout.write(`data recevied: ${d}: counter: ${counter}\n`);
}
function run_as_async(data, cb) {
        const st = setTimeout(() => {++counter; cb(data + " with setTimeout.")}, 0);
        const nt = process.nextTick(() => {++counter;cb(data + " with tick")});
        const prom = new Promise((res, rej)=> res(data + " with promise1")).then((d) => {++counter;cb(d)});
        const mt = queueMicrotask(() => {++counter;cb(data + " with Microtask")});
        const prom2 = new Promise((res, rej)=> res(data + " with promise2")).then((d) => {++counter;cb(d)});
        console.log(st);
        console.log(nt);
        console.log(mt);
        console.log(prom);
}

function main() {
        run_as_async(`hi at async ${counter}`, write);
        write(`hi at sync.write counter`);
        console.log(`hi at sync.console.logcounter: ${counter}`);
}

main();
write(`all sync finished, EVENT loop.write counter`);
console.log(`all sync finished, EVENT loop.console.log counter`);
/* Your code ends... */

/* OUTPUT
Timeout {
  _idleTimeout: 1,
  _idlePrev: [TimersList],
  _idleNext: [TimersList],
  _idleStart: 69,
  _onTimeout: [Function (anonymous)],
  _timerArgs: undefined,
  _repeat: null,
  _destroyed: false,
  [Symbol(refed)]: true,
  [Symbol(kHasPrimitive)]: false,
  [Symbol(asyncId)]: 5,
  [Symbol(triggerId)]: 1
}
undefined
undefined
Promise { <pending> }
data recevied: hi at sync.write counter: counter: 0
hi at sync.console.logcounter: 0
data recevied: all sync finished, EVENT loop.write counter: counter: 0
all sync finished, EVENT loop.console.log counter
data recevied: hi at async 0 with tick: counter: 1
data recevied: hi at async 0 with promise1: counter: 2
data recevied: hi at async 0 with Microtask: counter: 3
data recevied: hi at async 0 with promise2: counter: 4
data recevied: hi at async 0 with setTimeout.: counter: 5
Process will be exit with exit:  0
Process exited with code:  0
*/
```

