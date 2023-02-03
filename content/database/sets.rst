Query Primer 6. Working with sets(union, intersect, except)
###########################################################

:date: 2022-09-02 18:18
:modified: 2022-09-03 15:57
:category: database
:slug: working-with-sets
:authors: junehan
:summary: intro to set operators in sql
:tags: sql, set

SUBJECT: 관계형DB의 주 요소인 set개념과 연산자를 다뤄보자
---------------------------------------------------------

   - References

      - text book, Learning sql 3rd edition

Set Theory primer
-----------------

:``UNION`` operator: 합집합, A OR B

:``INTERSECT`` operator: 교집합, A AND B

:``EXCEPT`` operator:  A - B (ONLY A)

:non common: A OR B - A AND B

   - ``(A UNION B) EXCEPT (A INTERSECT B)``
   - ``(A EXCEPT B) UNION (B EXCEPT A)``


