---
title: "How_js_works"
date: 2022-04-06T00:17:07+09:00
categories:
- STUDY
- JS
---

How Object work?
-----------------

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

   - object타입은 존재하지 않는 property에 접근을 시도하면, MRO를 따라 가장 가까운 상속자의 property를 반환할 것이다.  


