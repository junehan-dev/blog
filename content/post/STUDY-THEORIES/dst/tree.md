---
title: "from Binary Tree에서 Binary Search Tree로"
date: 2022-03-24T15:02:49+09:00
categories:
- STUDY
- DST
- TREE
- BINARY TREE
tags:
- binary tree
- search
thumbnailImage: https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Binary_search_tree.svg/180px-Binary_search_tree.svg.png
---

SUBJECT: Binary Tree에서 Binary Search Tree
-------------------------------------------
  - Objectives
    - Binary Tree에 대해 동작방식과 구현, 용어등을 명확히 파악한다.
    - BST의 Insert, Delete등의 Operation의 동작방식에 대한 근거를 확실히 한다.

  - References
    - https://www.tutorialspoint.com/rooted-and-binary-tree
    - https://www.youtube.com/watch?v=76dhtgZt38A&list=PLUl4u3cNGP63EdVPNLG3ToM6LaEUuStEY&index=91

Binary Tree와 Traverse order
----------------------------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWLsVNVps1X9GmohypJkvItUZy96ok5mMEZ-DiYfrx1Zz0SP_hIgNIUpvwlPN0XzKVyx5i8oISQGXW9ddf0qgd-5P9deTU26g49eCO7aBQeZo2bO0HHpvaPnr0yvKyttD6FfomaxCtUJfUGMTIk5Oqi=w916-h1222-no?authuser=0" title="Binary Tree and Traversing" >}}

Binary Tree
  - 높이(Height)는 Leaf에서 특정 서브트리의 root를 향하는 것이다.
  - 깊이(Depth or Level)는 대부분 Tree Root에서부터 특정 서브트리의 Leaf를 지칭할 수 도 있으나, 대부분 root에서 최하단 leaf을 언급하기 위해 더 많이 사용한다. 
  - 트리라는 그래프는 수학적으로 rooted-binary-tree라고 불려진다.
  - 대부분 트리가 커질 수록 높이가 커지는 것을 의미하기 때문에 알고리즘에서 ``O(logn)``으로 표현되는 최대 operation은 트리의 도메인에서는 ``O(h)``로 표현하는 더 큰 범주 아래에 있는 개념이다.
    - 왜냐하면 트리는 높이라는 개념 자체가 트리의 기능과 성능에 직결되어 정의 이후에 개별적인 트리를 구분짓는 것이기  때문이다.

Traversal order of node
  - SubTree-First order
    - 서브트리를 구성하는 노드부터 탐색하는 것을 의미하며, rightmost 부터 혹은 leftmost 부터 인지는 상황에 따라 선택가능하다.
    - 서브트리는 단일 노드(Leaf or Root only) 또한 서브트리이다.
    - 선택한 방향이 left라면, ``root -> root's left most leaf -> while parent.right``로 successor에게 돌아가며 RSP를 통해 방문했던 순서로 다시 parent.right의 indirection를 방문하고,
      - 다시 위와 같이 root of subtree's leftmost leaf를 재귀적으로 수행한다.
      - 이를 통해 판단이 되는 것은 Tree의 메인 root인지 아닌지일뿐  Binary Tree내부의 모든 vertex는 내가 원하면 언제나 root가 되어줄 수 있다.

Rooted Tree > Binary Tree
-------------------------

> Rooted Tree **G**는 비순환형 그래프로 root라 불리는 특별한 노드를 가진 트리이다.
>   - 모든 edge는 직접적으로 혹은 indirect를 통해 Root로 부터 기원된다.
>   - *ordered rooted tree*는 각각의 내부 자식 vertex들이 정렬된 것이다.
>   - 만약 rooted tree의 모든 내부 vertex가 *m*보다 적은 수라면, 이것은 *m-ary-tree*라고 불려진다.
>     - ``if m == 2,`` 이라면 **rooted tree**는 **binary tree**라고 불린다.


