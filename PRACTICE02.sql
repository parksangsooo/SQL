-- 문제1.
-- 매니저가 있는 직원은 몇 명입니까? 아래의 결과가 나오도록 쿼리문을 작성하세요
SELECT COUNT(*) AS "haveMngCnt" -- 매니저가 있는 직원의 총 수를 계산
FROM employees
WHERE manager_id IS NOT NULL; -- 매니저 ID가 NULL이 아닌 레코드만 고려



-- 문제2.
-- 직원중에 최고임금(salary)과 최저임금을 “최고임금, “최저임금”프로젝션 타이틀로 함께 출력해 보세요.
-- 두 임금의 차이는 얼마인가요? “최고임금 – 최저임금”이란 타이틀로 함께 출력해 보세요.
SELECT
  MAX(salary) AS "최고임금", -- 직원 중 최고 급여액
  MIN(salary) AS "최저임금", -- 직원 중 최저 급여액
  MAX(salary) - MIN(salary) AS "최고임금 - 최저임금" -- 최고 급여와 최저 급여의 차이
FROM employees;



-- 문제3.
-- 마지막으로 신입사원이 들어온 날은 언제 입니까? 다음 형식으로 출력해주세요.
-- 예) 2014년 07월 10일
SELECT TO_CHAR(MAX(HIRE_DATE), 'YYYY"년 "MM"월 "DD"일"') AS 마지막신입 -- 가장 최근 입사일을 년월일 형식으로 변환
FROM EMPLOYEES;




-- 문제4.
-- 부서별로 평균임금, 최고임금, 최저임금을 부서아이디(department_id)와 함께 출력합니다.
-- 정렬순서는 부서번호(department_id) 내림차순입니다.
SELECT
  DEPARTMENT_ID, -- 부서 ID
  ROUND(AVG(SALARY), 2) AS 평균임금, -- 각 부서별 평균 급여 (소수 둘째자리까지 반올림)
  MAX(SALARY) AS 최고임금, -- 최고 급여
  MIN(SALARY) AS 최저임금 -- 최저 급여
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID -- 부서별로 그룹화
ORDER BY DEPARTMENT_ID DESC; -- 부서 ID 기준으로 내림차순 정렬



-- 문제5.
-- 업무(job_id)별로 평균임금, 최고임금, 최저임금을 업무아이디(job_id)와 함께 출력하고 정렬순서는
-- 최저임금 내림차순, 평균임금(소수점 반올림), 오름차순 순입니다.
-- (정렬순서는 최소임금 2500 구간일때 확인해볼 것)
SELECT
  JOB_ID, -- 직무 ID
  ROUND(AVG(SALARY), 0) AS 평균임금, -- 직무별 평균 급여 (반올림)
  MAX(SALARY) AS 최고임금, -- 최고 급여
  MIN(SALARY) AS 최저임금 -- 최저 급여
FROM EMPLOYEES
GROUP BY JOB_ID -- 직무별로 그룹화
ORDER BY 최저임금 DESC, 평균임금 ASC, JOB_ID ASC; -- 최저임금 내림차순, 평균임금 오름차순, 직무 ID 오름차순으로 정렬



-- 문제6.
-- 가장 오래 근속한 직원의 입사일은 언제인가요? 다음 형식으로 출력해주세요.
-- 예) 2001-01-13 토요일
SELECT TO_CHAR(MIN(HIRE_DATE), 'YYYY-MM-DD DAY') AS 최고참 -- 가장 이른 입사일을 '년-월-일 요일' 형식으로 변환
FROM EMPLOYEES;


-- 문제7.
-- 평균임금과 최저임금의 차이가 2000 미만인 부서(department_id), 평균임금, 최저임금 그리고 (평균임금 – 최저임금)를 (평균임금 – 최저임금)의 내림차순으로 정렬해서 출력하세요.
SELECT
  DEPARTMENT_ID, -- 부서 ID
  avg(SALARY) as 평균임금, -- 평균 급여
  min(SALARY) as 최저임금, -- 최저 급여
  avg(SALARY) - min(SALARY) as "(평균임금 - 최저임금)" -- 평균 급여와 최저 급여의 차이
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID -- 부서별로 그룹화
HAVING avg(SALARY) - min(SALARY) < 2000 -- 평균 급여와 최저 급여의 차이가 2000보다 작은 경우
ORDER BY (평균임금 - 최저임금) DESC; -- 차이가 큰 순으로 내림차순 정렬



