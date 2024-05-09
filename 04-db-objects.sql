-----------------
-- DB OBJECTS
-----------------

-- SYSTEM 으로 진행
-- view 생성을 위한 system 권한 부여
GRANT CREATE VIEW TO himedia;

GRANT SELECT ON hr.employees TO himedia; --  HR에 있는 EMPLOYEES 테이블의 SELECT 권한을 HIMEDIA 에게 부여.
GRANT SELECT ON hr.departments TO himedia;
--  HR에 있는 DEPARTMENTS 테이블의 SELECT 권한을 HIMEDIA 에게 부여.

-- HIMEDIA 접속
-- simple view
-- 단일 테이블 혹은 단일 뷰를 base 로 한 함수, 연산식을 포함하지 않은 뷰

-- emp123 테이블 확인
DESCRIBE emp123;
-- emp123 테이블 기반, department_id = 10 부서 소속 사원만 조회하는 뷰
CREATE OR REPLACE VIEW emp10
AS
SELECT employee_id, first_name, last_name, salary
FROM emp123
WHERE department_id = 10;

SELECT *
FROM tabs;

-- 일반 테이블처럼 활용가능함.
SELECT *
FROM emp10;
SELECT first_name || ' ' || last_name, salary
FROM emp10;

-- SIMPLE VIEW 는 제약 사항에 걸리지 않는다면 INSERT, UPDATE, DELETE 를 할 수 있다.
UPDATE emp10
SET salary = salary * 2;
ROLLBACK;

-- 가급적 view 는 조회용으로만 활용하자
-- with read only : 읽기 전용 뷰
CREATE OR REPLACE VIEW emp10
AS
SELECT employee_id, first_name, last_name, salary
FROM emp123
WHERE department_id = 10
WITH READ ONLY;

UPDATE emp10
SET salary = salary * 2;

/*
complex view
한 개 혹은 여러 개의 테이블 혹은 뷰에 JOIN, 함수, 연산식 등을 활용한 view
특별한 case 가 아니면 INSERT, UPDATE, DELETE 작업 불가.
*/
CREATE OR REPLACE VIEW emp_detail
    (employee_id, employee_name, manager_name, department_name)
AS
SELECT emp.employee_id,
       emp.first_name || ' ' || emp.last_name,
       man.first_name || ' ' || man.last_name,
       department_name
FROM hr.employees emp
         JOIN hr.employees man ON emp.manager_id = man.employee_id
         JOIN hr.departments dept ON emp.department_id = dept.department_id;

SELECT *
FROM emp_detail;

-- view 를 위한 딕셔너리 : views
SELECT *
FROM user_views;
SELECT *
FROM user_objects;
-- view 포함 모든 DB 객체들의 정보

-- view 삭제 : DROP VIEW
-- view 를 삭제해도 기반 테이블의 데이터는 삭제되지 않음.
DROP VIEW emp_detail;
SELECT *
FROM user_views;


--------------
-- INDEX
--------------
-- hr.employees 테이블 복사 s_emp 테이블 생성

CREATE TABLE s_emp
AS
SELECT *
FROM hr.employees;
SELECT *
FROM s_emp;

-- s_emp 테이블의 employee_id에 UNIQUE INDEX 를 걸어봄
CREATE UNIQUE INDEX s_emp_id_pk
    ON s_emp (employee_id);

--- 사용자가 가지고 있는 인덱스 확인
SELECT *
FROM user_indexes;
-- 어느 인덱스가 어느 컬럼에 걸려 있는지 확인
SELECT *
FROM user_ind_columns;
-- 어느 인덱스 어느 컬럼에 걸려 있는지 JOIN 해서 알아봄
SELECT t.index_name,
       t.table_name,
       c.column_name,
       c.column_position
FROM user_indexes t
         JOIN user_ind_columns c ON t.index_name = c.index_name
WHERE t.table_name = 'S_EMP';

-----------------
-- sequence
-----------------
SELECT *
FROM author;

-- 새로운 레코드를 추가 겹치지 않는 유일한 PK 가 필요
INSERT INTO author(author_id, author_name)
VALUES ((SELECT MAX(author_id) + 1 FROM author), '이문열');
ROLLBACK;

-- 순차 정보 객체 sequence
CREATE SEQUENCE seq_author_id
    START WITH 4
    INCREMENT BY 1
    MAXVALUE 1000000;

-- pk 는 sequence 객체로부터 생성
INSERT INTO author(author_id, author_name, author_desc)
VALUES (seq_author_id.nextval, '스티븐 킹', '쇼생크 탈출');
SELECT *
FROM author;
SELECT seq_author_id.currval
FROM dual;

-- 새 시퀀스 생성
CREATE SEQUENCE my_seq
    START WITH 1 -- 시퀀스 시작 번호
    INCREMENT BY 1 -- 증가분
    MAXVALUE 10; -- 시퀀스 최대값

SELECT my_seq.nextval
FROM dual; --시퀀스 'my_seq'의 다음 값을 조회합니다. 이 쿼리는 시퀀스를 1 증가시키고, 증가된 값을 반환합니다.
SELECT my_seq.currval
FROM dual;
-- 시퀀스 'my_seq'의 현재 값을 조회합니다. 이 쿼리는 마지막으로 증가된 시퀀스 값을 반환하지만, 시퀀스 자체는 증가하지 않습니다.

-- 시퀀스 수정
ALTER SEQUENCE my_seq
    INCREMENT BY 2
    MAXVALUE 1000000;

SELECT my_seq.currval
FROM dual;
SELECT my_seq.nextval
FROM dual;

-- 시퀀스를 위한 딕셔너리
SELECT *
FROM user_sequences;

SELECT *
FROM user_objects
WHERE object_type = 'SEQUENCE';

-- 시퀀스 삭제
DROP SEQUENCE my_seq;
SELECT *
FROM user_sequences;

-- book 테이블 PK 의 현재 값 확인
SELECT max(employee_id) FROM new_employees; -- 206

CREATE SEQUENCE seq_emp_id
START WITH 3
INCREMENT BY 1
MAXVALUE 1000000
NOCACHE;

