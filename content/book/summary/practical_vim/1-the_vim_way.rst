Practical Vim/1/The vim way
###########################

:date: 2023-11-26 23:41
:modified: 2023-12-05 19:10
:category: book-summary
:slug: practical-vim-1-the-vim-way
:authors: junehan
:summary: book summary of practical vim chapter 1.
:tags: vim, practical vim

Intro
-----

| 우리의 작업은 자연적으로 반복을 수반한다.
| 반복적으로 실행되는 작업으로 연결되는 것은 우리의 시간을 수 십배만큼 절약시킬 수 있다.

| Vim은 반복작업에 최적화가 되어 있다.
| Vim의 효율성은 우리의 마지막 행동을 기록하는 것에 기초한다.
| 그들이 다시 동작했을 때 유용한 단위의 행동을 하도록 우리의 행동을 개선하도록 습득하지 않는다면 의미없다.

| ``.<DOT-COMMAND>``\명령은 이것의 시작이다.
| 이것은 눈에 보이듯이 매우 간단한 명령이고 대중적인 도구이지만,
| 이것을 잘 이해하는 것이 vim을 마스터하기 위한 첫번째 도약이 될 것이다.

TIP-1 Dot command
-----------------

| Vim은 두 가지 모드에서 변화에 대한 키 입력을 기록한다.

   - Normal mode changes(``>>``\, ``x``\, ``dd``\) 
   - Insert mode changes

| ``.<DOT-COMMAND>``\키는 이 기록의 마지막 키입력 단위를 반복해서 현재 커서위치에 적용한다.

TIP-2 Don't repeat yourself
---------------------------

Reduce Extraneous Movement
^^^^^^^^^^^^^^^^^^^^^^^^^^

- 아래의 텍스트 각 줄의 끝에 ';'삽입하기

   .. code-block:: js

      var foo = 1
      var bar = 1
      var foobar = 1

- 기본명령을 사용한 과정과 단축된 방법

   .. code-block:: vim

      " procedural way
      $a; 
      j$.
      j$.

      " improved way
      A;
      j. 
      j. 

.. note:: Compound Commands.

   :``C``: ``c$``
   :``s``: ``cl``
   :``S``: ``^C``
   :``I``: ``^i``
   :``A``: ``$a``
   :``o``: ``A<CR>``
   :``O``: ``ko``

TIP-3 Take One Step Back, Then Three Forward
--------------------------------------------

Padding Characters
^^^^^^^^^^^^^^^^^^

| 여기서도 Vim의 관용구적인 사용법을 활용하여
| 특정 문자 좌우로 <SPACE>를 삽입하는 실습을 진행한다.

.. code-block:: js

   var foo = "method("+argument1+","+arguments2+")";

.. code-block:: vim

   " 1. find + in a line forward from cursor
   f+

   " 2. delete cursor char and insert " + "
   s + <ESC>

   " 3. find next and redo 3 times
   ;.
   ;.
   ;.
   
| ``s``\키는 두 가지(삭제 + 삽입모드)를 한번에 진행한다.
| 우리는 이를 통해 ``.<DOT-COMMAND>``\를 사용하여 이후의 과정을 원활히 진행할 수 있다.

TIP.4 Act, Repeat, Reverse
--------------------------

.. csv-table:: Repeatable Actions and How to Reverse Them
   :header: 의도, 명령, 반복, 되돌리기
   :widths: 10, 8, 2, 2

   "Make a change", "{모든 수정사항}", ``.``, ``u``
   "Scan line for next char", ``f{char}/t{char}``, ``;``, "``,``"
   "Scan line for prev char", ``F{char}/T{char}``, ``;``, "``,``"
   "Scan document for next match", ``/pattern<CR>``, ``n``, ``N``
   "Scan document for prev match", ``?pattern<CR>``, ``n``, ``N``
   "Perform substitution", ``s/target/replacement``, ``&``, ``u``
   "Execute a sequence of changes(macro record)", ``qx{changes}q``, ``@x``, ``u``


TIP.5 Find and Replace by Hand
------------------------------

| formal way로써는 ``:s``\, ``:substitute``\명령을 사용하여 원하는 패턴을 찾고 값을 교체할 수 있다.
| 여기서는 직접 하나씩 비교적 간편하게 교체하는 방법을 소개한다.

Be Lazy: Search Without Typing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:``*``: ``/<word on cursor>``\와 같이 동작한다.
:``#``: ``?<word on cursor>``\와 같이 동작한다.

::
   
   Document from vim doc

      'typing을 줄일 수 있는 방법으로, word를 기준으로 find를 할 때
      *명령은 커서 위에 위치한 word를 찾는다.'

.. code-block:: vim

   " find keyword on cursor
   *
   " change key
   cw{WORD}
   " repeat on next
   n.


TIP.6 Meet the Dot Formula
--------------------------

1. tip2: 문장 끝에 ;키 추가
   ``A;`` + ``j.``

#. tip3: padding space on '+' character
   ``f+`` + ``s + <CR>`` + ``;.``

#. tip5: replace word by hand
   ``*`` + ``cw{WORD}`` + ``n.``

The Ideal: 1 Key(move) + 1 Key(execute)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| 한번의 키 입력으로 원하는 위치로 이동하고,
| 한번의 키 입력으로 원하는 변경을 수행하는 것.
| 이것은 이상적인 해결책이다.
| 이러한 해결법을 앞으로도 사용하게 될 것이고,
| 이 패턴으로 *Dot Formula*\라고 부르기로 한다.

