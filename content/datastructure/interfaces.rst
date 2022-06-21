Component of DST, interface
###########################

:date: 2022-06-16 02:09
:modified: 2022-06-16 02:09
:category: datastructure
:slug: interface-in-datastructure
:authors: junehan
:summary: About the interface of datastructure
:tags: interface

SUBJECT: DST의 구성요소
-----------------------

Objectives
^^^^^^^^^^

    - 자료구조와 인터페이스, 알고리즘 요소들과 역할, 정의등을 두루 분명히 하는 것
    - 사소한 것들은 사소한대로 잘 정의하는 것
    - 명료한 지식의 상태로 체득하는 것

Why
^^^

    C에서는 항상 ``array``\나 ``malloc``\으로 거의 다 해결하고, 파이썬에서도 ``list``\, ``tuple``\, 고작해야 ``namedtuple``\같은 자료형을 좋아하고, 그러다보니 복잡한 문제를 해결하는 데에 기본 자료형의 자유로움이 제약이 굉장히 크게 온 경험이 있었다.  

       - 늘 쓰던 방식을 전 프로그램에 걸쳐서 특정한 함수를 따로 만들어서 사용하는걸 해내지 못했으니 오히려 코드 품질이나 개발의 집중도, 진척도 모든 것에 악영향을 주었다. 배열을 앞에서 1byte씩 잘라서 재할당하는 행동을 좋아할 사람은 아무도 없다.

    프로그래머스의 문제 중 어려운 문제가 아니었는데, 다리위에 트럭이 지나가고 빠져나가는 것을 시뮬레이션 하는 프로그램을 작성하는 케이스였다.  

       - 나 같이 기본데이터만 사용해온 사람들은 array-like 한 파이썬의 리스트를 사용하여 앞에서 slicing을 사용하거나 slice and push 용 함수를 짰었을 텐데, 자유도가 높은 자료형으로 사용해왔던 습관을 특정 방식으로만 특정한 시간 내에 조작할 수 있도록 유지해서 프로그램을 완성하기가 어려웠고, 절망에 빠지게 되었다.  
       - 난 이것도 못하는 놈인가 생각을 해보니 나는 queue, stack같은 자료형에 관심도 없었을 뿐만 아니라 그게 어떤건지 정확히 규정하는 것도 불가능하면서 잘난척하는 부류였다는 사실은 절망감을 주었다.

    이를 개선하기 위해 명칭, 작용방식, 활용 가능성들을 충분히 머금기 위해서 이에 대한 학습을 정리하였다.

interface
^^^^^^^^^
   **"인터페이스와 자료구조는 다르다."**

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLUaqZqeosJ5JDXPp_SHx8CkNC5gl4cGEKHvhyobqDxlL9uC5o09qSQzqtV239d76gchF8mOuIaKsPO7tQXDdhJ8XTgItEVO7jAJc4oWHF66E11K4qd9Dpe6OYXA9PjuQzLBkU9Zv-5-gJqtGDVA0hU=w916-h1222-no?authuser=0
   :alt: Component of DST

Interface는 *"무엇을 하고 싶은지?"* 에 대해 규정하는 부분이다.

   - Sequence

      - 일반적으로는 사람들이 가장 원하는 데이터가 Array기반의 빠른 동작을 주는 인덱싱 오브젝트.
      - *(ADT는 다양하다)*: OS에서 제공하는 배열은 stack이나 malloc 이지만 이걸로 다양한 동작방식으로 강제할 수 있다. 
      - Linked list의 연속성을 관리하고 대표해주는 Node클래스 혹은 인스턴스

   - Set(Hash map)

      - Hash map은 Hash function이라는 키 생성 함수를 통해서, 배열에 포인터가 저장된 형태로, hash function을 통해서 해당 인덱스로 접근할 수 있도록 구성된 인터페이스.


.. image:: https://lh3.googleusercontent.com/pw/AM-JKLUJZAhvAONIMKM2dRlsgYzfEh6cMUdljndNb-zHx73fKhuXwqaCQFkEdgY_4VQwPPc4SGGWr1PE4WqTceMQx9dn9kcyqwL0AeKqhBeYRFf7MA3A-iGKIVY0MNX8jS1wwgDKlS5gqEcNu6BvytBZUZk=w916-h1222-no?authuser=0
   :alt: Dynamic Interfaces

- 파이썬의 리스트가 위에 얘기가 나오는데, ADT에 대해 얘기할 때는 뭘 담는것을 신경쓸 것이 아니라 자료를 어떻게 다루는지를 관찰해야 한다.
- 일단 거기 들어 있는 데이터가 reference건 아니건 신경 쓸 부분이 아니다. 파이썬의 list는 dynamic array로서 사용성만큼은 C에서 사용하는 array이상의 advanced array의 기능을 자동적으로 처리해주고 있다.


Physical Datastructure
^^^^^^^^^^^^^^^^^^^^^^
   **"인터페이스가 없어도 물리적인 메모리의 주소는 존재한다. 하지만, 인터페이스가 있어야 우리는 사용할 수 있다. 그것이 아주 단순한 문자열 배열일지라도.**

반면 흔히 통칭하는 Data-structure는 *"어떻게 할 수 있는지?"*\를 규정하거나, 이미 규정된 부분이다.

   - Array based: stack automatic

      - string
      - array of bytes
      - sequencial to physical

         - 가장 기본적인 형태
         - 재할당의 리스크를 변경시에 순서, 즉 시퀸스를 다시 구성해줘야 하는 단점.

   - Pointer based: link based data structure

      - dynamic allocation
      - structure
      - sequencial to logical inside strcture through link

         - 어떻게보면, 진화된 형태
         - 하지만, 주소에 대해 값을 가져오라는 명령을 추가로 수행하기 때문에 단점은 있다.
         - 마찬가지로, 명령이 늘어나는 것에 부담을 적은 경우에 더 이점이 있고, 관리가 용이하다.

