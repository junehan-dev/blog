Intro to QUEUE
##############

:date: 2022-06-22 08:19
:modified: 2022-06-22 08:19
:category: datastructure
:slug: intro-to-queue
:authors: junehan
:summary: introduction to ADT, queue.
:tags: interface, queue

SUBJECT: 스택에 대비하여 큐를 이해하자
--------------------------------------

:Objectives:

   - Queue의 ADT가 제공하는 메커니즘을 이해한다.
   - Stack에 비교하여 어떤 성질을 가지고 있는지를 깊게 체득한다.

:References:

   - https://en.wikipedia.org/wiki/Queue_(abstract_data_type)

Essentials
----------

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLWU5Qqd-m-7ItrXBpyLa91UEZ8US00Uu4ICF092y8TXzXoPS1gbyqcp_ewuHFZUXJlBbjdBXLOvyr4I16_GJNecQsnpda0T6xfZpjR7gIZ8gzW47U5DQluzse8s21f6y-zoMYzx8aA-KHQ0fVgN-Vc=w701-h934-no?authuser=0
   :alt: Queue basic note

1. *Iterative한 특성을 지니는 프로세스를 가졌다*

   - 입력 그대로 해결, Resolve의 순서를 가지기 때문에 Resolve는 언제든 중단될 수 있고, 그 대상이 사라졌다고 나머지 Queue의 출력프로세스와 단절되는 방식.

#. *Resolve하는 순서가 입력순서를 유지하고 바로 문제해결 해소될 수 있는 특성*

   - 이 덕에 충분히 쌓아놓고, 먼저 쌓은 문제를 좀 해결하고, 이후 더 쌓을지 혹은 그만할지를 정해도 sequence가 무너지지 않는다.

#. *WIKI: "People lineup to wait for goods."*

   - 1, 2번의 특징을 묘사하는 이야기로, 깊게 생각하면, 접시는 전부 다 치워야 근원의 문제, 대전제가 해결되는 반면,  
   - *Data누적 순서간에 계층구조가 존재하지 않는다.*

CMP With Stack
--------------

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLW7ceFA69OWmnL8-FcPkPh0uMMdrSZzVCGgeFlyzqT32QWqSlh07ngG6mnyBZo3J502Vk5x_6bAAOo0ihDZPsMfk-OQGPwNSC7hEH8vW28R8u0vps7jxabayuXzv67dJk-hRTbjt5MudQLB26Rq9T4=w701-h934-no?authuser=0
   :alt: Queue basic note

1. 스택은 컴퓨터의 메모리, 그리고 등장배경과 마찬가지로 *MAIN->SUB1->SUB2->GET BACK* 의 구조와 정확히 맞아 떨어져서, 동작방식이 매우 컴퓨팅과 상호작용한다고 볼 수 있다.
#. **순서가 유지면서 수평적인 관계로 접근을 하는지 혹은, 계층적으로 구성되어 모든 문제가 다른 문제의 연속으로 볼 수 있는지?**
#. 자연상태의 것이라면 Queue의 ADT가 그 사이의 순서는 유의미하며 중간의 어떤 것도 주인공이 될 수 있거나 모두 동등한 관계를 묘사하기 적절할 것이고,  
   Stack이라면 연계된 작업 혹은 첫 문제를 해결하기 위한 것으로 단계적으로 문제를 분산해 나갈 것인지, 그래서 결국 해소해야하는 대상은 첫 문제로 돌아가는지 등을 생각해서 판단해야 할 것이다.
#. 적재해야할 필요가 없다면, 다른 문제에 파상된 문제가 아니라면, For 문에서 순차적으로 아래로 가면서 이전에 for block과는 동등한 실행자이고, 이전 것은 그의 *dequeue*\에서 이미 사라졌고, 지금은 내가 적합한 대상인지가 더 중요한..?

