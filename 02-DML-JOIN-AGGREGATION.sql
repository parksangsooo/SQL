-------------------
-- JOIN
-------------------

-- employees 와 departments
describe emloyees;
desc DEPARTMENTS;

select *
from EMPLOYEES; -- 107 rows
select *
from DEPARTMENTS; -- 27 rows

select *
from EMPLOYEES,
     DEPARTMENTS;
-- 107 x 27

-- 카티전 프로덕트
select *
from EMPLOYEES,
     DEPARTMENTS
where EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;

-- INNER JOIN, EQUI-JOIN

-- alias 를 이용한 원하는 필드의 Projection
----------------------------------------
-- simple Join or Equi-Join
----------------------------------------

select FIRST_NAME,
       dept.DEPARTMENT_ID,
       emp.DEPARTMENT_ID,
       DEPARTMENT_NAME
from EMPLOYEES emp,
     DEPARTMENTS dept
where emp.DEPARTMENT_ID = dept.DEPARTMENT_ID; -- 106명, department_id 가 null 인 직원은 JOIN 에서 배제

select *
from EMPLOYEES
where DEPARTMENT_ID is null; -- 178 kimberely

select emp.FIRST_NAME,
       dept.DEPARTMENT_NAME
from EMPLOYEES emp
         join DEPARTMENTS dept using (DEPARTMENT_ID);

-------------------
-- Theta Join
-------------------
-- Join 조건이 = 아닌 다른 조건들
-- 급여가 직군 평균 급여보다 낮은 직원들 목록
select emp.EMPLOYEE_ID,
       emp.FIRST_NAME,
       emp.SALARY,
       emp.JOB_ID,
       j.JOB_ID,
       j.JOB_TITLE
from EMPLOYEES emp
         join jobs j on emp.JOB_ID = j.JOB_ID
where emp.SALARY <= (j.MIN_SALARY + j.MAX_SALARY) / 2;


-------------------
-- Outer Join
-------------------
-- 조건을 만족하는 짝이 없는 튜플도 null 을 포함해서 결과 출력 참여시키는 방법
-- 모든 결과를 출력할 수 있는 테이블이 어느 쪽에 위치하는 가에 따라서 LEFT, RIGHT, FULL OUTER JOIN 으로 나뉨
-- ORACLE SQL의 경우 NULL 값이 출력되는 쪽에 (+) 를 붙인다.

--------------------
-- LEFT OUTER JOIN
--------------------

-- ORACLE SQL
select emp.FIRST_NAME,
       emp.DEPARTMENT_ID,
       dept.DEPARTMENT_ID,
       DEPARTMENT_NAME
from EMPLOYEES emp,
     DEPARTMENTS dept
where emp.DEPARTMENT_ID = dept.DEPARTMENT_ID (+); -- null 이 포함된 테이블 쪽에 (+) 표기

select *
from EMPLOYEES
where DEPARTMENT_ID is null;
-- kimberely -> 부서에 소속되지 않음


-- ANSI SQL - 명시적으로 JOIN 방법을 정한다
select FIRST_NAME,
       emp.DEPARTMENT_ID,
       dept.DEPARTMENT_ID,
       DEPARTMENT_NAME
from EMPLOYEES emp
         left outer join DEPARTMENTS dept
                         on emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;

--------------------
-- right OUTER JOIN
--------------------
-- RIGHT 테이블의 모든 레코드가 출력 결과에 참여한다.

-- Oracle SQL
select FIRST_NAME,
       emp.DEPARTMENT_ID,
       dept.DEPARTMENT_ID,
       DEPARTMENT_NAME
from EMPLOYEES emp,
     DEPARTMENTS dept
where emp.DEPARTMENT_ID (+) = dept.DEPARTMENT_ID;
-- departments 테이블 레코드 전부를 출력에 참여 122 레코드

-- ANSI SQL
select FIRST_NAME,
       emp.DEPARTMENT_ID,
       dept.DEPARTMENT_ID,
       DEPARTMENT_NAME
from EMPLOYEES emp
         right outer join DEPARTMENTS dept
                          on emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;


--------------------
-- FULL OUTER JOIN
--------------------
-- JOIN 에 참여한 모든 테이블의 모든 레코드를 출력에 참여
-- 짝이 없는 레코드들은 null 을 포함해서 출려에 참여

