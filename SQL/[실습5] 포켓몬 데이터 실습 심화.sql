-- pokemon_db 데이터베이스 선택하기
USE pokemon_db;

-- Q1) pokemon 테이블에서 첫 번째 타입(type1)의 범주의 종류를 구하시오.
SELECT DISTINCT type1
FROM pokemon;


-- Q2) pokemon 테이블에서 각 포켓몬의 첫 번째 타입(type1)별 공격력(attack)을 내림차순으로 정렬하고, 각 포켓몬에 대해 공격력 순위를 계산하여 attack_order 컬럼으로 표시하세요.
-- 힌트 : ROW_NUMBER()를 사용해보세요.

SELECT kor_name
	, type1
	, attack
	, ROW_NUMBER() OVER (
		PARTITION BY type1
        ORDER BY attack DESC
    ) AS attack_order
FROM pokemon
;

-- Q3) pokemon 테이블에서 각 포켓몬의 첫 번째 타입(type1)별 공격력(attack)을 내림차순으로 정렬하고, 각 포켓몬에 대해 공격력 순위를 계산하여 attack_order 컬럼으로 표시하세요.
-- 힌트 : RANK()를 사용해보세요.

SELECT kor_name
	, type1
	, attack
	, RANK() OVER(
		PARTITION BY type1
		ORDER BY attack DESC
		) AS attack_order
FROM pokemon
;

-- Q4) pokemon 테이블에서 각 포켓몬의 첫 번째 타입(type1)별 공격력(attack)을 내림차순으로 정렬하고, 각 포켓몬에 대해 공격력 순위를 계산하여 attack_order 컬럼으로 표시하세요.
-- 힌트 : DENSE_RANK()를 사용해보세요.

SELECT kor_name
	, type1
	, attack
	,DENSE_RANK() OVER(
		PARTITION BY type1
		ORDER BY attack DESC
		) AS attack_order
FROM pokemon
;

-- Q5) pokemon 테이블에서 각 포켓몬의 첫 번째 타입(type1)별 공격력(attack)을 내림차순으로 정렬하고, 각 포켓몬에 대해 공격력 순위를 백분율로 표시하여 attack_order_pct 컬럼으로 표시하세요.
-- 힌트 : PERCENT_RANK()를 사용해보세요.

SELECT kor_name
	, type1
	, attack
	,PERCENT_RANK()OVER(
	PARTITION BY type1
	ORDER BY attack DESC)
	AS attack_order_pct
FROM pokemon
;

-- Q6) pokemon 테이블에서 각 포켓몬의 첫 번째 타입(type1)을 기준으로 공격력(attack)을 내림차순으로 정렬하고, 각 포켓몬에 대해 공격력 순위를 계산합니다.
-- 그 후, 각 타입별로 공격력이 높은 Top3 포켓몬들을 출력하세요.

SELECT *
from
	(SELECT kor_name
		, type1
		, attack
		, ROW_NUMBER() OVER (
			PARTITION BY type1
	        ORDER BY attack DESC)
	        AS attack_rank
	FROM pokemon)p
WHERE attack_rank <=3
;

-- Q7) pokemon 테이블에서 각 포켓몬의 첫 번째 타입(type1)을 기준으로 **공격력(attack)**을 내림차순으로 정렬하고, 각 타입별로 포켓몬들을 4개의 그룹으로 나누어 공격력 순위를 계산하고, 그룹 번호를 attack_order 컬럼으로 조회하세요.
-- 힌트 : NTILE()을 사용해보세요.

SELECT type1
	, attack
	, NTILE(4) OVER (
	PARTITION BY type1
    ORDER BY attack DESC
	)AS attack_order
FROM pokemon
;

-- Q8) pokemon 테이블에서 각 포켓몬의 첫 번째 타입(type1)을 기준으로 공격력(attack)을 내림차순으로 정렬한 후,
-- 각 포켓몬에 대해 이전 포켓몬과 다음 포켓몬을 구하는 SQL 쿼리를 작성하세요.
-- 힌트 : LAG()와 LEAD()를 사용해보세요.

SELECT 
    kor_name,
    type1,
    attack,
    LAG(kor_name) OVER (ORDER BY attack DESC) AS prev_pokemon,
    LEAD(kor_name) OVER (ORDER BY attack DESC) AS next_pokemon
FROM pokemon
;

-- Q9) trainer_pokemon 테이블에서 location, level, avg_level_by_loc 컬럼을 조회하세요.
-- avg_level_by_loc 컬럼은 각 포켓몬이 잡힌 위치(location)를 기준으로 레벨(level)의 평균을 나타냅니다.

SELECT location
	,`level`
	, AVG(`level`)OVER(PARTITION BY location) AS avg_level_by_loc
FROM trainer_pokemon
;

