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
WHERE LOWER(first_name) LIKE '_a__';

-- 부서 ID 가 90인 사원들 중, 급여가 20000 이상인 사원
Select department_id, first_name, salary
From employees
WHERE salary >= 20000 and department_id =90;


-- 입사일이 11/01/01 ~ 17/12/31 구간의 있는 사원의 목록, 입사일
Select hire_date, first_name
From employees
WHERE hire_date between '11/01/01' and '17/12/31';


-- MANAGER_ID 가 100, 120, 147인 사원의 명단 이름, ID
-- 두 쿼리를 비교

-- 1. 비교연산자 + 논리연산자의 조합
SELECT first_name, manager_id
FROM employees
WHERE manager_id in (100, 120, 147);

-- 2. IN 연산자 이용
SELECT first_name, manager_id
FROM employees
WHERE manager_id = 100 or 
    manager_id =120 or 
    manager_id =147;

------------------
-- ORDER BY
------------------
-- 특정 컬럼명, 혹은 연산식, 별칭, 컬럼 순서를 기준으로 레코드 정렬
-- ASC(오름차순: default), DESC(내림차순)
-- 여러개의 컬럼에 적용할 수 있고 `,`로 구분

-- 부서 번호의 오름차순으로 정렬, 부서번호, 급여, 이름 출력
SELECT department_id, first_name, salary
FROM employees
Order by department_id ASC;     -- asc 는 생략가능(디폴트값)


-- 급여가 10000 이상인 직원 대상, 급여의 내림차순으로 출력. 이름, 급여
SELECT first_name, salary
FROM employees
WHERE salary >= 10000
ORDER BY salary DESC;

-- 부서번호, 급여, 이름순으로 출력하되 정렬기준은 부서번호로 오름차순, 급여의 내림차순
SELECT department_id, salary, first_name
FROM employees
ORDER BY department_id asc, salary desc;

-- 정렬 기준을 어떻게 세우느냐에 따라 성능, 출력 결과에 영향을 미칠 수 있다.



---------------
-- 단일행 함수
---------------

-- 단일 레코드를 기준으로 특정 컬럼에 값에 적용되는 함수

-- 문자열 단일행 함수
SELECT first_name, last_name,
    CONCAT(first_name, CONCAT(' ', last_name)),     -- 문자열 연결 함수
    first_name || ' ' || last_name,     -- 문자열 연결 연산자
    INITCAP(first_name || ' ' || last_name)     -- 각 단어의 첫 글자를 대문자
From employees;

SELECT first_name, last_name,
    LOWER(first_name),      --  모두 소문자
    UPPER(first_name),       -- 모두 대문자
    LPAD(first_name, 20, '*'),      -- 왼쪽 빈자리 채움
    RPAD(first_name, 20, '*')       --  오른쪽 빈자리 채움
FROM employees;


SELECT '    Oracle     ',
    '*****Database*****',
    LTRIM('    Oracle     '),       -- 왼쪽의 빈 공간 삭제
    RTRIM('    Oracle     '),        -- 오른쪽의 빈 공간 삭제
    TRIM('*' FROM '*****Database*****'), -- 앞 뒤의 잡음 문자 삭제
    SUBSTR('Oracle Database', 8, 4),     -- 부분 문자열
    SUBSTR('Oracle Database', -8, 4),        -- 역 인덱스 이용 부분 문자열
    LENGTH('Oracle Database')       -- 문자열의 길이
FROM dual;

-- 수치형 단일행 함수
SELECT 3.14159,
    ABS(-3.14),     -- 절대값 함수
    CEIL(3.14),     -- 올림 함수
    Floor(3.14),     -- 버림 함수
    ROUND(3.5),     -- 반올림
    ROUND(3.14159, 3),   -- 셋 째자리 뒤에서 숫자 반올림
    TRUNC(3.5),     -- 버림함수
    TRUNC(3.14159, 3),   -- 소숫점 셋 째자리 뒤에서 버림
    SIGN(-3.14159),      -- 부호함수 (-1: 음수, 0 : 0 , 1: 양수)
    MOD(7, 3),           --  나머지 함수(7을 3으로 나눈 나머지)
    POWER(2, 4)         -- 제곱함수 2의 4제곱
FROM dual;

---------------------
-- DATA FORMAT
---------------------

-- 현재 세션 정보 확인
SELECT *
FROM nls_session_parameters;

-- 현재 날짜 포맷이 어떻게 되는가
-- 딕셔너리를 확인
SELECT value FROM nls_session_parameters
WHERE parameter = 'NLS_DATE_FORMAT';

-- 현재 날짜 : SYSDATE
SELECT sysdate FROM dual;       -- 가상 테이블 dual로부터 받아오므로 1개의 레코드

SELECT sysdate FROM employees;  -- employees 테이블로부터 받아오므로 employees 테이블 레코드의 갯수만큼

