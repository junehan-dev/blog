---
title: "226 Invert_binary_tree"
date: 2022-03-23T23:09:00+09:00
categories:
- PBL
- ALGORITHM
- LEETCODE
tags:
- BST
---

program name 입력
-----------------

  - SOURCE: [leetcode 226. Invert Btree](https://leetcode.com/problems/invert-binray-tree/)
  - Solved code: [my github PullReq](https://github.com/junehan-dev/Programming_Lectures/pull/50)

PROGRAM
-------

  - Subject  
    root라는 TreeNode객체를 읽어 Left -> right ascending 방향을 right -> left ascding으로 전환하라.(각 서브트리의 좌우 반전)

  ```python
    INPUT_ROOT = [4,2,7,1,3,6,9];
    OUTPUT_INVERTED_ROOT = [4,7,2,9,6,3,1];
  ```

ORDER OF PROCEDURE
------------------
  {{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLURkSJH2JBPKHHxx4HTJEPuulFPcejzpQZ1f5zocaVLJ_ZxxCjY4BAX6-bvxDAave5nXeNWKBLUwxaKBGrzpEqTJ018uurZljsD-IqYMUVwuToRbfohF4sJWo-7Gn1jaEifmm4jJzE0HLiVt_KnO9yr=w916-h1222-no?authuser=0" title="" >}}

  1. 루트노드를 기준으로 2개의 링크를 큐에 담아 레벨별 시퀸스로 좌우 스왑을 진행한다.
  2. 위쪽노드에서 레벨별로 한 노드씩 내려가면서, 자식노드가 None인 경우까지 혹은 그 경우를 제외하고 Swap이 일어나며, 자식노드가 None이라면 Work Q에 추가하지 않는다.

Process of Solving
------------------

- **BFS**
  - 하위의 서브트리로 이동할 때마다 또한 서브트리를 구성하기 때문에, 서브트리의 루트들은 상위에서 indirection이 스왑된 것이다.
  - 이에 포함되는 서브트리의 루트들은 본인의 서브트리에는 아무런 간섭을 받지 않기 때문에, 루트가 트리의 바닥에 도달할 때 까지, 루트가 계승된다라고 볼 수 있어서, 루트와 서브트리의 관계는 재귀적이라고 할 수 있다.
  - 좌측과 우측개념의 서브트리는 메모리상의 어떠한 변화 없이 언제나 서브트리의 루트의 내부 값을 swap하는 것으로 해결된다.

- **DFS**
  - Q에 BFS로 자식레벨 시퀸스 처리를 하는 것이 너무 단순하게 처리되는 듯하여 습득에 도움이 되고자 DFS방식으로 전환해보았다.
    - *끔찍한 과정이 아닐 수 없다.*
      - Sub-Tree-First-order를 오늘 배운 것이라 적용해 보았는데, 코드는 더욱 단순하게 구성할 수 있었지만, 한번 indirection(링크)을 통해 좌측 최하단까지 내려가서 스택해제를 통해 successor(parent node of subtree) callee의 스택으로 순차성을 보장한다.  
  - 뿐만 아니라 그룹의 서브트리를 구성하는 노드는 언제나 좌측을 순회하고 return할 뿐만 아니라 해제한 스택프레임 만큼 우측을 또 다시 쌓는 결과라 굉장히 바쁜 시간을 보냈을 것이라 추측한다.

