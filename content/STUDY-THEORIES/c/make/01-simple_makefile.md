---
title: "make-01-Simple makefile"
date: 2022-04-05T22:02:40+09:00
categories:
- STUDY
- C
- MAKE
thumbnailImage: https://cdn.dribbble.com/users/6491/screenshots/2725990/makefile-logo-selected.png
tags:
- GNU
---

How to write simple makefile?
-----------------------------

Intro
-----

프로그래밍의 기술은 주로 간단한 루틴의 [파일 편집, 소스파일 컴파일, 디버깅]이 뒤따른다.

소스파일을 컴파일하는 과정이 종료되었을 떄, 프로그래머는 많은 시간을 문제를 해결하는데 시간을 허비할 수 있다.

대부분의 개발자들은 function modification과 새로운 코드를 동작켜서 그들의 변화가 버그를 수정하지 못했다는 것에 좌절을 느낀다.

이후 그들은 그들이 수정한 함수를 실행한 적이 없다는 것을 알게되는데, 아마 그들의 recompile, relink 또는 rebuild a jar에 실패했기 때문일 것이다.

더욱이 프로그램의 복잡성이 증가하면서 에러에 취약한 상태가 되는데, 그들의 다른 버전들이 개발될 수록 그렇다, 아마 다른 플랫폼이나 다른 버전의 외부라이브러리등이 이유가 된다.

``make`` 프로그램은 거대한 측면의 소스코드 컴파일을 자동화하기 위해 생겼다.

``make`` 를 통한 이점으로는 당신의 프로그램의 요소들의 관계를 정의할 수 있다는 것이고, 그러한 관계와 timestamp가 즉각적으로 다시 새로운 프로그램을 생성해야 한다는 것을 감지한다는 것이다.

이 정보를 사용해서, ``make``는 빌트 프로세스를 불필요한 과정에서 최적화한다.
___

*GNU make* 는 이것을 세심하게 처리한다.

``make`` 는 소스코드, 복합파일과 실행 프로그램들의 관계를 묘사하는 언어를 정의한다.

이것은 또한 대체적인 설정, 재사용사능한 라이브러리의 명세, 파라메터화된 프로세스들을 user-defined macros로 관리하는 기능을 제공한다.

짧게 말해서, ``make``는 application의 컴포넌트의 로드맵을 제공하면서 개발 프로세스의 중심으로 여겨진다.

Process of Make
---------------

makefiles의 most default goal는 프로그램 build이다.

이것은 주로 많은 단계를 포함하는데,

1. source compiled into binary object files.
2. 이후 object files가 linker에 의해 together bound되며,(주로 *complier gcc*\)
3. executable program을 형성한다.

- ``make`` 의 원리는 빌드를 위한 복합적인 순차적인 커맨드들 수행하고, 
- 이러한 명령들을 최적화하여, **edit-compile-debug** 싸이클의 시간을 줄인다.

더욱이 ``make`` 는 portablity가 끝장난다.

``make`` 가 *rule* 을 평가하는 것을 요청받았을 때,

1. begins by finding the files indicated by the prerequisites and target.

   - 만약 어떤 prerequisites가 관련된 rule이 있을 때 make는 그들을 최초로 업데이트를 시도한다.

2. targetfile이 고려된다.
3. (만약pre_reqs들이 target보다 timestamp가 latest하면) target은 recompiled된다.

**각 커맨드들은 shell에 전달되고, 자체 subshell에서 실행된다.**


Dependency Checking
-------------------


