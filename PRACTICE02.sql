-- 문제1.
-- 매니저가 있는 직원은 몇 명입니까? 아래의 결과가 나오도록 쿼리문을 작성하세요
SELECT COUNT(*) AS "haveMngCnt"
FROM employees
WHERE manager_id IS NOT NULL;


-- 문제2.
-- 직원중에 최고임금(salary)과 최저임금을 “최고임금, “최저임금”프로젝션 타이틀로 함께 출력해 보세요.
-- 두 임금의 차이는 얼마인가요? “최고임금 – 최저임금”이란 타이틀로 함께 출력해 보세요.
SELECT MAX(salary) AS "최고임금",
       MIN(salary) AS "최저임금",
       MAX(salary) - MIN(salary) AS "최고임금 - 최저임금"
FROM employees;


-- 문제3.
-- 마지막으로 신입사원이 들어온 날은 언제 입니까? 다음 형식으로 출력해주세요.
-- 예) 2014년 07월 10일
SELECT TO_CHAR(MAX(HIRE_DATE), 'YYYY"년 "MM"월 "DD"일"') AS 마지막신입
FROM EMPLOYEES;



-- 문제4.
-- 부서별로 평균임금, 최고임금, 최저임금을 부서아이디(department_id)와 함께 출력합니다.
-- 정렬순서는 부서번호(department_id) 내림차순입니다.
SELECT  DEPARTMENT_ID,
          ROUND(AVG(SALARY), 2) AS 평균임금,
          MAX(SALARY) AS 최고임금,
          MIN(SALARY) AS 최저임금
FROM EMPLOYEES
group by DEPARTMENT_ID
order by DEPARTMENT_ID desc;


-- 문제5.
-- 업무(job_id)별로 평균임금, 최고임금, 최저임금을 업무아이디(job_id)와 함께 출력하고 정렬순서는
-- 최저임금 내림차순, 평균임금(소수점 반올림), 오름차순 순입니다.
-- (정렬순서는 최소임금 2500 구간일때 확인해볼 것)
SELECT JOB_ID,
       ROUND(AVG(SALARY), 0) AS 평균임금,
       MAX(SALARY) AS 최고임금,
       MIN(SALARY) AS 최저임금
FROM EMPLOYEES
group by JOB_ID
ORDER BY 최저임금 desc, 평균임금 asc, JOB_ID asc;


-- 문제6.
-- 가장 오래 근속한 직원의 입사일은 언제인가요? 다음 형식으로 출력해주세요.
-- 예) 2001-01-13 토요일
SELECT TO_CHAR(MIN(HIRE_DATE), 'YYYY-MM-DD DAY') AS 최고참
FROM EMPLOYEES;


-- 문제7.
-- 평균임금과 최저임금의 차이가 2000 미만인 부서(department_id), 평균임금, 최저임금 그리고 (평균임금 – 최저임금)를 (평균임금 – 최저임금)의 내림차순으로 정렬해서 출력하세요.
select DEPARTMENT_ID,
       avg(SALARY) as 평균임금,
       min(SALARY) as 최저임금,
       avg(SALARY) - min(SALARY) as "(평균임금 - 최저임금)"
from EMPLOYEES
group by DEPARTMENT_ID
HAVING avg(SALARY) - min(SALARY) < 2000
order by (평균임금 - 최저임금) desc;


-- 문제8.
-- 업무(JOBS)별로 최고임금과 최저임금의 차이를 출력해보세요.
-- 차이를 확인할 수 있도록 내림차순으로 정렬하세요?
select JOB_TITLE, MIN_SALARY, MAX_SALARY,
       MAX_SALARY - MIN_SALARY AS 임금차이
FROM JOBS
ORDER BY 임금차이 desc;




-- 문제9
-- 2015년 이후 입사자중 관리자별로 평균급여 최소급여 최대급여를 알아보려고 한다.
-- 출력은 관리자별로 평균급여가 5000이상 중에 평균급여 최소급여 최대급여를 출력합니다.
-- 평균급여의 내림차순으로 정렬하고 평균급여는 소수점 첫째짜리에서 반올림 하여 출력합니다.
SELECT MANAGER_ID,
    Round(avg(SALARY),1) as 평균급여,
    max(SALARY) as 최대급여,
    min(SALARY) as 최소급여
FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('2015-01-01', 'YYYY-MM-DD')
GROUP BY MANAGER_ID
HAVING avg(SALARY) >= 5000
ORDER BY 평균급여 desc;


-- 문제10
-- 아래회사는 보너스 지급을 위해 직원을 입사일 기준으로 나눌려고 합니다.
-- 입사일이 02/12/31일 이전이면 '창립맴버, 03년은 '03년입사’, 04년은 ‘04년입사’
-- 이후입사자는 ‘상장이후입사’ optDate 컬럼의 데이터로 출력하세요.
-- 정렬은 입사일로 오름차순으로 정렬합니다.