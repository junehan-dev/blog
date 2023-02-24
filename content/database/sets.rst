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

:``UNION ALL`` operator: 중복합집합, A OR B + A AND B

:``INTERSECT`` operator: 교집합, A AND B

:``EXCEPT`` operator:  A - B (ONLY A)

:non common: A OR B - A AND B

   - ``(A UNION B) EXCEPT (A INTERSECT B)``
   - ``(A EXCEPT B) UNION (B EXCEPT A)``

Set Operation rules
-------------------

Sorting Compound Query Results
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| 복합된 쿼리가 정렬되려면, 끝에 ORDER BY 구를 사용하면 되는데,
| 복합된 테이블의 경우, Column을 순차적으로 첫 번째 테이블로 행을 합치는 식이 되기 때문에,
| 기준 테이블의 Column명을 기준으로 사용해야 한다.