-- ANSI SQL
select FIRST_NAME,
       emp.DEPARTMENT_ID,
       dept.DEPARTMENT_ID,
       DEPARTMENT_NAME
from EMPLOYEES emp
         full outer join DEPARTMENTS dept
                         on emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;

--------------------
-- NATURAL JOIN
--------------------
-- JOIN 할 테이블에 같은 이름의 컬럼이 있는 경우, 해당 컬럼을 기준으로 JOIN

select *
from EMPLOYEES emp
         natural join DEPARTMENTS dept;
-- select * from EMPLOYEES emp join DEPARTMENTS dept on emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;
-- select * from EMPLOYEES emp join DEPARTMENTS dept on emp.MANAGER_ID = dept.MANAGER_ID;
select *
from EMPLOYEES emp
         join DEPARTMENTS dept on emp.MANAGER_ID = dept.MANAGER_ID and emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;

--------------------
-- self join
--------------------
-- 자기 자신과의 JOIN
-- 자기자신을 두 번 호출 하기 때문에 -> 별칭을 반드시 부여해야 할 필요가 있는 JOIN

select *
from EMPLOYEES; -- 107
select emp.EMPLOYEE_ID,
       emp.FIRST_NAME,
       emp.MANAGER_ID,
       man.FIRST_NAME
-- from EMPLOYEES emp join EMPLOYEES man
-- on emp.MANAGER_ID = man.EMPLOYEE_ID;
from EMPLOYEES emp,
     EMPLOYEES man
where emp.MANAGER_ID = man.EMPLOYEE_ID;
-- 106

-- 해봅시다. steven (매니저 없는 분까지)
select emp.EMPLOYEE_ID,
       emp.FIRST_NAME,
       emp.MANAGER_ID,
       man.FIRST_NAME
-- from EMPLOYEES emp, EMPLOYEES man
-- where emp.MANAGER_ID = man.EMPLOYEE_ID(+);
from EMPLOYEES emp
         left outer join EMPLOYEES man
                         on emp.MANAGER_ID = man.EMPLOYEE_ID;

--------------------
--Group Aggregation
--------------------

-- 집계 : 여러 행으로부터 데이터를 수집, 하나의 행으로 반환
-- count : 갯수 세기 함수
-- employees 테이블의 총 레코드 갯수

select count(*)
from EMPLOYEES;
-- 107
-- * 로 카운트 하면 모든 행의 수를 반환
-- 특정 컬럼내에 null 값이 포함이 되어 있는지에 대한 여부는 중요하지 않음ㄴ

-- commission 을 받는 직원의 수를 알고 싶을 경우
select count(COMMISSION_PCT)
from EMPLOYEES;
-- 35
-- commission_pct 가 null인 경우를 제외하고 싶을 경우
select count(*)
from EMPLOYEES
where COMMISSION_PCT is not null;

-- sum : 합계 함수
-- 모든 사원의 급여의 합
select sum(SALARY)
from EMPLOYEES;

-- AVG : 평균 함수
-- 사원들의 평균 급여
select avg(SALARY)
from EMPLOYEES;

-- 사원들이 받는 커미션 비율의 평균
select avg(COMMISSION_PCT)
from EMPLOYEES;
-- 22%

-- avg 함수는 null 값이 포함되어 있을 경우 그 값을 집계 수치에서 제외한다.
-- null 값을 집계 결과에 포함시킬지의 여부는 정책으로 결정하고 수행해야 한다.
select avg(nvl(COMMISSION_PCT, 0))
from EMPLOYEES;
-- 7%

-- min / max 함수 : 최소값 & 최대값
--avg / median : 산술평균 / 중앙값(중요한 통계수치)
select min(SALARY)    최소급여,
       max(SALARY)    최대급여,
       avg(SALARY)    평균급여,
       median(SALARY) 급여중앙값
from EMPLOYEES;

-- 흔히 범하는 오류..
-- 부서별로 평균 급여를 구하고자 할 때,
/*
select DEPARTMENT_ID, avg(SALARY)   -- 오류 : 단일 그룹이 아님
from EMPLOYEES;
*/

select DEPARTMENT_ID
from EMPLOYEES; -- 여러 개의 레코드
select avg(SALARY)
from EMPLOYEES; -- 단일 레코드

select DEPARTMENT_ID, SALARY
from EMPLOYEES
order by DEPARTMENT_ID;

