---
title: "108 Convert_sorted_array_into_BST"
date: 2022-03-24T01:48:43+09:00
categories:
- PBL
- ALGORITHM
- LEETCODE
tags:
- BST
---

정렬된 배열에 BST로 자료구조 전환
---------------------------------

  - SOURCE: [leetcode 108.convert_sorted_array_into_BST](https://leetcode.com/problems/convert-sorted-array-to-binary-search-tree/)
  - Solved code: [my github source file](https://github.com/junehan-dev/Programming_Lectures/tree/LC/LC/108-Convert_sorted_array_to_BST/create_bst.py)

PROGRAM
-------

  - Subject
    정렬된 배열(리스트)를 트리로 전환하면서 BST를 구성하라.

  - Contraints
    - 트리는 ascending order로 **height-balanced** 된 BST이어야 한다.

ORDER OF PROCEDURE
------------------

  1. 트리의 루트가 될 중간 크기의 데이터 위치에서 데이터를 추출하여 루트노드를 구성한다.
  2. 좌측 혹은 우측의 중간 데이터를 추출해서 루트노드의 Left Right 노드로 링크한다.
  3. 위의 작업을 반복적으로 수행하고, levelorder로 링크를 연결하는 것은 순회방식과 무관하다.

PSUEDO CODE
-----------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLVEoJ5g_YLZTw_FdqeMmzy4gq8QEChS0lAAg0gk5MPbDXIK2CQTv-H2ii0OjEWf7ETmKtUyFJ0egu0znrVGrTZx1sqkWA_Eivb6M9P1DcL1Qj2s7N03veSehf71fXcpxVU244d2bAVHLS7jOBeCpVNc=w916-h1222-no?authuser=0">}}

Process of Solving
------------------

  1. 데이터를 기반으로 Loop를 순회하고 해당 데이터 노드로 전환할 수 있겠지만, 노드자식으로 나눠져서 얻게되는 left, right에 비해 root는 위치와는 인접성에 있어서 격차가 있다.
  2. 따라서 데이터를 기반으로 보다는, 노드를 재귀적으로, 혹은 남아있는 파티션의 데이터에 맞게 인덱스를 사용하여 sorted 상태를 보장한다.
  3. 데이터의 인덱스와 트리의 인덱스는 동일하기 때문에, 이 기법과 bfs순서로 전환하여 성능에 개선이 가능하다.

