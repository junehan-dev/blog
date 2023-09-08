Query Primer 13. Indexes and Constraints
########################################

:date: 2023-09-04 18:04
:modified: 2023-09-08 23:58
:category: database
:slug: indexes-and-constraints
:authors: junehan
:summary: how to create index and constraints for table
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
^^^^^^^^^^^^^^^^^^^^^

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

B-tree index
^^^^^^^^^^^^

- branch node: A-Z, 0-9 등으로 traverse 방향을 가리키기 위한 navigating node
- leaf node(no child node): actual value와 physical 데이터 위치값을 가진 actual node

| 데이터가 삽입되고 수정, 삭제될때마다 B-tree는 치우치는 것을 방지하기 위해 부분 정렬을 실시한다.
| tree를 균형상태로 유지하는 것으로, leaf node를 탐색의 균일한 속도를 보장할 수 있다.

Bitmap index
^^^^^^^^^^^^

| B-tree index가 다양한 범위의 값들을 정렬한 상태로 탐색하기 일반적으로 좋은 것이라면,
| 때로는 *true, false*\등과 같이 정해진 값이 분포되는 데이터의 항목이 있는 경우도 있다.
| 이 경우 0, 1을 나누는 용도로 branch node가 navigate로서 의미있게 활용될 수 없을 것이다.

| 이렇게 적은 범위의 값(*low-cardinality data*\)을 가진 데이터 구성요소를 위해서는 다른 indexing 전략이 필요하다.
| Oracle DB의 경우에 *bitmap index*\를 사용한다.
| 이것은 각 데이터 항목에 대해서 bitmap을 생성한다.

   | 두 개 범위의 값을 가지고 있는 경우(true, false)
   | 두 종류의 비트맵을 생성한다.
   | 만약 *false*\인 데이터를 찾는다면, DB서버는 0 비트맵을 읽고 빠르게 찾으려는 데이터를 조회한다.

| bitmap index는 low-cardinality data에 대해서 간편하고 좋은 방법이디만,
| 이 전략은 값의 범위가 넓어진다면 너무 많은 bitmap들을 관리해야하게 되어 실패로 이어질 수 있다.

.. code-block:: sql

   # Oracle feature
   CREATE BITMAP INDEX idx_active
   ON customer (active);

Text index
^^^^^^^^^^

| 데이터 항목이 많은 텍스트를 포함하고 있는 경우에, 해당 데이터에서 특정 키워드나 구문을 검색하게 되는 경우가 있다.
| 그렇다고 이 항목을 전부 탐색해서 키워드를 검색하는 것을 원하지는 않을 것이다.

.. note::

   - MySQL의 경우에는 *full text* indexes라는 도구를 지원하며,
   - Oracle의 경우에는 *Oracle Text*\라는 도구를 지원한다.

| Document 탐색은 예시를 들기에는 매우 최적화가 된 도구이니,
| 단순히 이런 도구가 있으며 문서탐색에 사용된다는 것으로 파악하고 있는 것이 좋다.

Using Index
^^^^^^^^^^^

각 Database Server 는 *query optimizer*\가 어떻게 SQL을 처리하는지 확인시켜주는 도구를 포함한다.

   .. code-block:: sql

      EXPLAIN
      SELECT customer_id, first_name, last_name
      FROM customer
      WHERE first_name LIKE 'S%' AND last_anme LIKE 'P%' \G;

      id: 1
      select_type: SIMPLE
      table: customer
      partitions: NULL
      type: range
      possible_keys: idx_last_name
      key: idx_last_name
      key_len: 182
      ref: NULL
      rows: 28
      filtered: 11.11
      Extra: Using index condition; Using where
      1 row in set, 1 warning (0.02 sec)

.. tip::

   | SQL과 INDEX등을 통해 여기까지 보여준 과정은 쿼리튜닝의 예시이다.
   | 튜닝은 SQL 구문을 살피고 서버에서 선택할 자원을 결정하는 것을 포함한다.
   | SQL구문을 수정하거나, DB서버의 자원을 수정하거나 혹은 둘 다 시행할 수 있다.
   | 튜닝은 매우 상세한 것을 다루는 주제이니,
   | 사용하는 서버의 튜닝가이드나 별도 서적을 살펴보는 것이 좋다.


