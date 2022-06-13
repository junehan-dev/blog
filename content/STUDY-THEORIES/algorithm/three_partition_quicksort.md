---
title: "Quicksort improved, three-partition-quicksort"
date: 2022-03-28T21:11:10+09:00
categories:
- STUDY
- ALGORITHM
- SORTING
- QUICKSORT
tags:
- sorting
thumbnailImage:  https://lh3.googleusercontent.com/pw/AM-JKLV_H3bsAyCGCnydzO6hdDXJJ67H-4nEv87wpNouxULo6McuckiQ81-fO8VPFnsxaT_aVKjpWTivXs1O7tk4aG2dG3mXzwoKmwsFkoFGD_WwyzGOSmerY4Qb1OCfMPp_EC0_zyGYpqKh3lFIrNWyiblu=w971-h1294-no?authuser=0---

SUBJECT: Three partition quicksort
----------------------------------
- References

  >  book, "algorithm" author: *Robert Sedgewick*

- Source code:  https://github.com/junehan-dev/py-libs-dst/blob/main/sort/3partition_qsort.py

  - *이 코드에 대해 주석을 포함한 소스코드를 작성했습니다.  
  원본 내용의 코드를 정말 존중하고 있습니다만, 맥락을 스스로 이해하기에 너무 깔끔한코드 라고 생각되어 변수명을 수정한 버전의 코드 입니다.*

Quicksort의 성능 개선법 
-----------------------

quicksort로 해결해야하는 문제가 있었는데, 쓴지가 너무 오래되서 기억나는대로 써봤는데 전혀 먹질 않았다.  
책을 읽으며 방법론을 다시 점검하다가 더 개선된 방법에 대해서 적혀 있어서 같은 걸 다시 쓰려고 노력하지 않아도 된다는 기쁨에 손코딩을 하면서 문제를 해결했고, 이것이 어떤 개선점이 있는지에 대해서 짧게 기술하려한다.


- 성능 개선법

  1. 삽입정렬로의 컷 오프 전환(Cut-off trasition by the insertion sort)
    - 작은 부분배열까지 나눠진 상태에서는 Insertion이 더 낫다.

  2. 3-중앙값 분할(collect three samples to enclose the better average)
    - 샘플에서 보통 3개의 데이터를 수집하여 조금 더 중앙에서 divide할 수 있도록 가능성을 올리는 것.

  3. 엔트로피 최적정렬(better sorting by not to operate useless sorting process)
    - 분류작업 중에 낭비되는 과정을 유효하게 사용할 수 있도록 전환한다. 

*"이 중에 3번에 해당하는 중복 값을 한 시퀸스 내에서 처리하는 방식이다."*

Three-partition quicksort
-------------------------

- Quicksort

  - Pivot Value (hope to be average)
  - left-partition includes smaller value from Pivot
  - right-partition includes larger value from Pivot
  - **(+ Three-partition quicksort) Pivot value set**

이전에도 중복값이 있는 상황을 체크하지도 않았고,  
깊이 생각하고 사용하지도 않았기 때문에 지나쳤지만 일부 그런 상황을 해결해야하는 문제가 있다.

그럴 때 위의 파티션을 추가하면 매우 좋은데 Pivot값을 left-P로 처리해버려서 같은 pivot이 재귀함수에서 중복되어 잡힐 수 도 있다.

아래 사진의 코드에서 재귀호출을 하기 전에 최초 qsort의 프로세스를 추적해서 적었다. ``C, B, A, C, A, D, E, A, C``를 처리하는 순서는 빨간색 펜으로 번호가 매겨져 있고,
위쪽에 있는 부분은 이를 처리하기 위한 추가적인 Auxilary에 대한 내용이다.

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLV_H3bsAyCGCnydzO6hdDXJJ67H-4nEv87wpNouxULo6McuckiQ81-fO8VPFnsxaT_aVKjpWTivXs1O7tk4aG2dG3mXzwoKmwsFkoFGD_WwyzGOSmerY4Qb1OCfMPp_EC0_zyGYpqKh3lFIrNWyiblu=w971-h1294-no?authuser=0" title="3partition-quicksort coded by writting" >}}

이 함수를 실제로 동작시키면 아래와 같은 로그를 얻을 수 있다.

```python
======START=======
PIVOT: C
qsort left:[LEFT:lt+1]- ['B', 'A', 'A', 'A']
qsort fixed:[lt+1:gt+1]- ['C', 'C']
qsort right:[gt+1:RIGHT+1]- ['E', 'D', 'C']
['B', 'A', 'A', 'A', 'C', 'C', 'E', 'D', 'C']
======FIN=======
======START=======
PIVOT: B
qsort left:[LEFT:lt+1]- ['A', 'A', 'A']
qsort fixed:[lt+1:gt+1]- ['B']
qsort right:[gt+1:RIGHT+1]- ['C', 'C', 'E', 'D', 'C']
['A', 'A', 'A', 'B', 'C', 'C', 'E', 'D', 'C']
======FIN=======
======START=======
PIVOT: A
qsort left:[LEFT:lt+1]- []
qsort fixed:[lt+1:gt+1]- ['A', 'A', 'A']
qsort right:[gt+1:RIGHT+1]- ['B', 'C', 'C', 'E', 'D', 'C']
['A', 'A', 'A', 'B', 'C', 'C', 'E', 'D', 'C']
======FIN=======
======START=======
PIVOT: E
qsort left:[LEFT:lt+1]- ['D']
qsort fixed:[lt+1:gt+1]- ['E']
qsort right:[gt+1:RIGHT+1]- ['C']
['A', 'A', 'A', 'B', 'C', 'C', 'D', 'E', 'C']
======FIN=======
```

- ``qsort fixed`` 에서 pivot value와 동일한 값들이 모두 포함되어 아래에 추가 처리를 요구하지 않는다.
- 일반 quicksort를 썼으면 함수호출이 이 줄에 3배는 더 많았을 텐데, 매우 큰 의미가 있었다.

