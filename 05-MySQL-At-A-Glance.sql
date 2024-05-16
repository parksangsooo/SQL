-- MySQL은 사용자와 Database를 구분하는 DBMS
SHOW DATABASES;

-- 데이터베이스 사용 선언
USE sakila;

-- 데이터베이스 내에 어떤 테이블이 있는가?
SHOW TABLES;

-- 테이블 구조 확인
DESCRIBE actor;

-- 간단한 쿼리 실행
SELECT VERSION(), CURRENT_DATE;
SELECT VERSION(), CURRENT_DATE
FROM dual;

-- 특정 테이블 데이터를 조회
SELECT *
FROM actor;

-- 데이터베이스 생성
-- webdb 데이터 베이스 생성.
CREATE DATABASE webdb;
DROP DATABASE webdb;
-- 기본 방식으로 설치한 경우 시스템 설정에 좌우되는 경우가 많음.
-- 문자셋, 정렬 방식을 명시적으로 지정하는 것이 좋음.
CREATE DATABASE webdb CHARSET utf8mb4
    COLLATE utf8mb4_unicode_ci;

SHOW DATABASES;
DESC author;

-- 테이블 생성 정보
SHOW CREATE TABLE author;

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
CREATE TABLE author
(
    author_id   INT PRIMARY KEY,
    author_name VARCHAR(50) NOT NULL,
    author_desc VARCHAR(500)
);

-- book 테이블 생성
CREATE TABLE book
(
    book_id   INT PRIMARY KEY,
    title     VARCHAR(100) NOT NULL,
    pubs      VARCHAR(100),
    pub_date  DATETIME DEFAULT NOW(),
    author_id INT,
    CONSTRAINT fk_book FOREIGN KEY (author_id)
        REFERENCES author (author_id)
);

SHOW TABLES;
DESC book;

-- INSERT : 새로운 레코드 삽입.
-- 묵시적 방법 : 컬럼 목록을 제공하지 않음. -> 테이블 생성시 선언 된 컬럼의 순서대로
INSERT INTO author
VALUES (1, '박경리', '토지 작가');
-- 명시적 방법 : 컬럼 목록을 제공한다. 컬럼 목록의 숫자와 순서와 데이터타입이
-- 값 목록의 숫자, 순서, 데이터 타입과 일치해야 함.

INSERT INTO author (author_id, author_name)
VALUES (2, '김영하');
SELECT *
FROM author;

-- MySQL 은 기본적으로 자동 COMMIT 이 활성화 되어 있음
-- autocommit 을 비활성화 autocommit 옵션을 0으로 설정
SET AUTOCOMMIT = 0;

-- MySQL 은 명시적 트랜잭션을 수행
START TRANSACTION;
SELECT *
FROM author;

-- UPDATE author
-- SET author_desc = '알쓸신잡 출연';    -- where 절이 없으면 전체 레코드 변경

UPDATE author
SET author_desc = '알쓸신잡 출연'
WHERE author_id = 2;

-- ROLLBACK;   -- 변경사항 반영 취소
COMMIT;
-- 변경사항 영구 반영

-- AUTO_INCREMENT 속성
-- 연속적인 일련번호 생성 -> 주로 PK에 붙어 사용.

-- author 테이블의 PK에 auto_increment 속성 부여해보기
ALTER TABLE author
    MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;

-- 1. 외래 key 정보 확인
SELECT *
FROM information_schema.key_column_usage;

SELECT constraint_name
FROM information_schema.key_column_usage
WHERE table_name = 'book';

-- 2. 외래 key 삭제 : book 테이블의 FK(fk_book)

ALTER TABLE book
    DROP FOREIGN KEY fk_book;

-- 3. author 의 PK 에 AUTO_INCREMENT 속성을 붙임
-- 기존 PK를 삭제해야 새로운 속성을 붙임.
ALTER TABLE author
    DROP PRIMARY KEY;
-- AUTO_INCREMENT 속성이 부여된 새로운 PRIMARY KEY 생성.
ALTER TABLE author
    MODIFY author_id INT AUTO_INCREMENT PRIMARY KEY;

-- 4. book 의 author_id 에 foreign key 다시 연결
ALTER TABLE book
    ADD CONSTRAINT fk_book
        FOREIGN KEY (author_id) REFERENCES author (author_id);

-- auto-commit 을 다시 켜줌.
SET AUTOCOMMIT = 1;

SELECT *
FROM author;

-- 새로운 auto_increment 값을 부여하기 위해 PK 최댓값을 구함
SELECT MAX(author_id)
FROM author;

-- 새로운 auto_increment 시작값을 변경
ALTER TABLE author
    AUTO_INCREMENT = 3;
-- 3부터 시작함.

-- 테이블 구조 확인
DESC author;

INSERT INTO author (author_name)
VALUES ('스티븐 킹');
INSERT INTO author (author_name, author_desc)
VALUES ('류츠신', '삼체 작가');

-- 테이블 생성시 AUTO_INCREMENT 속성을 부여하는 방법
DROP TABLE book CASCADE;

CREATE TABLE book
(
    book_id   INT AUTO_INCREMENT PRIMARY KEY,
    title     VARCHAR(100) NOT NULL,
    pubs      VARCHAR(100),
    pub_date  DATETIME DEFAULT NOW(),
    author_id INT,
    CONSTRAINT book_fk FOREIGN KEY (author_id)
        REFERENCES author (author_id)
);

INSERT INTO book (title, pub_date, author_id)
VALUES ('토지', '1994-03-04', 1);
INSERT INTO book (title, author_id)
VALUES ('살인자의 기억법', 2);
INSERT INTO book (title, author_id)
VALUES ('쇼생크 탈출', 3);
INSERT INTO book (title, author_id)
VALUES ('삼체', 4);

SELECT *
FROM book;

-- JOIN
SELECT title 제목,
       pub_date 출판일,
       author_name 저자명,
       author_desc '저자 상세'
FROM book b
         JOIN author a ON b.author_id = a.author_id;