-- MySQL은 사용자와 Database를 구분하는 DBMS
SHOW DATABASES;

-- 데이터베이스 사용 선언
USE sakila;

-- 데이터베이스 내에 어떤 테이블이 있는가?
SHOW tables;

-- 테이블 구조 확인
DESCRIBE actor;

-- 간단한 쿼리 실행
select version(), current_date;
select version(), current_date from dual;

-- 특정 테이블 데이터를 조회
SELECT * FROM actor;

-- 데이터베이스 생성
-- webdb 데이터 베이스 생성.
CREATE DATABASE webdb;
DROP DATABASE webdb;
-- 기본 방식으로 설치한 경우 시스템 설정에 좌우되는 경우가 많음.
-- 문자셋, 정렬 방식을 명시적으로 지정하는 것이 좋음.
CREATE DATABASE webdb CHARSET utf8mb4
COLLATE utf8mb4_unicode_ci;

SHOW DATABASES;

-- 사용자 만들기
CREATE USER 'dev'@'localhost' IDENTIFIED BY 'dev';
-- 사용자 비밀번호 변경
-- ALTER USER 'dev'@'localhost' IDENTIFIED BY 'new_password';
-- 사용자 삭제
-- DROP USER 'dev'@'localhost';

-- 권한 부여
-- GRANT 권한 목록 ON 객체 TO '계정'@'접속호스트';
-- 권한 회수
-- REVOKE 권한 목록 ON 객체 FROM '계정'@'접속호스트';

-- 'dev'@'localhost' 에게 webdb 데이터베이스의 모든 객체에 대한 모든 권한 허용
GRANT ALL PRIVILEGES ON webdb.* TO 'dev'@'localhost';
-- REVOKE ALL PRIVILEGES ON webdb.* FROM 'dev'@'localhost'; 모든 권한 회수

-- 데이터베이스 확인
SHOW DATABASES;

USE webdb;

-- AUTHOR 테이블 생성
CREATE TABLE author (
author_id int PRIMARY KEY,
author_name varchar(50) NOT NULL,
author_desc varchar(500)
);
