-- SQL 문장의 주석
-- SQL 문장은 마지막에 `;` 으로 끝난다.
-- 키워드들은 대소문자 구분하지 않는다.
-- 실제 데이터의 경우 대소문자를 구분한다.

-- 테이블 구조를 확인할 때 (DESCRIBE)
DESCRIBE employees;
-- describe EMPLOYEES;

DESCRIBE departments;
DESCRIBE locations;



-- DML(Data Mainpulation Language)
-- SELECT

-- * : 테이블 내의 모든 컬럼 Projection, 테이블 설계시에 정의한 순서대로
SELECT * FROM employees;

-- 특정 컬럼만 Projection 하고자 한다면 열 목록을 명시


-- employees 테이블의 first_name, phone_number, hire_date, salary 만 보고 싶다면??
SELECT first_name, phone_number, hire_date, salary From employees;


-- 사원의 이름, 성, 급여, 전화번호, 입사일 정보 출력
SELECT first_name, last_name, salary, phone_number, hire_date from employees;


-- 사원 정보로부터 사번, 이름, 성을 출력하시오.
Select employee_id, first_name, last_name From employees;


-- 산술연산 : 기본적인 산술연산을 수행할 수 있다.
-- 특정 테이블의 값이 아닌 시스템으로부터 데이터를 받아오고자 할 때: dual(가상테이블)
SELECT 3.14159 * 10 * 10 FROM dual;

-- 특정 컬럼의 값을 산술 연산에 포함 시키고자 할 때,
SELECT first_name 이름,
    salary 월급,
    salary*12 연봉
FROM employees;

-- 다음 문자을 실행해 봅시다.
SELECT first_name,
    job_id,
    job_id * 12,
FROM employees;
-- 오류의 원인 : JOB_ID 는 문자열(VARCHAR2) 데이터 이기 때문에 산술연산 X

DESC employees;