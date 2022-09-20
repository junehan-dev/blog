Query Primer 3. from and tables
###############################

:date: 2022-08-05 17:32
:modified: 2022-08-05 19:01
:category: database
:slug: sql-query-from-and-tables
:authors: junehan
:summary: intro to from clause and tables

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
