Query Primer 9. Subqueries
##########################

:date: 2023-03-07 22:04
:modified: 2023-03-24 20:01
:category: database
:slug: timing-for-subquery-uses
:authors: junehan
:summary: subquries to filter, generate data and create temporal table
:tags: sql

SUBJECT: 서브쿼리를 사용하여 필터, 값 추출, 임시 테이블 생성하기
----------------------------------------------------------------

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611
         - SQL level up/Mic/9788968482519

Subquery란 무엇인가?
--------------------

| 쿼리 내부에 포함되는 다른 SQL문이며, 대부분 포함하는 구문보다 먼저 수행된다.
| 일반 쿼리구문과 동일하게, 아래와 같은 결과를 얻을 수 있다.

   - 하나의 행의 데이터를 가지는 단일 Row
   - 하나의 행의 데이터를 가지는 다수의 Rows
   - 다수의 행의 데이터를 가지는 다수의 Rows

| 이는 선언스코프에서 임시테이블과 같은 역할을 한다.
| 즉, subquery를 포함하는 SQL구문 전체가 종료되면 DB서버는 해당 메모리를 해제한다.
| 서브쿼리는 쿼리를 나눠서 해야할 것을 single transaction에 처리한 다는 점에서 성능상 이점이 있다.

Subqueury Types
^^^^^^^^^^^^^^^

크게는 두 가지 종류로 나뉠 수 있다.

   :*noncorrelated subqueries*:
      독자적으로 실행되는 구문, *scalar subquery*\라고 불려진다.
   :*correlated subqueries*:
     외부 구문과 연관되어 실행되는 구문 

nonCorrelated Subqueries
------------------------

| 메인 쿼리의 FROM 테이블에 대한 스코프를 사용하지 않는, 연관없이 진행되는 부수적인 것이라
| 임시테이블을 생성하고 잠시 사용한다는 개념 정도의 활용성을 가진다.

.. code-block:: sql

   /* Simple Usage */
   SELECT first_name, last_name
   FROM customer
   WHERE customer_id NOT IN (
      SELECT customer_id
      FROM payment
      WHERE amount = 0
   )

   /* MultiColumn Subquery */
   SELECT actor_id, film_id
   FROM film_actor
   WHERE (actor_id, film_id) IN (
      SELECT a.actor_id, f.film_id
      FROM actor a
         CROSS JOIN film f
      WHERE a.last_name = 'MONROE'
      AND f.rating = 'PG'
   );

.. code-block:: sql

   EXPLAIN
      SELECT customer_id
      FROM customer
      WHERE customer_id <> ALL (
         SELECT customer_id FROM payment WHERE amount = 0
      )
   \G;

   *************************** 2. row ***************************
              id: 1
     select_type: SIMPLE
           table: <subquery2>
      partitions: NULL
            type: eq_ref
   possible_keys: <auto_distinct_key>
             key: <auto_distinct_key>
         key_len: 3
             ref: sakila.customer.customer_id
            rows: 1
        filtered: 100.00
           Extra: Using where; Not exists
   *************************** 3. row ***************************
              id: 2
     select_type: MATERIALIZED
           table: payment
      partitions: NULL
            type: ALL
   possible_keys: idx_fk_customer_id
             key: NULL
         key_len: NULL
             ref: NULL
            rows: 15813
        filtered: 100.00
           Extra: Using where
   3 rows in set, 1 warning (0.00 sec)

.. important::

   | ``NOT IN`` 또는 동일한 표현인 ``<> ALL``\를 사용할떄, NULL 값이 우측항에 있는지 꼭 확인해야한다.
   | 특정 값이 NULL(비어있는 상태의 값)과 비교되는 순간, 서버는 알 수 없다라는 결과를 내기 때문에
   | NULL을 제외하고 일치하는 대상이 없는 경우에도 문제가 되며,
   | 마찬가지로 NULL과 NULL의 비교도 인정되지 않는다. (판명 불가)

Correlated Subqueries
---------------------

| 이전의 서브쿼리는 독립적으로 실행될 수 있는 것이었기 때문에,
| 메인 쿼리가 수행되기 이전에 먼저 준비가 되어도 상관이 없는 것이었다.
| 반면 이 타입의 서브쿼리는, 개별 행에 대해서 매회 실행된다.

.. code-block:: sql

   SELECT
      first_name, last_name
   FROM customer
   WHERE 20 = (
      SELECT count(*) FROM rental WHERE customer_id = customer.customer_id
   )