-- Q10) trainer 테이블에서 각 트레이너의 업적 수준(achievement_level)을 기준으로 나이(age)를 내림차순으로 정렬하여, 각 업적 수준별로 나이 순위를 구한 후, 나이 순위가 3위 이하인 트레이너들의 이름, 나이, 성취 레벨, 순위를 출력하시오.

SELECT *
FROM (SELECT name
			, age
			, achievement_level
			, ROW_NUMBER() OVER(PARTITION BY achievement_level
								ORDER BY age DESC) AS age_rank
		FROM trainer) t
WHERE age_rank <= 3
;

/* Q11
trainer 테이블에서 선호하는 포켓몬 타입(prefer_type)에 따라 트레이너를 Offensive, Defensive, Balanced로 분류하고, Balanced 타입에 해당하는 트레이너들을 출력하세요.
단 다음 조건을 따릅니다. 
1. Electric 또는 Fire 타입을 선호하는 트레이너는 Offensive로 분류합니다.
2. Rock 또는 Water 타입을 선호하는 트레이너는 Defensive로 분류합니다.
3. 나머지 타입은 Balanced로 분류합니다.
이 문제는 공통 테이블 식(CTE)를 사용해보세요.
*/

WITH c AS (
    SELECT 
        name,
        prefer_type,
        CASE 
            WHEN prefer_type IN ('Electric', 'Fire') THEN 'Offensive'
            WHEN prefer_type IN ('Rock', 'Water') THEN 'Defensive'
            ELSE 'Balanced'
        END AS category
    FROM trainer
)
SELECT 
   *
FROM c
WHERE category = 'Balanced';

/* Q12
pokemon 테이블에서 풀(Grass) 타입과 벌레(Bug) 타입의 포켓몬들을 각각 필터하여 별도의 테이블(각각 grass_pkm, bug_pkm)로 저장하고, 벌레(Bug) 타입 포켓몬들만 조회하세요.
*/

CREATE TABLE grass_pkm AS
SELECT * FROM pokemon
WHERE type1 = 'Grass'
;

CREATE TABLE bug_pkm AS
SELECT * FROM pokemon
WHERE type1 = 'Bug'
;

SELECT * FROM bug_pkm;

-- Q13) trainer_pokemon과 trainer 테이블을 INNER JOIN하여, 각 트레이너의 포켓몬 데이터를 출력하세요.

SELECT *
FROM trainer t
	INNER JOIN trainer_pokemon tp
		ON t.id = tp.trainer_id;

-- Q14) trainer_pokemon과 trainer 테이블을 INNER JOIN하여, 각 트레이너의 ID, 포켓몬 레벨, 그리고 트레이너 이름을 조회하세요.

SELECT t.id
	, tp.level
	, t.name
FROM trainer t
	INNER JOIN trainer_pokemon tp
		ON t.id = tp.trainer_id
;
-- Q15) trainer_pokemon과 trainer 테이블을 LEFT JOIN하여, 모든 데이터를 조회하세요.

SELECT *
FROM trainer t
	LEFT JOIN trainer_pokemon tp
		ON t.id = tp.trainer_id
;

-- Q16) trainer 테이블과 trainer_pokemon 테이블을 LEFT JOIN하여, 업적 수준(achievement_level) 별로 트레이너 수를 계산하세요.

SELECT t.achievement_level
	, COUNT(DISTINCT t.id) AS trainer_count
FROM trainer t
	LEFT JOIN trainer_pokemon tp
		ON t.id = tp.trainer_id
GROUP BY t.achievement_level
;

-- Q17) 2024년 2월에 잡힌 포켓몬의 이름(kor_name)과 타입(type1)을 출력하세요.

SELECT p.kor_name
	,p.type1
	,tp.catch_date
FROM pokemon p
	LEFT JOIN trainer_pokemon tp
		ON p.id = tp.pokemon_id
WHERE tp.catch_date BETWEEN '2024-02-01' AND '2024-02-29'
;


-- Q18) battle 테이블과 trainer 테이블을 결합하여, 승리가 가장 많은 지역을 찾으세요.

SELECT 
    t.hometown, 
    COUNT(b.winner_id) AS win_count
FROM trainer t
	INNER JOIN battle b 
	    ON t.id = b.winner_id
GROUP BY t.hometown
ORDER BY win_count DESC
LIMIT 1;

-- Q19) trainer_pokemon, trainer, pokemon 테이블을 결합하여, 전설의 포켓몬을 가진 트레이너 이름과 그 트레이너가 가진 전설의 포켓몬 이름을 출력하세요.

SELECT T.NAME
	, P.KOR_NAME
	, P.ENG_NAME
FROM TRAINER_POKEMON TP
	LEFT JOIN TRAINER T 
		ON TP.TRAINER_ID = T.ID
	LEFT JOIN POKEMON P
		ON TP.POKEMON_ID = P.ID
WHERE P.IS_LEGENDARY = 'True'
;


