---
title: "622 Circular queue"
date: 2022-03-15T19:44:59+09:00
categories:
- PBL
- ALGORITHM
- LEETCODE
tags:
- queue
thumbnailImage: https://photos.google.com/share/AF1QipMg9PKJSVsJpSRSDt2KjAOcx6Lt0RshXwbuurF1U9ddfcV6-YIDEcYEggUaLpSRdg/photo/AF1QipPl8ulMBVqPNOmsR8WqT559zfBDAPAVCkcqCTxJ?key=elJWUDJIeUNBSHRocnRoSjhSNHkybmhFcU5UMDFB
---

Circular Queue
--------------

  - SOURCE: [leetcode 622/Circular Queue](https://leetcode.com/problems/design-circular-queue/)
  - Solved code: [my github source file](https://github.com/junehan-dev/Programming_Lectures/tree/LC/LC/622-Circular_queue)

PROGRAM
-------

  - Subject
    네트워크 버퍼의 모델인 RingBuffer를  FIFO의 순환형큐를 디자인 하자.

      - 일반 큐에서는 입출력 방향이 다른 성질에 의해 한번 출력이 시작되면 전부 소모해야 입력 sequence를 유지할 수 있지만 순환 참조형 큐의 장점은 데이터를 모두 소모하지 않아도, 입력데이터는 정해진 공간을 벗어나는 순간 시작 주소로 돌아가서 이어서 적재할 수 있다는 장점이 있다.

  - Contraints

    - enQueue, deQueue, Front, Rear, isEmpty, isFull 인터페이스를 제공하라

ORDER OF PROCEDURE
------------------

{{< figure src="https://lh3.googleusercontent.com/pw/AM-JKLXorgE-41XXpPAUjE97Q01j02msaLJP5lQQYi1ZklTMZPgKI5KVB2hJ3tw3CFAGTxxK4O9vKcYO2BhhlyMtZN8n_3QR4fiqVcp6gYzYRGYhRYp_m_39DP-LUsJ4NAHvmzzXPwWyEiOvTHdRmWe0_po=w701-h934-no?authuser=0" title="how to implement Circular Q" >}}


  1. 이 문제는 정해진 인터페이스 내에서 해결하면 되는 문제라 함수의 역할 쪽에 좀 더 계획을 잡고 시작했다.
  2. 길이 할당을 하는 부분이 있는데 조금 반가운 마음에 데이터는 수정할 수 없는 container타입의 데이터에 입력 길이만큼의 객체를 주입하고, 해당 객체를 삭제나 교체하는 것은 불가능하도록 설정했다.
  3. 아래와 같이 기본 속성과 API에 기능에 대해 정의하고, 위에 정의된 속성을 기준으로 구현할 수 있는 부분들부터 채워나갔다.

  ```python
  class MyCircularQueue:
      def __init__(self, k: int):
          self.series = Tuple([[] for _ in range(k)]);
          self.capacity = k;
          self._front = 0;
          self._rear = 0;
      def enQueue(self, value: int) -> bool:
          pass
      def deQueue(self) -> bool:
          pass
      def Front(self) -> int:
          """Front : position of object inserted latest
          Depends to the property _front
          """
      def Rear(self) -> int:
          """Depends to the Property _rear
          """
      def isEmpty(self) -> bool:
          """IF FRONT EQUAL REAR -> THEN EMPTY.
          """
      def isFull(self) -> bool:
          """IF REAR + 1 IS FRONT? -> THEN FULL.
          """
  ```

Process of Solving
------------------

  1. 3개의 공간 밖에 존재하지 않는데 끝이 없는 상태라, 처음에 start와 end는 동일한 곳을 가리킨다.

  - 그런데 이게 하나가 추가되는 순간 end가 하나 밀리는데, 그렇게 되면 꽉 찾을때 end가 공간보다 하나 커지게 된다.
  - 이 부분을 해결하기 위해 데이터가 하나만 있을때 end는 start와 같은 장소를 계속 가리킨다.

  2. getter setter인터페이스를 구성한 것은 좋았는데, 아무래도 현재 크기정보가 같이 없으니 현재 start와 end가 같은 곳을 가리키고 있을때 이것이 하나의 정보가 있는 건지 아니면 진짜 비어있는 건지 구분하는데 문제가 있었다.

  3. 위 두 부분을 수정하고 적절히 사용하니 동작은 굉장히 안정적이었고, 마지막 버그가 제출시에 발생했는데, 1개의 데이터가 들어와 있을때 Deque를 하면, start는 뒤로 한칸 밀리는데 end는 가만히 있는 누락이 있었다.  하지만 이것도 지나고 보니, 데이터가 하나일 때 deque한다면 그냥 아무것도 하지 않는게 더 적절하다.

RESULT, Complete Program
------------------------

- Solved code
  [my github source file](https://github.com/junehan-dev/Programming_Lectures/tree/LC/LC/622-Circular_queue)

- RESULT

  ```python
  def enQueue(self, value: int) -> bool:
      if self.isFull():
          return False;
      if self.size == 0:
          self.front_obj.append(value);
      else:
          self._rear = self.get_next_r_idx();
          self.rear_obj.append(value);
      self.size += 1; 
      return (True);

  def deQueue(self) -> bool:
      if self.size == 0:
          return False;

      self.front_obj.pop();
      if self.size == 1:
        return True;
      self._front = self.get_next_f_idx();
      self.size -=1;
      return True;
  ```

