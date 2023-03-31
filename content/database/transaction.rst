Query Primer 12. Transactions
#############################

:date: 2023-03-28 22:04
:modified: 2023-03-31 21:10
:category: database
:slug: how-to-transaction
:authors: junehan
:summary: how to transcation
:tags: database, transaction

SUBJECT: Database의 transaction의 이해와 활용
---------------------------------------------

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611
         - SQL level up/Mic/9788968482519

Multiuser Databases
-------------------

*transactions*
   SQL 구문들을 그룹화하여, 그룹 전체를 성공, 실패하도록 관리하는 매커니즘.


| DBMS는 한명의 유저가 데이터를 수정하고, 데이터를 읽는 것을 허용하지만
| 다수의 유저가 DB에 동시적으로 접근하고 수정이 일어난다.
| 예를 들어 이번주의 영화 대여정보를 집계하려고 하는데,

   - 고객이 영화를 새로 대여하는 상황
   - 고객이 대여한 것을 반납하는 상황

| 이렇게 추가와 수정이 같이 일어난다면,
| 내가 원하는 집계결과는 어떻게 나와할까?

정답은, 어떻게 DBMS가 *locking*\을 다루는 지에 달려있다.

Locking
-------

| Lock은 동시 접근을 제어하기 위한 메커니즘이다. 
| 이미 수정이 일어나고 있거나, 접근 중인 데이터에 수정을 하려면 lock이 해제되는 것을 기다려야 한다.
| 대부분의 DBMS는 아래 두 가지 *locking strateies*\중 하나를 사용한다.

   :*read lock, write lock*:
      | Database Writer는 *write lock*\을 DBMS로부터 습득해야 데이터를 수정할 수 있고,
      | Database Reader는 *read lock*\을 DBMS로부터 습득해야 데이터를 읽을 수 있다.
      | *Read lock*\은 동시에 여러 유저에게 전달될 수 있지만,
      | *Write lock*\은 각 테이블에 하나만 발행될 수 있고, 발행된 동안 *read requests*\는 막힌상태로 대기한다.

         - pro

            순차적으로 잘 반영된 데이터를 보장할 수 있다.

         - con

            많은 요청을 처리할 때, write 요청의 처리 속도에 따라 전체적인 속도가 좌우된다.

   :*versioning*:
      | Database Writers는 *write lock*\을 요청하고 습득해야 데이터를 수정할 수 있지만,
      | Database Reader는 어떠한 타입의 lock도 필요로 하지 않는다.
      | 대신, 서버는 Reader의 쿼리가 시작된 시점에서 종료되는 시점사이에 일어나는 어떠한 수정도 반영되지 않은,
      | 균일한 view의 데이터를 보장해야한다.
      | 이 접근법은 *versioning*\이라고 알려져 있다.

         - pro

            많은 요청을 허용할 수 있다.

         - con

            특정 read 요청이 길어질 경우 그 사이 많은 수정사항이 종료되었다면 version과 version사이에 차이가 많이 벌어진다.

| 위 전략의 사용사례로는 아래와 같다.

   - Microsoft SQL Server: 첫 번째, *read lock, write lock* strategy
   - Oracle Server: 두 번째, *versioning* strategy
   - MYSQL SERVER: 선택가능, strategy depend on *storage engine*

Lock Granularities: Level of lock
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

| lock을 활용하는 방식에서도 다양한 전략이 존재한다.
| 서버는 lock에 단위레벨을 부여하는 것으로 세밀한 조정을 구현할 수 있다.

- *Table locks*
   한 테이블에서 다수의 유저가 동시에 수정하는 것을 막는다.
   
- *Page locks*
   | 한 테이블의 동일한 페이지(2KB ~ 16KB의 크기를 가지는 메모리 세그먼트)에서
   | 동시에 다수의 유저가 수정하는 것을 막는다.

- *Row locks*
   동일한 row의 데이터에 대해서 동시에 다수의 유저가 수정하는 것을 막는다.

| 또한 lock의 단위를 지정하는 방식은 각각 장단점이 존재하는데,
| *table lock*\의 경우 전체 테이블들을 lock 하는데에 매우 적은 오버헤드가 발생하지만
| 사용자가 증가할 수록 납득할 수 없는 대기시간이 발생하게 된다.

| 반면, *row lock*\은 오버헤드(lock에 대해 기록되는 정보)가 훨씬 커지는 대신
| 많은 유저가 같은 테이블을 동시에 수정할 수 있다는 장점이 있다.

| MYSQL, MSSQL은 row lock, page lock, table lock을 전환하는 방식으로 사용한다.
| ORACLE의 경우 row lock만을 사용하고, 중간에 레벨 변경은 일어나지 않는다.

What is transaction?
--------------------

