---
title: "46_77 Permutation_combination"
date: 2022-03-18T20:09:34+09:00
categories:
- PBL
- ALGORITHM
- LEETCODE
tags:
- recursion
---

```python
# joke..
permutation_data = get_perm([1,2,3]);
combination = get_perm([1,2,3,4])[:4] % 4!
```

Permutation
-----------

  - SOURCE: [leetcode 46](https://leetcode.com/problems/permutations/)
  - Solved code: [permutation source file](https://github.com/junehan-dev/Programming_Lectures/blob/LC/LC/46-permutations/PSEUDO.py)

Combination
-----------

  - SOURCE: [leetcode 77](https://leetcode.com/problems/combinations/)
  - Solved code: [combination source file](https://github.com/junehan-dev/Programming_Lectures/tree/LC/LC/4)

PROGRAM
-------

  - Subject

    ``nums``라는 배열이 주어지고, 각자 다른 값의 정수이다.
    가능한 permutations의 모든 것을 반환하라.

  - Contraints

    1. 모든 정수는 고유한 값이다.

ORDER OF PROCEDURE
------------------

  1. 엔트리 포인트에서 첫번째 permutation에 사용할 문자를 지정한다.
  #. 받은 문자열은 다음 엔트리의 loop iteration에서 사용해야 하니 변환하지말고 새로운 값을 복사해 첫 문자로 지정한 문자를 제외한다.
  #. 이것은 끝으로 가면서 하나의 조합이 완성될 것이다. 그러면 재귀이되 꼭 값을 가지고 돌아올 필요까진 없었으나 모든 문자열이 사라진 시점이 ``""`` base case이다.
  #. basecase가 빈문자열을 가지고 돌아오면 해당 문자열의 해당 callee의 스택 내의 개별적인 배열에다(가장 바깥에서 전달받은 문자 순서를 유지한 상태로) 가능한 선택권을 하나씩 선택하고 끝으로 ``""``까지 전달한다.
  #. 아래 부분 조합이 완성되고 ret으로 범위내 permutation셋을 돌려주면 또 이전 인덱스의 for가 기다리고 있다. 그 함수 또한 자신의 선택권 내에서 다음 함수에게 전달할 ``src``에서 자신이 선택한 문자를 제외하고 호출한다.

PSUEDO CODE
-----------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLU_j6_PmIXIf9IPyLYS3Y9DbAw8p5q6feSjQ-wkYAMDWM724LZrzh7Cpv1w1o4hwPN1F5HZsmsFi4AATcF3HAU9nRyIqih0Yl8HglpJD7oIE7jbBT67I-SUhuCKIdnJUchQ7s-OBXXJv3X8xM-FMpI=w971-h1294-no?authuser=0" title="permutation processing" >}}

Process of Solving
------------------

1. 손코딩으로 *nPk*와 내가 생각하는 출력순서 완성순서 등을 생각하면서 적다보니 *PSEUDO*라고 이름 지은 파일에서 시작해서 이전에는 해당 파일을 지우는 것으로 마쳤었는데 *PSEUDO*에서 끝나버렸다.

  - 손코딩으로 Depth의 call마다 전달될 매개변수의 변화에 대해서 정리하고 완성되는 시점에 대해 많이 시뮬레이션 했었다.

  - 데이터가 완성되는 시점은 원래 조정할 수 있으나, f(n)이 만족한다면 f(n - 1)도 만족해야 한다는 팩토리얼의 마음으로 f(0)까지 연결해보고 싶었다. 사실 불필요한 짓이다. 재귀적으로 호출하는 과정에서 ``if not src``로 처리하면 함수 호출을 해당 순열의 개수만큼 줄일 수 있다.

2. combination의 경우는 순열의 총합에 중복도를 나누어주면 되는데, 선택하는 카드의 수의 순열로 나눠주면 원하는 값을 얻을 수 있다.``

  - ~라는 생각을 가지고 손코딩을 해봤는데, 백트래킹은 아직 숙달이되지 않아 하지 않는게 좋은 상태이고 마땅한 공식이 떠오르지 않았다.

  - 순열과는 공식이나 시뮬레이션을 프로그램으로 전환하는 방식이 좀 달랐다 이전에 해당 연속실행이 종료할 시퀸스에서 발생한 것이 아니더라도, 이전에 상당히 거리가 먼 249-942 다른 함수에서 같은 정보를 포함한 적이 있다면 포함해서는 안된다.

    - 그렇다고 쌓인 정보를 함수 내부에서가 아니라 외부에 굳이 저장해야 할만큼 해결책이 없을 만한 문제 같지도 안았고, 매번 완성전에 배열 중복조합 체크를 해야한다는 것은 끔찍하다.

  - 그래서 순열을 재활용하여 key-value pair자료형에 해쉬키를 사용하는 게 어떨까 싶다가, python은 collections.Counter객체로 byte들을 문자로 갯수별 정렬해주는 collection을 사용해보았다. 아래와 같이 길이만 줄여서 가져오는 방식으로, 213 123등을 가져오긴 하나..

  ```python
  def combination(n, k):
      ret = [];
      sets = permutation([], src, k);
      [ret.append(c) for c in iter(map(Counter, sets)) if c not in ret]
      return [list(uniq.keys())for uniq in ret];
  ```

  - 동작은 잘 되는데 역시 문자열 배치를 한 set별로 다 가져오는거에서 *Time Limit Exceeded*라고 한다. 

  - 그래서 마감 30분 전에 포기해야하나 고민했었는데, 예전에 조합할 때 사용했던 방법인, 123~789를 출력하는 아주 쉬운 기법이 생각나서 적용했다.

  - 오늘 배운 graph순회에서 매개변수에 log정보를 함께 전달해서 처리하는 것과 비슷한데, 순열과 조합의 가장 큰 동작방식의 차이는 이전에 내가 src의 대상이 내 선택으로 인해서 다음에 사람이 선택할 수 있는 것이 제한된다. 순열에서는 이전에 선택한 문자만 제한했다면, 조합에서는 이전에 선택하지 않은 문자도 다른 선택에 포함되어 있다면, 포함해서는 안된다.

    ```python
        if not src or not k:
            return [];

        ret = [];
        for base in src:
            nsrc = src[src.index(base) + 1:]; """<<<
        src에서 loop char을 제거하는 방식에서 src이전을 잘라내는 방식,
        이 선택값 이전의 값은 선택 할 수 없다."""
            permutations = permutation_2(dest + [base], nsrc, k-1);
            ret += (permutations);

        return (ret)
    ```

  - 물론 오늘 배운 내용을 활용하기에는 아직 무리가 있다고 생각해서 하지 않았지만, (백트래킹 같은거 오늘 처음 배웠지는 않고 처음 봤죠..) 

> 신이 주신 배열에게 감사한다. 고마워요 리치!
