Intro to STACK
##############

:date: 2022-06-14 14:49
:modified: 2022-06-14 14:49
:category: datastructure
:slug: intro-to-Stack
:authors: junehan
:summary: Introduction for datastructure stack
:tags: interface, stack

SUBJECT: 스택의 정의와 속성, 그리고 이해
----------------------------------------

Objectives

   :Essentials:

       - Stack은 ADT라는 정의를 명확히 이해한다.
       - Stack의 구성 방법을 파악한다.
       - Stack이 왜 사용되며 어떻게 쓰일 수 있는지 이해한다.

   :TrackBacks:

       - Stack은 왜 등장했는지 이해
       - Stack은 왜 필요했는지 공감해본다.

   :References:

       - https://en.wikipedia.org/wiki/Stack_(abstract_data_type)
       - https://en.wikipedia.org/wiki/Turing_machine

Essentials
----------

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLUY8o3uaENfy4tuk1IYzOmV0W52O-EyKgvHKYUpxlLELmZYENRx8Tty3JP-c9_IEQjvt_0d7MoQGNETOstJN4BrXBcZolgIiS_jduYtfLsY63_1O1xOzpfL1F07LBjLnXZfQHP3twKdY1vOR3sw_hA=w702-h936-no?authuser=0
  :alt: hand note to stack 1

**Stack as Collection Object**
   어떤 목적에 의하여 데이터가 집합되고, 그리고 그 집합을 하나의 객체가 포함하는 것.  
   데이터가 같은 목적을 가지고 분류된 결과가 어떤 집합이라면,

**Provides a sequnce for a group of data**
   어떤 방식으로 객체를 저장하고, 어떤 API를 제공하는 지에 따라달라지지만,

      - *"데이터를 보관할 수 있는 공간과 요소들의 수에 따라 길이 개념도 제공해야한다.*
      - ``int size(void)``
      - ``int is_empty(void)``
      
   | 컬렉션에 따라, 데이터를 보관한 이후, 추출하는 방식에서 가장 큰 차이가 있다.
   | 어떤 목적에 직관적으로 이어지도록 도움을 줄 수 있는지에 가장 큰 설계 기반이 있다.::

      :Bag: [Store only]

          - ``int add(void *Item)``

      :Queue: [FIFO]

          - ``void enque(void *Item)``
          - ``void *deque(void)``

      :Stack: [LIFO]

          - ``void push(void *Item)``
          - ``void *pop(void *Item)``

**Stack<T>**
   - 일관된 배치의 데이터 묶음을 이 스택이 생성 시의 ``stack_len``\을 관리하고 *PUSH, POP*\의 API를 드러낸다.
     *(현대적인 의미에서는 내부구현 방식에 관계없이.)*
   - 그래도 스택의 유래를 유지하는 언어들의 경우에는 Generic은 받되, Stack 생성 시점에 최대 길이(크기와는 구별)는 지정하도록 의미적으로 정의하고 있다.

유래와 사용성
-------------

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLWpYSrN5JNbFZjV-1lvqG4SnGWmdvF1f_PglN6m-XbAoYaUluQD5epOKSkhLkQxoN6m86glDTjw8_GAQFQY88Gre0R8CbcjWvi5nZ1kTfS9RbZcnHnxzMM6droDzs47-SOzgA5NKZgZKzrrqkUfQUk=w702-h936-no?authuser=0"
  :alt: hand note to stack 2

| 파이썬 List에서 append, pop 메서드만 사용하는 것으로 스택을 사용해야 해결해야하는 문제풀이를 끝내고 나서 조금 시간이 흘렀다.  
| 굳이 pointer operation으로 이미 존재하는 Collection을 유지하면서도 stack처럼 같은 효과를 낼 수 있는데 왜 이걸 덮어 씌워야 할까에 대해 고민했다.

| wikipedia에는 c로 array를 포함하는 Stack을 구현하는 코드가 있는데 그 지점까지 읽었을 때도,
| ``stack_max, stack_cur`` 에 size와 top에 대해 저장하고 그와 함께 *function parameter라는 훌륭한 인터페이스를 사용하면 해결될 것을 굳이 기본연산자들을 감출 이유를 공감하지 못했는데,*  
| 이 개념의 등장 시기에 대한 부분을 위키페디아에서 보고 필요성만큼은 납득할 수 있었다.

wikipedia stack/history 
^^^^^^^^^^^^^^^^^^^^^^^ 

   | 앨런 튜링이 1946년 subroutine을 호출하고 돌아오는 과정을 bury, unbury라고 불렀다.
   | 그리고 subroutine은 1945년 구현되었다.
    
   | 1960 ~ 1970년 중에 벨연구소에서 여전히 커다란 컴퓨터를 다루던 시기이고, assembly는 심지어 1949년에 처음 등장했다는 것과 그것보다도 4년은 더 이전의 시기인 점으로 생각하면, ``PUSH EBP`` 루틴정도는 앞으로 눈감고 써야하지 않을까 생각이 들었다.

Edsger W. Dijkstra's Algorithm
------------------------------

Pushdown autonmation
--------------------

