---
title: "from Binary Tree에서 Binary Search Tree로"
date: 2022-03-24T15:02:49+09:00
categories:
- STUDY
- DST
- GRAPH
- TREE
tags:
- binary tree
- binary search
thumbnailImage: https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Binary_search_tree.svg/180px-Binary_search_tree.svg.png
---

SUBJECT: Binary Tree에서 Binary Search Tree
-------------------------------------------
  - Objectives
    - Binary Tree에 대해 동작방식과 구현, 용어등을 명확히 파악한다.
    - BST의 Insert, Delete등의 Operation의 동작방식에 대한 근거를 확실히 한다.

  - References
    - rooted tree, https://www.tutorialspoint.com/rooted-and-binary-tree

Binary Tree와 Traverse order
----------------------------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWLsVNVps1X9GmohypJkvItUZy96ok5mMEZ-DiYfrx1Zz0SP_hIgNIUpvwlPN0XzKVyx5i8oISQGXW9ddf0qgd-5P9deTU26g49eCO7aBQeZo2bO0HHpvaPnr0yvKyttD6FfomaxCtUJfUGMTIk5Oqi=w916-h1222-no?authuser=0" title="Binary Tree and Traversing" >}}

Binary Tree
  - 높이(Height)는 Leaf에서 특정 서브트리의 root를 향하는 것이다.
  - 깊이(Depth or Level)는 대부분 Tree Root에서부터 특정 서브트리의 Leaf를 지칭할 수 도 있으나, 대부분 root에서 최하단 leaf을 언급하기 위해 더 많이 사용한다. 
  - 트리라는 그래프는 수학적으로 rooted-binary-tree라고 불려진다.
  - 대부분 트리가 커질 수록 높이가 커지는 것을 의미하기 때문에 알고리즘에서 ``O(logn)``으로 표현되는 최대 operation은 트리의 도메인에서는 ``O(h)``로 표현하는 더 큰 범주 아래에 있는 개념이다.
    - 왜냐하면 트리는 높이라는 개념 자체가 트리의 기능과 성능에 직결되어 정의 이후에 개별적인 트리를 구분짓는 것이기  때문이다.

Rooted Tree > Binary Tree
-------------------------

> Rooted Tree **G**는 비순환형 그래프로 root라 불리는 특별한 노드를 가진 트리이다.
>   - 모든 edge는 직접적으로 혹은 indirect를 통해 Root로 부터 기원된다.
>   - *ordered rooted tree*는 각각의 내부 자식 vertex들이 정렬된 것이다.
>   - 만약 rooted tree의 모든 내부 vertex가 *m*보다 적은 수라면, 이것은 *m-ary-tree*라고 불려진다.
>     - ``if m == 2,`` 이라면 **rooted tree**는 **binary tree**라고 불린다.

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLUnO7pKYsMMvQ6cT9ukOKOKyG7NB573Y3NR6m-kFg-S92gcERor46XAwnJitSqsBHRQ36wbCaiam-QV51O3DUPyi7WNIaA1bdsftmrvgZ5iX7haXcQJAqbTWvBbJTLeTSmvmFjUUvvwAXcKITKkuBQp=w971-h1294-no?authuser=0" title="Subtree First order traverse" >}}

Traversal order of node (from tutorialspoint)
  - SubTree-First order
    - 서브트리를 구성하는 노드부터 탐색하는 것을 의미하며, rightmost 부터 혹은 leftmost 부터 인지는 상황에 따라 선택가능하다.
    - 서브트리는 단일 노드(Leaf or Root only) 또한 서브트리이다.
    - 선택한 방향이 left라면, ``root -> root's left most leaf -> while parent.right``로 successor에게 돌아가며 RSP를 통해 방문했던 순서로 다시 parent.right의 indirection를 방문하고,
      - 다시 위와 같이 root of subtree's leftmost leaf를 재귀적으로 수행한다.
      - 이를 통해 판단이 되는 것은 Tree의 메인 root인지 아닌지일뿐  Binary Tree내부의 모든 vertex는 내가 원하면 언제나 root가 되어줄 수 있다.
___

