-- 서브쿼리(SUBQUERY)
-- 문제1.
-- 평균 급여보다 적은 급여를 받는 직원 수를 계산
select count(*) -- 결과로 직원 수를 반환
from EMPLOYEES
where SALARY < (select avg(SALARY) from EMPLOYEES); -- 서브쿼리를 사용하여 전체 직원의 평균 급여보다 적은 급여를 받는 직원을 필터링



-- 문제2.
-- 평균급여 이상, 최대급여 이하의 월급을 받는 사원의 직원번호(employee_id), 이름(first_name),
-- 급여(salary), 평균급여, 최대급여를 급여의 오름차순으로 정렬하여 출력하세요
-- (51건)
-- 평균급여 이상, 최대급여 이하의 월급을 받는 사원 정보 출력
select emp.EMPLOYEE_ID 직원번호,
       emp.FIRST_NAME  이름,
       emp.SALARY      급여,
       t.avgSalary     평균급여,
       t.maxSalary     최대급여
from EMPLOYEES emp
         join (select round(avg(SALARY)) avgSalary, max(SALARY) maxSalary from EMPLOYEES) t -- 서브쿼리를 통해 평균급여와 최대급여를 계산
              on emp.SALARY between t.avgSalary and t.maxSalary -- 평균급여와 최대급여 사이의 급여를 받는 직원 필터
order by 급여, 평균급여, 최대급여; -- 급여, 평균급여, 최대급여 기준으로 오름차순 정렬



-- 문제3.
-- 직원중 Steven(first_name) king(last_name)이 소속된 부서(departments)가 있는 곳의 주소를 알아보려고 한다.
-- 도시아이디(location_id), 거리명(street_address), 우편번호(postal_code), 도시명(city),
-- 주(state_province), 나라아이디(country_id) 를 출력하세요
-- (1건)
-- 직원 Steven King이 소속된 부서의 위치 정보 출력 (서브쿼리 이용)
select LOCATION_ID,
       STREET_ADDRESS,
       POSTAL_CODE,
       CITY,
       STATE_PROVINCE,
       COUNTRY_ID
from LOCATIONS
where LOCATION_ID = (select LOCATION_ID
                     from DEPARTMENTS
                     where DEPARTMENT_ID =
                           (select DEPARTMENT_ID from EMPLOYEES where FIRST_NAME = 'Steven' and LAST_NAME = 'King'));

-- 같은 정보를 조인을 이용하여 출력
select LOCATION_ID,
       STREET_ADDRESS,
       POSTAL_CODE,
       CITY,
       STATE_PROVINCE,
       COUNTRY_ID
from LOCATIONS
         natural join DEPARTMENTS
         join EMPLOYEES on EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
where FIRST_NAME = 'Steven'
  and LAST_NAME = 'King';


-- 문제4.
-- job_id 가 'ST_MAN' 인 직원의 급여보다 작은 직원의 사번,이름,급여를 급여의 내림차순으로출력하세요
-- ANY연산자 사용
-- (74건)
-- job_id 'ST_MAN'인 직원보다 낮은 급여를 받는 직원 정보 출력
select EMPLOYEE_ID,
       FIRST_NAME,
       SALARY
from EMPLOYEES
where SALARY < any (select SALARY from EMPLOYEES where JOB_ID = 'ST_MAN') -- ANY 연산자를 사용해 'ST_MAN' 직무의 급여보다 낮은 급여를 필터
order by SALARY desc; -- 급여 기준 내림차순 정렬



-- 문제5.
-- 각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name)과 급여(salary) 부서번호(department_id)를 조회하세요
-- 단 조회결과는 급여의 내림차순으로 정렬되어 나타나야 합니다.
-- 조건절비교, 테이블조인 2가지 방법으로 작성하세요
-- (11건)
-- 조건절 비교를 이용한 부서별 최고 급여 직원 정보 조회
select emp.EMPLOYEE_ID,
       emp.FIRST_NAME,
       emp.SALARY,
       emp.DEPARTMENT_ID
from EMPLOYEES emp
where (emp.DEPARTMENT_ID, emp.SALARY) in (select DEPARTMENT_ID, max(SALARY) from EMPLOYEES group by DEPARTMENT_ID) -- 부서별 최고 급여를 그룹화하고 해당 최고 급여를 받는 직원을 조회
order by SALARY desc; -- 급여 기준 내림차순 정렬

-- 테이블 조인을 이용한 부서별 최고 급여 직원 정보 조회
select e.EMPLOYEE_ID,
       e.FIRST_NAME,
       e.SALARY,
       e.DEPARTMENT_ID
from EMPLOYEES e
         join (select DEPARTMENT_ID, max(SALARY) salary from EMPLOYEES group by DEPARTMENT_ID) t -- 부서별 최고 급여를 그룹화하고 이를 조인
              on e.DEPARTMENT_ID = t.DEPARTMENT_ID
where e.SALARY = t.salary -- 조인된 결과에서 최고 급여를 받는 직원만 필터
order by SALARY desc; -- 급여 기준 내림차순 정렬



