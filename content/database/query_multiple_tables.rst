Query Primer 5. Querying Multiple Tables, JOIN
##############################################

:date: 2022-08-25 15:18
:modified: 2022-08-29 15:57
:category: database
:slug: querying-multiple-tables-join
:authors: junehan
:summary: intro to multiple table querying, join
:tags: sql, sql-join

SUBJECT: 다수의 테이블을 다루는 방법, JOIN을 파악하자
-----------------------------------------------------

   - References

      - text book, Learning sql 3rd edition

What is JOIN
------------

*normalization*
   | 같은 데이터를 여러번 저장하는 것은 낭비이기 때문에, 관계형 모델에서는 이 부분의 분할이 정확하다.
   | 데이터의 각 독립적인 부분의 데이터를 중복되지 않도록 데이터베이스의 디자인을 정제하는 과정을 normalization이라 부른다.

| 위 같은 관계형 데이터베이스의 효과적인 데이터 저장 방식에 의해서,
| 다수의 테이블을 엮어서 조회하는 방식은 매우 흔하게 일어나는데, 이 메커니즘은 ``JOIN``\으로 알려져 있다.

``JOIN``
   | 두 테이블 간에 교집합관계가 되는 필드를 통신수단으로 하여, 두 테이블을 result set으로 포함되도록 하는 것.
   | 이러한 타입의 연산이 join으로 알려져 있다.

.. note::

   | Foreign key constraint는 해당 값이 다른 테이블에 존재한다고 명시하기위해 추가될 수 있다.
   | 하지만, 다른 테이블을 join하기 위해서 반드시 foreign key가 필요한 것은 아니다.


Inner joins
-----------

.. code-block:: sql

   SELECT count(*)
      FROM customer AS c
      JOIN address AS a;
   # 361,197

   SELECT count(*)
      FROM customer AS c
      JOIN address AS a
      ON c.address_id = a.address_id;
   # 599

   SELECT count(*)
      FROM customer AS c
      INNER JOIN address AS a
      ON c.address_id = a.address_id;
   # 599

| ``INNER``\를 명시하지 않아도 기본적으로 ``INNER JOIN``\을 의미한다.

Joining Three or More Tables
----------------------------

.. code-block:: sql

   SELECT
      c.first_name, c.last_name, ct.city
   FROM customer c
      INNER JOIN address a
      ON c.address_id = a.address_id
      INNER JOIN city ct
      ON a.city_id = ct.city_id;

| 위 쿼리에서 3개의 테이블이 있고 2개의 join타입이 있다.
| 그리고 2개의 ON 부구문이 from구문에 포함되어 있다.
| 먼저 테이블을 입력하는 것은 아무런 결과의 차이가 없다. 그저 순서만 조금 다른데,
| 그것은 ``ORDER BY``\구분이 존재하지 않기 때문이다.

.. tip::

   JOIN 순서가 중요한가?

      | SQL은 절차적인 언어가 아니다.
      | 어떤 쿼리를 작성하건 결론적으로 SQL서버가 이 쿼리를 어떻게 결정하는지가 결과이다.
      | 만약 여러 테이블을 JOIN할때, 동일한 순서를 보장받고 싶다면,
      | ``STRAIGHT_JOIN`` 키워드를 사용하여, force order 옵션을 요청할 수 있다.
      | 이 경우 첫번쨰의 명시하는 테이블을 기점(as driving table)으로 정렬 순서를 보장한다.

      .. code-block:: sql

         SELECT STRAIGHT_JOIN
            c.first_name, c._last_name, ct.city
         FROM city ct
            INNER JOIN address a
            ON a.city_id = ct.city_id
            INNER JOIN customer c
            ON c.address_id = a.address_id;

Self Joins
----------

| 일부 테이블들은 자신을 foreign key로 사용하는 경우가 있기 때문에, 이런 경우에 self join이 사용된다.

.. code-block:: sql

   SELECT
      f.title, f_prnt.title prequel
   FROM film f
      INNER JOIN  film f_prnt
      ON f_prnt.film_id = f.prequel_file_id # self Foreign key
   WHERE f.prequel_film_id IS NOT NULL;

위 쿼리는 file 테이블이 자신의 prequel_file_id 외래키를 스스로의 테이블을 join한다.

