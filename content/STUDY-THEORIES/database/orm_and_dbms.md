---
title: "데이터베이스와 DBMS 그리고 ORM"
date: 2022-04-12T22:26:56+09:00
categories:
- STUDY
- DATABASE
---

SUBJECT: DBMS와 ORM의 이해
-------------------------
  - References
    - https://en.wikipedia.org/wiki/Object%E2%80%93relational_mapping
    - https://en.wikipedia.org/wiki/Database

Definition
----------

*Database*
   정렬된 데이터의 집합으로 전기신호를 통해 접근하거나 저장하는 대상을 의미합니다.

   - 작은 데이터베이스들은 파일 시스템에 저장될 수 있지만, 거대한 데이터베이스라면 컴퓨터 클러스터를 사용합니다.
   - 데이터 베이스의 디자인은 형식적인 기술과 실용적인 방법론들로 확장됩니다.
      - 데이터 모델링
      - 효율적인 데이터 저장방식과 저장소
      - query 언어(질의 언어)
      - 민감한 데이터에 대한 보안
      - 동시성의 접근과 실수에 내성을 지닌 분산 컴퓨팅 문제

*Database Management system(DBMS)*
   데이터 베이스 관리 시스템은 사용자, application, 그리고 데이터 베이스 자신과 소통하여, 데이터를 확보하고 분석하는 software를 의미합니다.

   - DBMS프로그램은 추가적으로 코어기술들이 데이터베이스를 감싸도록 합니다.
   - 데이터베이스의 총합, DBMS 그리고 관련된 applications들은 *database system* 이라고 불려질 수 있습니다.

*Relational Database*
   컴퓨터 과학자들이 DBMsystem을 그들이 지원하는 방식의 데이터 모델들에 따라 분류하였습니다.

   - 이 모델은 1980년대에 등장하였고, rows와 columns가 tables에 나열되어 있고, 대부분 *SQL*을 사용하여 데이터를 작성하거나, query(질문)하였습니다.
   - 대표 제품: *mysql, oracle, postgresql, mariadb*

