Query Primer 7. Data Generation, Manipulation, and Conversion
#############################################################

:date: 2023-02-10 18:18
:modified: 2023-02-27 19:41
:category: database
:slug: Data-generation-manipulation-conversion
:authors: junehan
:summary: intro to data manipulates and DDL
:tags: sql

SUBJECT: 데이터 타입과 데이터 조작 방법에 대해 알아보자
-------------------------------------------------------

   - References

      - text book, Learning sql 3rd edition

String Data
-----------

TYPES
^^^^^

:``CHAR``: | 고정된 길이로, blank-padded strings. 
           | MYSQL에서는 255, Oracle에서는 2000길이 까지 허용한다.

:``VARCHAR``: | variable-length. 길이와, 문자열을 동시에 가진 string.
              | MYSQL-65,535 Oracle 4000

:``TEXT``: | 굉장히 긴 VARCHAR문자열 데이터.
           | MYSQL-MAX 4GB(tinytext, text, midiumtext, longtext), ORACLE(clob type)-128TB


String Generation
-----------------

| 정해진 데이터의 제약(길이제한 등)에 맞지 않게 데이터를 입력할 경우,
| 서버는 예외를 발생시킨다.
| 이는 모든 DB서버에서 동일한 현상이지만, MYSQL 등 일부 서버의 경우 잘라진 길이로 입력되도록 하는 등
| 예외가 아닌 처리가 가능하도록 정책을 변경할 수 도 있다.
|
| MYSQL 6.0(현 8.032), 이후 기본 행동은 "strict" mode 로 설정되어 있다.
| 이는 문제 생겼을때 예외를 발생시키는 것으로, 반면 구 버전의 경우 
| 문자는 잘려지고, 경고가 전달된다.

.. code-block:: sql

   SELECT @@session.sql_mode;
   +-----------------------------------------------------------------------------------------------------------------------+
   | @@session.sql_mode                                                                                                    |
   +-----------------------------------------------------------------------------------------------------------------------+
   | ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION |
   +-----------------------------------------------------------------------------------------------------------------------+

   SET sql_mode="ansi";

   SELECT @@session.sql_mode;
   +--------------------------------------------------------------------------------+
   | @@session.sql_mode                                                             |
   +--------------------------------------------------------------------------------+
   | REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI |
   +--------------------------------------------------------------------------------+

   update string_tbl set vchar_fld = 'THIS IS very long of vchar field data';
   Query OK, 1 row affected, 1 warning (0.00 sec)
   Rows matched: 1  Changed: 1  Warnings: 1 

   SHOW warnings;
   +---------+------+------------------------------------------------+
   | Level   | Code | Message                                        |
   +---------+------+------------------------------------------------+
   | Warning | 1265 | Data truncated for column 'vchar_fld' at row 1 |
   +---------+------+------------------------------------------------+ 


| 실제로 위처럼 구문에 대한 모드를 변경했을때, 
| ANSI_QUOTES 라는 규칙에 의해 " 는 제대로 동작하지 않는다.

   :*ANSI_QUOTES*: "기호를 \`와 같은 구분자 문자로 사용하고 문자열 기호로 사용하지 않는다.

| 문자열이 잘려지는 것은, 결론적으로는 규약에 따라 재입력된 것으로
| 원하는 결과와는 다르게 적용된 것이라서, varchar를 사용하면서 충분히
| 큰 길이의 문자열을 담을 수 있도록 제약을 수정하는 것이 좋은 해결법이다.

   .. tip::

      *서버는 문자열이 저장되기 위한 공간만 사용하는 것이기 때문에,
      충분히 큰 크기로 데이터의 제약을 설정하는 것은 낭비라고 볼 수 없다.*

including single quotes
^^^^^^^^^^^^^^^^^^^^^^^

| 홑따옴표가 문자열의 구분자로 사용되기 때문에 apostrophe로 활용하기 위해서
| 아래와 같이 사용할 수 있다.

.. code-block:: sql

   UPDATE string_tbl
   SET text_fld = 'This string didn''t work, but it does now';

   UPDATE string_tbl
   SET text_fld = 'This string didn\'t work, but it does now';

String Manipulation
-------------------

Functions return numbers
^^^^^^^^^^^^^^^^^^^^^^^^

- :``LENGTH(str)``: 문자열의 현재 길이를 반환.

   .. code-block:: sql

      SELECT 
         LENGTH(char_fld) AS char_data,
         LENGTH(vchar_fld) AS VCHAR_DATA
      FROM string_tbl; 

      +-----------+------------+
      | char_data | VCHAR_DATA |
      +-----------+------------+
      |         9 |         10 |
      +-----------+------------+

     #char_data = 'char data'
     #vchar_data = 'vchar data'

