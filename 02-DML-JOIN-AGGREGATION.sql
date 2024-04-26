-------------------
-- JOIN
-------------------

-- employees 와 departments
describe emloyees;
desc DEPARTMENTS;

select * from EMPLOYEES; -- 107 rows
select * from DEPARTMENTS; -- 27 rows

select *
from EMPLOYEES, DEPARTMENTS;    -- 107 x 27

-- 카티전 프로덕트
select *
from EMPLOYEES,DEPARTMENTS
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
from EMPLOYEES emp, DEPARTMENTS dept
where emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;   -- 106명, department_id 가 null 인 직원은 JOIN 에서 배제

select *
from EMPLOYEES
where DEPARTMENT_ID is null;    -- 178 kimberely

select emp.FIRST_NAME,
       dept.DEPARTMENT_NAME
from EMPLOYEES emp join DEPARTMENTS dept using (DEPARTMENT_ID);

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
from EMPLOYEES emp join jobs j on emp.JOB_ID = j.JOB_ID
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
from EMPLOYEES emp, DEPARTMENTS dept
where emp.DEPARTMENT_ID = dept.DEPARTMENT_ID (+); -- null 이 포함된 테이블 쪽에 (+) 표기

select *
from EMPLOYEES where DEPARTMENT_ID is null; -- kimberely -> 부서에 소속되지 않음


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
from EMPLOYEES emp, DEPARTMENTS dept
where emp.DEPARTMENT_ID (+) = dept.DEPARTMENT_ID;   -- departments 테이블 레코드 전부를 출력에 참여 122 레코드

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
from EMPLOYEES emp full outer join DEPARTMENTS dept
on emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;

--------------------
-- NATURAL JOIN
--------------------
-- JOIN 할 테이블에 같은 이름의 컬럼이 있는 경우, 해당 컬럼을 기준으로 JOIN

select * from EMPLOYEES emp natural join DEPARTMENTS dept;
-- select * from EMPLOYEES emp join DEPARTMENTS dept on emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;
-- select * from EMPLOYEES emp join DEPARTMENTS dept on emp.MANAGER_ID = dept.MANAGER_ID;
select *
from EMPLOYEES emp join DEPARTMENTS dept on emp.MANAGER_ID = dept.MANAGER_ID and emp.DEPARTMENT_ID = dept.DEPARTMENT_ID;

--------------------
-- self join
--------------------
-- 자기 자신과의 JOIN
-- 자기자신을 두 번 호출 하기 때문에 -> 별칭을 반드시 부여해야 할 필요가 있는 JOIN

select * from EMPLOYEES;        -- 107
select emp.EMPLOYEE_ID,
       emp.FIRST_NAME,
       emp.MANAGER_ID,
       man.FIRST_NAME
-- from EMPLOYEES emp join EMPLOYEES man
-- on emp.MANAGER_ID = man.EMPLOYEE_ID;
from EMPLOYEES emp, EMPLOYEES man
where emp.MANAGER_ID = man.EMPLOYEE_ID; -- 106

-- 해봅시다. steven (매니저 없는 분까지)
select emp.EMPLOYEE_ID,
       emp.FIRST_NAME,
       emp.MANAGER_ID,
       man.FIRST_NAME
-- from EMPLOYEES emp, EMPLOYEES man
-- where emp.MANAGER_ID = man.EMPLOYEE_ID(+);
from EMPLOYEES emp left outer join EMPLOYEES man
on emp.MANAGER_ID = man.EMPLOYEE_ID;
