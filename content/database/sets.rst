Query Primer 6. Working with sets(union, intersect, except)
###########################################################

:date: 2022-09-02 18:18
:modified: 2023-03-06 11:57
:category: database
:slug: working-with-sets
:authors: junehan
:summary: intro to set operators in sql
:tags: sql, set

SUBJECT: 관계형DB의 주 요소인 set개념과 연산자를 다뤄보자
---------------------------------------------------------

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611
         - SQL level up/Mic/9788968482519

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

UNION with WHERE statement
--------------------------

| ``UNION, INTERSECT, EXCEPT``\를 사용한 결과는 ROW(RECORD)에 대해서 COLUMN의 정보를 추가하는 개념이 아닌,
| RESULT SET의 ROW의 수를 늘리는 것으로 결과 테이블에 COLUMN명이 동일하게 처리된다는 점에서
| 같은 테이블을 대상으로 사용할 가능성이 높다.
| 하지만, 같은 테이블에 대해서 두 집합의 교집합, 합집합을 사용해 결과테이블을 만들게 된다면,
| 2회의 FULL ACCESS가 일어나게되는데, 이는 조회 비용이 2배 높다는 의미를 가진다.

.. code-block:: sql

   EXPLAIN
   SELECT * FROM film WHERE release_year > 2006
   UNION ALL
   SELECT * FROM film WHERE release_year < 2004\G;
   *************************** 1. row ***************************
              id: 1
     select_type: PRIMARY
           table: film
      partitions: NULL
            type: ALL
   possible_keys: NULL
             key: NULL
         key_len: NULL
             ref: NULL
            rows: 1000
        filtered: 33.33
           Extra: Using where
   *************************** 2. row ***************************
              id: 2
     select_type: UNION
           table: film
      partitions: NULL
            type: ALL
   possible_keys: NULL
             key: NULL
         key_len: NULL
             ref: NULL
            rows: 1000
        filtered: 33.33
           Extra: Using where
   2 rows in set, 1 warning (0.00 sec)

| 위의 실행결과 분석처럼 film테이블의 1000개의 ROW를 두번의 SELECT에서 각각 개별적으로 조회하고 있다.

.. tip::

   goto구문의 사용을 피하라는 격언처럼 SQL에도 UNION의 사용을 피하라는 일종의 격언이 존재한다.
   UNION을 사용할 근거를 먼저 마련하고, 그것이 위 예제처럼 CASE를 통한 조건분기로 대체 가능하다면,
   대체하는 것이 좋다.
   SQL 구문이 길다는 것은 그만큼 추상화된 표현으로 인해 확장되는 내부적인 처리는 배로 늘어난 다는 것을 의미한다.
   
When to use UNION?
------------------

| 두 개의 다른 테이블을 기준으로 결과를 합쳐야 하는 경우 UNION을 사용해야 하는 근거와 활용에 올바르다.
| CASE를 통해서 WHERE을 대체하고, 동시에 FROM구에서 SUBQUERY를 사용하여 두 개의 테이블을 결합하여 사용할 수 있지만,
| 이는 불필요하게 중간테이블을 생성하는 과정을 포함하는 것을 의미하게 된다.


.. code-block:: sql

   # Sample Table;

   CREATE TABLE ThreeElements (
      Id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
      date_1 DATE,
      flg_1 BIT(1),
      date_2 DATE,
      flg_2 BIT(1),
      date_3 DATE,
      flg_3 BIT(1)
   );

   SELECT * FROM ThreeElements;
   +----+------------+--------------+------------+--------------+------------+--------------+
   | Id | date_1     | flg_1        | date_2     | flg_2        | date_3     | flg_3        |
   +----+------------+--------------+------------+--------------+------------+--------------+
   |  1 | 2013-11-01 | 0x01         | NULL       | NULL         | NULL       | NULL         |
   |  2 | NULL       | NULL         | 2013-11-01 | 0x01         | NULL       | NULL         |
   |  3 | NULL       | NULL         | 2013-11-01 | 0x00         | NULL       | NULL         |
   |  4 | NULL       | NULL         | 2013-12-30 | 0x01         | NULL       | NULL         |
   |  5 | NULL       | NULL         | NULL       | NULL         | 2013-11-01 | 0x01         |
   |  6 | NULL       | NULL         | NULL       | NULL         | 2013-12-01 | 0x00         |
   +----+------------+--------------+------------+--------------+------------+--------------+

   
| 위 테이블에서, *date_n, flg_n*\의 n에 대해서 날짜가 131101이며, 플래그가 TRUE인 행을 찾는다 라고 했을때, 
| UNION을 사용한 방법은 아래와 같다.

.. code-block:: sql

   SELECT * FROM ThreeElements
      WHERE
         date_1 = '2013-11-01' AND flg_1 = TRUE
   UNION
      SELECT * FROM ThreeElements
         WHERE
            date_2 = '2013-11-01' AND flg_2 = TRUE
   UNION
      SELECT * FROM ThreeElements
         WHERE
            date_3 = '2013-11-01' AND flg_3 = TRUE;

