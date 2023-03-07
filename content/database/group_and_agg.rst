Query Primer 8. Grouping and Aggregates
#######################################

:date: 2023-02-28 14:04
:modified: 2023-03-07 22:06
:category: database
:slug: grouping-and-aggregates
:authors: junehan
:summary: Aggregations in database
:tags: sql, set

SUBJECT: 데이터를 가공하는 그룹화와 집계 함수들에 대해
------------------------------------------------------

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611
         - SQL level up/Mic/9788968482519

Intro
-----

| 데이터는 일반적으로 사용자가 필요로 하는 '작은 디테일들로 구성된(granularity)' 수준의 하위레벨에 저장되어 있다.
| 만약 세고있는 도중의 데이터들이 개별적인 고객관련 transaction을 살펴볼 필요가 있다면,
| 개별적인 transaction을 저장하고 있는 테이블이 필요할 것이다.
| 하지만 이것은 모든 유저가 데이터를 데이터베이스에 저장된 것처럼 다뤄야 한다는 것은 아니다.
| 이 챕터에서의 중점은, 유저가 무엇이 데이터베이스에 저장되었냐가 아닌,
| 사용자가 고수준의 디테일들에 있는 것들과 상호작용할 수 있도록, 어떻게 데이터가 그룹화되고 집계되는지에 관한 것이다.

Aggregate functions
^^^^^^^^^^^^^^^^^^^

- ``MAX()``: Set 내부에서 최대의 value를 return
- ``MIN()``: Set 내부에서 최소의 value를 return
- ``AVG()``: Set 내부에서 평균의 value를 return
- ``SUM()``: Set 내부에서 총합의 value를 return
- ``COUNT()``: Set 내부에서 value의 수를 return
  


Grouping Concept
----------------

.. code-block:: sql

   SELECT customer_id, count(*)
   FROM RENTAL
   WHERE count(*) >= 40
   GROUP BY customer_id;

   ERROR 1111: Invalid use of group function

| ``WHERE``\구 내에 ``COUNT(*)``\ 집계함수를 사용할 수 없는데,
| 왜냐하면, ``WHERE``\구가 평가되는 시점에는 아직 그룹이 생성되지 않은 시점이기 때문이다.
| ``WHERE``\는 FROM 테이블을 대상으로 COLUMN등을 평가하는 구문으로
| ``GROUP BY``\로 생성된 결과테이블을 대상으로 필터링하려면 ``HAVING``\을 사용한다.

.. note::

   *subquery나 FROM구를 제외하면 대부분 순차적으로 작성된 그대로 실행순서를 가진다고 보아야한다.*

   1. FROM 참조
   2. SELECT 행 설정
   3. WHERE 조건 검사
   4. 결과테이블 작성
   5. ORDER BY 재정렬

.. code-block:: sql

   # SUCCESS

   SELECT customer_id, count(*)
   FROM RENTAL
   WHERE customer_id < 200
   GROUP BY customer_id
   HAVING count(*) >= 40;

   SELECT customer_id, count(*) AS cnt
   FROM RENTAL
   GROUP BY customer_id
   HAVING cnt >= 40;

Implicit vs Explicit groups
---------------------------

.. code-block:: sql

   SELECT
      customer_id, MAX(amount), COUNT(*)
   FROM payment;

   ERROR 1140 (42000): In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'sakila.payment.customer_id'; this is incompatible with sql_mode=only_full_group_by

| 위처럼 시도하면 에러가 발생하게 되는데, GROUP BY를 제외하고 없이 집계함수를 사용했을때
| Implicit Group(모든 rows를 대상으로 결과를 취합하는)으로 동작하게 되어,
| 특정 조건을 대상으로 그룹을 분리하지 않은 결과로 *customer_id*\를 그룹에 대한 대표값으로 설정 할 수 없기 때문이다.

:``ONLY_FULL_GROUP_BY``: 

   ``SELECT <COLUMNS>``, ``HAVING``, ``ORDER BY``\등에서 ``GROUP BY``\로 이름지어진 집계된 COLUMNS가 아니라면 쿼리를 거절하라.

.. code-block:: sql

   SELECT
      customer_id, MAX(amount), COUNT(*)
   FROM payment
   GROUP BY custoer_id;

| ``group by``\구문에 의한 포함관계에 의해서 서버는 각 행들을 어떻게 집계해야할 지 파악하게 되고,

   1. 그룹마다 동일한 *customer_id*\ 열을 기준으로 각 행을 집계한 뒤
   #. 나머지 집계함수를 실행하여 결과테이블을 생성한다.

.. tip::

   | DISTINCT의 경우 aggregation이 아니고, 결과테이블을 생성하는 과정에서 고유한 값의 수만 세는 과정이 포함된 것으로,
   | quite simple하게는 별도 테이블을 하나 더 만들어서 중복 값 집계를 한다고 보아야 해서,
   | 어떤 select 쿼리에 다수로 사용해도 문제없이 동작한다.

.. tip::

   ROW가 존재하지만 특정 집계 대상 COLUMN에서 값이 NULL일 경우 COLUMN에 대한 집계 대상에서 제외된다.

Generating Rollups
------------------

:``GROUP BY <COLUMNS> WITH ROLLUP``:
   GROUP BY 분류에 대해서 COLUMNS 수에 따른 분류 레벨에 따른 집계를 포함한다.

   | COLUMNS가 1개라면 NULL 항목으로 총 개수를,
   | COLUMNS가 2개 이상이라면 A-a, A-b 에 따른 분류를 진행하면서
   | A-NULL이라는 항목으로 대분류 A에 대한 총 row수를 표시한다.


.. code-block:: sql

   SELECT
      fa.actor_id, f.rating, COUNT(*)
   FROM film_actor fa
   INNER JOIN film f
      ON fa.film_id = f.film_id
   GROUP BY fa.actor_id, f.rating WITH ROLLUP ORDER BY 1, 2 LIMIT 10;

   +----------+--------+----------+
   | actor_id | rating | count(*) |
   +----------+--------+----------+
   |     NULL | NULL   |     5462 |
   |        1 | NULL   |       19 |
   |        1 | G      |        4 |
   |        1 | NC-17  |        5 |
   |        1 | PG     |        6 |
   |        1 | PG-13  |        1 |
   |        1 | R      |        3 |
   |        2 | NULL   |       25 |
   |        2 | G      |        7 |
   |        2 | NC-17  |        8 |
   +----------+--------+----------+
   10 rows in set (0.01 sec)
         