Terminology in Binary Tree 
--------------------------
*(확실히 표현력이 남다르다. 'Caller', 'Callee' 함수 호출에서 일어나는 대상에 대한 지칭표현으로 브라이언 커닝헌이 쓴 practice of programming에서 이 대상화를 들어봤지만, 여기서는 그것을 넘어선 신세계다.")* 

1. Successor: 어떤 대상 이후에 뒤따르는 것, *a thing tha comes after another thing.*

  - 이건 상위subtree로의 회기에 대한 대상의 지칭을 표현하는데,  
    leaf에 도달한 context가 스택프레임의 주소 해제가 되면서 호출자의 컨텍스트로 돌아가는 것과는 현상적으로는 동일한 것을 말하지만,  
    이것은 대상을 지칭하는 것이다. 트리는 비순환 단방향 그래프에서 최대 2개의 하위노드의 링크를 포함하는 구조체이다.  
    그래서 원칙적으로는 이게 스택이 해제되면서 간다는게 트리정보에서는 있을 수 없는 일인데,  
     구현체는 결국 나무가 아니라 프로그램이고, recursive 함수이기 때문에 가능한 stack memory operation에 캐릭터를 부여해 돌아가는 대상 subtree의 root를 지칭하는데 사용된다.

2. Predecessor: 전임자, *a thing that has been followed or replaced by another.*
  - 이는 아래 adjacent와 함께 이후 다룰 binary search tree에서 등장하는 용어인데, subtree의 root인 vertex가 tree에서 delete되는 시점 이전에 특정 적합한 대상과 value를 교환하면서 그 대상이 사라진 값이 위치하던 구조체 메모리에 저장되어 탈바꿈 한 객체의 지칭이다.
  - delete를 성공적으로 수행했다고 함은, **그 대상이 leaf가 아니었다면 vertex의 메모리는 그대로 있고** Recursive value exchanges between adjacents 사이에서 Swap이 일어나고
  - 부분 재정렬이 일어나고 끝에 붙어있는 마지막 일부 byte만 해제한 array와 같은 식인데, 비워지고 다시 메워진 그자리를 차지한 대상을 통을어 Predecessor이라 부른다.

3. Adjacent: 아주 인접한, *very near.*
  - Adjacent는 deletion에 사용될 용어이다. 
  - 일단 root는 집어치우자 어차피 어떤 노드라도 트리안에 있는 노드는 subtree의 root이면서 child of parent node이다.
    특정 노드가 삭제된다는 가정하에 위치를 교환해 트리의 규칙에 문제가 없는 vertex를 지칭하는데, 그 값이 노드보다 크면 오른쪽으로 가고, 반대일 경우 왼쪽을 탐색한다.
    대상 노드의 왼쪽 노드는 Target 노드보다 값은 바로 다음으로 작은 것이 아니라 작은 그룹에서 중간의 순서를 가졌던, sorted array에서 중앙 기준 좌측 시퀸스의 중간 인덱스이다.
    따라서, 왼쪽 노드에서 가장 오른쪽의 노드는 Target Node보다 작으면서 작은 그룹의 가장 큰 값이 된다.
___

Insert and Delete a node in Binary Search Tree 
----------------------------------------------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXgjOKWM94MGQyW7kHnyJDVYQ0oe4h0ktelervGMjNkHUt0Or1QbhYeCLaAwELlaGvuFS3fYKWwnozFX4HVNpBxg58_vJeGfGZBlMjWLaK8A1qOyTYP3eSnkwR4C_asCg6JAFiFocGHCRn9-LxSzukC=w971-h1294-no?authuser=0" title="INSERT methodology" >}}

- 기본적인 BST에 값을 더해가는 것 비대칭을 키우기 십상이라, 트리의 균형이 깨진다. 여기에 필요한 기술이 rotate와 AVL이다.
  - 추가하는 방법은 root에서 순회하면서, 자신이 넣을 보다 작은 값과 더 큰값 사이를 찾아 새로운 node를 생성하고, 부모에게 연결하면 된다.

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLWrGwxcSerALTt8-rOW9r5qAvpFeZnaSJdtxWNVVjyq6LjVJNYdaPqnVNNptSboCkErE8PndqxuMdvNgQuHj5owjzWR8qN730wdJ0HcMStMq2I3ZBYxyAb7EhfU7t6gAnVSbbN716F2FYVnTEbM3aq_=w971-h1294-no?authuser=0" title="DELETE methodology" >}}

- 2가지의 경우로 나눌 수 있다.
  - 삭제하려는 노드가 h가 0인 leaf라면, successor에게서 링크를 해제하면서 값을 삭제하면 된다.
  - **높이를 가지는 서브트리의 root라면,**
    - 모든 정렬연산을 수행할 것이 아니라면, 메모리 해제, 탐색 등을 반복하지 않기 위해서라도,  
    adj가 삭제하려는 노드의 자리를 대신하도록 한다 변화 이후에 트리가 이전에 규칙을 통해서 생성되었다면 좌는 우보다 크다는 사실에는 변함이 없을 것이다.  
    (left의 rightmost, 혹은 right의 leftmost의 노드와 교환하는 방식으로 이 방식을 재귀적으로 전환하여 leaf까지 이동하고 삭제하는 방법이다.)
    - 하지만 이 방법 또한 "단순히 어디를 지금 바로 해결할 수 있어" 라는 greedy한 느낌이라, 오래 사용하다보면 높이가 맞지 않는 문제가 발생한다, 이를 unbalance하다 라고 말한다..

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXZ34kzD5qIXYmzsWi7TjwXgKaK80odfls2dQRSCBjAXVNE2BXcvizz-FLP8LXplxpSpQKfg3-SslY9jQ7z9Py4bBrJNAqEw3X2oh_KzgfXtn2dK21w_Fo4SZ_aF2jY55nJF-0-A6A1f8sJyG2CeQJ9=w971-h1294-no?authuser=0" title="DELETE Pseudo code" >}}