.. code-block:: sql

   EXPLAIN
      SELECT
         first_name, last_name
      FROM customer
      WHERE 20 = (
         SELECT count(*) FROM rental WHERE customer_id = customer.customer_id
      )
   \G;
   *************************** 2. row ***************************
              id: 2
     select_type: DEPENDENT SUBQUERY
           table: rental
      partitions: NULL
            type: ref
   possible_keys: idx_fk_customer_id
             key: idx_fk_customer_id
         key_len: 2
             ref: sakila.customer.customer_id
            rows: 26
        filtered: 100.00
           Extra: Using index
   2 rows in set, 2 warnings (0.00 sec)

.. caution::

   | 의존적인 서브쿼리는 각 행에 대해서 매회 평가되는 구문으로,
   | 해당 메인 쿼리가 얼마나 많은 행을 반환하는 지에 따라 성능 이슈를 가질 수 있다.

Subquery와 자주 사용하는 연산자
-------------------------------

| 여기에 등장하는 연산자는 모두 WHERE과 결합되며,
| SUBQUERY를 피연산 대상으로 동작하기에 매우 적합한 목록이다.

IN and NOT IN operator
^^^^^^^^^^^^^^^^^^^^^^

| 하나의 값을 대상 집합에 대해서 직접 비교 할 수 없기 때문에, 
| 하나의 값이 대상 집합에 포함되는지를 통한 비교로 ``IN``\을 사용한다.

   .. code-block:: sql

      /* 1. ARRAY와 비교되는 IN의 활용 */
      SELECT country_id
      FROM country
      WHERE country IN ('Canada', Mexico');

하지만,

   - 비교할 대상 집합이 갯수가 적거나 (쿼리 구문의 간소화) 
   - 대상 집합의 값을 지정할 수 있는 경우라면 (다른 테이블과 무관하거나, 알고 있는)

단순히 아래와 같이 ``WHERE CONDITION-A  OR CONDITION-B``\의 형태로 작성하는 것이 더 합리적이다.

   .. code-block:: sql

      /* 2. 피연산 대상이 갯수가 적은 경우 Reasonable */
      SELECT country_id
      FROM country
      WHERE country = 'Canada' OR country = 'Mexico';
 
| 특정하게 지정할 수 있는 문자열, 날짜, 숫자로 비교하는 경우도 있겠지만,
| 다른 테이블에서 추출한 값에서 그 대상을 찾는 경우가 조금 더 많을 것이다.

   .. code-block:: sql

      /* 3. 피연산 대상이 많거나 불분명할때 Subquery와 조합 */
      SELECT country_id, city
      FROM city 
      WHERE country_id IN (
         SELECT country_id
         FROM country
         country NOT IN ('Canada', 'Mexico')
      );

ALL operator
^^^^^^^^^^^^

| ``ALL``\연산자는 하나의 값과 집합의 모든 값에 대한 비교를 가능하게 한다.
| ``WHERE <VALUE OR COLUMN> ANY <CMP operator> <SUBQUERY>``\
| *(=, <>, <, >, etc.)*\등의 연산자와 함께 조합되어 사용되어야 한다.

.. code-block:: sql

   /* <> 연산자와 결합, NOT IN과 동일 */
   SELECT first_name, last_name FROM customer
   WHERE customer_id <> ALL (
      SELECT customer_id FROM payment WHERE amount = 0
   );

.. code-block:: sql

   SELECT customer_id, count(*) FROM rental
   GROUP BY customer_id
   HAVING count(*) > ALL (
      SELECT count(*) FROM rental
         INNER JOIN customer c
         ON r.customer_id = c.customer_id
         INNER JOIN address a
         ON c.address_id = a.address_id
         INNER JOIN city ct
         ON a.city_id = ct.city_id
         INNER JOIN country co
         ON ct.country_id = co.country_id
      WHERE co.country IN ('United States', 'Mexico', 'Canada')
      GROUP BY r.customer_id
   );

ANY operator
^^^^^^^^^^^^

| ``ALL``\연산자와 동일하게 ``WHERE <VALUE OR COLUMN> ANY <CMP operator> <SUBQUERY>``\의 형태로, 값 집합을 대상으로 특정값을 비교할 때 사용된다.
| 그러나 차이점이 있다면, 집합 내에 하나의 대상이라도 *<CMP operator>* 조건에 부합한다면 true로 평가된다는 점이다.

.. code-block:: sql

   /* 구매를 한 유저의 구매 총합과 유저 */
   /* 구매 총합이 3개의 국가별 구매내역 총합 중 최소보다 큰*/
   SELECT customer_id, sum(amount) AS paid
   FROM payment
   GROUP BY customer_id
   HAVING paid > ANY (
      SELECT sum(p.amount)
      FROM payment p
         INNER JOIN customer c
         ON p.customer_id = c.customer_id
         INNER JOIN address a
         ON c.address_id = a.address_id
         INNER JOIN city ct
         ON a.city_id = ct.city_id
         INNER JOIN country co
         ON ct.country_id = co.country_id
      WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
      GROUP BY co.country
   );

EXISTS Operator
^^^^^^^^^^^^^^^

| Correlated subquery를 사용하면서 가장 흔히 사용되는 연산자이다.
| 서브쿼리의 결과인 temporary 테이블에 row가 있는지 없는지를 검사하는 것으로 ``WHERE``\과 결합되어 사용된다.
| 즉, EXISTS에 사용된 서브쿼리에서 SELECT 구의 COLUMN에 대한 명시는 유효할 수 있는 것 이기만 하면 무엇이건 상관없다.

.. code-block:: sql

   SELECT a.first_name, a.last_name
   FROM actor
   WHERE EXISTS (
      SELECT 1 FROM film_actor
      INNER JOIN film ON film.film_id = film_actor.film_id
      WHERE film_actor.actor_id = actor.actor_id
      AND film.rating = 'R'
   );

| film이 'R'등급인 영화에 출연한 actor 정보만 추출할 수 있도록 하는데,
| ``WHERE [NOT] EXISTS SUBQUERY``\로 SUBQUERY와만 결합되어 사용될 수 있는 연산자이며
| 결과가 하나라도 있는지의 기준으로 평가된다는 점으로 효율이 좋다.

Common usages of Subqueries
---------------------------

UPDATE using Correlated Subquries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| 이전에는 ``SELECT``\구문만이 등작하였고, 성능적인 이슈가 있다는 점에서 이것이 유용하지 못한 것은 아니다.
| Subquery는 주로 ``UPDATE, DELETE, INSERT``\문에서 특히 자주 사용되는데, **correlated의 경우 update, delete에서 특히 유용하다.**

.. code-block:: sql

   UPDATE customer
   SET last_update = (
      SELECT MAX(rental_date) FROM rental
      WHERE customer_id = customer.customer_id
   );

| 위 쿼리에서는 UPDATE에서 주어지는 customer_id에 대해 rental 정보가 존재하지 않는 경우 NULL(EMPTY SET) 으로 처리되므로,
| 사전에 반드시 1회 이상 대여기록이 있는지 확인하거나, 아래와 같은 쿼리의 개선이 필요하다.

.. code-block:: sql

   /* My Version */
   UPDATE customer
   SET last_update = (
      SELECT CASE WHEN COUNT(*) != 0 THEN MAX(rental_date) FROM rental
      WHERE customer_id = customer.customer_id
   );

   /* Book Version */
   UPDATE customer
   SET last_update = (
      SELECT MAX(rental_date) FROM rental
      WHERE customer_id = customer.customer_id
   ) WHERE EXISTS (
      SELECT 1 FROM rental
      WHERE customer_id = customer.customer_id
   );

| 책에서 사용된 쿼리가 조금 더 나은 성능을 가지게 된다.
| BookVersion의 경우 두 개의 쿼리는 다른 별개의 실행을 가지는 독립적인 쿼리이지만,
| 두번째 WHERE에 해당하는 구문이 먼저 실행되고, 이 조건에 부합할때만 SET에 있는 SELECT 쿼리가 동작하게 되는 반면
| 내가 작성한 쿼리는 NULL에 대한 처리를 강제하기 위해 ``CASE WHEN COUNT(*)`` 를 사용하는 것으로 인해
| 모든 행에 대해서 집계가 발생한다.

DELETE using Correlated Subquries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| ``DELETE``\구문에서도 연결된 서브쿼리는 유용하게 사용된다.
| 예를 들어서 데이터를 유지하는 스크립트를 매달 실행한다고 했을때, 아래와 같은 구문으로 구성될 수 있다.

.. code-block:: sql

      DELETE FROM customer
      WHERE 365 < ALL (
         SELECT datediff(now(), r.rental_date) rental_days
         FROM rental r
         WHERE r.customer_id = customer.customer_id
      );

Powerful ways to use Subquries
------------------------------

| 이제부터 서브쿼리를 사용해서 유용한 SQL구문을 작성해볼 것이다.
| 다음 세 챕터에 걸쳐서 서브쿼리를 통해,

   - 커스텀 테이블 생성
   - 조건문 생성
   - 결과 테이블에 Column Value 생성

등을 알아볼 것이다.


Subquries as Data sources
-------------------------

.. code-block:: sql

      SELECT c.first_name, c.last_name,
         pymnt.num_rentals, pymnt.tot_payments
      FROM customer c
         INNER JOIN (
            SELECT customer_id,
               count(*) num_rentals, sum(amount) tot_payments
               FROM payment
               GROUP BY customer_id
         ) pymnt
         ON c.customer_id = pymnt.customer_id;

데이터 소스인 FROM 테이블로 사용된 서브쿼리는 반드시 "non correlated" 이어야 한다.

   - 여기서 서브쿼리는 먼저 실행되고,
   - 해당 쿼리가 종료될 때까지 메모리에서 대기상태를 가진다.

| 서브쿼리는 엄청난 유연성을 제공하는데,
| SQL작성자는 목표로 하는 가상의 그 어떤 view라도 생성할 수 있도록
| 유효한 테이블을 훨씬 넘어갈 수 있고,
| 이후 결과를 다른 테이블 혹은 서브쿼리로 연결할 수 있기 때문이다.
| 서브쿼리의 유연성 덕분에, 과거에는 다수의 쿼리나 절차형 언어를 사용했던 것을 하나의 쿼리로 대체할 수 있다.

Data fabrication
^^^^^^^^^^^^^^^^

| 실재하는 데이터를 요약하는 서브쿼리를 사용하는 방법처럼,
| 서브쿼리를 사용하여 존재하지 않는 형태의 테이블을 생성할 수 있다.

.. csv-table:: Customer payment groups
   :header: "Group name", "Lower limit", "Upper limit"

   "Small", 0, 74.99
   "Average", 75, 149.99
   "Heavy", 150, 999999.99

.. code-block:: sql

   with pymnt_grps AS (
      SELECT 'Small' name, 0 low_limit, 74.99 upper_limit
      UNION ALL
      SELECT 'Average' name, 75 low_limit, 149.99 upper_limit
      UNION ALL
      SELECT 'Heavy' name, 150 low_limit, 999999.99 upper_limit;
   )
   SELECT pymnt_grp.name, count(*) num_customers
   FROM (
      SELECT customer_id, count(*) num_rentals, sum(amount) tot_payments
      FROM payment
      GROUP BY customer_id
   ) pymnt
   INNER JOIN pymnt_grps
      ON pymnt.tot_payments BETWEEN pymnt_grps.low_limit AND pymnt_grps.upper_limit
   GROUP BY pymnt_grps.name;

| 물론 영구적인 혹은 임시 테이블을 생성해서 사용할 수 도 있다.
| 하지만 그럴 경우, 데이터베이스를 임시적으로 필요한, 혹은 덜 중요한 것들이 흩뿌려진(littered) 모습으로 만들어
| 이 파편들은 존재 자체도 잊을만한 대상이 될 것이다.

| 반면, 서브쿼리를 사용하면
| **"데이터베이스에 추가되는 테이블은 오직 분명한 필요가 존재하는 경우에만 추가되어야 한다."**
| 라는 정책에 달라붙게(adhere) 될 수 있다.

Task-oriented Subqueries
^^^^^^^^^^^^^^^^^^^^^^^^

``SELECT * FROM <HEART-TABLE> INNER JOIN <ADDITIONAL-TABLES>``

| TABLE들에 분포된 데이터가 Normalized 되어 있어서,
| 특정 정보에 부가적인 정보를 더해 Rich하게 데이터를 구성해야하는 경우,
| heart of the query(Minimum data For purpose only and no duplicates)를 Subquery에 작성하여 분리하고,
| 나머지 heart of query를 기반으로 확장될 수 있는 부가적인 정보는 이어지는 JOIN 등으로 두는 방식으로 구성하는 것이
| 저자의 입장에서는 SQL Statement구성이 Clear하다고 판단된다 [idiom01]_.

.. [idiom01] | beauty is in the eye of the beholder
             | 미에대한 기준은 사람의 눈에 달려 있다.

| 예를 들어 도시정보가 포함된 유저의 정보를 가져온다고 했을때,
| CITY-ADDRESS-USER 순서로 INNER JOIN을 할 수 도 있지만,
| USER-ADDRESS-CITY 순서로 바꿔주는 것이 해당 SQL의 목적을 조금 더 분명히 드러낼 수 있다는 장점이 있다.

.. code-block:: sql

   /* Not clear for describing the purpose of query */
   SELECT p.customer_id, a.address_id, ct.city_id, SUM(p.amount) paid, count(*) cnt
   FROM payemnt p
      INNER JOIN customer c
      ON p.customer_id = c.customer_id
      INNER JOIN address a
      ON c.address_id = a.address_id
      INNER JOIN city ct
      ON a.city_id = ct.city_id
   GROUP BY c.first_name, c.last_name, ct.city;

   /* Better clear for understanding the heart of SQL */
   with main_tbl as (
      SELECT p.customer_id, SUM(p.amount) paid, count(*) cnt
      FROM payemnt p
      GROUP BY customer_id
   )
   SELECT main_tbl.*, ct.city_id, a.address_id
   FROM main_tbl
   INNER JOIN customer c
      ON main_tbl.customer_id = c.customer_id
   INNER JOIN address a
      ON c.address_id = a.address_id
   INNER JOIN city ct
      ON a.city_id = ct.city_id;


| ``SELECT main_tbl.*, ct.city_id, a.address_id``\만으로도,
| 원하는 정보는 대부분 main_tbl에 존재하고 이후 연결되는 부분은 부수적인 정보임을 추측하기 용이하다.
| 또한 id값만 포함하는 것으로, 최소한의 식별정보만 유지하도록 하는 부분도 주목할만 하다.


Common table expressions(with statements)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| *Common table expression*\은 쿼리의 상단부에, ``WITH``\구와 함께 사용되는 이름이 있는 서브쿼리를 말한다.
| WITH로 선언되는 테이블은 뒤에 있는 것이 앞에 있는 CTE의 이름을 그대로 사용할 수 있다.

Subqueries as Expression Generators
-----------------------------------

| *With single-column, single row scarlar subqueries.*
| 단일 값의 결과를 반환하는 scarlar 서브쿼리는 아래와 같다.

   - filter condition, ``WHERE v = (Subquery)``
   - ``SELECT (Subquery)``
   - ``ORDER BY (Subquery)``
   - ``INSERT INTO (A, B, C) VALUES ((Subquery-A), (Subquery-B), (Subquery-C))``

Better to use subquery
----------------------

| 결합과 관련된 쿼리를 수행할때, 성능측면에서 서브쿼리를 사용하는 것이 도움이 된다.
| 결합할때 중요한 것은 **최대한 결합 대상 레코드 수를 줄이는 것이 중요하다.**
| 결합을 통해 얻고자 하는 데이터가 어떤 결과인지를 최대한 염두하여,
| 대표적인 예로 집약 처리가 포함된다면, 아래와 같은 두 가지 방법이 존재한다.

1. 결합을 먼저 수행

.. code-block:: sql

   SELECT a.first_name, a.last_name, count(*) AS films
   FROM actor AS a
   INNER JOIN film_actor AS fa
   ON a.actor_id = fa.actor_id
   GROUP BY a.actor_id;

#. 집약을 먼저 수행

.. code-block:: sql

   WITH fa AS (
      SELECT actor_id, count(*) AS films
      FROM film_actor
      GROUP BY actor_id
   )
   SELECT a.first_name, a.last_name, fa.films
   FROM actor AS a
   INNER JOIN fa
   ON a.actor_id = fa.actor_id;

- actor table rows : 200
- film_actor table rows : 5462

:결합을 먼저하는 경우:

   | JOIN 결합의 결과인 중간 테이블에서(5462개의 rows)
   | group by를 실행해서 200개로 줄어드는 결과 테이블을 생성한다.
   | *group by 비용을 줄일 수 있는 장점*

:집약을 먼저하는 경우:

   | GROUP BY 집약의 결과인 중간 테이블에서(200개의 rows)
   | 이를 join하여 결과 테이블을 생성한다.
   | *I/O 비용을 줄일 수 있는 장점*

.. hint::

   - **옵티마이저가 잘 판별하지 못할때에는** 사람이 직접 연산순서를 명시해주면 성능적으로 좋은 결과를 얻을 수 있다.
   - I/O는 SQL 성능의 가장 큰 평가 요인
   - 서브쿼리와 결합을 윈도우 함수로 대체하면 성능을 개선할 가능성이 있음.

