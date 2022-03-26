---
title: "147 insertion sort for singly linked list"
date: 2022-03-26T21:30:00+09:00
categories:
- PBL
- ALGORITHM
- LEETCODE
tags:
- sorting
---

insertion sort for singly linked list
--------------------------------------

  - SOURCE: [leetcode 147. Insertion sort list](https://leetcode.com/problems/insertion-sort-list/)
  - Solved code: [my github PullReq](https://github.com/junehan-dev/Programming_Lectures/pull/62)

PROGRAM
-------

  - Subject  
    head에는 s-linked-list가 주어진다. 이것에 insertion sort를 수행하고 head를 반환하라.


ORDER OF PROCEDURE
------------------
  {{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUws3qKnLlyECACdlAUkH2FKXk5UkIZskAMI7OknT8uaskzFSNd8A_s4X1op-0cEZ_INeeODSpfIODL0Ar-BFD98JZ0zWxD7EYLTLImEL1QR5qjR5BLAF2rTu3e0L-t6dKcYuZpjUm3328ZdSo1Ki6G=w971-h1294-no?authuser=0" title="" >}}

1. 배열과 달리 이전요소에 접근할 수 없다. 첫번째 노드의 연결을 보관하기 위해 head앞에 새로운 node를 생성하여 base라 네이밍하여 연결한다.
2. 순차적으로 비교하면서 진행하되, 만약 인접한 역순의 짝을 발견한다면, 직전의 데이터와만 비교가 가능하기 때문에, base에 link된 노드부터 역순의 짝을 만나기 전까지, 혹은 삽입한 대상보다 큰값을 선형 탐색에서 발견 했을 때 핸들러를 실행한다.
    1. 삽입 대상노드를 기존의 연결을 제거하고 target_node의 앞(cur) 뒤(next)를 연결해준다.
    2. base의 뒤 노드부터 선형 탐색으로 비교하고 만역 적절한 위치라면, 이 또한 previous_node의 next를 target_node.next로 연결하고, prev_node의 next를 처리한다.
3. 위를 반복하여 모든 노드를 정렬하여 base.next를 돌려준다.

Process of Solving
------------------

- Insertion sort에 대한 문서를 <알고리즘>에서 보고 작성했는데, 배열에서 linked list로 전환되었지만 이미 linked list데이터를 시퀸스를 대상으로 삽입정렬을 실행할 때, 삽입을 위해 데이터 밀어내기가 필요없다는 것을 알고 있었기 때문에,

1. 기본적으로 배열 형태를 해결할 수 있는 방법을 잘 떠올려서 작성했다.
2. 이후 이 데이터를 linked list로 전환했을 떄 어떤 부분부터 바뀌어야할 지 탐색하고 수정했다.
3. 키워드를 수정하고 나니 pseudo code대로 sync를 맞추면서 프로그래밍 하니, 오타오류 정도 외에 다른 오류는 해결 중간과정에 들어오지도 못했다.


*원리를 정확하게 알고, 순차적으로 어떤 처리가 필요하고 왜하는 지에 대한 개연성을 완성한 상태로 문제를 봤는데, 어디어디에서 문제가 생길 가능성이 있는지, 이 다음에 무엇을 해야하는지에 대한 생각도 원만하게 진행되었다. 앞으로도 파악하고, 이해하는데 좀 더 에너지를 사용하고. 문제는 잘 정리된 building blocks로 해결하는게 나한테는 중요하다고 생각했고, 그리고 이 사례를 통해서 알고리즘 문제에 대한 제출자의 마인드 같은 부분도 어떻게 해야 이상적일지 살필 수 있었던 경험이었습니다.*
