---
title: "43165 Leaf_Target_Number"
date: 2022-03-24T13:41:55+09:00
categories:
- PBL
- ALGORITHM
- PROGRAMMERS
tags:
- BST
---

타겟 넘버
---------

  - SOURCE: [PG 43165. TargeNumber](https://programmers.co.kr/learn/courses/30/lessons/43165)

  - Solved code: [my github PullReq](https://github.com/junehan-dev/Programming_Lectures/pull/58)

PROGRAM
-------

  - Subject  
    n개의 음이 아닌 정수들이 ``numbers`` 로 주어지고 이 숫자를 순서를 바꾸지 않고 순차적으로 더하더나 합하여서 ``target`` 을 만드는 방법의 수를 리턴하는 함수를 작성하시오.

```python
INPUT_NUMBERS = [1,1,1,1,1];
INPUT_TARGET = 3;
-1+1+1+1+1 = 3;
+1-1+1+1+1 = 3;
+1+1-1+1+1 = 3;
+1+1+1-1+1 = 3;
+1+1+1+1-1 = 3;
OUTPUT = 5;
```

ORDER OF PROCEDURE
------------------

  1. 리스트에 있는 데이터를 완전 이진트리의 레벨별로 필요한 노드 수에 전환하여 트리를 구성한다. ``[0, 1, -1, 1, -1, 1, -1...]``
  2. Root로 부터 브랜칭 될때마다, Successor의 value를 더하여 전달하여서 모든 leaf를 취득하며 돌아오는 방식이 아니라 가면서 값을 더하고 연결방향으로 전달하는 방식으로 누적값을 처리한다.
  3. 모든 leaf는 누적값이 Target과 동일하다면 1을 반환하고 아닐 경우는 0을 반환한다.
  4. 스택이 해제될 때 서브트리가 반환하는 값을 누적하여 Root의 메모리가 해제되면서 원하는 결과값에 얼마나 일치했는지 취합할 수 있다.

Process of Solving
------------------

- **BFS** ``def bfs_traverse(root: TreeNode, target:int) -> int``:
  - 레벨 별로 처리하며 Q에 레벨이 내려가면서 누산되는 값을 다르게 저장해야하기 때문에, Q에 child node를 저장할 때 log를 묶어서 저장해서 브랜칭에 따라 부모노드가 value를 반영하는 값을 유지 할 수 있도록 함께 Enqueue한다.
  - 로그의 백트래킹 검증이 아니라 값의 취합이라 좋은 점은, 결과 값만 있으면 되는 덧에 모든 로그를 배열타입에 저장할 필요가 없이 값의 전달로 처리할 수 있어서, log 객체복사 같은 것도 신경쓰지 않고 쉽게 해결 할 수 있었다.

- **DFS** ``def dfs_traverse(node: TreeNode, log: list, target: int) -> int``:
  - DFS_traverse함수에서는 추가로 배열타입 자료형인 log를 매개변수로 받는다.
  - 아직 백트래킹에 익숙하지 않아서, log를 쌓는 방식으로 처리하도록 시도해보았다.
  - 로그에 분기된 데이터를 전달해야 하니 객체복사가 이루어 졌고, 마지막에는 ``sum(log) + leaf.value`` 로 종료한다.

```python
def bfs_traverse(tree, target):
    q = deque();
    q.append((tree, 0));
    ret = 0;
    while q:
        node, log = q.popleft();
        if node.left and node.right:
            q.append((node.left, log + node.val));
            q.append((node.right, log + node.val));
        else:
            if log + node.val == target:
                ret += 1;
    return ret;
       
def dfs_traverse(t, log, target):
    if not t.left and not t.right:
        ret = sum(log) + t.val;
        if ret == target:
            return 1;  
        return 0
    ret = 0;
    if t.left:
        ret += dfs_traverse(t.left, log + [t.val], target);
    if t.right:
        ret += dfs_traverse(t.right, log + [t.val], target);
    return ret;

def solution(numbers, target):
    numbers = numbers;
    data = []
    for i,v in enumerate(numbers):
        to_add = [v, -v] * (2**i);
        data += to_add;
    t_data =[0] + data;
    t = create_tree(t_data);
    ret = bfs(t,target);
    #ret2 = dfs_traverse(t, [], target);

    return (ret);

assert(solution([1,1,1,1,1], 3) == 5);
assert(solution([4,1,2,1], 4) == 2);

```
