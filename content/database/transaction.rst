Query Primer 12. Transactions
#############################

:date: 2023-03-28 22:04
:modified: 2023-03-29 20:32
:category: database
:slug: intro-to-transcation-mechanism
:authors: junehan
:summary: intro to transcation mechanism
:tags: database, transaction

*transactions*
   SQL 구문들을 그룹화하여, 그룹 전체를 성공, 실패하도록 관리하는 매커니즘.

SUBJECT: Database의 transaction 매커니즘에 대한 이해
----------------------------------------------------

   - References

      - web
      - text book

         - Learning sql 3rd edition/Alan Beaulieu/9781492057611
         - SQL level up/Mic/9788968482519

Multiuser Databases
-------------------

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

Lock Granularities
^^^^^^^^^^^^^^^^^^