| 위 구문에 대한 실행 평가는 아래와 같다.

.. code-block:: sql

   *************************** 1. row ***************************
              id: 1
     select_type: PRIMARY
           table: ThreeElements
      partitions: NULL
            type: ALL
   possible_keys: NULL
             key: NULL
         key_len: NULL
             ref: NULL
            rows: 6
        filtered: 16.67
           Extra: Using where
   *************************** 2. row ***************************
              id: 2
     select_type: UNION
           table: ThreeElements
      partitions: NULL
            type: ALL
   possible_keys: NULL
             key: NULL
         key_len: NULL
             ref: NULL
            rows: 6
        filtered: 16.67
           Extra: Using where
   *************************** 3. row ***************************
              id: 3
     select_type: UNION
           table: ThreeElements
      partitions: NULL
            type: ALL
   possible_keys: NULL
             key: NULL
         key_len: NULL
             ref: NULL
            rows: 6
        filtered: 16.67
           Extra: Using where
   *************************** 4. row ***************************
              id: 4
     select_type: UNION RESULT
           table: <union1,2,3>
      partitions: NULL
            type: ALL
   possible_keys: NULL
             key: NULL
         key_len: NULL
             ref: NULL
            rows: NULL
        filtered: NULL
           Extra: Using temporary
   4 rows in set, 1 warning (0.00 sec)

| 이때 쿼리를 최적을 성능으로 수행하기 위해 필드 조합에 대해 INDEX를 설정하고
| 다시 동일한 구문에 대해 실행과정을 평가 할 경우, 아래와 같은 결과를 얻을 수 있는데,

.. code-block:: sql

   CREATE INDEX IDX_1 ON ThreeElements (date_1, flg_1);
   CREATE INDEX IDX_2 ON ThreeElements (date_2, flg_2);
   CREATE INDEX IDX_3 ON ThreeElements (date_3, flg_3);

   *************************** 1. row ***************************
              id: 1
     select_type: PRIMARY
           table: ThreeElements
      partitions: NULL
            type: ref
   possible_keys: IDX_1
             key: IDX_1
         key_len: 6
             ref: const,const
            rows: 1
        filtered: 100.00
           Extra: NULL
   *************************** 2. row ***************************
              id: 2
     select_type: UNION
           table: ThreeElements
      partitions: NULL
            type: ref
   possible_keys: IDX_2
             key: IDX_2
         key_len: 6
             ref: const,const
            rows: 1
        filtered: 100.00
           Extra: NULL
   *************************** 3. row ***************************
              id: 3
     select_type: UNION
           table: ThreeElements
      partitions: NULL
            type: ref
   possible_keys: IDX_3
             key: IDX_3
         key_len: 6
             ref: const,const
            rows: 1
        filtered: 100.00
           Extra: NULL
   *************************** 4. row ***************************
              id: 4
     select_type: UNION RESULT
           table: <union1,2,3>
      partitions: NULL
            type: ALL
   possible_keys: NULL
             key: NULL
         key_len: NULL
             ref: NULL
            rows: NULL
        filtered: NULL
           Extra: Using temporary
   4 rows in set, 1 warning (0.01 sec)

| ``ref: const, const``\는 table에서 rows를 select하기 위해 index에 대해서 어떤 값이 비교되었는지를 의미한다.
| 즉 index로 설정된 행을 가져오면서, 비교한 값은 두개의 상수(날짜와 TRUE)이다.
| 이 3개의 index 기반 select 테이블을 UNION RESULT로 합치는 것으로 결과 테이블이 생성된다.

.. code-block:: sql

   SELECT * FROM ThreeElements
      WHERE
         (date_1 = '2013-11-01' AND flg_1 = TRUE)
         OR
            (date_2 = '2013-11-01' AND flg_2 = TRUE)
         OR
            (date_3 = '2013-11-01' AND flg_3 = TRUE);

   *************************** 1. row ***************************
              id: 1
     select_type: SIMPLE
           table: ThreeElements
      partitions: NULL
            type: index_merge
   possible_keys: IDX_1,IDX_2,IDX_3
             key: IDX_1,IDX_2,IDX_3
         key_len: 6,6,6
             ref: NULL
            rows: 3
        filtered: 100.00
           Extra: Using union(IDX_1,IDX_2,IDX_3); Using where
   1 row in set, 1 warning (0.00 sec)

| 쿼리 옵티마이저에 의해서 UNION을 사용하도록 변경된 WHERE구로 적용되었으며,
| 3개의 UNION의 결과를 WHERE를 사용하여 ROW를 구하는 결과.
| 3개의 INDEX를 전부 가져와 UNION을(``index_merge``\) 수행하여 중간테이블을 생성하고,
| 결과테이블에서는 WHERE를 적용하여 종료된다.
| 결과적으로는 3개의 UNION을 사용한다는 점에서 변화가 없는데,
| INDEX를 온전히 사용하는 케이스이기 때문에 위와 같은 변형이 있었던 것으로 추측된다.

