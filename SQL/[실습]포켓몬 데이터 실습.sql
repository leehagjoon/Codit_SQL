-- Q1) pokemon 테이블에 있는 모든 열을 조회하시오.

SELECT * FROM pokemon p ;

-- Q2) pokemon 테이블에서 포켓몬의 한국어 이름(kor_name)과 종합 능력치(total)을 조회하시오.

SELECT kor_name
	, total
FROM pokemon
;

-- Q3) pokemon 테이블의 행 수를 조회하시오.

SELECT COUNT(*)
FROM pokemon
;

-- Q4) trainer 테이블에서 achievement_level 범주의 종류를 조회하시오.

SELECT DISTINCT(ACHIEVEMENT_LEVEL)
FROM TRAINER;

-- Q5) trainer 테이블에서 achievement_level 범주의 개수를 조회하시오.

SELECT COUNT(DISTINCT ACHIEVEMENT_LEVEL)
FROM trainer;

-- Q6) pokemon 테이블에서 type1 범주의 개수를 조회하고 type1_cnt 별칭을 부여하시오.

SELECT COUNT(DISTINCT type1) AS type1_cnt
FROM pokemon;

-- Q7) trainer 테이블에서 배지의 개수(badge_count)가 6개 이상인 데이터를 조회하시오.

SELECT *
FROM trainer
WHERE BADGE_COUNT >= 6
;

-- Q8) trainer 테이블에서 나이가 30대인 데이터를 조회하시오.

SELECT *
FROM trainer
WHERE AGE BETWEEN 30 AND 39
;

-- Q9) trainer 테이블에서 트레이너의 고향이 서울인 데이터를 조회하시오.

SELECT *
FROM TRAINER
WHERE HOMETOWN = 'seoul'
;

-- Q10) trainer 테이블에서 트레이너가 선호하는 포켓몬 타입(prefer_type)이 Poison이고 나이가 30세 이상인 트레이너를 조회하시오.

SELECT *
FROM TRAINER
WHERE PREFER_TYPE = 'Poison'
AND age BETWEEN 30 AND 39
;

-- Q11) trainer 테이블에서 트레이너가 배지의 개수가 8개이거나 고향이 제주인 트레이너를 조회하시오.

SELECT *
FROM trainer
WHERE BADGE_COUNT = 8 AND HOMETOWN = 'Jeju'
;

-- Q12) battle 테이블에서 2024년 10월 15일 이후에 대결한 데이터만 조회하시오.

SELECT *
FROM BATTLE
WHERE BATTLE_DATE >= '2024-10-15'
;

-- Q13) trainer 테이블에서 트레이너가 선호하는 포켓몬 타입(prefer_type)이 Fairy 또는 Dragon인 데이터를 조회하시오.

SELECT *
FROM trainer
WHERE prefer_type IN ('Fairy', 'Dragon')
;

-- Q14) trainer 테이블에서 트레이너의 이름이 C로 시작하는 데이터를 조회하시오.

SELECT *
FROM trainer
WHERE name LIKE('C%')
;

-- Q15) trainer 테이블에서 트레이너의 이름의 세번째 알파벳이 a인 데이터를 조회하시오.

SELECT *
FROM TRAINER
WHERE name LIKE('__a%')
;

-- Q16) trainer 테이블에서 트레이너가 20~30대인 데이터를 조회하고, 나이를 기준으로 내림차순 정렬하시오.

SELECT *
FROM trainer
WHERE age BETWEEN 20 AND 39
ORDER BY age desc
;

-- Q17) trainer 테이블에서 트레이더 이름(name)을 대문자로 표기하고, 배지의 개수(badge_count)를 '_'로 연결한 새로운 컬럼을 name_badge로 조회하시오.

SELECT 
    CONCAT(UPPER(NAME), '_', BADGE_COUNT) AS NAME_BADGE
FROM TRAINER;

-- Q18) trainer_pokemon 테이블에서 트레이너의 현재 레벨(level)의 최솟값(min_lv), 최댓값(max_lv), 평균값(avg_lv)을 구하고 평균값은 소수점 아래 첫째자리까지 반올림하시오.

