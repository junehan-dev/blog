Query Primer 13. Indexes and Constraints
########################################

:date: 2023-09-04 18:04
:modified: 2023-09-07 23:38
:category: database
:slug: indexes-and-constraints
:authors: junehan
:summary: how to create index and constraints in database
:tags: database

SUBJECT: index와 constraints를 이해하고 사용해보자
--------------------------------------------------
   | ``select, insert, update, delete``\등의 SQL을 사용하는 것과 별개로,
   | SQL의 사용에 영향을 주는 다른 기능들을 알아보자.

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611
         - SQL level up/Mic/9788968482519

Indexes
-------

| 테이블에 데이터를 추가하는 경우에, DB는 이 데이터를 특정한 위치로 놓도록 순서를 조정하거나 하지 않고 단순히 테이블의 남은 공간의 첫 위치에 놓을 뿐이다.
| 따라서 테이블에 query를 한다면 서버는 *table scan*\(테이블 풀 스캔)을 통해 원하는 응답을 생성한다.

   .. code-block:: sql

      SELECT first_name, last_name
      FROM customer
      WHERE last_name LIKE 'Y%';

      +------------+-----------+
      | first_name | last_name |
      +------------+-----------+
      | LUIS       | YANEZ     |
      | MARVIN     | YEE       |
      | CYNTHIA    | YOUNG     |
      +------------+-----------+
      3 rows in set (0.00 sec)

   | 매우 많은 데이터를 대상으로 table scan을 진행할 때, 
   | 서버는 추가적인 도움없이 합리적인 시간 내에 결과를 생성할 수 없을 것이다.
   | 이때에 필요한 도움은 테이블 내의 하나 혹은 다수의 *indexes*\의 형태로 받을 수 있다.

*index*
   | 출판물의 앞 혹은 뒤에 있는 목차, 용어 목록과 다르지 않게
   | db서버는 *indexes*\를 사용하여 테이블의 특정 행을 가리킨다.
   | *indexes*\는 일반적인 테이블과 다르게 특정한 순서가 유지되는 테이블이다.
   | 그들은 데이터 entity를 전부 포함하는 대신, 특정 행을 가리키기 위한 데이터를 포함하며,
     거기에는 특정하는 행의 물리적인 위치정보도 포함된다.
   | 그러므로, *indexes*\의 역할은 테이블의 데이터 subset을 추적하는 시설을 갖추어
   | 모든 테이블을 탐색하지 않도록 하는 것이다.

INDEX 생성
^^^^^^^^^^

   .. code-block:: sql

      # Create Index on MYSQL
      ALTER TABLE customer
      ADD INDEX idx_email (email);

      ## new since MYSQL5 Internally alter table
      # CREATE INDEX idx_email
      # ON customer (email);

      Query OK, 0 rows affected (0.10 sec)
      Records: 0  Duplicates: 0  Warnings: 0

      # REMOVE Index on MYSQL
      ALTER TABLE customer
      DROP INDEX idx_email;

      ## new since MYSQL5 Internally alter table
      # DROP INDEX idx_email
      # on customer;

      Query OK, 0 rows affected (0.10 sec)
      Records: 0  Duplicates: 0  Warnings: 0

| 기본적으로 생성되는 Index는 B-tree(Balacing binary search tree)의 자료구조로 관리된다.
| Index가 내장되면서, query optimizer는 이점이 있어보이는 index를 사용하도록 선택할 수 있다.

   .. code-block:: sql

      EXPLAIN
      SELECT * FROM customer
      WHERE email LIKE 'a%';

      # with Index
      +----+-------------+----------+------------+-------+---------------+-----------+---------+------+------+----------+-----------------------+
      | id | select_type | table    | partitions | type  | possible_keys | key       | key_len | ref  | rows | filtered | Extra                 |
      +----+-------------+----------+------------+-------+---------------+-----------+---------+------+------+----------+-----------------------+
      |  1 | SIMPLE      | customer | NULL       | range | idx_email     | idx_email | 203     | NULL |   44 |   100.00 | Using index condition |
      +----+-------------+----------+------------+-------+---------------+-----------+---------+------+------+----------+-----------------------+

      # without Index
      +----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------------+
      | id | select_type | table    | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
      +----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------------+
      |  1 | SIMPLE      | customer | NULL       | ALL  | NULL          | NULL | NULL    | NULL |  599 |    11.11 | Using where |
      +----+-------------+----------+------------+------+---------------+------+---------+------+------+----------+-------------+

      SHOW index FROM customer WHERE Key_name = 'idx_email' \G;
      *************************** 1. row ***************************
              Table: customer
         Non_unique: 1
           Key_name: idx_email
       Seq_in_index: 1
        Column_name: email
          Collation: A
        Cardinality: 599
           Sub_part: NULL
             Packed: NULL
               Null: YES
         Index_type: BTREE
            Comment:
      Index_comment:
            Visible: YES
         Expression: NULL
      1 rows in set (0.01 sec)

