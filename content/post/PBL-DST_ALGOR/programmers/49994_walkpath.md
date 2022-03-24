---
title: "49994_walkpath"
date: 2022-03-24T14:18:08+09:00
categories:
- PBL
- ALGORITHM
- PROGRAMMERS
tags:
- graph
---

타겟 넘버
---------

  - SOURCE: [PG 49994. Walkpath](https://programmers.co.kr/learn/courses/30/lessons/49994)

  - Solved code: [my github Sourcecode](https://github.com/junehan-dev/Programming_Lectures/blob/PG/PG/49994/walk_path.py)

PROGRAM
-------

  - Subject  
    문자열로 4가지 명령어들이 조합되어 입력됩니다. "UDRL"로 (0,0)의 좌표평면에서 시작하여 최대 (5 ~ -5, 5 ~ -5)의 크기를 가지는 지도에서 명령어대로 이동하고, 중복되지 않는 path를 이동한 횟수를 출력하시오.

```python
INPUT_CMDS = "ULURRDLLU"
OUTPUT = 7;
```

ORDER OF PROCEDURE
------------------

  1. 입력데이터를 현재 위치에 대하여 값의 변화를 줄 수 있는 인터페이스를 만든다.
  2. 좌표평면의 이동을 기록할 수 있는 데이터를 어떤식으로 저장해야 출발좌표와 이동좌표의 중복을 처리할 수 있을지 고민하여 Set형식의 데이터에 Set형식의 값을 저장하는 방식으로 결정하였다.
  3. 커맨드에 대해 Iteration을 수행하는 ``walk(cmds, log)`` 함수를 작성했다., 현재좌표는 Iteration에서 언제나 접근할 수 있도록 설정한다.
  4. 이동좌표에서 목적좌표로 이동할 때, 반대에서 온 기록이 있는지 검사한 후에 등록할 수 있도록 ``register(log, cur, cmd)`` 함수를 작성했다.

Process of Solving
------------------

1. 처음에 데이터를 어떻게 저장할지 생각하다가 2차원 배열을 먼저 선택했는데, 부적절함을 알게되었다.
    - 0번 인덱스 row에서 -1인덱스 row로 이동하는 것도 이동하는 것도 추가작업이 불가피하고,
    - 면적을 이동하는 개념이 아니라 선을 따라 이동하는 개념이라 10x10의 지도가 아니라 10x10의 면적을 구분하는 경계선으로 이동 중복을 처리한다.
      - 이는 10x10이 아니라 11x11이다.

2. 이에 따라 해쉬키 값을 ``log["0100"], log["0001"]`` 같은 식으로 저장하도록 파이썬의 dictionary를 선택했고 내부 저장 데이터는 개별 지점에서의 중복체크를 피할 수 있도록 set(hash key sequence)를 선택했다.
    - log데이터 중, "0001"에 대응하는 sequence에 "0101"을 저장하는 과정에서 log["0101"]의 해쉬키가 존재하는지, 존재한다면 그 안에 "0001"의 키가 포함되어 있는지를 검사하고 없을 경우 등록하지 않는다.
      - iteration외부에서 유지되는 ``cur``이라는 현재위치 배열 데이터에 변화값을 반영한다.
    - 기록에서 중요한건 중복이 있는 기록이 없도록 하고, 현재 위치만 잘 유지한다면 프로그램의 목적을 잘 달성할 수 있다.