-- 날짜 관련 단일행 함수
SELECT
    sysdate,
    ADD_MONTHS(sysdate, 2), -- 2개월이 지난 후의 날자
    LAST_DAY(sysdate),       -- 현재 달의 마지막 날
    MONTHS_BETWEEN('12/09/24', sysdate),    -- 해당 날짜와 오늘 날짜까지 두달 사이에 몇 달이 지났는가
    NEXT_DAY(sysdate, '화요일'),           -- 1: 일 ~ 7: 토
    ROUND(sysdate, 'MONTH'),             -- MONTH를 기준으로 반올림
    TRUNC(sysdate, 'MONTH')              -- MONTH를 기준으로 버림
FROM dual;

-- employees 테이블 중에서 hire_date 컬럼을 가지고 해보자
-- 근속 월수 뽑아보기
SELECT first_name, hire_date,
    ROUND(MONTHS_BETWEEN(sysdate, hire_date), 0) as 근속월수 
FROM employees
ORDER BY 근속월수 desc;


-----------------
-- 변환 함수
-----------------

-- TO_NUMBER(s, fmt) : 문자열 -> 숫자
-- TO_DATE(s, fmt) : 문자열 -> 날짜
-- TO_CHAR(o, fmt) : 숫자, 날짜 -> 문자열

-- TO_CHAR
SELECT first_name, 
    TO_CHAR(hire_date, 'YYYY-MM-DD')        --  년- 월- 일
FROM employees;

-- 현재 시간을 년-월-일 시:분:초로 표기
SELECT sysdate,
TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

SELECT
TO_CHAR(3000000, 'L999,999,999.99')
FROM dual;

--모든 직원의 이름과 연봉 정보 표시
Select 
    first_name, salary, commission_pct,
    TO_CHAR((salary + salary * nvl(commission_pct, 0)) * 12, '$999,999.99') as 연봉
FROM employees;


-- 문자 -> 숫자 : TO_NUMBER
SELECT '$57,600',
    TO_NUMBER('$57,600', '$999,999.99') / 12 as 월급
FROM dual;

-- 문자열 -> 날짜 : TO_DATE
SELECT '2012-09-24 13:48:00',
TO_Date('2012-09-24 13:48:00', 'YYYY-MM-DD HH24:MI:SS')
FROM dual;

-- 날짜 연산
-- DATE +/- Number : 특정 날수를 더하거나 뺄 수 있다.
-- Date - date : 두 날짜의 경과 일수
-- DATA + NUMBER / 24 : 특정 시간이 지난 후의 날짜

SELECT 
    sysdate,
    sysdate + 1, sysdate -1,
    sysdate - TO_DATE('20120924'),
    sysdate + 48 / 24       --   48시간이 지난 후의 날짜
FROM dual;

-- nvl function
SELECT first_name,
    salary,
    nvl(salary * commission_pct, 0) commission  --nvl(표현식, 대체값)
FROM employees;

--nvl2 function
SELECT FIRST_NAME,
       SALARY,
       nvl2(COMMISSION_PCT, SALARY * COMMISSION_PCT, 0) commission  -- nvl2 (조건문, null이 아닐때의 값, null일때의 값)
FROM EMPLOYEES;

-- CASE function
-- 보너스를 지급하기로 했습니다.
-- AD 관련 직종에게는 20%, SA 관련 직원에게는 10%, IT 관련 직원들에게는 8%, 나머지에게는 5%
SELECT first_name, job_id, salary,
    SUBSTR(job_id, 1, 2),
    CASE SUBSTR(job_id, 1, 2) WHEN 'AD' THEN salary * 0.2
                            WHEN 'SA' THEN salary * 0.1
                            WHEN 'IT' THEN salary * 0.08
                            ELSE salary * 0.05
                            END bonus
FROM EMPLOYEES;


-- DECODE 함수
SELECT first_name, job_id, salary,
    SUBSTR(job_id, 1, 2),
    DECODE(SUBSTR(job_id, 1, 2),        -- 비교할 값
            'AD', salary * 0.2,
            'SA', salary * 0.1,
            'IT', salary * 0.08,
            salary*0.05) bonus
FROM employees;

-- 연습문제
-- 직원의 이름, 부서, 팀을 출력
-- 팀은 부서 ID로 결정
-- 10 ~ 30 : A-GROUP
-- 40 ~ 50 : B-GROUP
-- 60 ~ 100 : C-GROUP
-- 나머지 부서 : REMAINDER

SELECT FIRST_NAME, DEPARTMENT_ID,
    CASE WHEN DEPARTMENT_ID >= 10 AND DEPARTMENT_ID <= 30 THEN 'A-GROUP'
        WHEN DEPARTMENT_ID >= 40 AND DEPARTMENT_ID <= 50 THEN 'B-GROUP'
        WHEN DEPARTMENT_ID >= 60 AND DEPARTMENT_ID <= 100 THEN 'C-GROUP'
        ELSE 'REMAINDER'
    END TEAM
FROM EMPLOYEES
ORDER BY team asc, DEPARTMENT_ID asc;

