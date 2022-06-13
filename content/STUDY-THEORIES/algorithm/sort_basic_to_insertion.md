---
title: "basis and insertion sort, 삽입정렬과 정렬의 기본"
date: 2022-03-26T20:02:49+09:00
categories:
- STUDY
- ALGORITHM
- SORTING
- INSERTION SORT
tags:
- sorting
thumbnailImage: https://upload.wikimedia.org/wikipedia/commons/0/0f/Insertion-sort-example-300px.gif
---

SUBJECT: 정렬의 모태가 되는 타입부터 잘 이해해야 한다.
------------------------------------------------------
  - Objectives
    - 정렬개념이 왜 필요한지, 어떤 기본 api들이 있는지 기본 원리는 어떠한지 파악한다.
    - Selection sort(선택 정렬)
    - Insertion sort(삽입 정렬)
    - Insertion sort를 정확하게 사용하여 single linked list를 정렬하는 문제를 해결한다.
      - (https://junehan-dev.github.io/post/pbl-dst_algor/leetcode/147-insertion_sort_list/) 

  - References
    >  - wikipedia-[selection sort, insertion sort]
    >  - book, "algorithm" author: *Robert Sedgewick*
    >  - book, "programming perls" author: *Jon Bently*

정렬의 구성
-----------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLU9mdsvKRI3nczXEExTysWyGQnDIQIfdwqX8aNx7FQjsYKTj6wL617QWI2JcmnBPLEuU_Eqs0mQL3XFmPHGgU9_qWq5yGU1KUiIiXBnObOjUZDik4eAqhJUjnb2Dn6jlzXERFiqhdIUfvghrTCuNCg5=w971-h1294-no?authuser=0" title="needs for algorithm" >}}

Index driven, selection sort (인덱스 주도형 정렬)
-------------------------------------------------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXnjIw2sFhfUnc30lsktrkaPe_IYxC44EKh6Z3GaCyW5OGYv8eDGDkcP2GDPH6_6QIP_aKFtcUtjBnyIaUi-0-wOPL857HdQszaAGr-t5ujmcRqYPGYWaToBAxKuVP1e_Ux4XWpSp1wbuuU0J7D-pCr=w971-h1294-no?authuser=0" title="Selection sort" >}}


**정렬이 무엇인지 어떤 것을 해야하고 어떤 일이 발생하는 지를 가장 먼저 알 수 있게 해주는 공부**

  1. 선택정렬은 0번째에 와야할 것을 찾기위해서 key배열 전체를 순회한다.
  2. 0번째 탐색에서 0번째에 있을 수 있는 자격이 있는 대상을 지정하고 넘어왔기 때문에, 나머지는 n-1개의 데이터가 남아있고 자리는 n-2개 남아있다.
  3. 위 정렬이 남아있는 빈 공간을 반복적으로 채워내면 성공이다. 이것으로 정렬을 성공적으로 마쳤다. 축하한다.

> 기본적으로 알아야할 정렬법([selection, insertion, merge, quick, heap, shell]-sort) 은 6개 남짓한 정도이기 때문에 꼭 과정을 작성하면서 해보시기를 추천드립니다.

부분 정렬의 전문도구, insertion sort
-------------------------------------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWHaIIvH5qSe-LQdSVXoAU2Y3-fu2TJTJfNu51pPpydnGGbYUNvmhbzRO9vPOVXlKPgT3OZ6TWZ_15LbwrYssETMyHksYXchUtGh4xuVyj92a2PvKq9I-HiKA2KRdNmcHBDZ50N5S4Gp6k_TrjPDYi9=w971-h1294-no?authuser=0" title="Insertion sort" >}}

> **역순의 쌍의 개수가 적다면, 그 어떤 정렬 알고리즘 보다 빠르다.**

  - 삽입 방식은 2개가 있다.
      1. 적절한 두 숫자 사이에 놓기 위해 기준선 우측 데이터를 한칸씩 밀어내고 데이터를 입력한다.
      2. sort트리거가 발생한 순간, 해당 숫자를 비교대상 숫자와 이전으로 한 unit씩 swap하면서 더 작은 값만 존재하는 경계까지 이동시킨다.
    - 이름에 따라서 유추하면 1번이 삽입정렬과 함께 소개된 방식이고, 2번은 그 전달과정에서 더 간편한 구현방법으로 대체된 것으로 생각된다.
  - 더 개선된 shell sort가 존재하지만 일단 중요한건 데이터의 패턴에 따라 지금도 채택할 수 있는 정렬 방식이라는 점이다.

jon bently's insertion sort, 가상코드
-------------------------------------
{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWLtPjGRJ0MmJnRCoeTOjziweIZnpB_85wUt12BZ774b_E9sNmAujeNYlc-RoOFkeiiVaLRdR0t-ehqx5gNGzDoaDbRVdEXjyQ5SQgmaw1vTJAWPwgiyxG_XPqUTUYvMmaMse4mR7InZSnZ7Dyms5dM=w971-h1294-no?authuser=0" title="Jon Bently's insertion sort" >}}