SELECT 
    MIN(LEVEL) AS MIN_LV,
    MAX(LEVEL) AS MAX_LV,
    ROUND(AVG(LEVEL), 1) AS AVG_LV
FROM TRAINER_POKEMON;

-- Q19) trainer 테이블에서 이름(name)의 길이가 긴 순서대로 내림차순 정렬하고, 이름의 길이가 같은 경우 알파벳 순으로 오름차순 정렬하시오.

SELECT *
FROM TRAINER
ORDER BY LENGTH(NAME) DESC, NAME ASC
;

-- Q20) pokemon 테이블에서 종합 능력치(total)가 가장 높은 포켓몬 상위 5개를 조회하시오.

SELECT *
FROM pokemon
ORDER BY total DESC LIMIT 5
;

-- Q21) 전설의 포켓몬인지 아닌지 여부(is_legendary)에 따라 최대 체력(max_hp), 최소 체력(min_hp), 평균 체력(avg_hp), 평균 속도(avg_speed)를 조회하시오.

SELECT 
    IS_LEGENDARY,
    MAX(HP) AS MAX_HP,
    MIN(HP) AS MIN_HP,
    AVG(HP) AS AVG_HP,
    AVG(SPEED) AS AVG_SPEED
FROM POKEMON
GROUP BY IS_LEGENDARY;

-- Q22) 전설의 포켓몬인지 아닌지 여부(is_legendary)에 따라 최대 체력(max_hp), 최소 체력(min_hp), 평균 체력(avg_hp), 평균 속도(avg_speed)를 조회하고 평균 체력이 센 순으로 조회하시오.
SELECT 
    IS_LEGENDARY,
    MAX(HP) AS MAX_HP,
    MIN(HP) AS MIN_HP,
    AVG(HP) AS AVG_HP,
    AVG(SPEED) AS AVG_SPEED
FROM POKEMON
GROUP BY IS_LEGENDARY
ORDER BY AVG_HP DESC;

-- Q23) trainer_pokemon 테이블에서 트레이너가 방생(Released)하지 않은 포켓몬들을 대상으로 트레이너별 포켓몬의 최대 경험치(max_point)와 평균 경험치(avg_point)를 구하시오.
-- Status의 종류 : Active(현재 트레이너가 보유 중인 포켓몬), Release(트레이너가 방생한 포켓몬), Training(포켓몬이 훈련 중)

SELECT TRAINER_ID,
	max(EXPERIENCE_POINT) AS max_point,
	avg(EXPERIENCE_POINT) AS avg_point
FROM TRAINER_POKEMON
WHERE STATUS != 'Release'
GROUP BY TRAINER_ID
;

-- Q24) 전설의 포켓몬인지 아닌지 여부(is_legendary)에 따라 최대 체력(max_hp), 최소 체력(min_hp), 평균 체력(avg_hp), 평균 속도(avg_speed)를 조회하고 평균 속도가 100보다 큰 경우만 필터링하시오.

SELECT 
    IS_LEGENDARY,
    MAX(HP) AS MAX_HP,
    MIN(HP) AS MIN_HP,
    AVG(HP) AS AVG_HP,
    AVG(SPEED) AS AVG_SPEED
FROM POKEMON
GROUP BY IS_LEGENDARY
HAVING AVG(SPEED) > 100;

-- Q25) traine_pokemon 테이블에서 각 월별로 포획된 포켓몬 수를 구하시오.

SELECT 
    DATE_FORMAT(CATCH_DATE, '%Y-%m') AS YM,
    COUNT(*) AS CNT
FROM TRAINER_POKEMON
GROUP BY YM
ORDER BY YM;

-- Q26) trainer 테이블에서 트레이너 성취도(achievement_level)별 최연장자, 최연소자, 평균 나이, 평균 배지 수를 출력하고 평균 배지 수로 오름차순 정렬하시오.

SELECT 
    ACHIEVEMENT_LEVEL,
    MAX(AGE) AS MAX_AGE,
    MIN(AGE) AS MIN_AGE,
    AVG(AGE) AS AVG_AGE,
    AVG(BADGE_COUNT) AS AVG_BADGE
