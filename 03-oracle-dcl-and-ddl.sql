-------------
-- DCL and DDL
--------------

-- 사용자 생성
-- CREATE USER 권한이 있어야 함
-- system 계정으로 수행
-- connect system / manager

-- himeedia 라는 이름의 계정을 만들고 비밀번호 himedia 로 설정
create user himedia identified by himedia;

-- Oracle 18 버전부터 container Database 개념 도입
-- 방법1. 사용자 계정 C##
create user C##HIMEDIA identified by himedia;

-- 비밀번호 변경 : ALTER USER
alter user C##HIMEDIA identified by new_password;

-- 계정삭제 : DROP USER
drop user C##HIMEDIA cascade;
--cascade : 폭포수 or 연결된 것을 의미


-- 방법2. 계정생성 Container Database 기능을 무력화 하기.
-- 연습 상태니까, 방법 2를 사용해서 사용자 계정 생성(추천하진 않음)
alter session set "_ORACLE_SCRIPT" = TRUE;
create user himedia identified by himedia;

/*
 Grant 시스템권한 목록 TO 사용자 | 역할 | public [WITH ADMIN OPTION] -> 시스템 권한 부여
 REVOKE 회수할 권한 FROM 사용자 | 역할 | PUBLIC

 GRANT 객체개별권한 | ALL ON 객체명 TO 사용자 | 역할 | PUBLIC [WITH ADMIN OPTION]
 REVOKE 회수할 권한 ON 객체명 FROM 사용자 | 역할 | PUBLIC
 */

-- 아직 접속 불가 상태..
-- 데이터베이스 객체 작업(DB에 접속, 테이블 생성 등) 을 수행하고자 한다면 -> CONNECT, RESOURCE ROLE 부여
grant connect, resource to himedia;
-- cmd : sqlplus himedia/himedia
-- create table test(a Number);
-- desc test; -- 테이블 test 의 구조 보기.

-- himedia 사용자로 진행
-- 데이터 추가
describe test;
insert into TEST
values (2024);
-- USERS 테이블스페이스에 대한 권한이 없다.
-- ORACLE 18 이상에서 발생하는 문제.
-- 시스템 계정으로 수행
alter user himedia default tablespace USERS quota unlimited on Users;
-- tablespace 권한 부여

-- himedia 로 복귀
insert into TEST
values (2024);
select *
from TEST;

select *
from USER_USERS; -- 현재 로그인한 사용자 정보(me)
select *
from ALL_USERS;
-- 모든 사용자 정보
-- DBA 전용(sysdba 로 로그인 해야 확인 가능)
-- cmd : sqlplus sys/oracle as sysdba       --> sysdba 로 접근 가능

-- 시나리오: HR 스키마의 employees 테이블 조회 권한을 himedia 에게 부여하고자 한다면?
-- HR 스키마의 owner => HR
-- HR로 접속
grant select on EMPLOYEES to himedia;

-- himedia 권한
select *
from hr.EMPLOYEES;
-- hr.employees 에 select 할 수 있는 권한.
-- select * from hr.departments;  -- 권한 부여 안되서 검색 불가

-- 현재 사용자에게 부여된 ROLE 확인
select *
from USER_ROLE_PRIVS;

-- CONNECT 와 RESOURCE 역할은 어떤 권한으로 구성되어 있는가?
-- sysdba 로 진행
-- cmd
-- sqlplus sys/oracle as sysdba
-- desc role_sys_privs;
-- connect role 에는 어떤 권한이 포함되어 있는가?
-- select privilege from role_sys_privs where role='CONNECT';
-- select privilege from role_sys_privs where role='RESOURCE';

-----------------
-- DDL
-----------------

-- 스키마 내의 모든 테이블을 확인
select *
from TABS;
-- tabs : 테이블 정보 딕셔너리

-- 테이블 생성 : CREATE TABLE
create table book
(
    book_id  number(5),
    title    varchar2(50),
    author   varchar2(10),
    pub_date date default sysdate
);

-- 테이블 정보 확인
desc BOOK;

-- 테이블 생성 방법 2. Subquery 를 이용
select *
from HR.employees;
-- HR.employees 테이블에서 job_id 가 IT_ 관련된 직원의 목록으로 새 테이블을 생성
select *
from hr.EMPLOYEES
where JOB_ID like 'IT_%';
create table emp_it as (select *
                        from hr.EMPLOYEES
                        where JOB_ID like 'IT_%');
-- NOT NULL 제약 조건만 물려받음.

select *
from TABS;
select *
from emp_it;

-- 테이블 삭제
drop table EMP_IT;
select *
from TABS;

-- author 테이블 생성
create table author
(
    author_id   Number(10),
    author_name varchar2(100) not null,
    author_desc varchar2(500),
    primary key (author_id)
);

-- book 테이블에 author 컬럼 삭제
-- 나중에 author_id 컬럼 추가 -> author.author_id 와 참조 연결할 예정
alter table BOOK
    drop column AUTHOR;

-- book 테이블에 author_id 컬럼 추가
-- author.author_id 를 참조하는 컬럼이기 때문에, author.author_id 컬럼과 같은 형태여야 한다.
alter table BOOK
    add (AUTHOR_ID number(10));

