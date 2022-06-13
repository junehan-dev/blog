---
title: "How Object work?"
date: 2022-04-06T00:17:07+09:00
categories:
- STUDY
- NODEJS
---

자바스크립트는 object라는 단어를 overload했다.

object

   - javascript의 primitive data structure. 
   - container of 속성, 혹은 멤버.

object.property

   - 각 property는 name과 value로 구성된다.
   - name은 string으로 결국 치환된다.
   - value는 최대의 자유도를 보장 받는다.
   - 아래의 것들이 property가 된다.

      - ``f = {"string": val}`` OR  ``f = {string : val}`` 는 동일하다.
        - f``<name>`` 은 이후 문자열로 전환된다.
      - parameter list를 감싸서 등장하며 function body인 '{' 가 뒤따르는 경우.(함수인 경우)

   - object의 property가 존재하지 않을 경우 undefined를 기본으로 하기 때문에, 구분을 위해 undefined를 저장한 property는 쓰지 않는 것을 권유한다.
   - 성숙한 data structures들은 objects 외부에서 생성될 수 있다, 왜냐하면 objects를 reference하는 것이 object에 저장될 수 있기 때문이다.
   - 모든 종류의 graph들과 순환형 자료구조들이 생성가능하다.
   - nesting 깊이의 제한이 없지만, 이것이 문제를 일으키진 않는다.

```js
// 순환 참조
a.link_a = copy;
copy.link_copy = a;
a: <ref * 1> { link_a: [Circular * 1] };
copy: <ref * 1> { link_copy: [Circular * 1] };
```

copy of object

```js
   let my_copy = Object.assign({}, origin); // copy object
   my_copy += 1;
   my_copy.bar;// 39
   my_copy.age += 1;
   my_copy.age;// 40 
   delete(my_copy.age); 
   my_copy.age;// undefined
``` 
   - object는 데이터를 어떤 object를 상속한 대상이라면 무엇이던 assigned 될 수 있다.
   - 같은 방식으로, 복잡한 object는 단순한 object의 조합으로 구성할 수 있다.

inheritance와 prototype chainning

   - ``Object.create(prototype)`` 은 prototype object를 상속받는 새로운 object인스턴스를 반환한다.
   - 상속 prototype chain에는 깊이에 대한 제한은 없지만, 그들을 짧게 하는 것이 현명하다.
    
```js
a = {1:14};
b = Object.create(a); // {} empty
a.hi = "HI";
b.__proto__ === a // true
b.__proto__.__proto__  // Object
b.__proto__.__proto__.__proto__ === null //  true
b['1']; // 14
b.hi; // "HI"
```

   - object타입은 존재하지 않는 property에 접근을 시도하면, MRO를 따라 prototype chaining 상 가장 가까운 상속자의 property를 반환할 것이다.  
   - 상속이 존재하기 때문에 2개 타입으로 property접근이 일어난다.

      1. ``hasOwnProperty``로 확인할 수 있는 top level property
      2. *inherated* property로 prototype chain을 통해 접근하는 property.

      - 두 방식 모두 동일한 기능을 수행하지만, 때로 해당 객체레벨에서 선언된 Property인지 확인해야하는데 hasOwnProperty는 상속되지 않은 유효한 property인지를 확인하는데 사용된다.

```js
objorigin.hasOwnProperty("bar");  // true
objcopy.hasOwnProperty("bar"); // true
objclone.hasOwnProperty("bar");  // false
```
   - Object.create의 경우 상속을 통한 객체생성을 지원하기 때문에, Object.assign으로 mix object를 생성하는 것보다 메모리 효율적이다.
      - 대부분의 경우 그렇게 중요한 일은 아닐 것이다.

   - Object.create으로 인스턴스를 생성하는 것은 생각보다 많은 내장 key들을 포함한다. ``constructor`` , ``toString`` 등이 있는데, 단순히 데이터를 저장하는 용도, hashtable로 object를 사용하고 싶다면 ``Object.create(null)`` 을 사용하는 것이 불필요한 상속을 막아준다. 현재 더글라스 크락포드는 이 방식을 애용하고 있다고 한다.


```js
normal = {'a' : 2};
normal.toString(); // [Object Object]
clean = Object.create(null);
clean[1] = [2,4,5];
clean.toString // undefined
clean.constructor // undefined

for (path of clean[1])
  console.log(path);

function CleanHash() {
  return Object.create(null);
}
``` 

for statement

```js
for (let i = 0; i < max_len; i++)  {

} // old 
```

- 고전적인 for loop는 control(goto)개념과 manual한 (if -> do)로 구성되기 때문에 statement중에서도 최악의 퍼포먼스를 자랑한다.
- 다른 언어에서도 for를 객체의 길이 등에 의존하는 방식으로 내부 인터페이스를 사용하도록 변화하고 있는데, 두 인터페이스의 뉘앙스는 아래와 같이 구분한다.

```js
keymap = {1:2, 3:4};
sequence = [1,2,3,4];

for (key in keymap) console.log(key);
for (element of sequence) console.log(element);
```

- 그렇다고 두개의 동작방식이 다른 것은 아니다. 하나는 Object.keys를 사용하고 하나는 Object.values를 사용한다.

```js
sequence = [121,242,323,41];
Object.keys(sequence); // [0,1,2,3]
Object.values(sequence); // [121,242,323,41];

obj = {"1" : 4, 2: "5"}
Objects.keys(obj) // ["1", "2"]
Objects.values(obj) // [4, "5"]
```