- :``POSITION(substr IN str)``: synonym for ``LOCATE(substr, str, 1)``\. LOCATE는 3번째 param으로 탐색 위치를 지정할 수 있으며, SQL에서는 0을 위치가 아닌 부정의 의미로만 사용한다.

   .. code-block:: sql

      SELECT 
         POSITION('data' IN vchar_fld) AS DATA_POS
      FROM string_tbl; 

      SELECT 
         LOCATE('data', vchar_fld) AS DATA_POS
      FROM string_tbl; 

      +----------+
      | DATA_POS |
      +----------+
      |        7 |
      +----------+ 

      #vchar_fld = 'vchar6data';

- :``STRCMP(expr1, expr2)``: 문자열 비교, string.h의 strcmp함수와 동일하게 동작한다. 문자열화 가능한 모든 것에 사용가능하며, NULL이 표현으로 들어올 경우 무조건 NULL이 반환된다. 

   .. code-block:: sql

      SELECT
         STRCMP('123', '123') as 'equ',
         STRCMP('abc', 'bcd') as 'smaller',
         STRCMP('q', 'a') as 'bigger',
         STRCMP('q', NULL) as 'null',
         STRCMP(123, 23) as 'smaller2';

         +-----+---------+--------+------+----------+
         | equ | smaller | bigger | null | smaller2 |
         +-----+---------+--------+------+----------+
         |   0 |      -1 |      1 | NULL |       -1 |
         +-----+---------+--------+------+----------+

- REGEXP, LIKE operator in SELECT

   .. code-block:: sql

      SELECT
         name, name LIKE '%y' AS ends_in_y
      FROM category;

      SELECT
         name, name REGEXP 'y$' AS ends_in_y
      FROM category;

      +-------------+-----------+
      | Action      |         0 |
      | Animation   |         0 |
      | Children    |         0 |
      | Classics    |         0 |
      | Comedy      |         1 |
      | Documentary |         1 |
      | Drama       |         0 |
      | Family      |         1 |
      | Foreign     |         0 |
      | Games       |         0 |
      | Horror      |         0 |
      | Music       |         0 |
      | New         |         0 |
      | Sci-Fi      |         0 |
      | Sports      |         0 |
      | Travel      |         0 |
      +-------------+-----------+ 

Functions return strings
^^^^^^^^^^^^^^^^^^^^^^^^

- :``CONCAT(str1, str2, ...)``: generate string with strings.

   .. code-block:: sql

      UPDATE string_tbl
         SET text_fld = CONCAT(text_fld, ', but now it''s more longer');

      SELECT first_name || ' ' || last_name || ' has been a customer since ` || date(create_date) 
      /*
       * '||' 기호를 concat으로 받아들이는 경우는 sql_mode에 PIPES_AS_CONCAT가 있어야 한다.(ansi로 설정시 추가됨)
       */

- :``INSERT(dest_str, pos, offset, src-str)``: generate with inserting src into dest

   .. code-block:: sql

      SELECT INSERT('Helloworld', 6, 0, ', ') AS string;

      +--------------+
      | string       |
      +--------------+
      | hello, world |
      +--------------+  

- ``REPLACE(str, search, replace)``: generate string with replacing the search string to replace string.

   .. code-block:: sql

      SELECT REPLACE('goodbye world', 'goodbye', 'hello');
      #hello world

- ``SUBSTRING(str, start, length)``: generate string extracted from start to length.

   .. code-block:: sql

      SELECT SUBSTRING('goodbye cruel world', 9, 5);
      #cruel

Working with Numeric Data
-------------------------

| 문자열과 다르게 숫자형 데이터는 단순하다.
| 숫자를 입력하고, 값을 추출하고, 계산을 통해 값을 생성한다.
| 모든 일반적인 숫자 연산이 가능하며, 괄호를 통해 우선순위를 지정할 수 있다.

Types
^^^^^

:tinyint: -128 ~ 127 / 1byte
:smallint: -32,768 ~ 32,767 / 2byte
:mediumint: -8,388,608 ~ 8,388,607 / 3byte
:int: -2,147,483,648 ~ 2,147,483,647 / 4byte
:bigint: -2^63 ~ -2^63 - 1 / 8byte
:float(p, s): 4byte single presion (unsignable)
:double(p, s): 8byte double precision (unsignable)

Controlling Number Precision
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- :``CEIL(number)``: Round up to integer.
- :``FLOOR(number)``: Round down to integer.
- :``ROUND(number, pos)``: Round at next to number of *pos(negative pos means interger portion)*\.
- :``TRUNCATE(number, pos)``: Truncate the number of *pos(same as usage of pos in ROUND function)*\.

   .. code-block:: sql

      SELECT ROUND(17, -1), TRUNCATE(17, -1);

      #20, 10


Generation Temporal Data
------------------------

시간 데이터를 생성하는 방법

   - 이미 존재하는 date, datetime, time열의 데이터에서 복사
   - date, datetime, time을 생성하는 내장 함수를 사용
   - 서버에서 평가할 수 있도록, 시간 데이터를 의미하는 문자열을 구성

String representation of temporal data
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Date Format Components

   - :YYYY: 1000 ~ 9999
   - :MM: 01 ~ 12
   - :DD: 01 ~ 31
   - :HH: 00 ~ 23
   - :HHH(elapsed): -838 ~ 838
   - :MI: 00 ~ 59
   - :SS: 00 ~ 59