-- GROUP BY
select DEPARTMENT_ID, ROUND(avg(SALARY), 2)
from EMPLOYEES
group by DEPARTMENT_ID -- 집계를 위해 특정 컬럼을 기준으로 그룹핑 한다.
order by DEPARTMENT_ID;

-- 부서별 평균 급여에 부서명도 포함하여 출력
select e.DEPARTMENT_ID,
       d.DEPARTMENT_NAME,
       ROUND(avg(e.SALARY), 2)
from EMPLOYEES e
         join DEPARTMENTS d on e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY e.DEPARTMENT_ID, d.DEPARTMENT_NAME
order by e.DEPARTMENT_ID;

-- Group by 절 이후에는 Group by 에 참여한 컬럼과 집계 함수만 남는다.

-- 평균 급여가 7000 이상인 부서만 출력
select DEPARTMENT_ID,
       ROUND(avg(SALARY), 2) 평균급여
from EMPLOYEES
where avg(SALARY) >= 7000 -- 아직까지 집계 함수가 시행되지 않은 상태 => 집계 함수의 비교는 불가하다.
group by DEPARTMENT_ID
order by DEPARTMENT_ID;

-- 집계 함수 이후의 조건 비교는 Having 절 이용 해야함
select DEPARTMENT_ID,
       ROUND(avg(SALARY), 2)
from EMPLOYEES
group by DEPARTMENT_ID
having avg(SALARY) >= 7000 -- Group by 와  aggregation 의 조건 필터링은 Having 절에서
order by DEPARTMENT_ID;

-- ROll UP 함수
-- GROUP BY 절과 함께 사용
-- 그룸 지어진 결과에 대한 좀 더 상세한 요약을 제공함.
-- 일종의 Item TOTAL 값을 집계해 주는 함수
select DEPARTMENT_ID,
       JOB_ID,
       sum(SALARY)
from EMPLOYEES
group by rollup (DEPARTMENT_ID, JOB_ID);


--CUBE
-- crossTab 에 대한 Summary 를 함께 추출하는 함수
-- Rollup 함수에 의해 출력되는 Item total 값과 column total 값을 함께 추출
select DEPARTMENT_ID,
       JOB_ID,
       sum(SALARY)
from EMPLOYEES
group by cube (DEPARTMENT_ID, JOB_ID)
order by DEPARTMENT_ID;

-----------------
-- subquery
-----------------

-- 모든 직원 급여의 중앙값보다 많은 급여를 받는 사원은?
-- 1) 모든 직원 급여의 중앙값은?
-- 2) 1)번의 결과보다 많은 급여를 받는 직원의 목록?
-- 1. 직원 급여 중앙값
select median(SALARY)
from EMPLOYEES;
-- 6200
--2. 1번의 결과(6200)보다 많은 급여를 받는 직원목록
select FIRST_NAME,
       SALARY
from EMPLOYEES
where SALARY >= 6200;

-- 1), 2) 쿼리 합치기
select FIRST_NAME, SALARY
from EMPLOYEES
where SALARY >= (select median(SALARY)
                 from EMPLOYEES)
order by SALARY desc;

-- susan 보다 늦게 입사한 사원의 정보는?
-- 1) Susan 의 입사일
-- 2) 1)번의 결과보다 늦게 입사한 사원의 정보 뽑기

-- 1. 수잔의 입사일
select HIRE_DATE
from EMPLOYEES
where upper(FIRST_NAME) = 'SUSAN';
-- 12/06/07

-- 2. 1) 결과(12/06/07) 보다 늦게 입사한 사원 정보
select FIRST_NAME, HIRE_DATE
from EMPLOYEES
where HIRE_DATE > '12/06/07';

-- 1) ,2) 쿼리 합치기
select FIRST_NAME, HIRE_DATE
from EMPLOYEES
where HIRE_DATE > (select HIRE_DATE
                   from EMPLOYEES
                   where UPPER(FIRST_NAME) = 'SUSAN');


-- 연습문제
-- 모든 직원 급여의 중앙값 보다 많이 받으면서 수잔보다 입사일이 늦은 사람
select FIRST_NAME, SALARY, HIRE_DATE
from EMPLOYEES
where SALARY >= (select median(SALARY)
                 from EMPLOYEES) and HIRE_DATE > (select HIRE_DATE
                   from EMPLOYEES
                   where UPPER(FIRST_NAME) = 'SUSAN')
order by HIRE_DATE asc, SALARY desc ;