| 만약 DBMS가 절떄 종료되지 않고, 프로그램이 실행을 멈추게하는 에러 없이 항상 잘 종료된다면,
| 동시적인 DB의 접근은 고려하지 않아도 괜찮을 것이다.
| 하지만 위에 요소들을 생각하지 않을 수 없고,
| 따라서 하나 이상의 구성요소에서 다수의 유저가 같은 데이터에 접근하는 것을 고려하지 않을 수 없다.
| 이 동시성의 문제를 해결하는 단서가 *transaction*\에 있다.

*transaction*

   | 복수의 SQL구문들을 그룹화 하여, 전부 성공 혹은 전혀 성공하지 못하도록 하는 장치이다. (*atomicity*\)
   | transaction은 정의상 아래 4가지 property로 그 기능과 원칙을 충족해야 한다.

   - *atomicity*
      **transaction으로 그룹화된 연산은 최종 결과에 의해 전부 실패되거나 성공되어야 한다는 특성이다.**

   - *durability*
      **durability는 반드시 영속적인 기록장치에 저장되도록 보장함을 의미하는 속성이다.** 

   - *isolated*\:
      transaction끼리 서로 영향을 주지 영향을 주지 않도록 관리되어야 한다.

      *(이는 최종적으로 transaction integrity가 언제 적용되야 하는지까지 이어진다.)*

   - *consistency*\:
      DBMS가 허용하는 방식, 제약사항을 충족한 상태로만 Data에 영향을 주어야 한다.

      *(cascade, constraints, triggers 등의 사전 조건)*

atomicity
^^^^^^^^^

| DB에 연속적인 동작으로 완결되는 요청이 있을 경우,
| 이전의 동작이 완료되어야 다음으로 약속된 행동으로 연결되는 것이 옳은 논리적인 처리가 필요하다.
| 사전동작에서 부터 최종동작까지 모두 중요한 의미를 가지겠으나,
| 논리적인 절차에 의해서 이는 순차적으로(단계적으로) 처리하기 마련이다.

1. 일련의 요청에 대한 안전한 처리를 위해 요청을 전달하는 프로그램쪽에서 최초로 *transaction*\을 시작한다.
#. 그리고 연결되는(그룹) SQL 구문이 있음을 알린다(issue).
#. 모든 동작이 성공적이었을 때,

   1. 프로그램은 서버에 ``commit``\명령을 issue하고
   #. DBMS는 **transaction을 종료**\하도록 한다.

#. 예외적인 상황이 발생했을 때,

   1. 프로그램은 서버에 ``rollback``\명령을 issue하고
   #. DBMS는 **transaction이 시작된 이후로 발생한 모든 변경을 취소**\한다.

**atomicity는 transaction으로 그룹화된 연산은 최종 결과에 의해 전부 실패되거나 성공되어야 한다는 특성이다.**

durability
^^^^^^^^^^

| 비정상적으로 서버가 종료되어 ``commit``\이나 ``rollback``\명령을 수행하기 전 상태의 transcation이 있을 경우,
| (modified table의 정보는 아직 in-memory상태였을 것이다.)
| DBMS는 재실행된 후 반드시 변화를 다시 적용해야 한다.

**durability는 반드시 영속적인 기록장치에 저장되는 것을 보장함을 의미하는 속성이다.** 

Starting a transaction 
----------------------

DBMS는 transaction의 생성을 아래 두 가지 방법 중 하나의 방법으로 다룬다.

   :connection session as transaction: 연결 세션 자체를 트랜젝션으로 처리한다.

      | 활성화된 transaction은 항상 DB session과 연관되어 있기 때문에, 
      | 명시적으로 transaction을 시작하는 필요나 수단이 준비되지 않는다.
      | 진행중인 transaction이 종료되면, 서버는 자동으로 나의 session에 대한 새로운 transaction을 준비한다.
      | Oracle의 경우 이 방법을 선택하고 있다.

         .. note::

            이 경우 단일 SQL구문이라도 transaction 처리되어, 나중에라도 이 요청을 rollback이 가능하다.

   :no transaction without issuing: 명시적으로 실행하지 않으면, 개별적으로만 처리한다.

      | 명시적으로 transaction을 실행하지 않는다면,
      | 개별적인 SQL구문들은 자동적으로 개별적인 독립된 commit이 진행될 것이다.
      | transaction을 실행하기 위해서, 처음 command를 issue해야 한다.
      | MSSQL, MYSQL의 경우 이 방법을 선택하고 있다.

         .. note::

            한번 입력이 종료되면, 추후 이 요청을 취소하여 되돌리는 것은 불가능하다.


