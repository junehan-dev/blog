Query Primer 14. SQL-Views
##########################

:date: 2023-09-11 18:04
:modified: 2023-09-14 19:32
:category: database
:slug: sql-views
:authors: junehan
:summary: view, api in dbms
:tags: database

SUBJECT: view를 활용하여 인터페이스를 구현해보자
------------------------------------------------
   | 공공 인터페이스는 내부 구현을 추상화하여 사용자에게 상세한 지식을 필요로 하지 않도록 한다.
   | view를 통해서 테이블의 정보를 숨기고 view를 통해서만 접근이 가능하도록 할 수 있다.

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611
         - SQL level up/Mic/9788968482519

Views란 무엇인가?
-----------------

| view는 데이터를 추출하는 메커니즘이다.
| 테이블과 달리 실제 데이터를 가지고 있지 않으며,
| ``select``\구문에 대해 이름을 부여하는 것으로 view를 생성할 수 있다.

| 예를 들어, 고객정보 테이블에서 이메일 주소를 부분적으로 알려지지 않는 것으로 하려 한다.
| 마케팅 부서에서는 광고 관련한 의도로 해당 이메일에 접근을 필요로 할 수 있다.
| 하지만 해당 회사의 개인정보 보호법상 이 데이터는 보안이 지켜져야 하는 것이다.
| 그러므로 직접 데이터 테이블의 접근을 허용하지 않는 대신,
| view를 생성하여, 마케팅 의도가 아닌 개인적인 사용에 고객정보에 접근하려면 이것을 사용하도록 주문할 수 있다.

.. code-block:: sql

   CREATE VIEW customer_vw (
      customer_id,
      first_name,
      last_name,
      email
   ) AS
      SELECT
         customer_id,
         first_name,
         last_name,
         CONCAT(SUBSTR(email, 1, 2), '*****', SUBSTR(email, -4)) AS email
      FROM customer;

view를 사용하는 이유
--------------------

Data 보안
^^^^^^^^^

| 권한에 맞게 접근 단위를 조절하는 방법으로 가장 좋은 제안은,
| 유저에 대해서 table에 대한 ``select``\의 권한을 주지 않으면서,
| view를 생성해 감춰야할 정보를 생략하거나 일부 감추는 것으로 하는 것이다.
| 또한 view에서 ``where``\조건을 걸어 유저가 접근이 가능한 데이터에 제약을 둘 수 도 있다.

Data 집약과 추상화
^^^^^^^^^^^^^^^^^^

| 프로그램에 대해 정리하는 것은 일반적으로 집약된 데이터를 요구하고,
| view는 그러한 상태로 database에 저장되어 있는 것처럼 보이게 하는 좋은 방법이다.
| 또한 긴 SQL을 저장할 수 있기에, JOIN으로 연결된 다수의 테이블을 하나의 테이블처럼 추상화할 수 있다는 장점이 있다.

   .. code-block:: sql

      CREATE VIEW sales_by_film_category
      AS 
         SELECT
            c.name AS category,
            SUM(p.amount) AS total_sales
         FROM payment AS p
            INNER JOIN
               rental AS r ON p.rental_id = r.rental_id
            INNER JOIN
               inventory AS i ON r.inventory_id = i.inventory_id
            INNER JOIN
               film AS f ON i.film_id = f.film_id
            INNER JOIN
               film_category AS fc ON f.film_id = fc.film_id
            INNER JOIN
               category AS c ON fc.category_id = c.category_id
         GROUP BY c.name
         ORDER BY total_sales DESC;

분할된 데이터의 결합
^^^^^^^^^^^^^^^^^^^^

| 때로 데이터베이스는 커다란 테이블을 성능 개선을 이유로 분할하는 경우가 있다.
| 예를 들어 오래된 데이터나 자주 사용하지 않을 데이터만 따로 추출해서 보관하는 것으로 테이블의 크기를 줄인다.

   .. code-block:: sql

      CREATE VIEW payment_all
         payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
      AS
         SELECT
            payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
         FROM payment_old
         UNION ALL
         SELECT 
            payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update
         FROM payment_current;

| 이 활용방식은 좋은 사례인데, 참조 테이블의 데이터의 구조를 변경하고자 할때
| 모든 유저들이 기존에 이 View를 사용하고 있었다면,
| 그들의 쿼리를 변경할 필요 없이 구조 변경이 종료될 수 있다.

View의 데이터 조작과 기반 테이블
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| View로 생성된 결과 테이블이 참조하는 base table의 데이터 항목을 변형하지 않은 상태이며 제약을 위반하지 않는다면,
| 하나의 base table에 ``UPDATE, DELETE, INSERT``\가 모두 가능하다.
| View에 포함된 데이터 Column의 base 테이블간의 관계, 그리고 제약사항을 감안하여 반드시 체크해야 한다.
| (*권한상으로 View에 대해* ``UPDATE``\ *만 가능하도록 하는 것이 가장 낫다.*)

   .. code-block:: sql

      CREATE VIEW customer_details
      AS
         SELECT
            c.customer_id, c.store_id, c.first_name, c.last_name, c.address_id, c.active, c.create_date,
            a.address, a.postal_code,
            ct.city,
            cn.country
         FROM customer AS c
            INNER JOIN address AS a ON c.address_id = a.address_id
            INNER JOIN city AS ct ON a.city_id = ct.city_id
            INNER JOIN country AS cn ON ct.country_id = cn.country_id;

      # SUCCESS on 1 base table
      UPDATE customer_details
      SET
         last_name = 'SMITH-ALLEN'
         active = 0
      WHERE customer_id = 1;
      Query OK, 1 row affected (0.03 sec) Rows matched: 1  Changed: 1  Warnings: 0

      # SUCCESS on 1 base table
      UPDATE customer_details
      SET
         address = '999 Mockingbird Lane'
      WHERE customer_id = 1;
      Query OK, 1 row affected (0.03 sec) Rows matched: 1  Changed: 1  Warnings: 0

      # Fail on 2 base tables
      UPDATE customer_details
      SET
         last_name = 'SMITH-ALLEN'
         active = 0
         address = '999 Mockingbird Lane'
      WHERE customer_id = 1;
      ERROR 1393 (HY000): Can not modify more than one base table through a join view 'sakila.customer_details'

