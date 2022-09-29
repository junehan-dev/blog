Query Primer 1. What is Query
#############################

:date: 2022-08-05 13:35
:modified: 2022-08-05 13:35
:category: database
:slug: sql-query-explanations
:authors: junehan
:summary: how-dose-Query-work
:tags: sql

SUBJECT: 쿼리의 동작방식과 개요
-------------------------------

   - References

      - text book, Learning sql 3rd edition

TERMINOLGY
^^^^^^^^^^

NULL
   | absence of vale, 값의 부재 주로 (알 수 없는, 비어있는)을 표시하는 데이터이다.


Query 동작방식
--------------

1. 로그인
#. connection id 발급 *(쿼리 실행 준비 완료)*

   ``Your MYSQL connection id is 11``

   이 정보는 만약 데이터베이스의 운영자에게 유용한 정보이다.

      - 쿼리의 실수로 되돌리거나,
      - 수 시간동안 동작하는 쿼리를 중단시켜야 한다거나 할때.

#. SQL 구문 전송
#. 사전평가

   DB서버는 아래의 조건들을 구문 실행 이전에 체크한다.

      - 구문을 실행 권한
      - 요구하는 데이터에 접근 권한
      - 올바른 SQL구문 체크

#. *query optimizer*\에 SQL 전달 (구문 평가 및 최적화)

   1. 어떤 테이블 조인할지, 어떤 것들이 인덱스가 걸려 있는지 확인
   #. 실행가능한 *execution plan(쿼리를 실행하는)*\을 수집

#. 쿼리 실행
#. result set 테이블 반환

   - 빈 테이블

      .. code-block:: sql

         mysql> SELECT first_name, last_name
            -> FROM customer
            -> WHERE last_name = 'ZIEGLER';
         Empty set (0.02 sec)

   - 유효한 result set

      .. code-block:: sql

         mysql> SELECT *
         -> FROM category;
            +-------------+-------------+---------------------+
            | category_id | name        | last_update         |
            +-------------+-------------+---------------------+
            |           1 | Action      | 2006-02-15 04:46:27 |
            |           2 | Animation   | 2006-02-15 04:46:27 |
            |          16 | Travel      | 2006-02-15 04:46:27 |
            +-------------+-------------+---------------------+

         16 rows in set (0.02 sec)


Query 구문
----------

- ``select``
   어떤 Columns들을 query의 result set에 포함할지 결정한다.

- ``from``
   어떤 테이블들에서 데이터를 수집할지, 그리고 어떻게 테이블들이 조인되어야 하는지 구분한다.

- ``where``
   원하지 않는 데이터를 filter한다.

- ``group by``
   rows를 column의 common-값을 기준으로 그룹화한다.

- ``having``
   원하지 않는 그룹을 filter한다.

- ``order by``
   result set 테이블에서, rows를 재정렬한다.