| MSSQL, MYSQL의 경우에도 autocommit 모드를 끄는 것으로
| ORACLE처럼 기본 SQL의 처리방식을 transaction으로 다루게 할 수 있다.

   .. code-block:: sql

      #MSSQL
      SET IMPLICIT_TRANSACTIONS ON 

      #MYSQL
      SET AUTOCOMMIT=0

   .. Important::

      | 이 경우 모든 SQL명령은 transaction의 group scope로 포함되며,
      | 반드시 명시적인 ``commit``\이나 ``rollback``\이 되어야 한다.

.. tip::

   | 로그인 세션이 실행될 때마다 autocommit 모드를 끄는 것으로
   | 모든 SQL구문을 transaction내에서 진행하는 습관을 들이는 것이 좋다.

   '무려 DBA에게 자신 실수를 되돌릴 것을 요청하는데 부끄러움을 줄이는데 아주 큰 도움이 된다!'

Ending a Transaction
--------------------

Transaction의 실행방법은 아래와 같았다.

   - 설정에 의한 자동 Transaction처리

      .. code-block:: sql

         # MYSQL
         SET AUTOCOMMIT=0;
         /* SELECT QUERY 생략 */
         /* INSERT QUERY 생략 */
         COMMIT;

   - SQL구문에서 명시적으로 Transaction실행

      .. code-block:: sql

         START TRANSACTION;
         /* SELECT QUERY 생략 */
         /* INSERT QUERY 생략 */
         COMMIT;

어떤 방식으로 시작되었건 간에, 전달하는 명령으로서 공통적으로는 아래 두 명령으로 종결되어야 한다.

   - ``COMMIT;``
   - ``ROLLBACK;``

위 두 가지 말고도 transaction이 종료될 수 있는 상황이 존재한다.

Straight forward Scenario
^^^^^^^^^^^^^^^^^^^^^^^^^

   - 서버가 종료된 경우

      서버가 재시작되면 transaction은 rollback된다.

   - 다시 ``START TRANSACTION;``\을 전달할 경우

      이전의 transaction은 commit된다.

Concerned Scenario
^^^^^^^^^^^^^^^^^^

   - SQL Schema를 변경하는 DDL의 요청이 포함되는 경우

      | ``ALTER TABLE``\과 같은 구문을 포함했을때, 현재 transaction이 commit되고 새로운 transaction이 시작될 수 있다.

      - 테이블 생성, 삭제
      - 인덱스 생성, 삭제
      - Table Column 삭제

      | 위와 같은 명령의 경우에는 ROLLBACK이 불가능한 이유로, transaction 밖에서 수행되도록 설정된다.

   - 서버가 *dead-lock*\을 발견하거나, transaction이 규칙을 깨는 경우
      
      현재 transaction은 rollback 되며, 에러 메세지를 응답으로 받게 된다.

         ``Message: Deadlock found when trying to get lock; try restarting transaction``

      | 이는 여러 transaction이 서로의 lock을 요구하는 상황에 발생하는데,
      | 이 경우, 하나의 transaction이 선택되어 roll back되고, 나머지는 진행을 이어가도록 한다.
      | 대부분 이렇게 종료된 transaction은 다시 실행될 수 있고, 추가적인 deadlock 상황 없이 종료된다.

         .. note:: *dead-lock*\의 경우 언제 발생하는가?

            | 두 개의 transaction이 각각 다른 lock-A, lock-B을 가지고 있고,
            | 다음에 각각 서로가 가진 lock-B, lock-A를 요구하는 상황일 때.
            | (lock granularity에 따라 row거나, table에 대한 lock)
            | 서로 무한히 lock을 기다리는 상황이 발생할 수 있다.

         .. tip:: 만약 deadlock이 자주 발생하는 편이라면?

            DBMS에 요청을 수행하는 프로그램 자체를 수정해서 문제를 예방해야 한다.

               **(가장 흔한 전략으로는, SQL 구문상 테이블 접근순서를 동일하게 통일하는 것이다.)**

Transaction Savepoints
----------------------

| 가끔 transaction내에서, ROLLBACK을 요구하는 상황에서
| 해당 transaction내의 모든 요청이 취소되는 것을 바라지 않을 수 있다.
| 이런 상황에 대비하여 transaction내에 중간 지점을 가리키는 *savepoints*\들을 설정하면,
| 특점 지점까지만 rollback하는 방식으로 활용될 수 있다.

.. code-block:: sql

   START TRANSACTION;
   UPDATE rental
   SET return_date = CURRENT_TIMESTAMP()
   WHERE rental_id = 1;

   SAVEPOINT before_update_rental;

   UPDATE rental
   SET update_date = CURRENT_TIMESTAMP()
   WHERE rental_id = 1;

   ROLLBACK TO SAVEPOINT before_update_rental;
   COMMIT;

