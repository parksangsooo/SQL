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

-- NULL
--이름, 급여 커미션 비율을 출력
SELECT first_name, salary, commission_pct
FROM employees;

--이름과 커미션까지 포함한 급여를 출력해보자
SELECT first_name, salary, commission_pct, salary * (1+commission_pct)
FROM employees;

--NULL이 포함된 연산식의 결과는 NULL
--NULL을 처리하기 위한 함수 NVL이 필요함
--NVL(표현식1, 표현식1이 널일 경우의 대체값)

-- NVL 활용 대체값 계산
SELECT first_name, salary, commission_pct, 
    salary * (1 + NVL(commission_pct, 0))
FROM employees;


--Null은 0이나 ""과 다르게 빈 값이다.
--Null은 산술연산 결과, 통계 결과를 왜곡시키기 때문에 -> NULL에 대한 처리는 철저히 할 것.

--별칭 Alias
--Projection 단계에서 출력용으로 표시되는 임시 `컬럼제목`

-- 컬럼명 뒤에 별칭을 붙이거나 컬럼명 뒤에 as 키워드 별칭
-- 표시명에 특수문자 포함된 경우 " " 묶어서 부여

-- 직원아이디, 이름, 급여 출력
-- 직원 아이디는 empNo, 이름은 f-name, 급여는 월 급으로 표시해라
SELECT employee_id as empNo, 
    first_name as "f-name",     -- 컬럼명 뒤에 as 별칭
    salary "월 급" -- 컬럼명 뒤에 별칭
From employees;


-- 직원 이름(first_name last_name 합쳐서) name 이라고 출력
-- 급여(커미션이 포함된 급여), 급여 * 12 연봉 별칭으로 표기
SELECT first_name ||''|| last_name,
    salary *(1 + nvl(commission_pct,0)) "급여(커미션포함)",
    salary * 12 연봉
FROM employees;

--연습 : Alias 붙이기 (employees 테이블)
--이름 : first_name last_name
--입사일 : hire_date
--전화번호 : phone_number
--급여 : salary
--연봉 : salary * 12

SELECT first_name ||''|| last_name "이름",
    hire_date 입사일,
    phone_number 전화번호,
    salary 급여,
    salary * 12 연봉
FROM employees;
    

----------------------
-- WHERE
----------------------
-- 특정 조건을 기준으로 레코드를 선택(SELECTION)

-- 비교 연산 : =, <>, >, >=, <, <=
-- 사원들 중에서 급여가 15000 이상인 직원의 이름과 급여
SELECT first_name, salary
FROM employees
WHERE salary > 15000;

-- 입사일이 07/01/01 이후인 직원들의 이름과 입사일
SELECT first_name, hire_date
FROM employees
WHERE hire_date >= '17/01/01';

-- 급여가 14000 이하이거나, 17000 이상인 사원의 이름과 급여
SELECT first_name, salary
FROM employees
WHERE salary <= 4000       -- 첫 번째
OR salary >= 17000;     -- 두 번째 조건

-- 급여가 14000 이상이고, 17000 이하인 사원의 이름과 급여
SELECT first_name, salary
FROM employees
WHERE salary >= 14000       -- 첫 번째
AND salary <= 17000;     -- 두 번째 조건

-- BETWEEN : 범위 비교
SELECT first_name, salary
FROM employees
WHERE salary BETWEEN 14000 AND 17000;

--NULL 체크 =, <> 사용하면 안됨
--IS NULL, IS NOT NULL

--commission 을 받지 않는 사람들 (-> commission_pct 가 NULL인 레코드)
SELECT first_name, commission_pct
FROM employees
WHERE commission_pct IS NULL;  -- NULL 체크

--commission 을 받는 사람들 (-> commission_pct 가 NULL이 아닌 레코드)
SELECT first_name, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;  -- NULL 체크


-- 사원들 중 10, 20, 40번 부서에서 근무하는 직원들의 이름과 부서 아이디.
SELECT first_name, department_id
FROM employees
WHERE department_id = 10 or
    department_id = 20 or
    department_id = 40;
    
-- IN 연산자 : 특정 집합의 요소와 비교
SELECT first_name, department_id
FROM employees
WHERE department_id In (10, 20, 40);


------------------
--LIKE 연산
------------------
--와일드카드(%, _)를 이용한 부분 문자열 매핑
--% : 0개 이상의 정해지지 않은 문자열
--_ : 1개의 정해지지 않은 문자 

-- 이름의 am을 포함하고 있는 사원의 이름과 급여 출력
SELECT first_name, salary
From employees
WHERE LOWER(first_name) LIKE '%am%';   -- 이름을 소문자로 바꾸고 am 앞뒤에는 뭐가 오든 상관 않겠다.


-- 이름의 두 번째 글자가 a인 사원의 이름과 급여
SELECT first_name, salary
From employees
WHERE LOWER(first_name) LIKE '_a%'; 


-- 이름의 네번째 글자가 a인 사원의 이름과 급여
SELECT first_name, salary
From employees
WHERE LOWER(first_name) LIKE '___a%'; 


-- 이름이 네 글자인 사원들 중에서 두 번째 글자가 a인 사원
SELECT first_name, salary
From employees
WHERE LOWER(first_name) LIKE '____' and '_a%'; 