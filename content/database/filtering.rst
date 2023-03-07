Query Primer 4. Filtering
#########################

:date: 2022-08-23 13:29
:modified: 2023-03-03 22:21
:category: database
:slug: sql-filtering
:authors: junehan
:summary: intro to filtering in sql
:tags: sql

SUBJECT: Filtering의 방법과 차이를 이해하자
-------------------------------------------

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611

Intro
-----

때로 테이블의 모든 row에 대해서 작업이 필요할 때가 있다.

   - 새로운 데이터를 형성하기 위해 테이블에서 불필요한 부분을 제거한다.
   - 새로운 Column(필드)가 추가된 후에 테이블의 데이터를 수정한다.
   - 메세지-큐 테이블에서 모든 데이터를 찾는다.

대부분 이런 경우는 *WHERE*\구문을 굳이 사용할 필요가 없다. (모든 데이터가 대상이 되기 때문에.)

| 하지만 테이블의 rows에서 subset에 집중하길 원할 때가 있을 것이다.
| 그러므로 모든 SQL구문은(insert를 제외한) 추가적인 *WHERE*\구문을 포함하여 구문에서 동작할 rows의 수를 제한한다.
| 추가적으로 *SELECT*\구문은 *having*\구문을 포함하여, 대상 데이터에 관계된 어떤 필터 조건들을 포함시킬지 정할 수 있다.
| 이 챕터에서는 다양한 필터 조건들을 알아보도록 한다.

Condition Evaluation
--------------------

:SYNTAX:
   WHERE <CONDITION-1> [[<AND / OR> <CONDITION-2>]...]

:DEFINITION:
   | 한개 혹은 다수의 Conditions를 포함할 수 있으며 연산자 *AND, OR*\를 사용한다.
   | 만약 다수의 조건이 걸려 있을때, 각 row에 대해 모두 true여야 *result set*\에 포함된다.

:EXAMPLE:
   ``WHERE first_name = "STEVEN" AND create_date > "2006-01-01"``

OPERATORS
---------

:AND:
   두 개의 CONDITION을 AND 연산으로 연결

:OR:
   두 개의 CONDITION을 OR 연산으로 연결

:NOT:
   CONDITION 의 결과값인 true false를 부정하는 연산

:(CONDITION):
   다수의 CONDITION이 AND, OR를 통해 이루어져 있을때, 목적을 분명히 하기위해 사용된다.

Building a Condition
--------------------

Condition은 하나 혹은 그 이상의 *expression*\으로 구성된다.

:*Expression*\:
   - number
   - column in a table or view
   - string lteral
   - buil-in function (``concat("Learning", " " , "SQL")``\)
   - subquery
   - list of expressions (``("boston", "new york", "chicago")``\)

:*Operators*\:
   - Comparison operator (``=, !=, <, >, <>, LIKE, IN, BETWEEN``\)
   - Arithmetic operator (+, -, \*, /)

BETWEEN Operator
^^^^^^^^^^^^^^^^

- ``column BETWEEN A and B`` 

   | 반드시 A를 하한의 경계를 먼저 입력하고 상한의 값 B를 입력해야한다.
   | (``column >= A, column <= B``\로 평가되기 때문에, 공통범위가 사라진다.)

- 문자열의 Range도 처리할 수 있다. (``first_name BETWEEN "FA" AND "FRB"``\)

Membership Conditions (IN Operator)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``IN``\연산자를 통해서, member를 추가적인 연산자 사용 없이 표기할 수 있다.

.. code-block:: sql

   SELECT
      title, rating
   FROM film
   WHERE rating = "G" OR rating = "PG";


.. code-block:: sql

   SELECT
      title, rating
   FROM film
   WHERE rating IN ("G", "PG", "R", "FG", "GPR);

Using Subqueries
^^^^^^^^^^^^^^^^

``("G", "PG")``\와 같이 멤버요소를 표현할때 Subquery를 사용해서 배열을 생성할 수 있다.

.. code-block:: sql

   SELECT
      title, rating
   FROM film
   WHERE rating IN (
      SELECT
         rating
      FROM film
      WHERE title LIKE "%PET%"
   ); # "G", "PG"

   +---------------------------+--------+
   | title                     | rating |
   +---------------------------+--------+
   | ACADEMY DINOSAUR          | PG     |
   | ACE GOLDFINGER            | G      |
   | AFFAIR PREJUDICE          | G      |
   | AFRICAN EGG               | G      |
   ...

Special Keywords
^^^^^^^^^^^^^^^^

1. WildCards
   부분적인 문자열을 검색할때, 아래 2가지 wildcard를 사용할 수 있다.

   :_:
      Exactly one any character

   :%:
      Any number of any character

2. NULL
      값이 존재하지 않음을 의미하는 값.

   위처럼 단순한 명제이지만, 아래처럼 활용은 다양하다.

      - Not applicable (적용할 수 없는)
      - Value not yet known (값을 알 수 없는)
      - Value undefined (값이 정해지지 않은)
      
   .. note::

      - 표현이 null이 될 수는 있지만, = null은 불가능 하다. (IS를 사용해야 한다.)
      - 두 개의 null은 절대 동일한 값이 아니다.

   1. Normal Usage

      .. code-block:: sql

            SELECT
               rental_id, customer_id
            FROM rental
            WHERE return_date IS NULL;

   #. NULL Is NOT A Value

      .. code-block:: sql

           SELECT
              rental_id, customer_id
           FROM rental
           WHERE return_date = NULL;

      Null이라는 값을 넣은 것이 아니라, 값을 넣지 않은 것이다.

