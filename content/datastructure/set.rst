Intro to SET
############

:date: 2022-07-14 17:49
:modified: 2022-07-18 16:02
:category: datastructure
:slug: intro-to-set
:authors: junehan
:summary: Introduction for datastructure set
:tags: interface, set, hash table

SUBJECT: Set의 정의와 속성, 그리고 이해
----------------------------------------

Objectives

   :Essentials:

       - Set은 ADT라는 정의를 명확히 이해한다.
       - Set의 구성 방법을 파악한다.
       - Set이 왜 사용되며 어떻게 쓰일 수 있는지 이해한다.

   :TrackBacks:

       - Set은 왜 등장했는지 이해
       - Set은 왜 필요했는지 공감해본다.

   :References:

       - https://en.wikipedia.org/wiki/Set_(abstract_data_type)

Essentials
----------

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLVFpqtFzvxDTYjU3TCDi5Z9JTs6ojI0GxGYZO7TCcL41rrM2Fa7A1WP_Np_19pfDL3B9PlBpkni3UE0KSvwh3_SoeG_3hAc7no7CZF1dVfjK4xWZR4mAkCFR6TBCQ-4utO_WUBXqxGwsgGBABCJWfpi=w1024-h1365-no?authuser=0
  :alt: hand note to set

**why set?**
   set, 즉 집합안에 어떤 요소가 포함되어있는지를 조회하기 위한 데이터의 모음을 구성을 필요로 한다면.

**usage**
   단어조회, 변수명 조회, 목록조회

**Set as ADT**
   어떤 목적에 의하여 데이터가 집합되고, 그리고 고유한 값을 포함하는 작용, 따라서 값들 사이의 관계에서 순서개념이 존재하지 않는다.

**One typically tests a value for membership in a set**
   다른 집한 자료타입들과 다르게, 특정한 값을 찾는 것 보다는 그 값이 존재하는지 아닌지가 중점이 된다.

**do not change after constructed sometimes**
   일부 set자료구조는 *static* 또는 *frozen* sets를 겨냥하여 디자인되는 경우가 있다.

      :static:

         - ``find(k)``\: in or not

      :dynamic:

         - ``find(k)``\: in or not
         - ``insert(v)``\: add key
         - ``delete(v)``\: delete key

구현
----

.. image:: https://lh3.googleusercontent.com/pw/AM-JKLXynY2eGtTK_ROOfi9260tQhSUX3jSW-PBLXQNTcd9B3VM3P-Fum6uxmQ8shzuWXkIq8rnjhcfmCHvPdTU0gfyEp1tS0scVmdD1yCsGk0s0BT_yo0SjJ328ZrDcfjhVd34cCWb57JAolK5Q-KJZlCz4=w1024-h1365-no?authuser=0
   :alt: hand note to implementation of set and symbol table

| 다양한 자료구조를 통해서 구현이 가능하다.
| Array의 경우 단순히 데이터를 모아놓아 모든 값을 조회하는 방식으로 이루어진다.
| Ordered Array는 수정이 복잡하지만, 값을 찾는 경우에 있어선 nlogn time을 보장한다.
| 여기에서 발전하면 hash table을 이용한 symbol table이 상용으로 사용되는 자료구조이다.

| key값으로 특정한 값을 산출해내고 해당 hash key내부에 중복되는 key들은 Binary search tree등을 구현하여 크기를 제어한다.

   - 즉 첫번째 Hash table의 크기는 hash function을 통해서 비교적 작은 크기로 유지될 수 있고
   - 중복된 키들은 Binary Search Tree로 해결할 경우, O(1)\[Hash] + O(log (n / table size))\[duplicate keys]의 복잡도를 가진다.
   - ordered array로 해결하는 방법도 있고 단순한 array를 사용할 수 도 있다. 이것은 데이터의 크기와 hash table의 사이즈에 따라 정해지는게 타당하다.

