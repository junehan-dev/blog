Query Primer 3. from and tables
###############################

:date: 2022-08-05 17:32
:modified: 2022-08-22 19:01
:category: database
:slug: sql-query-from-and-tables
:authors: junehan
:summary: intro to from clause and tables
:tags: sql, sql-tables, sql-from

SUBJECT: from문을 파악하고 이해하자
-----------------------------------

   - References

      - text book, Learning sql 3rd edition

From Clause
-----------

SYNTAX

   ``SELECT ... FROM [TABLE1 NAME [??JOIN [TABLE2] ON [CONDITION]]]``

INTRO

   | 지금까지 보았을 쿼리에서 ``FROM`` 구가 하나의 테이블을 포함하는 것을 보았을 것입니다.
   | 대부분 하나 혹은 다수의 테이블을 포함하는 구 로설명하지만 아래와 같이 정의를 넓히고 싶습니다.

      | *The from clause defines the tables used by query, along with the means of linking the tables together.*
      | *from구는 테이블들과 연결되어 쿼리에서 사용될 테이블들을 정의한다.*

   | 이 정의는 2개의 다른 개념이 혼용된 것이지만 이 장에서 다룰 것입니다.

TABLES
------

4-Types of Tables

   - Permanent Tables (``CREATE TABLE``\로 생성된 전통적인 테이블)
   - Derived Tables (subquery에 의해 생성된 in-memory 중간 테이블)
   - Temporary Tables (in-memory volatile 테이블)
   - Virtual Tables (``CREATE VIEW``\로 생성된 가상테이블 command of table)

| 각 테이블은 query의 from 구문에 포함 될 수 있다.
| 현재로서는 영구적인 테이블을 from구에 더하는 것에 익숙해져야하기 때문에, 다른 타입의 테이블은 간단하게 설명하기로 하자.

Derived (Subquery-generated) Tables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Subuquery
   | 서브쿼리는 다른 쿼리에 대해 포함되는 쿼리를 의미한다.
   | 서브쿼리는 괄호에 둘러쌓여 있고, select 구문, from 구문의 다양한 부분에서 사용될 수 있다.

.. note:: 

   그러나 from 구문 내에서 서브쿼리는 *파생테이블*\을 생성하는 역할을 수행하며
   이에 다른 모든 쿼리 내에서 접근 가능하고, from 구문 내의 다른 테이블과 상호작용할 수 있다.

.. code-block:: sql

   SELECT 
      concat(cust.last_name, ", ", cust.first_name) AS full_name
   FROM (
      SELECT
         first_name, last_name, email
      FROM customer
      WHERE
         first_name = "JESSIE"
   ) AS cust;

   +---------------+
   | full_name     |
   +---------------+
   | BANKS, JESSIE |
   | MILAM, JESSIE |
   +---------------+
   2 rows in set (0.00 sec)
   

Temporary tables
^^^^^^^^^^^^^^^^

| 비록 구현체에 차이는 있지만, 모든 관계형 데이터베이스는 volatile 혹은 temporary한 table을 생성할 수 있는 기능이 있다.
| 이 테이블들은 일반 테이블과 동일해 보이지만, 특정한 순간에 사라지는 것이다.(일반적으로 transaction, db-session의 종료시점)

.. code-block:: sql

   CREATE TEMPORARY TABLE actors_j
      (
         actor_id smallint(5),
         first_name varchar(45),
         last_name varchar(45)
      );

   INSERT INTO actors_j
      SELECT
         actor_id,
         first_name,
         last_name
      FROM actor
      WHERE last_name LIKE "J%";

Virtual (View-prepared) tables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| view는 **data dictionary**\에 저장되는 쿼리이다.
| 이것은 마치 테이블 처럼 보이고 동작하지만, 실제로 데이터가 관련되지는 않는다.
| 우리가 view를 향해서 query를 전달할때, 쿼리는 view와 결합되어 실행된다.

.. code-block:: sql

   CREATE VIEW cust_vw AS
      SELECT
         customer_id, firstName, last_name, active
         FROM customer;

   SELECT
      first_name,
      last_name
   FROM cust_vw
   WHERE active = 0;

