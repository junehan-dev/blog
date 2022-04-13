---
title: "why json works?"
date: 2022-04-06T14:17:07+09:00
categories:
- STUDY
- NODEJS
---
 
JSON은 다른 언어끼리 데이터를 효과적으로 교환하는 것을 가능하기 위한 목적을 두고 있다.

모든 언어는 다른 선형시퀸스의 Data structure, character set, integer data format등을 가지고 있지만,
프로그래밍 언어들사이의 모든 접점을 찾는 것으로 모든 프로그램들은 서로 대화를 나눌 수 있다.

JSON Object
-----------

js에서는 ``JSON object`` 의 2개의 함수를 통해서 JSON을 지원한다.

그들은 ``parse`` 와 ``stringify`` 인데, 그것은 온전한 나의 실수이다.

   - 나는 ``parse`` 를 나쁜예시의 ``Date`` 함수를 참조하다가 선택해버렸다.
   - ``stringify`` 를 고른 것은 ``toString`` 이 올바른 표현같지 않아보였기 때문이다.

나는 그들을 ``decode`` , ``encode`` 로 했어야 했다.

1. ``JSON.parse(text[, reviver])``

``parse`` function은 JSON text를 받아 js data로 변환한다.

``reviver(key, value) -> value for key`` function은 transformation을 할 수 있다. 

2. ``JSON.stringify(value[, replacer[, space]])`` 

``stringify`` function은 value를 받아 JSON text로 encode한다.

``replacer(key, value) -> string value for key``

```js
const json_text = JSON.stringify(obj, (k, v) => {
        (value instanceof Date) ? value.toISOString() : value;
    }
);
```

JSON format은 whitespace를 허용하여, 가독성을 증진시킨다.

기본-동작으로, compact를 위해 추가적인 whitespace를 더하지 않는다.

만약 ``space`` param이 사용되면 line break와 indentation이 삽입된다.

JSON Grammar
------------

- json
   - element
- value
   - object
   - array
   - string
   - number
   - "true"
   - "false"
   - "null"
- object
   - '{' ws '}'
   - '{' members '}'
- member
   - string ':' element
- array
   - '[' ws ']'
   - '[' elements ']'
  
container를 수용하기 때문에, Interpolate(연결) 하기 매우 간편하다.

```js
[
    {
        "first": "Jerome",
        "middle": "Lester",
        "last": "Howard",
        "nick-name": "Curly",
        "born": 1903,
        "died": 1952,
        "quote": "nyuk-nyuk-nyuk!"
    },
    {
        "first": "Harry",
        "middle": "Moses",
        "last": "Howard",
        "nick-name": "Moe",
        "born": 1897,
        "died": 1975,
        "quote": "Why, you!"
    },
    {
        "first": "Louis",
        "last": "Feinberg",
        "nick-name": "Larry",
        "born": 1902,
        "died": 1975,
        "quote": "I'm sorry. Moe, it was an accident
    }
]
```

