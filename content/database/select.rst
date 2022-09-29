Query Primer 2. select
######################

:date: 2022-08-05 15:35
:modified: 2022-08-05 15:35
:category: database
:slug: sql-query-select
:authors: junehan
:summary: intro to select clause
:tags: sql-select, sql

SUBJECT: select문을 파악하고 이해하자
-------------------------------------

   - References

      - text book, Learning sql 3rd edition

Select Clause
-------------

SYNTAX

   ``SELECT [Columns] FROM ...``

INTRO

   | ``select`` 구문이 select 진술에서 첫 부분을 차지하고 있으나,
   | database가 최종으로 평가하는 구문들 중의 하나이다.::

      | 왜냐하면 무슨 데이터를 포함할지 결정하기 전에,
      | 어떤 데이터인지 (어떤 필드들이 결과 테이블에 포함될 수 있는지) 확인하는 것이 우선되기 때문이다.

   | 그렇기 때문에, ``select``\구문을 이해하기 위해선 ``from``\을 이해하는 것이 선행된다.

Column Argument TYPES

   - Literals, ``amount`` 같은 문자열 혹은 숫자
   - Expressions, ``amount * 10`` 같은 연산 표현
   - Built-in function calls, ``ROUND(amount, 2)`` 같은 함수
   - User-defined function calls

EXAMPLE

   - *"language 테이블의 모든 row의 데이터들과 모든 column 의 데이터를"*

      .. code-block:: sql

         SELECT *
            FROM language;

      1. FROM: language 테이블 1개
      #. SELECT: all columns, 모든 필드

   - *language 테이블의 모든 row 데이터들에 대해*

      - language_id: 행을 그대로 포함한다.
      - language_name: name 행의 값을 대문자로 변환해 포함한다.
      - language_usage: "COMMON" 이라는 값으로 결과 테이블에 포함한다.
      - lang_pi_value: lauguage_id에 3.14 를 곱한 값을 연산해 포함한다.
   
      .. code-block:: sql

         SELECT
            language_id , # column
            'COMMON' AS language_usage, # literal
            UPPER(name) AS language_name, # Builtin function
            language_id * 3.14 AS lang_pi_value # Expression
         from `language`;

   - *내장함수 사용*

      .. code-block:: sql

         SELECT
            VERSION(),
            USER(),
            DATABASE();
 
         /*
         * | VERSION()      | USER()         | DATABASE() |
         * | 10.8.3-MariaDB | root@localhost | sakila     |
         */

      | 테이블에 의존하지 않는 정보를 추출하는 내장함수를 사용하였기 때문에,
      | ``FROM``\구문을 사용할 필요가 없다.

Column Aliase
-------------

INTRO

   | *(mysql같은 도구는 우리가 희망하는 column에 대해서 label을 생성해 주지만,)*
   | 스스로 label을 할당하고 싶을 수 있다.
   | SELECT 구문의 각 요소에 대해서 ``AS``\ column alias를 더하는 것으로 변경이 가능하다.

PURPOSE

   | 데이터베이스에서 column의 명칭은 너무 길지 않으면서도, 약어 표현을 삼가하는 경우가 많다.
   | 이것을 우리의 python, java 프로그램으로 가져와서 처리할 때에, 더 손에 쥐기 간편한 표현으로 변경하는 것으로 가독성을 증대시킬 수 있다.

Removing Duplicate
------------------

INTRO

   | 특정 column의 데이터가 중첩되지 않는 것을 보장할 수 있다면, ``ALL`` 키워드를 사용하여 가져올 수 있다.
   | 그러나 ``ALL`` 키워드는 기본옵션에 해당하는 것이기에 명시할 필요가 없다.

EXAMPLE

   - *"영화출연 로그 중에서, 배우의 아이디를 고유하게 처리하여 리스트업"*

      .. code-block:: sql

         SELECT
            DISTINCT actor_id
         FROM file_actor
         ORDER BY actor_id;

.. important::

   | DISTINCT 키워드를 사용하여 result set을 생성하기 위해선, 데이터가 정렬되어있어야 한다.
   | 굳이 중복을 한번 더 체크하기 위해서 DISTINCT 키워드를 사용하는 것은 비효율적이다.
   | 그렇게 작성하기 보다는, 다루려고하는 데이터를 살펴보고 중복이 없을지 판단하는 것이 현명하다.