-- book 테이블의 book_ID 도 author 테이블의 PK 와 같은 데이터 타입(NUMBER(10))으로 변경
alter table BOOK
    modify (book_id number(10));

-- book 테이블의 book_id 컬럼에 PRIMARY KEY 제약조건을 부여.
alter table BOOK
    add constraint pk_book_id primary key (BOOK_ID);

-- book 테이블의 author_id 컬럼과 author 테이블의 author_id 를 FK 로 연결
alter table BOOK
    add constraint fk_author_id foreign key (AUTHOR_ID)
        references AUTHOR (AUTHOR_ID);


-- DICTIONARY
-- USER_ : 현재 로그인 된 사용자에게 허용된 뷰
-- ALL_ : 모든 사용자 뷰
-- DBA_ : DBA(관리자) 에게 허용된 뷰

-- 모든 딕셔너리 확인
select *
from DICTIONARY;

-- USER_OBJECTS (사용자 스키마 객체)
select *
from USER_OBJECTS;

-- 사용자 스키마의 이름과 타입 정보 출력
select OBJECT_NAME, OBJECT_TYPE
from USER_OBJECTS;

-- 제약 조건의 확인
select *
from USER_CONSTRAINTS;
select CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION, TABLE_NAME
from USER_CONSTRAINTS;

-- book 테이블에 적용된 제약조건의 확인
select CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION
from USER_CONSTRAINTS
where TABLE_NAME = 'BOOK';

truncate table author;
-- INSERT : 테이블에 새 레코드(튜플) 추가
-- 제공된 컬럼 목록의 순서와 타입, 값 목록의 순서와 타입이 일치해야 함
-- 컬럼 목록을 제공하지 않으면 테이블 생성시 정의된 컬럼의 순서의 타입을 따른다

-- 컬럼 목록이 제시되지 않았을 때
INSERT INTO author
VALUES (1, '박경리', '토지 작가');

-- 컬럼 목록을 제시했을 때,
-- 제시한 컬럼의 순서와 타입대로 값 목록을 제공해야 함.
insert into author (AUTHOR_ID, AUTHOR_NAME)
values (2, '김영하');

-- 컬럼 목록을 제공 했을 때,
-- 테이블 생성시 정의된 컬럼의 순서와 상관 없이 데이터 제공 가능
insert into author (author_name, author_id, author_desc)
VALUES ('류츠신', 3, '삼체 작가');
select *
from AUTHOR;

rollback; -- 반영 취소
select *
from author;

insert into author
values (1, '박경리', '토지 작가');
insert into author (author_id, author_name)
values (2, '김영하');
insert into author (author_name, author_id, author_desc)
values ('류츠신', 3, '삼체 작가');

select *
from author;

commit; -- 변경사항 반영

select *
from author;

-- update
-- 특정 레코드의 컬럼 값을 변경한다
-- where 절이 없으면 모든 레코드가 변경되니
-- 특별한 케이스가 아니라면 가급적 WHERE 절로 변경하고자 하는 레코드를 지정하도록 한다.

update author
set author_desc = '알쓸신잡 출연';

rollback;
select *
from author;

update author
set author_desc = '알쓸신잡 출연'
where author_name = '김영하';

select *
from author;
commit;

--delete
-- 테이블로부터 특정 레코드를 삭제
-- where 절이 없으면 모든 레코드 삭제(주의)

-- 연습
-- hr.employees 테이블을 기반으로 department_id 10, 20, 30 인 직원들만 새테이블 emp123으로  생성
create table emp123 as (select *
                        from hr.EMPLOYEES
                        where DEPARTMENT_ID in (10, 20, 30));
select FIRST_NAME, SALARY, DEPARTMENT_ID
from emp123;

-- 부서가 30인 직원들의 급여를 10% 인상
update emp123
set SALARY = SALARY + SALARY * 0.1
where DEPARTMENT_ID = 30;

select FIRST_NAME, SALARY, DEPARTMENT_ID
from emp123;

--JOB_ID MK_ 로 시작하는 직원들 삭제
delete
from emp123
where JOB_ID like 'MK_%';

select * from emp123;

delete from emp123;     -- where 절이 생략된 delete 문은 모든 레코드를 삭제하기 때문에 주의할 것.

select * from emp123;
rollback;

----------------------
-- TRANSACTION
----------------------

-- 트랜잭셕 테스트 테이블
create table t_test(
log_text varchar2(100)
);

-- 첫 번째 DMl 이 수행된 시점에서 transaction
insert into t_test values ('트랜잭션 시작');
select *
from t_test;

insert into t_test values ('데이터 INSERT');
select *
from t_test;

savepoint  sp1;     -- 세이브 포인트 설정

insert into t_test values ('데이터 2 INSERT');
select *
from t_test;

savepoint sp2;      -- 세이브 포인트 설정

update t_test set log_text = '업데이트';
select *
from t_test;

rollback to sp1;       -- sp1 로 귀환
select *
from t_test;

insert into t_test  values ('데이터 3 INSERT');
select *
from t_test;

-- 반영 : commit or 취소 : rollback
-- 명시적으로 TRANSACTION 종료

commit;
select * from t_test;