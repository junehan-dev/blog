leetcode/125/Valid Palindrome
#############################

:date: 2022-07-20 12:09
:modified: 2022-07-22 17:31
:category: algorithm
:slug: valid-palindrome
:authors: junehan
:summary: problem solving to valid-palindrome
:tags: leetcode, string manupulation

REFERENCE
---------

- LEETCODE 125 https://leetcode.com/problems/valid-palindrome/
- SOURCE CODE https://github.com/junehan-dev/Programming_Lectures/tree/LC/LC/125-Valid_Palindrome

Python 풀이
-----------

USING INDEX
^^^^^^^^^^^

- Runtime: *75ms, faster than 49.99: 속도 평균*
- MemUse: *14.5mb, better than 57.28: 메모리 사용량 조금 더 나음*

.. code-block:: python

   class Solution:
       def isPalindrome(self, s: str) -> bool:
           start = 0;
           end = len(s) - 1;
           result = True;

           while (result and start <= end):
               # while still Palindrom and comparing pair is left.
               while (start <= end and not (s[start].isalnum() and s[end].isalnum())):
                   # move cursor to next alnum character
                   start = start if s[start].isalnum() else start + 1;
                   end = end if s[end].isalnum() else end - 1;
               if (start <= end):
                   # if comparable?
                   result = s[start].lower() == s[end].lower();
                   start += 1;
                   end -= 1;
           return (result);

USING REGEX
^^^^^^^^^^^

- Runtime: *64ms, faster than 38.99: 속도는 좀 더 빠르게 개선됨*
- MemUse: *15.6mb, better than 15.28: 메모리 사용량은 조금 더 악화되었는데, 메서드 호출이 많아진 원인*

.. code-block:: python

   class Solution:
       def isPalindrome(self, s:str) -> bool:
           s = s.lower();
           s = re.sub("[^a-z0-9]", "", s);
           return (s == s[::-1]);
    
해설
^^^^

| 문자열이 앞뒤로 같은지 구분하는 프로그램을 작성해야 합니다.
| 따라서, alphabet as lower character, number만을 비교대상으로 합니다.

1. 문자열의 길이를 파악하고,
#. 앞 뒤로 pair를 잡아 각 캐릭터가 같은 값을 가리키는지 비교합니다.
#. 즉 도중에 맞지 않는다는 것을 확인하였다면 pelindrome을 충족하지 않는다는 답을 낼 수 있습니다.
#. 비교를 위해 다른 배열을 사용할 필요는 없습니다.

   - 이미 저장된 배열 자료구조에서 pair 문자값을 비교 할때에, 답을 알 수 있기 때문에 새로운 가공을 필요로 하지 않습니다.


| deque를 사용하거나 Regex를 사용하는 방법이 있는데, 특히 REGEX를 사용하는 방법은 엄청난 개선을 불러올 것이라고 생각했다.
| 그러나 의외로속도에서 약간의 개선이 일어날 뿐 편차치가 있고, 오히려 Index를 사용한 방법은 균일한 효과를 불러왔다.
| 이로 미루어보아 코드의 양을 줄이는 것이 큰 목적이 아니라면,
| 기본적인 조작방식을 선택하는 c스타일 프로그래밍이 최선의 결과를 불러온다는 것을 알 수 있다.

C 풀이
------

- Runtime: *0 ~ 4ms, faster than 70 ~ 100: 컴파일러 최적화에 따라 최고 성능*
- MemUse: *6.4 ~ 6.6mb, better than 30.00 ~ 20.00: 메모리 사용량은 안 좋은 편*

1. 초기속도 느림

   .. code-block:: c
      :linenos:

      #include <string.h>
      #include <unistd.h>

      bool isPalindrome(char *s)
      {
          ssize_t end;
          ssize_t start;
          char s_alnum;
          char e_alnum;
          bool ret;

          ret = 1;
          start = 0;
          end = strlen(s) - 1;
          while (ret && start <= end) {
              while (start <= end && !((s_alnum = isalnum(*(s + start))) && (e_alnum = isalnum(*(s + end))))) {
                  start = !s_alnum ? start + 1 : start;
                  end = !e_alnum ? end - 1 : end;
              }

              ret = (start <= end) ? (tolower(*(s + start++)) == tolower(*(s + end--))) : 1;
          }

          return (ret);
      }


#. 속도 개선

   .. code-block:: c
      :linenos:

      bool ispalindrome(char *s)
      {
          // + 2
          if (end < 1) // 빠른 종료
              return (1);

          // - while (ret && start <= end) {
          // -     while (start <= end && !((s_alnum = isalnum(*(s + start))) && (e_alnum = isalnum(*(s + end))))) {
          // + 2 
          while (ret && start < end) { // do not cmp on single character
              while (start < end && !((s_alnum = isalnum(*(s + start))) && (e_alnum = isalnum(*(s + end))))) {
                  start = !s_alnum ? start + 1 : start;
                  end = !e_alnum ? end - 1 : end;
              }

              // - (start <= end)
              // + 1
              ret = (start < end) ? (tolower(*(s + start++)) == tolower(*(s + end--))) : 1;
          }

          return (ret);
      }

#. 불필요한 코드 삭제(최종)
 
   .. code-block:: c
      :linenos:

      #include <string.h>
      #include <unistd.h>

      bool ispalindrome(char *s)
      {
          ssize_t end;
          ssize_t start;
          char s_alnum;
          char e_alnum;
          bool ret;

          ret = 1;
          start = 0;
          end = strlen(s) - 1;

          while (ret && start < end) {
              while (start < end && !((s_alnum = isalnum(*(s + start))) && (e_alnum = isalnum(*(s + end))))) {
                  start = !s_alnum ? start + 1 : start;
                  end = !e_alnum ? end - 1 : end;
              }

              ret = (start < end) ? (tolower(*(s + start++)) == tolower(*(s + end--))) : 1;
          }

          return (ret);
      }

- Runtime: *0 ~ 5ms, faster than 70 ~ 100: 컴파일러 최적화에 따라 최고 성능*
- MemUse: *6.1 ~ 6.4mb, better than 95: 컴파일러 최적화에 따라 최고 성능*

개선사항
^^^^^^^^

   - 빠른 리턴을 추가하여 적용하여 약산 개선된 속도를 얻을 수 있었습니다.

      .. code-block:: c

         if (end < 1)
            return (1);

   - 최종에서 단독 문자일때는 비교하지 않도록 수정하였더니

      .. code-block:: c

         // if (start <= end) 삭제
         if (start < end)

   - 최종적으로 단독문자를 비교하지 않는다는 수정이 빠른 리턴을 삭제 할 수 있도록 해주었습니다.

      .. code-block:: c

         /* 이전 수정으로 삭제
          * if (end < 1)
          *     return (1);
          */
