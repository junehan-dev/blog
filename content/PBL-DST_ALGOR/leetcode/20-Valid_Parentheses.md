leetcode/20/Valid Parentheses
#############################

:date: 2022-08-04 16:09
:modified: 2022-08-04 16:09
:category: algorithm
:slug: valid-parentheses
:authors: junehan
:summary: problem solving to valid-parentheses
:tags: leetcode, string manupulation

Valid Parentheses
-----------------

  - SOURCE: [leetcode 20/Valid Parentheses](https://leetcode.com/problems/valid-parentheses/)
  - Solved code: [my github source file](https://github.com/junehan-dev/Programming_Lectures/tree/LC/LC)

PROGRAM
-------
   - Subject

     문자열 ``s`` 를 입력받는다. 
     해당 문자열은 반드시 ``[], (), {}`` 로만 구성된다.  
     이 문자열 ``s`` 가 유효한지 검사하는 함수를 작성하라.

  - Contraints

     - 열린 bracket은 반드시 올바른 순서로 닫혀야한다.
     - 열린 bracket은 반드시 자신의 pair와 맞게 닫혀야 한다.
     - ``0< s.length < 10**4``

ORDER OF PROCEDURE
------------------

   1. 문자열의 길이를 전부 순회하고 검사하면 앞뒤로 index search를 하면서 검사할 수 있으니,  

      최악의 경우에 정상 문자열의 경우로 모든 문자열을 검사하겠다.

      - 이를 개선하기 위해서 1회의 순차 탐색에서 stack자료구조를 사용한다.

   2. 해당 StackCollection은 특수하게 위에 해당되는 문자 입력만 받으며, 단일 객체)타입은 해당 문자열이 아닌 타입을 받으면 오류를 일으키고 대상 object는 push하지 말하야한다.
   3. StackCollection은 최대 10000의 길이까지 처리해야한다.


PSUEDO CODE
-----------

[Pseudo code](https://github.com/junehan-dev/Programming_Lectures/blob/LC/LC/20-Valid_Parentheses/PSUEDO.py)

Process of Solving
------------------

   1. 처음에 ``[()]`` 이런 방식으로만 Pair order를 valid하다라고 말한다라고 사양을 잡고 빠르게 작성하였다.

      | ``[]()`` 같은 사양을 처리할 수 있도록, brace를 close할때 스택을 해제하도록 처리한다.  
      | *(위 사양은 이 스택을 함수가 종료되면서 해제해도 상관없기 때문에 바로 작은 문제가 해결되는 데로 그 pair를 스택에서 제외한다.)*

   2. ``[[[([])]]]`` 같은 경우에 처리가 필요하여, Openning이 push하면 해당 문자를 담당하는 flag가 ``False -> True`` 로 전환하였는데,  

      | ``int flags[3]`` 를 ``int counters[3]`` 로 전환하여 값을 증가시키는 방식으로 전환하며,
      | openning의 경우 *stacksize* 만 체크하여 push하도록 전환하였다.

RESULT, Complete Program
------------------------

.. code-block:: python

   # s: Input string
   is_pushed = [0, 0, 0];
   # OLD: is_pushed = [False, False, False] 
    # is_pushed name is not fine. better to renames as "brace_counters"
   for ch in s:
      # ch: single Character
      if ch in "({[":
          if ch == '(':
              is_pushed[0] += 1;
          # elif ... {, [

          if len(stack) > 10000:
              return IndexError("Stack size overflow");
          stack.append(ch);

      elif ch in ")]}":
          if ch == ']':
              if is_pushed[1] != 0:
                  raise ValueError("opening Pair not found from stack")
              if stack.pop() != '['
                  raise ValueError("last in from stack was not opening pair")
              is_pushed[1] -= 1;
          # elif ... ), }
  ```

