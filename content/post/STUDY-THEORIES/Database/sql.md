---
title: "기초 Sql 요약"
date: 2022-04-19T07:46:49+09:00
categories:
- STUDY
- DATABASE
- SQL
keywords:
- SQL
#thumbnailImage: //example.com/image.jpg
---

SUBJECT: 데이터베이스 쿼리문을 간단히 파악하자
----------------------------------------------
  - References

    - https://www.w3schools.com/mysql/default.asp

GROUP BY
--------

- DESC

   - GROUP BY 진술은 일반 rows를 같은 값으로 평가된 것을 요약화된 rows로 그룹화합니다.

   - 예를 들면, find the number of customers in each country

      - 각 나라별 소비자의 숫자. / 도시(공통키워드) / customer별로 country정보가 있을 것이다.

- SYNTAX

   ```sql
   SELECT column_name(s)
   FROM table_name
   WHERE condition
   GROUP BY column_name(s)
   ```

ORDER BY
--------

- DESC

   - ``ORDER BY`` 키워드는 result-set을 오름차순, 내림차순으로 정렬하는 데에 사용됩니다.

   - ``ORDER BY`` 키워드는 records들을 기본적으로 asc(오름차순)으로 정렬하고, ``DESC`` 키워드를 통해 내림차순으로 정렬할 수 있습니다.


- SYNTAX

   ```sql
   SELECT column1, column2, ...
   FROM table_name
   ORDER BY column1, column2, ... ASC|DESC; 
   ```

MIN MAX Function
----------------

- DESC

   - ``MIN()`` 는 선택한 column에서 가장 작은 값을 반환합니다.
   - ``MAX()`` 는 선택한 column에서 가장 큰 값을 반환합니다.

- SYNTAX

   ```sql
   SELECT MIN(column_name)
   FROM table_name
   WHERE condition; 
   ```

COUNT Function
--------------

- DESC

   - ``COUNT()`` 는 명시한 조건을 만족하는 Rows의 수를 반환합니다.

- SYNTAX

   ```sql
   SELECT COUNT(column_name)
   FROM table_name
   WHERE condition; 
   ```

AVG Function
-------------

- DESC

   - ``AVG()`` 는 명시한 조건을 만족하는 column(numeric)에 해당하는 row들의값의 평균을 반환합니다.

- SYNTAX

   ```sql
   SELECT AVG(column_name) # STRING TYPE X order by와 다르다.
   FROM table_name
   WHERE condition; 
   ```

ALIASES
-------

- DESC

   - aliases들은 테이블 혹은 테이블의 필드에 대해서 temporary name을 부여합니다.
   - aliases들은 column(필드)의 이름을 더욱 가독성 있게 만들어줍니다.
   - 지정한 aliases들은 해당 쿼리에 대해서만 유효합니다.
   - aliases들은 ``AS`` 키워드를 통해 생성됩니다.

- SYNTAX

   ```sql
   SELECT column_name AS alias_name
   FROM table_name;
   ```

   ```sql
   SELECT column_name
   FROM table_name AS alias_name;
   ```