FROM TRAINER
GROUP BY ACHIEVEMENT_LEVEL
ORDER BY AVG_BADGE ASC;
-- Q27) 전설의 포켓몬인지 아닌지 여부(is_legendary)에 따라 최대 체력(max_hp), 최소 체력(min_hp), 평균 체력(avg_hp), 평균 속도(avg_speed)를 조회하고 총계를 조회하시오.

SELECT 
    IFNULL(IS_LEGENDARY, 'TOTAL') AS IS_LEGENDARY,
    MAX(HP) AS MAX_HP,
    MIN(HP) AS MIN_HP,
    AVG(HP) AS AVG_HP,
    AVG(SPEED) AS AVG_SPEED
FROM POKEMON
GROUP BY IS_LEGENDARY WITH ROLLUP;

-- Q28) pokemon 테이블에서 hp와 hp를 문자형으로 변환하여 hp_char로 조회하시오.

SELECT 
    HP,
    CAST(HP AS CHAR) AS HP_CHAR
FROM POKEMON;

-- Q29) trainer 테이블에서 이름과 나이를 name(age) 형태로 조회하고 name_age 컬럼명으로 조회하시오.

SELECT 
    NAME,
    AGE,
    CONCAT(NAME, '(', AGE, ')') AS NAME_AGE
FROM TRAINER;

-- Q30) trainer 테이블에서 이름과 배지의 개수를 name_badge_count 형태로 조회하고 name_badge 컬럼명으로 조회하시오.

SELECT 
    CONCAT(NAME, '_', BADGE_COUNT) AS NAME_BADGE
FROM TRAINER;

-- Q31) trainer 테이블에서 achievement_level의 가장 첫 번째 알파벳만 조회하시오.

SELECT 
    LEFT(ACHIEVEMENT_LEVEL, 1) AS FIRST_CHAR
FROM TRAINER;

-- Q32) trainer 테이블에서 name을 모두 대문자로 조회하시오.

SELECT UPPER(name)
FROM trainer
;

-- Q33) trainer 테이블에서 achievement_level의 Expert를 Professional로 변경하시오.

SELECT 
    CASE 
        WHEN ACHIEVEMENT_LEVEL = 'Expert' THEN 'Professional'
        ELSE ACHIEVEMENT_LEVEL
    END AS ACHIEVEMENT_LEVEL
FROM TRAINER;

-- Q34) trainer 테이블에서 name의 문자의 길이를 조회하시오.

SELECT LENGTH(name)
FROM trainer;

-- Q35) battle 테이블에서 battle_date와 battle_date의 년, 월, 일을 조회하시오.

SELECT BATTLE_DATE,
		YEAR(BATTLE_DATE),
		MONTH(BATTLE_DATE),
		DAY(BATTLE_DATE)
FROM battle;

-- Q36) catch_date를 날짜형 데이터로 바꾸고 catch_ymd로 조회하시오.

SELECT CATCH_DATE AS CATCH_YMD
FROM TRAINER_POKEMON;

-- Q37) trainer_pokemon 테이블에서 catch_date을 YYYYMMDD 형태로 catch_ymd 컬럼명으로 조회하시오.

SELECT 
    DATE_FORMAT(CATCH_DATE, '%Y%m%d') AS CATCH_YMD
FROM TRAINER_POKEMON;

-- Q38) trainer_pokemon 테이블에서 catch_date과 catch_date 기준 1주일 후(after_1w), 1주일 전(before_1w)을 조회하시오.

SELECT 
    CATCH_DATE,
    DATE_ADD(CATCH_DATE, INTERVAL 1 WEEK) AS AFTER_1W,
    DATE_SUB(CATCH_DATE, INTERVAL 1 WEEK) AS BEFORE_1W
FROM TRAINER_POKEMON;

-- Q39) trainer_pokemon 테이블에서 catch_date과 현재 날짜 간의 차이를 조회하시오.
-- 현재 날짜 : CURRENT_DATE()

SELECT 
    CATCH_DATE,
    DATEDIFF(CURRENT_DATE(), CATCH_DATE) AS DATE_DIFF
FROM TRAINER_POKEMON;