-- 문제8.
-- 업무(JOBS)별로 최고임금과 최저임금의 차이를 출력해보세요.
-- 차이를 확인할 수 있도록 내림차순으로 정렬하세요?
SELECT
  JOB_TITLE, -- 직무 제목
  MIN_SALARY, -- 최저임금
  MAX_SALARY, -- 최고임금
  MAX_SALARY - MIN_SALARY AS 임금차이 -- 최고임금과 최저임금의 차이
FROM JOBS
ORDER BY 임금차이 DESC; -- 임금 차이 기준으로 내림차순 정렬

select JOB_ID,
       max(SALARY) - min(SALARY) diff
from EMPLOYEES
group by JOB_ID
order by diff desc;




-- 문제9
-- 2015년 이후 입사자중 관리자별로 평균급여 최소급여 최대급여를 알아보려고 한다.
-- 출력은 관리자별로 평균급여가 5000이상 중에 평균급여 최소급여 최대급여를 출력합니다.
-- 평균급여의 내림차순으로 정렬하고 평균급여는 소수점 첫째짜리에서 반올림 하여 출력합니다.
SELECT
  MANAGER_ID, -- 매니저 ID
  ROUND(avg(SALARY),1) as 평균급여, -- 평균 급여 (소수 첫째자리까지 반올림)
  max(SALARY) as 최대급여, -- 최대 급여
  min(SALARY) as 최소급여 -- 최소 급여
FROM EMPLOYEES
WHERE HIRE_DATE > TO_DATE('2015-01-01', 'YYYY-MM-DD') -- 2015년 1월 1일 이후에 입사한 직원
GROUP BY MANAGER_ID -- 매니저별로 그룹화
HAVING avg(SALARY) >= 5000 -- 평균 급여가 5000 이상인 경우만
ORDER BY 평균급여 DESC; -- 평균 급여 기준으로 내림차순 정렬



--문제10
-- 아래회사는 보너스 지급을 위해 직원을 입사일 기준으로 나눌려고 합니다.
-- 입사일이 12/12/31일 이전이면 '창립맴버, 13년은 '13년입사’, 14년은 ‘14년입사’
-- 이후입사자는 ‘상장이후입사’ optDate 컬럼의 데이터로 출력하세요.
-- 정렬은 입사일로 오름차순으로 정렬합니다.

select EMPLOYEE_ID,       -- 직원의 고유 식별자
       FIRST_NAME,        -- 직원의 이름
       LAST_NAME,         -- 직원의 성
       HIRE_DATE,         -- 직원이 회사에 입사한 날짜
       case
           when HIRE_DATE < TO_DATE('2013-01-01', 'YYYY-MM-DD')
               then '창립맴버' -- -- TO_DATE 함수를 사용하여 문자열을 날짜 타입으로 변환. 날짜 비교를 통해 2003년 이전에 입사한 직원들을 창립멤버로 분류함.
           when TO_CHAR(hire_date, 'YYYY') = '2013' then '13년입사' -- TO_CHAR 함수를 사용하여 날짜에서 연도를 문자열로 추출.
           when TO_CHAR(hire_date, 'YYYY') = '2014' then '14년입사' -- 추출된 연도가 '2004'인 경우 해당 직원을 '04년입사'로 분류함.
           else '상장이후입사' -- 위의 모든 조건에 해당하지 않는 경우, 직원을 '상장이후입사'로 분류함.
           end AS optDate -- CASE 문을 사용해 계산된 값을 optDate 라는 새로운 열로 표시
from EMPLOYEES -- employees 테이블에서 데이터를 선택함
order by HIRE_DATE ASC; -- hire_date 기준으로 결과를 오름차순으로 정렬함

