-- 혼합 SQL 문제입니다.
-- 문제1.
-- 담당 매니저가 배정되어있으나 커미션비율이 없고, 월급이 3000초과인 직원의
-- 이름, 매니저 아이디, 커미션 비율, 월급을 출력하세요.
-- (45건)
SELECT first_name     AS "이름",
       manager_id     AS "매니저 ID",
       commission_pct AS "커미션 비율",
       salary         AS "월급"
FROM employees
-- 매니저가 있고 커미션 비율이 NULL이며 급여가 3000을 초과하는 직원을 필터링합니다.
WHERE manager_id IS NOT NULL
  AND commission_pct IS NULL
  AND salary > 3000;



-- 문제2.
-- 각 부서별로 최고의 급여를 받는 사원의 직원번호(employee_id), 이름(first_name), 급여 (salary),
-- 입사일(hire_date), 전화번호(phone_number), 부서번호(department_id)를 조회하세요
-- -조건절 비교 방법으로 작성하세요
-- -급여의 내림차순으로 정렬하세요
-- -입사일은 2001-01-13 토요일 형식으로 출력합니다.
-- -전화번호는 515-123-4567 형식으로 출력합니다.
-- (11건)

SELECT e.employee_id                                AS "직원번호",
       e.first_name                                 AS "이름",
       e.salary                                     AS "급여",
       TO_CHAR(e.hire_date, 'YYYY-MM-DD DY')        AS "입사일",
       REPLACE(SUBSTR(e.phone_number, 3), '.', '-') AS 전화번호,
       e.department_id                              AS "부서번호"
FROM employees e
-- 각 부서별로 최고 급여를 그룹화하고 해당 급여를 받는 직원을 선택합니다.
WHERE (e.department_id, e.salary) IN (SELECT department_id, MAX(salary)
                                      FROM employees
                                      GROUP BY department_id)
-- 결과를 급여의 내림차순으로 정렬합니다.
ORDER BY e.salary DESC;


-- 문제3
-- 매니저별로 평균급여 최소급여 최대급여를 알아보려고 한다.
-- -통계대상(직원)은 2015년 이후의 입사자 입니다.
-- -매니저별 평균급여가 5000이상만 출력합니다.
-- -매니저별 평균급여의 내림차순으로 출력합니다.
-- -매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
-- -출력내용은 매니저 아이디, 매니저이름(first_name), 매니저별 평균급여, 매니저별 최소급여,매니저별 최대급여 입니다.
-- (9건)
SELECT *
FROM employees;

SELECT e.manager_id            AS "매니저 아이디",
       e.first_name            AS "매니저 이름",
       ROUND(AVG(e.salary), 1) AS "평균급여",
       MIN(e.salary)           AS "최소급여",
       MAX(e.salary)           AS "최대급여"
FROM employees e
         JOIN employees m ON e.employee_id = m.manager_id
WHERE e.hire_date >= '2015-01-01'
GROUP BY e.manager_id, e.first_name
HAVING AVG(e.salary) >= 5000;


-- 문제4.
-- 각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명(department_name),
-- 매니저(manager)의 이름(first_name)을 조회하세요.
-- 부서가 없는 직원(Kimberely)도 표시합니다.
-- (106명)
SELECT emp.employee_id      AS 사번,
       emp.first_name       AS 이름,
       dept.department_name AS 부서명
FROM employees emp
         LEFT OUTER JOIN departments dept ON emp.department_id = dept.department_id
WHERE emp.manager_id IS NOT NULL;

-- 문제5.
-- 2015년 이후 입사한 직원 중에 입사일이 11번째에서 20번째의 직원의
-- 사번, 이름, 부서명, 급여, 입사일을 입사일 순서로 출력하세요
SELECT e.employee_id     AS 사번,
       e.first_name      AS 이름,
       d.department_name AS 부서명,
       e.salary          AS 급여,
       e.hire_date       AS 입사일,
       r.rank
-- 서브쿼리에서 RANK()를 사용하여 입사일 기준으로 순위를 할당
FROM (SELECT employee_id,
             first_name,
             hire_date,
             salary,
             RANK() OVER (ORDER BY hire_date) AS rank -- 입사일 기준으로 각 직원에게 순위를 부여
      FROM employees) r
         JOIN employees e ON r.employee_id = e.employee_id
         JOIN departments d ON e.department_id = d.department_id
WHERE rank BETWEEN 11 AND 20;
-- 순위가 11에서 20 사이인 직원만 선택합니다.


-- 문제6.
-- 가장 늦게 입사한 직원의 이름(first_name last_name)과 연봉(salary)과 근무하는 부서 이름(department_name)은?
SELECT e.first_name || ' ' || e.last_name AS 이름,
       salary                             AS 연봉,
       dept.department_name               AS 부서이름,
       e.hire_date                        AS 입사일
FROM employees e
         JOIN departments dept ON e.department_id = dept.department_id
WHERE hire_date = (SELECT MAX(hire_date) FROM employees);


-- 문제7.
-- 평균연봉(salary)이 가장 높은 부서 직원들의 직원번호(employee_id), 이름(firt_name), 성
-- (last_name)과 업무(job_title), 연봉(salary)을 조회하시오.
-- 최대 평균 연봉을 가진 부서의 직원 정보 조회
-- 최대 평균 연봉을 가진 부서의 직원 정보 및 해당 부서의 평균 연봉 조회
SELECT e.employee_id,                            -- 직원 ID
       e.first_name || ' ' || e.last_name AS 이름, -- 직원 이름
       d.avg_salary,                             -- 부서의 평균 연봉
       j.job_title                               -- 직원 직무명
FROM employees e
         JOIN
     jobs j ON e.job_id = j.job_id
         JOIN
     ( -- 최대 평균 연봉을 가진 부서의 평균 연봉과 부서 ID 조회
         SELECT department_id,
                AVG(salary) AS avg_salary
         FROM employees
         GROUP BY department_id) d ON e.department_id = d.department_id
WHERE d.avg_salary = ( -- 최대 평균 연봉 선택
    SELECT MAX(avg_salary)
    FROM (SELECT AVG(salary) AS avg_salary
          FROM employees
          GROUP BY department_id))
ORDER BY e.salary DESC;



-- 문제8.
-- 평균 급여(salary)가 가장 높은 부서는?
SELECT department_name
FROM (SELECT dept.department_id,
             dept.department_name,
             AVG(e.salary) AS avg_salary
      FROM departments dept
               JOIN employees e ON dept.department_id = e.department_id
      GROUP BY dept.department_id, dept.department_name
      ORDER BY avg_salary DESC)
WHERE ROWNUM = 1;


-- 문제9.
-- 평균 급여(salary)가 가장 높은 지역은?

SELECT department_name
FROM (SELECT dept.department_id,
             dept.department_name,
             AVG(e.salary) AS avg_salary
      FROM departments dept
               JOIN employees e ON dept.department_id = e.department_id
      GROUP BY dept.department_id, dept.department_name
      ORDER BY avg_salary DESC)
WHERE ROWNUM = 1;


-- 문제10.
-- 평균 급여(salary)가 가장 높은 업무는?
SELECT *
FROM (SELECT j.job_title
      FROM employees e
               JOIN jobs j ON e.job_id = j.job_id
      GROUP BY j.job_title
      ORDER BY AVG(e.salary) DESC)
WHERE ROWNUM = 1;