| MySQL은 index를 테이블에 소속되는 추가적인 요소로 여기기 때문에, ALTER구문을 사용하도록 한다.
| 반면 많은 다른 서버의 경우(ORACLE, MSSQL, POSTGRESQL)는 Index를 별도의 Schema objects로 취급한다.

   .. code-block:: sql

      CREATE INDEX idx_email
      ON customer (email);

| 현재는 mysql 5.0 이후로 ``CREATE, DROP``\구문으로 Index를 관리할 수 있지만
| 내부적으로 ALTER를 사용하는 것은 차이가 없다.

Multicolumn indexes
^^^^^^^^^^^^^^^^^^^

| 데이터의 두 개 이상의 구성요소를 결합한 것에 대해서도 Index를 생성할 수 있다.
| 예를 들어, 성과 이름을 합친 전체 이름에 대해서 Index를 생성한다고 하면,

   .. code-block:: sql

      CREATE INDEX idx_full_name
      ON customer (last_name, first_name);

      EXPLAIN SELECT * FROM customer WHERE last_name LIKE 'k%' AND FIRST_NAME LIKE 'k%';
      +----+-------------+----------+------------+-------+-----------------------------+---------------+---------+------+------+----------+-----------------------+
      | id | select_type | table    | partitions | type  | possible_keys               | key           | key_len | ref  | rows | filtered | Extra                 |
      +----+-------------+----------+------------+-------+-----------------------------+---------------+---------+------+------+----------+-----------------------+
      |  1 | SIMPLE      | customer | NULL       | range | idx_full_name,idx_last_name | idx_full_name | 364     | NULL |   14 |    11.11 | Using index condition |
      +----+-------------+----------+------------+-------+-----------------------------+---------------+---------+------+------+----------+-----------------------+
      1 row in set, 1 warning (0.00 sec)

이때 *idx_full_name*\은 *last_name* 을 기준으로 first_name까지 연결된 것을 Index로 삼고 있기 때문에,

   1. *last_name*\과 뒤로 *first_name*\이 연결된 것을 검색할 때
   #. *last_name*\을 기준으로 검색할 때

| 두 경우에서 사용될 수 있으며, *first_name*\을 기준으로 검색하는 경우에는 활용이 불가능하다.
| 따라서 *multicolumn INDEX*\를 생성하고 이를 *query optimizer*\가 활용할 수 있는 옵션 설비로 하기 위해서
| **어떤 항목을 기준으로 먼저 검색하도록 할지의 순서가 중요하다.**

   .. tip::

      multicolumn index는 구성 요소가 같아도 순서가 다르다면(순서를 기준으로 구성되는 것이라) 생성 가능하다.

UNIQUE (unique index)
---------------------

| Database를 디자인 할때, 특정한 데이터의 구성요소가 중복된 값을 가질 수 있는지 없는지를 결정하는 것은 매우 중요하다.
| ``UNIQUE`` index를 생성하는 것으로 이 규칙은 강화할 수 있다.
| 이 규칙은 두 가지 정도의 역할을 동시에 수행한다.

   1. ``INDEX``\로서의 기능(B-tree)
   #. 데이터 항목이 중복된 내용으로 수정, 생성이 되는 것을 거부하는 기능

.. code-block:: sql

   # UNIQUE INDEX creation (ALTER)
   CREATE UNIQUE INDEX idx_email
   ON customer (email);

   # duplicate insertion error
   ERROR 1062 (23000): Duplicate entry 'dup-email@dupemail.org' for key 'customer.idx_email'

Types of Indexes
----------------