- 테이블 내에 Index를 생성하는 것이 적합한지는 *값의 다양성 분포(cardinality)*\가 높은지에 달려 있다.
- SQL구문의 Index활용 효율성은 데이터 선택 압축율이 10%보다 작은 것을 기준으로 일반적으로 평가된다.

   - 압축율이 높은 범위의 Index scan을 하도록 제한하는 방법을 사용한다.
   
      .. code-block:: sql

         SELECT * FROM post
         WHERE
            created BETWEEN '2023-08-01' AND '2023-08-07'

   - 찾으려는 데이터 항목을 *Covering Index*\로 생성하고 이를 사용한다.

      이는 테이블 접근 없이, *multicolumn index object* 내에서 검색과 추출이 종료됨을 의미한다.

      .. code-block:: sql

         # multicolumn index 없이 두 항목을 필터 추출
         EXPLAIN FORMAT=JSON SELECT last_name, address_id FROM customer WHERE address_id BETWEEN 200 AND 300 AND (last_name LIKE 'H%' OR last_name LIKE 'J%')\G;
      
      .. code-block:: json

         EXPLAIN: {
           "query_block": {
             "select_id": 1,
             "cost_info": {
               "query_cost": "28.86"
             },
             "table": {
               "table_name": "customer",
               "access_type": "range",
               "possible_keys": [
                 "idx_fk_address_id",
                 "idx_last_name"
               ],
               "key": "idx_last_name",
               "used_key_parts": [
                 "last_name"
               ],
               "key_length": "182",
               "rows_examined_per_scan": 63,
               "rows_produced_per_join": 10,
               "filtered": "16.69",
               "index_condition": "((`sakila`.`customer`.`last_name` like 'H%') or (`sakila`.`customer`.`last_name` like 'J%'))",
               "cost_info": {
                 "read_cost": "27.81",
                 "eval_cost": "1.05",
                 "prefix_cost": "28.86",
                 "data_read_per_join": "5K"
               },
               "used_columns": [
                 "last_name",
                 "address_id"
               ],
               "attached_condition": "(`sakila`.`customer`.`address_id` between 200 and 300)"
             }
           }
         }

      .. code-block:: sql

         # multicolumn index에 대해서만 필터 추출
         ALTER TABLE customer ADD INDEX idx_lname_addr (address_id, last_name);
         EXPLAIN FORMAT=JSON SELECT last_name, address_id FROM customer WHERE address_id BETWEEN 200 AND 300 AND (last_name LIKE 'H%' OR last_name LIKE 'J%')\G;
 
      .. code-block:: json

         EXPLAIN: {
           "query_block": {
             "select_id": 1,
             "cost_info": {
               "query_cost": "20.60"
             },
             "table": {
               "table_name": "customer",
               "access_type": "range",
               "possible_keys": [
                 "idx_fk_address_id",
                 "idx_last_name",
                 "idx_lname_addr"
               ],
               "key": "idx_lname_addr",
               "used_key_parts": [
                 "address_id"
               ],
               "key_length": "184",
               "rows_examined_per_scan": 99,
               "rows_produced_per_join": 10,
               "filtered": "10.52",
               "using_index": true, // <- covering index 사용여부
               "cost_info": {
                 "read_cost": "19.56",
                 "eval_cost": "1.04",
                 "prefix_cost": "20.60",
                 "data_read_per_join": "5K"
               },
               "used_columns": [
                 "last_name",
                 "address_id"
               ],
               "attached_condition": "((`sakila`.`customer`.`address_id` between 200 and 300) and ((`sakila`.`customer`.`last_name` like 'H%') or (`sakila`.`customer`.`last_name` like 'J%')))"
             }
           }
         }

   - 캐싱 데이터를 활용한다.

      - IO 크기를 줄이는 *summary table* (접근 테이블을 분할해서 복사한 테이블)

         - 원본 테이블과의 sync가 fresh(신선)해야한다.

         .. code-block:: sql

            # 검색 데이터 항목과 primary key만 가지고 있는 subset.

            SELECT * FROM post_date_mart
            WHERE created BETWEEN '2023-08-01' AND '2023-08-07';


      - 데이터 수를 줄이는 *cache database* (최근 사용중인 데이터만 저장하는 서버)

         - 백업 DB로의 주기적인 업로드 batch job을 포함한다.

Downside of Index
^^^^^^^^^^^^^^^^^

| Index는 Table의 특정 column을 복사해둔 듯한 별도의 테이블이다.

   - 많은 공간을 차지하며,
   - 테이블에 대한 수정은 연관된 index table의 조정으로 이어진다.

   따라서 Index를 많이 생성할수록 서버는 모든 Schem objects(index)이어서 관리해야하고 이는 속도를 느리게 한다.