-- Q20) pokemon 테이블과 trainer 테이블을 CROSS JOIN하여 모든 트레이너와 포켓몬의 조합을 출력하세요.

SELECT *
FROM pokemon p
	CROSS JOIN trainer t
;

-- Q21) battle 테이블과 trainer 테이블을 결합하여 LEFT JOIN과 RIGHT JOIN을 이용하여, 모든 전투 기록과 트레이너 이름을 출력하세요.

SELECT b.battle_date
	, t.name
FROM battle b
	LEFT JOIN trainer t
		ON b.winner_id = t.id
;

SELECT b.battle_date
	, t.name
FROM battle b
	RIGHT JOIN trainer t
		ON b.winner_id = t.id
;

/* Q22)
두 개의 battle 테이블에서 각각의 전투 기록을 합쳐서 출력하는 하나의 SQL 쿼리를 작성하세요.
첫번째 battle 테이블 : 전투 기록이 id 기준으로 15보다 작거나 같은 경우
두번째 battle 테이블 : 전투 기록이 id 기준으로 15 이상 30 이하인 경우
*/

SELECT *
FROM battle
WHERE id <= 15

UNION

SELECT *
FROM battle
WHERE id >= 15 AND id <= 30;

/* Q23
trainer 테이블에서 성취도(achievement_level)가 Beginner와 Master인 경우에 대해 각각 로 연장자(age) 3명을 선택하여 UNION을 사용하여 하나의 쿼리로 작성하세요.
가이드 :
1. 성취도가 Beginner인 경우 연장자 3명을 선택하는 테이블을 생성하세요.
2. 성취도가 Master인 경우 연장자 3명을 선택하는 테이블을 생성하세요.
3. 위 두 테이블을 UNION을 사용하여 합치세요.
*/
(SELECT *
 FROM trainer
 WHERE achievement_level = 'Beginner'
 ORDER BY age DESC
 LIMIT 3)
 
UNION

(SELECT *
 FROM trainer
 WHERE achievement_level = 'Master'
 ORDER BY age DESC
 LIMIT 3)
 ;
-- Q24. 트레이너의 고향(hometown)이 서울(Seoul)인 경우 '수도권', 아니면 '타지역'으로 구분하여 hometown_status라는 별칭으로 출력하세요.

SELECT name
	,IF (hometown = 'Seoul','수도권','타지역') AS hometown_status
FROM trainer
;

-- Q25. 트레이너의 고향(hometown)이 서울(Seoul) 또는 인천(Incheon)인 경우 '수도권', 아니면 '타지역'으로 구분하여 hometown_status라는 별칭으로 출력하세요.

SELECT name
     , CASE 
         WHEN hometown IN ('Seoul', 'Incheon') THEN '수도권'
         ELSE '타지역'
       END AS hometown_status
FROM trainer
;

-- Q26. 트레이너의 고향(hometown)이 서울(Seoul)이고, 나이(age)가 30 이상인 경우 '수도권', 그 외에는 '타지역'으로 구분하여 hometown_status라는 별칭으로 출력하세요.

SELECT name
     , CASE 
         WHEN hometown = 'Seoul' AND age >= 30 THEN '수도권'
         ELSE '타지역'
       END AS hometown_status
FROM trainer;

/* Q27.
포켓몬의 레벨(level)에 따라 Low, Medium, High로 구분하여 level_category로 조회하세요.
20 미만은 'Low'
20 이상 50 미만은 'Medium'
50 이상은 'High'
*/

SELECT p.id
	, p.kor_name
	, p.eng_name
	, tp.level
FROM pokemon p
	LEFT JOIN trainer_pokemon tp
		ON p.id = tp.pokemon_id
;
SELECT *
FROM trainer_pokemon tp;

/* Q28.
트레이너의 뱃지 개수(badge_count)에 따라 Bronze, Silver, Gold로 구분하여 badge_category로 조회하세요.
- 5 미만은 'Bronze'
- 5 이상 8 미만은 'Silver'
- 8 이상은 'Gold'
*/

SELECT *
     , CASE 
         WHEN badge_count < 5 THEN 'Bronze'
         WHEN badge_count >= 5 AND badge_count < 8 THEN 'Silver'
         ELSE 'Gold'
       END AS badge_category
FROM trainer;

/* Q29.
트레이너의 선호 타입(prefer_type)에 따라 Offensive, Defensive, Balanced로 구분하여 type_category로 조회하세요.
- Electric 또는 Fire는 'Offensive'
- Rock 또는 Water는 'Defensive'
- 그 외는 'Balanced'
*/

SELECT *
	, CASE
		WHEN prefer_type IN ('Electric', 'Fire')THEN 'Offensive'
		WHEN prefer_type IN ('Rock', 'Water') THEN 'Defensive'
		ELSE 'Balanced'
	END AS type_category
FROM trainer
;

