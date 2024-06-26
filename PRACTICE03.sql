-- 테이블간 조인(JOIN) SQL 문제입니다.

-- 문제1.
-- 직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을
-- 조회하여 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬하세요.
-- (106건)

-- Simple Join
select emp.EMPLOYEE_ID,
       emp.FIRST_NAME,
       emp.LAST_NAME,
       dept.DEPARTMENT_NAME
from EMPLOYEES emp,
     DEPARTMENTS dept
where emp.DEPARTMENT_ID = dept.DEPARTMENT_ID -- Join 조건
order by dept.DEPARTMENT_NAME asc, emp.EMPLOYEE_ID desc;

-- ANSI
-- JOIN 의 의도를 명확하게 하고, 조인 조건과 SELECTION 조건을 분리하는 효과
select e.EMPLOYEE_ID, e.FIRST_NAME, e.LAST_NAME, d.DEPARTMENT_NAME
from EMPLOYEES e -- 중심테이블 명시
         join DEPARTMENTS d
              on e.DEPARTMENT_ID = d.DEPARTMENT_ID -- JOIN 조건
order by d.DEPARTMENT_NAME asc, e.EMPLOYEE_ID desc;



-- 문제2.
-- employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
-- 직원들의 사번(employee_id), 이름(firt_name), 급여(salary), 부서명(department_name),
-- 현재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
-- 부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.
-- (106건)

-- SIMPLE JOIN
select e.EMPLOYEE_ID     사번,
       e.FIRST_NAME      이름,
       e.SALARY          급여,
       j.JOB_TITLE       현재업무,
       d.DEPARTMENT_NAME 부서명
from EMPLOYEES E,
     JOBS J,
     DEPARTMENTS D
where e.DEPARTMENT_ID = d.DEPARTMENT_ID
  and e.JOB_ID = j.JOB_ID
  and e.FIRST_NAME != 'Kimberely'
order by e.EMPLOYEE_ID;

-- ANSI
select e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, d.DEPARTMENT_NAME, j.JOB_TITLE
from EMPLOYEES e
         join HR.JOBS J
              on e.JOB_ID = J.JOB_ID
         join DEPARTMENTS d
              on e.DEPARTMENT_ID = d.DEPARTMENT_ID
where e.FIRST_NAME != 'Kimberely'
order by e.EMPLOYEE_ID;


-- 문제2-1.
-- 문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요
-- (107건)

-- Oracle 쿼리
select emp.EMPLOYEE_ID      사번,
       emp.FIRST_NAME       이름,
       emp.SALARY           급여,
       dept.DEPARTMENT_NAME 부서명,
       j.JOB_TITLE          현재업무
from EMPLOYEES emp,
     DEPARTMENTS dept,
     JOBS j
where emp.DEPARTMENT_ID = dept.DEPARTMENT_ID (+) and -- NULL이 포함된 테이블 쪽에 (+)
      emp.JOB_ID = j.JOB_ID
order by emp.EMPLOYEE_ID;

--ANSI
select e.EMPLOYEE_ID, e.FIRST_NAME, e.SALARY, d.DEPARTMENT_NAME, j.JOB_TITLE
from EMPLOYEES e
         join HR.JOBS J using (JOB_ID)
         left outer join DEPARTMENTS d
                   on e.DEPARTMENT_ID = d.DEPARTMENT_ID
order by e.EMPLOYEE_ID;


-- 문제3.
-- 도시별로 위치한 부서들을 파악하려고 합니다.
-- 도시아이디, 도시명, 부서명, 부서아이디를 도시아이디(오름차순)로 정렬하여 출력하세요
-- 부서가 없는 도시는 표시하지 않습니다.
-- (27건)
select l.LOCATION_ID, l.CITY, d.DEPARTMENT_NAME, d.DEPARTMENT_ID
from LOCATIONS l
         join DEPARTMENTS d on l.LOCATION_ID = d.LOCATION_ID
order by l.LOCATION_ID;


-- 문제3-1.
-- 문제3에서 부서가 없는 도시도 표시합니다.
-- (43건)
select l.LOCATION_ID, l.CITY, d.DEPARTMENT_NAME, d.DEPARTMENT_ID
from LOCATIONS l
         left outer join DEPARTMENTS d on l.LOCATION_ID = d.LOCATION_ID