-- 문제6.
-- 각 업무(job) 별로 급여(salary)의 총합을 구하고자 합니다.
-- 연봉 총합이 가장 높은 업무부터 업무명(job_title)과 연봉 총합을 조회하시오
-- (19건)
-- 각 업무 별로 급여의 총합을 구하고 연봉 총합이 가장 높은 업무부터 업무명과 연봉 총합을 조회
select j.JOB_TITLE,  -- 업무명
       t.sumSalary,  -- 연봉 총합
       j.JOB_ID,     -- 업무 ID (JOBS 테이블)
       t.JOB_ID      -- 업무 ID (집계 서브쿼리 결과)
from JOBS j
         join (select JOB_ID, sum(SALARY) sumSalary from EMPLOYEES group by JOB_ID) t  -- 각 업무별 급여의 총합을 계산하는 서브쿼리
              on j.JOB_ID = t.JOB_ID  -- JOBS 테이블과 서브쿼리 결과를 업무 ID로 조인
order by sumSalary DESC;  -- 연봉 총합 기준 내림차순 정렬


-- 문제7.
-- 자신의 부서 평균 급여보다 월급(salary)이 많은 직원의 직원번호(employee_id), 이름(first_name)과 급여(salary)을 조회하세요
-- (38건)
-- 자신의 부서의 평균 급여보다 월급이 많은 직원의 직원번호, 이름, 급여를 조회
select emp.EMPLOYEE_ID,  -- 직원번호
       emp.FIRST_NAME,   -- 이름
       emp.SALARY        -- 급여
from EMPLOYEES emp
         join (select DEPARTMENT_ID, avg(SALARY) salary
               from EMPLOYEES
               group by DEPARTMENT_ID) t  -- 각 부서별 평균 급여 계산
              on emp.DEPARTMENT_ID = t.DEPARTMENT_ID  -- EMPLOYEES 테이블과 평균 급여 결과를 부서 ID로 조인
where emp.SALARY > t.salary;  -- 직원의 급여가 해당 부서의 평균 급여보다 클 경우만 선택


-- 문제8.
-- 직원 입사일이 11번째에서 15번째의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력하세요
-- 직원 입사일 기준으로 11번째에서 15번째 사이의 직원의 사번, 이름, 급여, 입사일을 입사일 순서로 출력

-- 최외각의 SELECT 문은 필터링된 결과에서 직원 번호, 이름, 급여, 입사일을 선택합니다.
select EMPLOYEE_ID 사번,  -- 각 행의 직원 번호를 '사번'으로 표시합니다.
       FIRST_NAME  이름,  -- 각 행의 직원 이름을 '이름'으로 표시합니다.
       SALARY      급여,  -- 각 행의 직원 급여를 '급여'로 표시합니다.
       HIRE_DATE   입사일 -- 각 행의 직원 입사일을 '입사일'로 표시합니다.
-- 서브쿼리에서는 입사일 기준으로 정렬된 직원 정보에 ROWNUM을 할당하고 필터링을 수행합니다.
from (select ROWNUM rn,  -- 결과에 순서 번호 rn을 할당합니다.
             EMPLOYEE_ID,
             FIRST_NAME,
             SALARY,
             HIRE_DATE
      from (select EMPLOYEE_ID,
                   FIRST_NAME,
                   SALARY,
                   HIRE_DATE
            from EMPLOYEES
            order by HIRE_DATE))  -- 가장 내부의 쿼리에서 EMPLOYEES 테이블을 입사일 오름차순으로 정렬합니다.
where rn >= 11
  and rn <= 15;  -- ROWNUM이 11에서 15 사이인 행만 선택합니다.


-- row_number 사용
-- row_number() 윈도우 함수를 사용하여 각 직원의 입사일 순서를 지정하고 11번째에서 15번째 사이의 직원을 선택합니다.
select rownum, EMPLOYEE_ID, FIRST_NAME, SALARY, HIRE_DATE
-- 서브쿼리에서 row_number()를 사용하여 각 직원의 입사일 순서를 지정합니다.
from (select EMPLOYEE_ID, FIRST_NAME, SALARY, HIRE_DATE, row_number() over (order by HIRE_DATE) as rnum from EMPLOYEES)
where rnum >= 11
  and rnum <= 15;  -- row_number()가 11에서 15 사이인 행만 선택합니다.


-- RANK() 윈도우 함수를 사용하여 입사일 기준으로 각 직원에게 순위를 부여하고 11번째에서 15번째 순위에 해당하는 직원을 선택합니다.
SELECT employee_id, first_name, salary, hire_date, rank
-- 서브쿼리에서 RANK()를 사용하여 입사일 기준으로 순위를 할당합니다.
FROM (SELECT employee_id, first_name, salary, hire_date,
        RANK() OVER (ORDER BY hire_date ASC) AS rank  -- 입사일 기준으로 각 직원에게 순위를 부여합니다.
        FROM employees)
WHERE rank BETWEEN 11 AND 15;  -- 순위가 11에서 15 사이인 직원만 선택합니다.

