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

select * from TABS;
select * from emp_it;

-- 테이블 삭제
drop table EMP_IT;
select * from TABS;