order by l.LOCATION_ID;

-- 문제4.
-- 지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름(country_name)으로 출력하되
-- 지역이름(오름차순), 나라이름(내림차순) 으로 정렬하세요.
-- (25건)
select r.REGION_NAME 지역이름, c.COUNTRY_NAME 나라이름
from REGIONS r
         join COUNTRIES C on r.REGION_ID = C.REGION_ID
order by REGION_NAME, COUNTRY_NAME desc;


-- 문제5.
-- 자신의 매니저보다 채용일(hire_date)이 빠른 사원의 사번(employee_id), 이름(first_name)과
-- 채용일(hire_date), 매니저이름(first_name), 매니저입사일(hire_date)을 조회하세요.
-- (37건)
-- self join 사용
select e.EMPLOYEE_ID as 사번,
       e.FIRST_NAME as 이름,
       e.HIRE_DATE as 채용일,
       m.FIRST_NAME as 매니저이름,
       m.HIRE_DATE as 매니저입사일
from EMPLOYEES e
         join EMPLOYEES m on e.MANAGER_ID = m.EMPLOYEE_ID
where e.HIRE_DATE < m.HIRE_DATE;




-- 문제6.
-- 나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다.
-- 나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 나라명(오름차순)로 정렬하여 출력하세요.
-- 값이 없는 경우 표시하지 않습니다.
-- (27건)
select c.COUNTRY_NAME    나라명,
       c.COUNTRY_ID      나라아이디,
       l.CITY            도시명,
       l.LOCATION_ID     도시아이디,
       d.DEPARTMENT_NAME 부서명,
       d.DEPARTMENT_ID   부서아이디
from LOCATIONS l
         left outer join COUNTRIES c
                         on l.COUNTRY_ID = c.COUNTRY_ID
         left outer join DEPARTMENTS d
                         on l.LOCATION_ID = d.LOCATION_ID
where d.DEPARTMENT_NAME is not null
order by c.COUNTRY_NAME asc;




-- 문제7.
-- job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
-- 과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 사번, 이름(풀네임), 업무아이디, 시작일, 종료일을 출력하세요.
-- 이름은 first_name과 last_name을 합쳐 출력합니다.
-- (2건)
select emp.FIRST_NAME ||' '|| emp.LAST_NAME "이름(풀네임)",
       jh.EMPLOYEE_ID 사번,
       jh.JOB_ID 업무아이디,
       jh.START_DATE 시작일,
       jh.END_DATE 종료일
from JOB_HISTORY JH join EMPLOYEES emp on JH.EMPLOYEE_ID = emp.EMPLOYEE_ID
where JH.JOB_ID = 'AC_ACCOUNT'


-- 문제8.
-- 각 부서(department)에 대해서 부서번호(department_id), 부서이름(department_name),
-- 매니저(manager)의 이름(first_name), 위치(locations)한 도시(city), 나라(countries)의 이름(countries_name)
-- 그리고 지역구분(regions)의 이름(resion_name)까지 전부 출력해 보세요.
-- (11건)
select dept.DEPARTMENT_ID   부서번호,
       dept.DEPARTMENT_NAME 부서이름,
       man.FIRST_NAME       매니저이름,
       l.CITY               도시,
       c.COUNTRY_NAME       나라이름,
       r.REGION_NAME        지역이름
from DEPARTMENTS dept
         join EMPLOYEES man on dept.MANAGER_ID = man.EMPLOYEE_ID
         join LOCATIONS l on dept.LOCATION_ID = l.LOCATION_ID
         join COUNTRIES c on l.COUNTRY_ID = c.COUNTRY_ID
         join REGIONS r on c.REGION_ID = r.REGION_ID;


-- 문제9.
-- 각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명(department_name),
-- 매니저(manager)의 이름(first_name)을 조회하세요.
-- 부서가 없는 직원(Kimberely)도 표시합니다.
-- (106명)
select
    emp.EMPLOYEE_ID 사번,
    emp.FIRST_NAME 이름,
    dept.DEPARTMENT_NAME 부서명,
    man.FIRST_NAME
from EMPLOYEES emp
    left outer join DEPARTMENTS dept on emp.DEPARTMENT_ID = dept.DEPARTMENT_ID
join EMPLOYEES man on emp.MANAGER_ID = man.EMPLOYEE_ID;