- Required Date Components Formats

   - :``DATE``: YYYY-MM-DD, date part only
   - :``DATETIME``: YYYY-MM-DD HH:MI:SS, date and time (1000-01-01 ~ 9999-01-01)
   - :``TIMESTAMP``: YYYY-MM-DD HH:MI:SS, date and time in UTC ONLY (1970-01-01 ~ 2038-01-19)
   - :``TIME``: HHH:MI:SS


- Date Format components

   - :``%M``: Month name(January ~ December)
   - :``%m``: Month (01 ~ 12)
   - :``%d``: Day (01 ~ 31)
   - :``%j``: Day of year (001 ~ 366)
   - :``%W``: Weekday name (Sunday ~ Saturday)
   - :``%Y``: Year in 4 digit (2023)
   - :``%y``: Year in 2 digit (23)
   - :``%H``: Hour (00 ~ 23)
   - :``%h``: Hour (01 ~ 12)
   - :``%i``: Minutes (00 ~ 59)
   - :``%s``: Seconds (00 ~ 59)
   - :``%f``: Microseconds (000000 ~ 999999)
   - :``%p``: A.M or P.M.

Generation Dates
^^^^^^^^^^^^^^^^

- :``CAST(<SRC> AS type)``: SRC 양식에서 type에 대한 자료로 변형

   .. code-block:: sql

      SELECT
         CAST('2019-09-17' AS DATE) AS date_field,
         CAST('108:17:57' AS DATE) AS time_field;

      # 2019-09-17 | 108:17:57
      # Type has changed.

- :``STR_TO_DATE('temporal string format' AS format_expr)``: 문자열 양식에서 format_expr에 해당하는 부분을 구성요소에 맞게 변형

   .. code-block:: sql

      SELECT STR_TO_DATE('Septempber 17,..HI 2019', '%M %d,..HI %Y');
      # 2019-09-17

      SELECT STR_TO_DATE('Septempber 17,..HI 2019 12', '%M %d,..HI %Y %H');
      # 2019-09-17 12:00:00

- :``DATE_ADD(SRC-DATE, INTERVAL n-amount AMOUNT-TYPE)``: SRC-DATE로 부터 Interval만큼 더한 날짜를 반환하는데, INTERVAL 형태에 따라 DATETIME으로 변형

   - Interval types

      - ``second``
      - ``minute``
      - ``hour``
      - ``day``
      - ``month``
      - ``year``
      - ``minute_second``: m:s sepeated by ':'
      - ``hour_second``: h:m:s sepeated by ':'
      - ``year_month``: sepeated by '-'

   .. code-block:: sql

      SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 9 DAY);
      # 2023-03-05
       
      SELECT DATE_ADD(CURRENT_DATE(), INTERVAL '9:33:34' HOUR_SECOND);
      # 2023-02-24 09:33:34

Manipulate Dates
^^^^^^^^^^^^^^^^

- :``DAYNAME(DATE)``: DATE로 부터 day name of week를 추출한다.

   .. code-block:: sql

      SELECT DAYNAME(CURRENT_DATE());
      # Friday

      SELECT DAYNAME('2019-09-18');
      # Wednesday       

- :``EXTRACT(UNIT FROM DATE)``: DATE로 부터 UNIT의 수치를 반환한다.

   :UNIT: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, MICROSECOND

   .. code-block:: sql

      SELECT EXTRACT(HOUR FROM NOW());
      # 23

      SELECT EXTRACT(DAY '2019-09-18');
      # 18

- :``DATEDIFF(DEST, SRC)``: DATE DEST로 부터 SRC의 DAY DIFF를 반환한다.

   :UNIT: YEAR, MONTH, DAY, HOUR, MINUTE, SECOND, MICROSECOND

   .. code-block:: sql

      SELECT DATEDIFF('2019-09-03', '2019-06-21 00:00:01');
      # 74


Conversion Functions
^^^^^^^^^^^^^^^^^^^^

| CAST()를 사용해서 string(date format)을 datetime 타입의 값으로 변환했었는데,
| 모든 데이터베이스 서버는 특정 데이터를 다른 타입으로 변경할 수 있는 내장함수들을 가지고 있지만,
| CAST()를 사용할 것을 적극 추천한다.

:``CAST(<SRC> AS <TYPE>)``: SRC를 내장 Type에 맞게 자료형을 변경한다.

   .. code-block:: sql

      SELECT
         CAST('2019-09-17' AS DATE) AS date_field,
         CAST('1456328' AS SIGNED INTEGER) AS to_num,
         CAST('099ABC111' AS UNSIGNED INTEGER) AS to_natural;
      # 2019-09-17 | 1456328 | 99

   | 이 경우 마지막 쿼리에서 Warning이 발생하는데,
   | 예상할 수 있는 정도의 경고로 크리티컬한 것이 아니므로
   | 성공적으로 쿼리는 종료되지만 정책의 변경에 의해 금지하거나 할 수 있다.

