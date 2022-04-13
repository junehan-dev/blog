---
title: "What is Async and promise?"
date: 2022-04-07T14:17:07+09:00
categories:
- STUDY
- NODEJS
---

Why Promise?
------------

callback function이 제대로 구현되지 않은 라이브러리가 Node 생태계에 놀라운 속도로 늘어났고, 디버깅 가능성을 줄여놓아 해결할 수 없는 문제로 남았다.

자바스크립트는 Promise라는 구성요소를 추가해 이 문제를 처리했다.

1970년 중반 생겨났고, IO-Bound 작업이 불가피한 서버프로세스 특성상 혹은 마찬가지로 Responsive web application마저도 유행을 타면서 2000년 이후 중흥기를 맞이한다.

Promise는 비동기 콜백 메커니즘을 언어 고유기능으로 포함시키며 라이브러리가 잘못 비동기연산을 수행하지 못하도록 한다.

**기존 콜백패턴인 익명함수를 익명 종료로 끝나는게 아니라, 종료와 동시에 상태를 저장하도록 한다.**

Promise object
--------------

SYNTAX

   ``const prom: Promise = new Promise(executor: (*function(*func, *func));``

DESC

   1. Promise의 인스턴스를 생성할 때,  내부에 2개의 parameter를 지원하는 executor주입해서 인스턴스를 생성한다.

```js
p1 = new Promise((res,rej) => res(2000))
>Promise {
  2000,
  [Symbol(async_id_symbol)]: 3669,
  [Symbol(trigger_async_id_symbol)]: 5,
  [Symbol(destroyed)]: { destroyed: false }
 }
```

   2. executor은 상황에 따라서 Yes or No의 의미를 가진 positional argument 중 하나를 선택해 async_call 종료시 trigger_function 분기처리를 해당 executor context 가 아닌 promise의 context에서 원하는 시점에 값을 추출할 수 있다.

```js
p1 = new Promise((res,rej)=>{setTimeout(()=>res(2000), 1000)})
> Promise {
  <pending>,
  [Symbol(async_id_symbol)]: 2974,
  [Symbol(trigger_async_id_symbol)]: 5,
  [Symbol(destroyed)]: { destroyed: false }
  }
p1.then((d)=>console.log(d));
> Promise {
  <pending>,
  [Symbol(async_id_symbol)]: 3010,
  [Symbol(trigger_async_id_symbol)]: 2974,
  [Symbol(destroyed)]: { destroyed: false }
}
```

   3. promise의 callback인자는 microtask개념으로 다뤄지며, microtask queue에 queue되는 방식으로 관리된다. 해당 queue를(list of reserved callbacks) 순회하면서 종료된(event) callback이 있는지 검사하고, 종료된 callback이라면 대상 callback을 포함하는 promise-instance에 상태를 전환한다.

   4. promise의 callback queue를 확인하는 것은 아래와 같은 순서로 진행된다.

```js
// check async finished handler todo is empty?
while (process.nexttick_queue) { // settimeout(callback)에서 callback, 즉 먼저 종료된 async를 flush해주는 역할
    resolve(process.nexttick_queue.pop());
}

// check async finished while no tick.
while (process.micro_task_queue and not process.nexttick_queue) {
    task = process.micro_task_queue.pop() // setimeout fin이 되면 해당 queue에 추가로 수행해야할 연속성이 기록되고, 그 연속성을 tick으로 이전한다.
    if (task) {
        process.nexttick_queue.push(task);
    }
}
```

   4. 즉 promise는 async건 아니건 callback을 기존 실행 컨텍스트와 분리해서 concurrency(동시성)을 구현해준다. 메인 컨텍스트의 코드를 line by line으로 동기적으로 처리하면서, 중간에 async(I/O)가 예약한 callback을 실행할 수 있는지 주기적으로 확인하는 event loop를 돌면서, 일반적인 javascript동작상태와 async coroutine(별도의 콜스택)을 구성해서 두 개를 주기적으로 cycling하는 개념인데,

      - promise는 async이후에 일어나야할 일들은 순차적으로, 분기를 가지고 실행할 수 있도록 예약하는 역할을 해주어서, callback hell로 인해 문제가 생기는 부분의 coverage를 제공해주는 목적으로 생겨나고, 그렇게 쓰이고 있다.

async
-----

async는 Promise를 produce하는 함수를 선언한다.

기존의 Promise객체를 생성하는 방식을 바로 Promise를 생산하는 함수로 전환해서 콜백을 내부에 포함하는 함수로 선언하는지, 혹은 콜백을 포함하는 Promise객체를 생성하는지의 차이가 있다. 재활용가능성을 올리는 방식으로 사용하고 싶을 때 사용하는 방식으로 아래와 같은 차이를 가진다.

```js
function getUserInfo() {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve({"username" : "test"});
        }, 2000);
    );
}


async function asyncCall() {
  const result = await getUserInfo();
  console.log(result); // username:test
  return "HI";
}

const prom = asyncCall();
prom.then((d) => console.log(d)); // "HI"
```

SYNTAX

   ``async function name([param[, param [,...])``

DESC

   - Promise객체를 생성하면서, 내부에 return으로 resolve를 1회 실행하는 것을 포함한다. 

```js
async function foo() {
    return 1;
}
function foo2() {
    return Promise.resolve(1);
}
out1 = foo1().then ...
out2 = foo2().then ...
```

   - 위와 같이 동일하게 활용될 수 있지만, 아래와 같은 차이가 있다.

```js
const prom = new Promise((res, rej) => {
    res(1);
});

async function asyncfunc() {
    return p; //resolve(p);
}
// 내부에 무엇이 있을지 모르지만 끝에 resolve(p)가 존재 하므로 이어p의 resolve를 이어간다는 점은 동일

const prom2 = Promise.resolve(p);
// p의 resolve를 그대로 이어간다는 진술로 종료


console.log(p === basicReturn()); // true
console.log(p === asyncReturn()); // false

asyncfunc() // 정말 간발의 시간 후에 <pending>에서 1로 전환된다.
Promise {
  <pending>,
  [Symbol(async_id_symbol)]: 2112,
  [Symbol(trigger_async_id_symbol)]: 5,
  [Symbol(destroyed)]: { destroyed: false }
}
> prom2
Promise {
  1,
  [Symbol(async_id_symbol)]: 1543,
  [Symbol(trigger_async_id_symbol)]: 5,
  [Symbol(destroyed)]: { destroyed: false }
}
> prom
Promise {
  1,
  [Symbol(async_id_symbol)]: 1543,
  [Symbol(trigger_async_id_symbol)]: 5,
  [Symbol(destroyed)]: { destroyed: false }
}
```

   - 이 차이는 async function이 기본적으로 await를 포함할 수 있다라는 제한이 붙으면서 일반 promise와 함께 동작하지만 별개의 promise로 생성하는 것과 같다.

   - async function은 ``new Promise(callback)`` 에서 callback만을 분리하고, await을 포함한 것이 되어 Promise와 소통할 수 있지만, 다른 결과 인것을 보면 Promise를 상속받아 오버라이딩한 새로운 Promise로 개인적으로 느껴진다.


