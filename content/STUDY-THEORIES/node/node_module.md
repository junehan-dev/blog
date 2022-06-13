---
title: "commonjs의 require동작 순서"
date: 2022-04-13T22:02:13+09:00
categories:
- STUDY
- NODEJS
tags:
- module
---

NodeJS의 모듈 시스템과 commonjs
-------------------------------
  - References
    - https://en.wikipedia.org/wiki/CommonJS

commonjs
--------

> CommonJs는 자바스크립트 일반실행 환경에서 모듈 순환시스템(eco system)을 성립시키기위해 Mozila의 팀에서 생성된 프로젝트입니다.

requriejs의 require동작방식
---------------------------

- 모듈을 못찾았을 때

```javascript
const target = "./require2";
const resolve = require.resolve;
const paths = require.resolve.paths;
const 절대경로 = paths(target); // 절대경로 정보
console.log(절대경로); // 파일명 제외
/*[
  '/home/junehan/Documents/POSTINGS/hugo_blog-Diary_Study/content/post/STUDY-THEORIES/node' // 첫번째 탐색 주소
]*/

const 해석결과 = paths(절대경로[0]); // 파일명 제외-> 못찾았다
[
  '/home/junehan/Documents/POSTINGS/hugo_blog-Diary_Study/content/post/STUDY-THEORIES/node/node_modules', // 상대패스로 존재하지 않았다면?
  '/home/junehan/Documents/POSTINGS/hugo_blog-Diary_Study/content/post/STUDY-THEORIES/node_modules',
  '/home/junehan/Documents/POSTINGS/hugo_blog-Diary_Study/content/post/node_modules',
  '/home/junehan/Documents/POSTINGS/hugo_blog-Diary_Study/content/node_modules',
  '/home/junehan/Documents/POSTINGS/hugo_blog-Diary_Study/node_modules',
  '/home/junehan/Documents/POSTINGS/node_modules',
  '/home/junehan/Documents/node_modules',
  '/home/junehan/node_modules',
  '/home/node_modules',
  '/node_modules',
  '/home/junehan/.node_modules',
  '/home/junehan/.node_libraries',
  '/home/junehan/.nvm/versions/node/v16.13.2/lib/node'
]
// MODULE_NOT_FOUND error가 thrown 됩니다.
```

- 모듈을 찾았을 때

```javascript
const 절대경로 = paths(target); // 절대경로 정보
console.log(절대경로);
const 해석결과 = resolve(절대경로[0]+"/require2"); // 파일이 있을 경우
console.log(해석결과);
console.log("hello from module1");
console.log(required);
```

- 대상 모듈

```javascript
console.log("안녕 from module2");
module.exports.message = "hi";
```

- 평가 결과

  ```bash
  $ node require_module_1.js
  hello from module1
  안녕 from module2
  { message: "hi" }
  ```

대상파일을 검사하여 ``module`` 모든 식을 평가하고, module에 Export된 대상을 require객체로 돌려줍니다.
