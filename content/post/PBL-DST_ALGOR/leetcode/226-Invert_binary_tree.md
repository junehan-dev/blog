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

  - SOURCE: [leetcode 226.](https://leetcode.com/problems/invert-binray-tree/)
  - Solved code: [my github PullReq](https://github.com/junehan-dev/Programming_Lectures/pull/50)

PROGRAM
-------

  - Subject  
    root라는 TreeNode객체를 읽어 Left -> right ascending 방향을 right -> left ascding으로 전환하라.(각 서브트리의 좌우 반전)

ORDER OF PROCEDURE
------------------
  {{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLURkSJH2JBPKHHxx4HTJEPuulFPcejzpQZ1f5zocaVLJ_ZxxCjY4BAX6-bvxDAave5nXeNWKBLUwxaKBGrzpEqTJ018uurZljsD-IqYMUVwuToRbfohF4sJWo-7Gn1jaEifmm4jJzE0HLiVt_KnO9yr=w916-h1222-no?authuser=0" title="" >}}

  1. 루트노드를 기준으로 2개의 링크를 큐에 담아 병렬적인 시퀸스로 진행한다. (물론 병렬처리는 불가능하지만.)
  2. 위쪽노드에서 레벨별로 한 노드씩 내려가면서, 자식노드가 None인 경우까지 Swap이 일어나며, 자식노드가 None이라면 Work Q에 추가하지 않는다.

Process of Solving
------------------

  - Q에 2개씩 넣고 자식레벨 시퀸스 처리를 하는 것이 너무 단순하게 처리가 되어서 dfs방식으로 전환해보았다.
  - L to R 로 subtreeFirst order를 오늘 배운 것이라 적용해 보았는데, 코드는 더욱 단순하게 구성할 수 있었지만, 한번 indirection을 통해 좌측 최하단까지 내려가서
  - 스택해제를 통해 더 이상 indirection data가 아닌 successor(callee, root of subtree) callee의 스택으로 프레임이 해제되면서 순차성을 보장한다.  
  - 뿐만 아니라 그룹의 서브트리를 구성하는 노드는 언제나 좌측을 순회하고 반대쪽까지 새로운 스택을 쌓고 해제하면서 더 이상 필요하지 않게 되기 때문에, 굉장히 바쁜 시간을 보낼 것이라 추측한다.