| 가장 좋은 전략은 특별히 필요성을 느끼는 경우에는 index를 추가하는 것이다.

   - 월별로 실시하는 백업이 있다면, 필요한 만큼 index를 생성하고 업무가 끝난 뒤에 삭제하고,
   - 데이터센터의 경우라면 로그가 쌓이는 낮에 index의 수정이 취약하고, 데이터를 백업하는 저녁에는 덜 필요할 것이다.

      - 백업전에 index를 삭제하고, 데이터 백업 후 index를 새로 생성하는 것이 일반적이다.
   
| Index는 너무 많거나 너무 적어도 문제가 되는 존재다.
| 만약 얼마나 많은 index를 준비해야할지 결정이 어렵다면 아래의 메뉴얼을 따르는 것을 추천한다.

   - Primary key
   - Foreign key, CASCADE
   - frequently used to retrieve data

      .. tip::

         - date column
         - short string(2 ~ 50) column

         위 경우 이외에는 피하는 것이 좋다.

Constraints
-----------

:*Primary key*: 데이터의 구성요소가 테이블 내에서 유일함을 보장함

   - primary key는 unique에 탐색유용성과 데이터의 대표성을 더한 특별한 변형

:*Unique key*: 데이터의 구성요소가 테이블 내에서 유일함을 보장함

:*Foreign key*: 데이터의 구성요소가 다른 테이블의 primary key 항목만을 포함하도록 보장함

   - *update cascade*
   - *delete cascade*

:*Check key*: 데이터의 구성요소가 특정한 값들만 가질 수 있도록 제한함

- *constrints*\를 제외하면 database의 지속가능성은 의심받을 수 있는 것이다.

   | 예를 들어, 만약 서버가 foreign key로 사용중인 customer의 ID를 변경하면서 연관된 정보를 수정하지 않는다면,
   | 해당 ID를 참조하는 다른 테이블의 정보는 유효하지 않은 것이 된다.
   | 이러한 데이터를 *orphaned rows*\라고 부른다.

- 반면 *primary key, foreign key*\가 존재한다면,

   | DB서버는 제약사항이 무너지는지 확인되는 순간 에러를 발생시키거나,
   | 규칙을 유지하기 위해 다른 테이블에 이 변화를 전파할 것이다.

Creation
^^^^^^^^

- 테이블 생성시 제약 조건 생성

   .. code-block:: sql

      CREATE TABLE customer (
         customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
         store_id TINYINT UNSIGNED NOT NULL,
         address_id SMALLINT UNSIGNED NOT NULL,
         last_name VARCHAR(45) NOT NULL,
         
         # Constraints
         ## PK
         PRIMARY KEY (customer_id),
         ## INDEX
         KEY idx_last_name (last_name),
         ## FK
         KEY idx_fk_store_id (store_id),
         KEY idx_fk_address_id (address_id),
         ### customer.address_id->address.address_id
         CONSTRAINT fk_customer_address
            FOREIGN KEY (address_id) REFERENCES address (address_id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE,
         ### customer.store_id->store.store_id
         CONSTRAINT fk_customer_store
            FOREIGN KEY (store_id) REFERENCES store (store_id)
            ON DELETE RESTRICT
            ON UPDATE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

- 테이블 생성 후 제약 조건 생성
   
   .. code-block:: sql

      ALTER TABLE customer
         ADD CONSTRAINT fk_customer_address
         FOREIGN KEY (address_id) REFERENCES address (address_id)
         ON DELETE RESTRICT ON UPDATE CASCADE;

| *FOREIGN KEY*\의 경우 다른 데이터 항목에 대해 의존하는 제약조건 인 만큼,
| 참조하는 항목의 수정, 삭제가 일어났을떄 어떻게 동작할지 규정할 수 있다.

   - ``RESTRICT``\: 참조 항목 변경, 삭제 시도를 에러처리 한다.
      orphaned row가 발생하지 않도록 제한한다.
   - ``CASCADE``\: 참조 항목 변경 시 데이터 항목은 이를 반영하며, 삭제시 항목을 포함하는 데이터도 삭제한다.
      orphaned row가 될 경우 삭제하도록 한다.
   - ``SET <VALUE>``\: 참조 항목 변경, 삭제시 데이터 항목을 <VALUE>값으로 설정한다. 