{{< figure src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Relational_key_SVG.svg/258px-Relational_key_SVG.svg.png" title="관계형 모델에서, record가 가상 키로 linked되는 형태" >}}

DBMS 아키텍처 
-------------

위의 정의 부분에서 database management system이라고 불리기 위해선,

   - "DBMS프로그램은 코어 기술들이 데이터베이스를 감싸도록한다."
   - 데이터베이스의 총합, DBMS 그리고 관련된 applications들은 *database system* 이라고 불려질 수 있습니다.

라고 언급되었기 때문에 이 부분의 구성요소는 어떤게 있는지 가볍게 요약해 보겠습니다.

DBMS Processing 
   1. User -> SQL 구문 작성
   2. Query language평가 엔진의 query 전처리과정

      - parser: 명령어 분석과 기계어 전환
      - optimizer: 명령어 분석 이후에 효율적인 연산을 위한 최적화

   3. 버퍼 매니저:

      - 특별한 용도로 사용하는 메모리 영역을 확보하는 관리자

   4. 디스크 용량 매니저:

      - HDD의 디스크컨트롤러가 아닌 스스로 저장할 위치를 선택하고 관리하는 역할을 맡아, 어디에 저장할지를 관리하여 읽고 쓰기를 제어합니다.

   5. 트랜잭션 매니저와 락 매니저:

      - 상용시스템에서 데이터베이스는 동시접근과 사용이 일어나는데, 각각 처리는 DBMS내부에서 트랜잭션이라는 단위로 관리됩니다.
      - 트랜잭션 매니저는 이 session(시간적인 실행단위)이 타 session에 대한 정합성을 유지하도록 하고
      - 필요한 경우 데이터에 lock을 걸어, 다른 요청이 들어오면 전화부스의 문을 닫아 놓듯이 요청을 대기키는 역할을 합니다.

   6. 리커버리 매니저: 

      - 시스템은 언제나 장애가 발생할 수 있기 때문에, 정기적으로 데이터를 백업하고 문제가 일어났을 때 복구를 해줘야 합니다. 이 역을을 수행하는 것이 리커버리 매니저입니다.

SQL
---

{{< figure src="https://upload.wikimedia.org/wikipedia/commons/f/f2/DVD_Rental_Query.png" title="SQL SELECT와 결과" >}}

- *데이터베이스에 대해서 사용하기 위해 위에 나열된 단위 기능의 사양과 언어, 절차에 대해서 이해해야만 사용해야한다면 극소수의 전문가 집단만이 조작할 수 있는 성역이 되었을 것입니다.*

- 이를 사용자가 사용할 수 있도록 마련된 것이 SQL, DBMS의 동작을 추상화한 SQL언어 입니다.

- DBMS프로그램은 언제나 원격접속보다 직접 접속한 관리자를 우선으로 한다고 합니다. 따라서 해당 프로그램을 직접 조작하는 관리자를 위해 모든 쓰레드를 동작시키지 않고 비상용 쓰레드를 남겨놓도록 설정되어 있는 경우가 대부분이라고 합니다.

- DBMS에 원격지가 아닌 곳에서 직접 프로그램을 실행시켜서 해당 제품에 맞는 SQL을 사용하는 것으로 DDL, DML, DCL로 나눠진 수행을 입력시킬 수 있습니다.

   - DML(Manipulate, 데이터 조작언어)
      ``SELECT, INSERT, UPDATE, DELETE``

   - DCL(Control, 데이터 제어언어)
      ``GRANT``

   - DDL(Definition, 데이터 정의언어)
      ``CREATE, ALTER, DROP``

위에 소개한 DBMS를 구성하는 작은 서비스들이 각 역할이 다르기 때문에,

SQL의 분류에 따라 작동하는 요소와 순서가 대략적으로 정해질 것으로 예상됩니다.

Object-relational-mapping
-------------------------

정의

- 컴퓨터과학에서 ORM은 프로그래밍 테크닉을 의미합니다.

   *data -> type system -> typed data* 로 전환하는 기술

- 전통적으로는 객체지향 프로그래밍 언어에서 생겨난 개념이라 정의상으로 위의 수행을 한다고 말합니다.

- 이것은 가상 object database를 생성하여, 프로그래밍 언어 실행 중에 활용됩니다.

단계적으로 아래와 같은 과정을 통해서 추상화 레벨이 증가합니다.

```javascript
const sql     = "SELECT id, first_name, last_name, phone, birth_date, sex, age FROM persons WHERE id = 10"; // SQL QUERY
const result  = context.Persons.FromSqlRaw(sql).ToList(); // FIND -> List object
const name    = result[0]["first_name"];
```

- 위 경우엔 함수의 DB connection 추상화( *DB Engine* 이라고 부릅니다.) 통해서 처리하되 SQL은 매뉴얼하게 작성하는 방식입니다.

```javascript
var person = repository.GetPerson(10);
var firstName = person.GetFirstName();
```

- 대조적으로 위의 경우에는 ORM-job API를 사용한 것입니다. SQL에 대한 모든 처리가 method에 녹아 들어 있습니다.

고전적인 데이터 접근 기술과 비교
-------------------------------

- 객체지향 프로그램과 관계형 데이터베이스 사이에 기술을 비교했을때, ORM은 코드를 줄일 수 있다는 점이 눈에 띄는 장점입니다.

- ORM에 대한 불이익은 일반적으로 상위 레벨의 추상화가 실제 동작을 숨긴다는 것이 단점이며, 또한 ORM 라이브러리등에 깊게 의존하기 때문에 비효율적으로 디자인된 데이터베이스를 생산할 가능성이 높아집니다.

결론
---

- DBMS는 구현체에 사용자 입장에서 가장 가까운 것이며 사용자는 직접 DB관리 프로그램에 명령을 내릴 수 있고 DBMS는 그에 처리를 추상화 합니다.
- ORM은 위의 명령에 대한 추상화로 주로 객체지향언어의 특성을 활용해 DBMS의 존재를 숨기는 것이라고 볼 수 있습니다.
