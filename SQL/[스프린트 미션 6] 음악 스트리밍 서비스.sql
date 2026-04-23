-- 파트1. 데이터 파악하기

-- 어떤 테이블과 컬럼들이 있는지 간단하게 기본 구조를 확인해 봅시다. 그리고 각 테이블에 어떤 형태로 데이터가 들어가 있는지도 확인해 보세요.
USE music;

/*1-1. 존재하는 테이블의 목록과, 각 테이블의 컬럼 정보를 각각 확인해 보세요.
테이블의 목록은 SHOW TABLES; 구문으로, 테이블의 컬럼 정보는 DESCRIBE 테이블_이름; 구문으로 확인할 수 있어요.
*/
SHOW tables;
DESCRIBE albums;
DESCRIBE artists;
DESCRIBE history;
DESCRIBE playlists;
DESCRIBE songs;
DESCRIBE users;
-- 1-2. 사용자 목록, 아티스트 목록을 각각 확인해 보세요.
SELECT * FROM users;
SELECT * FROM artists;
-- 1-3. 궁금한 아티스트를 한 명 골라 모든 앨범 목록을 확인해 보세요.
SELECT a.id
	, a.name
	, ab.title
FROM artists a
	LEFT JOIN albums ab
		ON a.id = ab.artist_id
WHERE a.id = 143
;

-- 1-4. 사용자를 한 명 골라 가장 최근에 재생한 20곡을 재생 시점 순으로 확인해 보세요. (재생 시점, 사용자 ID, 사용자 계정명, 곡 ID, 곡 제목, 곡 재생 시간(초)를 조회해보세요.)

SELECT h.played_at
	, u.id
	, u.username
	, s.id
	, s.title
	, s.duration_seconds
FROM history h
	LEFT JOIN users u
		ON h.user_id = u.id
	LEFT JOIN songs s
		ON h.song_id = s.id
WHERE u.id = 4
ORDER BY h.played_at DESC LIMIT 20
;

-- 강사님 쿼리
SELECT h.played_at
	, h.user_id
    , u.username
    , h.song_id
    , s.title AS song_title
    , s.duration_seconds
FROM history h
INNER JOIN users u ON h.user_id = u.id
INNER JOIN songs s ON h.song_id = s.id
WHERE h.user_id = 1
ORDER BY h.played_at DESC
LIMIT 20
;



-- 파트2. 2024년의 음악

/* 음악계에는 매년 다양한 일들이 벌어집니다. 기대를 모았던 아티스트가 새 앨범을 발표하기도 하고, 예상치 못한 신인이 차트를 휩쓸기도 하죠. 2024년의 음악 데이터를 분석해, 
 * 그 해에 발매된 앨범과 아티스트들의 활동을 살펴보고 가장 많이 재생된 곡과 아티스트를 확인해 봅시다.
 */

-- 2-1. 2024년에 발매된 모든 앨범을 확인해 보세요. (앨범의 ID, 앨범 제목, 앨범 발매일, 아티스트 이름을 조회해 보세요. 발매순으로 정렬하고 발매일이 같을 경우 앨범의 ID 순으로 정렬하세요.)

SELECT a.id
	, a.title
	, a.release_date
	, art.name
FROM albums a
	LEFT JOIN artists art
		ON a.artist_id = art.id
WHERE YEAR(a.release_date) = 2024
ORDER BY a.release_date DESC, a.id ASC
;

-- 강사님 쿼리

SELECT al.id AS album_id
	, al.title AS album_title
    , al.release_date
    , ar.name AS artist_name
FROM albums al
INNER JOIN artists ar ON al.artist_id = ar.id
WHERE al.release_date >= '2024-01-01'
	AND al.release_date < '2025-01-01'
ORDER BY al.release_date, al.id
;

/* 2-2. 2024년에 앨범을 발매한 아티스트의 목록을 앨범을 많이 발매한 순서대로 확인해 보세요. 
(아티스트 ID, 아티스트 이름, 발매한 앨범의 수를 조회하고, 앨범의 수가 많은 것부터 정렬하되 앨범의 수가 같을 경우 아티스트의 이름 순으로 정렬하세요.)
*/

SELECT alb.artist_id
	, a.name
	, COUNT(alb.id) AS alb_count
FROM artists a
	LEFT JOIN albums alb
		ON a.id = alb.artist_id
WHERE YEAR(alb.release_date) = 2024
GROUP BY a.id , a.name
ORDER BY alb_count DESC, a.name ASC
;

-- 강사님 쿼리

SELECT al.artist_id
	, ar.name
    , COUNT(al.id) AS albums_count
FROM albums al
INNER JOIN artists ar ON al.artist_id = ar.id
WHERE al.release_date >= '2024-01-01'
	AND al.release_date < '2025-01-01'
GROUP BY al.artist_id, ar.name
ORDER BY COUNT(al.id) DESC, ar.name
;


-- 2-3. 2024년에 가장 많이 재생된 20곡을 많이 재생된 순서대로 확인해 보세요. (곡의 ID, 곡 제목, 재생 수를 조회하고, 재생 수가 같을 경우 곡 제목 순으로 정렬하세요.)

SELECT s.id
	, s.title
	, COUNT(h.id) AS h_count
FROM songs s
	LEFT JOIN history h
		ON s.id = h.song_id
WHERE YEAR(h.played_at) = 2024
GROUP BY s.id, s.title
ORDER BY h_count DESC, s.title ASC
LIMIT 20
;

-- 강사님 쿼리

SELECT h.song_id
	, s.title AS song_title
    , COUNT(h.id) AS played_count
FROM history h
INNER JOIN songs s ON h.song_id = s.id
WHERE h.played_at >= '2024-01-01'
	AND h.played_at < '2025-01-01'
GROUP BY h.song_id, s.title
ORDER BY COUNT(h.id) DESC, s.title
LIMIT 20
;

-- 2-4. 2024년에 가장 많이 재생된 20명의 아티스트를 많이 재생된 순서대로 확인해 보세요. (아티스트의 ID, 아티스트 이름, 재생 수를 조회하고, 재생 수가 같은 경우 아티스트의 이름 순으로 정렬하세요.)

SELECT a.id
	, a.name
	, COUNT(h.id) AS play_count
FROM artists a
	LEFT JOIN albums alb
		ON a.id = alb.artist_id
	LEFT JOIN songs s
		ON alb.id = s.album_id
	LEFT JOIN history h
		ON s.id = h.song_id
WHERE YEAR(h.played_at) = 2024
GROUP BY a.id, a.name
ORDER BY play_count DESC, a.name ASC
LIMIT 20;

-- 강사님 쿼리

SELECT al.artist_id
	, ar.name AS artist_name
    , COUNT(h.id) AS played_count
FROM history h
INNER JOIN songs s ON h.song_id = s.id
INNER JOIN albums al ON s.album_id = al.id
INNER JOIN artists ar ON al.artist_id = ar.id
WHERE h.played_at >= '2024-01-01'
	AND h.played_at < '2025-01-01'
GROUP BY al.artist_id, ar.name
ORDER BY COUNT(h.id) DESC, ar.name
LIMIT 20
;


-- 파트3. 내가 2024년에 들은 음악

/*한 해 동안 우리는 수많은 음악을 듣습니다. 어떤 날은 같은 곡을 반복해서 듣고, 또 어떤 날은 새로운 아티스트를 발견하기도 하죠. 
재생 기록을 살펴보면 내가 어떤 음악 혹은 어떤 아티스트를 많이 감상했는지, 그리고 한 달 중 언제 음악을 가장 많이 들었는지 알 수 있습니다. 
자유롭게 사용자를 골라 음악 감상 기록을 분석해 한 해 동안의 음악 활동을 다양한 데이터로 확인해 봅시다.
*/

-- 3-1. 특정 사용자가 2024년에 재생한 곡 중에서 가장 최근에 재생한 100곡을 재생 시점 순으로 정렬하여 확인해 보세요. (사용자 ID, 사용자 계정명, 재생 시점, 곡 제목, 앨범 제목, 아티스트 이름을 조회하세요.)

SELECT u.id
	, u.username
	, h.played_at
	, s.title
	, a.title
	, art.name
FROM users u
	LEFT JOIN history h
		ON u.id = h.user_id
	LEFT JOIN songs s
		ON h.song_id = s.id
	LEFT JOIN albums a
		ON s.album_id = a.id
	LEFT JOIN artists art
		ON a.artist_id = art.id
WHERE u.id = 4 AND YEAR(h.played_at) = 2024
ORDER BY h.played_at DESC
LIMIT 100;


-- 강사님 쿼리

SELECT h.user_id
	, u.username
    , h.played_at
    , s.title AS song_title
    , al.title AS album_title
    , ar.name AS artist_name
FROM history h
INNER JOIN users u ON h.user_id = u.id
INNER JOIN songs s ON h.song_id = s.id
INNER JOIN albums al ON s.album_id = al.id
INNER JOIN artists ar ON al.artist_id = ar.id
WHERE h.played_at >= '2024-01-01'
	AND h.played_at < '2025-01-01'
    AND h.user_id = 1
ORDER BY h.played_at DESC
LIMIT 100
;
		
-- 3-2. 특정 사용자가 2024년에 많이 들은 20곡을 많이 들은 순서대로 확인해 보세요. (곡의 ID, 곡 제목, 재생 수를 조회하시오. 재생 수가 같은 경우 곡 제목 순으로 정렬하세요.)

SELECT s.id
	, s.title
	, COUNT(s.id) AS song_count
FROM users u
	LEFT JOIN history h 
		ON u.id = h.user_id
	LEFT JOIN songs s
		ON h.song_id = s.id
WHERE u.id = 5 AND YEAR(h.played_at) = 2024
GROUP BY s.id, s.title
ORDER BY song_count DESC, s.title ASC
LIMIT 20
;

-- 강사님 쿼리

SELECT h.song_id
	, s.title AS song_title
    , COUNT(h.id) AS played_count
FROM history h
INNER JOIN songs s ON h.song_id = s.id
WHERE h.played_at >= '2024-01-01'
	AND h.played_at < '2025-01-01'
    AND h.user_id = 1
GROUP BY h.song_id, s.title
ORDER BY COUNT(h.id) DESC, s.title
LIMIT 20
;


-- 3-3. 특정 사용자가 2024년에 많이 들은 20명의 아티스트를 많이 들은 순서대로 확인해 보세요. (아티스트의 ID, 아티스트 이름, 재생 수를 조회하고, 재생 수가 같은 경우 아티스트의 이름 순으로 정렬하세요.)

SELECT art.id
	, art.name
	, COUNT(h.id) AS play_count
FROM users u
	LEFT JOIN history h
		ON u.id = h.user_id
	LEFT JOIN songs s
		ON h.song_id = s.id
	LEFT JOIN albums a
		ON s.album_id = a.id
	LEFT JOIN artists art
		ON a.artist_id = art.id
WHERE u.id = 6 AND YEAR(h.played_at) = 2024
GROUP BY art.id, art.name
ORDER BY play_count DESC, art.name ASC
LIMIT 20
;

-- 강사님 쿼리

SELECT ar.id AS artist_id
	, ar.name AS artist_name
    , COUNT(h.id) AS played_count
FROM history h
INNER JOIN songs s ON h.song_id = s.id
INNER JOIN albums al ON s.album_id = al.id
INNER JOIN artists ar ON al.artist_id = ar.id
WHERE h.played_at >= '2024-01-01'
	AND h.played_at < '2025-01-01'
    AND h.user_id = 1
GROUP BY ar.id, ar.name
ORDER BY COUNT(h.id) DESC, ar.name
LIMIT 20
;

-- 3-4. 특정 사용자의 2024년 월별 음악 감상 횟수를 확인해 보세요.

SELECT MONTH(h.played_at) AS month
     , COUNT(h.id) AS play_count
FROM users u
	LEFT JOIN history h
		ON u.id = h.user_id
WHERE u.id = 6 AND YEAR(h.played_at) = 2024
GROUP BY MONTH(h.played_at)
ORDER BY month ASC
;

-- 강사님 쿼리

SELECT MONTH(played_at) AS played_month
	, COUNT(id) AS played_count
FROM history
WHERE user_id = 1
	AND played_at >= '2024-01-01'
    AND played_at < '2025-01-01'
GROUP BY MONTH(played_at)
ORDER BY MONTH(played_at)
;

-- 3-5. 특정 사용자가 2024년 재생한 곡들의 총 재생 시간을 확인해 보세요.
SELECT u.id AS user_id
     , u.username
     , SUM(s.duration_seconds) AS total_duration_seconds
FROM users u
	LEFT JOIN history h 
		ON u.id = h.user_id
	LEFT JOIN songs s 
		ON h.song_id = s.id
WHERE u.id = 1 AND YEAR(h.played_at) = 2024
GROUP BY u.id, u.username
;

-- 강사님 쿼리

SELECT SUM(duration_seconds) AS total_duration_seconds
FROM history h
INNER JOIN songs s ON h.song_id = s.id
WHERE user_id = 1
	AND played_at >= '2024-01-01'
    AND played_at < '2025-01-01'
;

-- 3-6. 특정 사용자가 2024년에 새롭게 발견한 아티스트 목록을 확인해 보세요. 
SELECT art.id
	, art.name
FROM artists art
	LEFT JOIN albums alb 
		ON art.id = alb.artist_id
	LEFT JOIN songs s 
		ON alb.id = s.album_id
	LEFT JOIN history h 
		ON s.id = h.song_id
WHERE h.user_id = 6 AND YEAR(h.played_at) = 2024
EXCEPT
SELECT art.id
	, art.name
FROM artists art
	LEFT JOIN albums alb 
		ON art.id = alb.artist_id
	LEFT JOIN songs s 
		ON alb.id = s.album_id
	LEFT JOIN history h 
		ON s.id = h.song_id
WHERE h.user_id = 6 AND YEAR(h.played_at) < 2024
;

-- 강사님 코드
SELECT ar.id
	, ar.name
FROM history h
INNER JOIN songs s ON h.song_id = s.id
INNER JOIN albums al ON s.album_id = al.id
INNER JOIN artists ar ON al.artist_id = ar.id
WHERE h.user_id = 1
GROUP BY ar.id, ar.name
HAVING MIN(h.played_at) >= '2024-01-01'
	AND MIN(h.played_at) < '2025-01-01'
ORDER BY ar.name
;
-- 파트4. 나의 음악 감상 패턴 발견하기

/*이제 기본적인 음악 감상 정보를 넘어, 더 깊이 있는 패턴을 살펴볼 차례입니다. 
 * 특정 사용자가 올해 새롭게 발견한 아티스트는 누구인지, 내가 자주 듣지만 다른 사람들은 잘 듣지 않는 곡이 있는지, 혹은 요일별 및 시간대별 음악 감상 패턴이 어떻게 다른지 등을 분석해 봅시다.
 */

-- 4-1. 특정 사용자가 2024년에 특정 아티스트의 곡을 들은 사용자들 중에서 감상 횟수 기준으로 상위 몇 퍼센트(%)에 속하는지 확인해 보세요.

WITH UserPlayCounts AS (
    SELECT h.user_id,
           COUNT(h.id) AS play_count,
           PERCENT_RANK() OVER (ORDER BY COUNT(h.id) DESC) AS rank_percent
    FROM history h
    	LEFT JOIN songs s 
    		ON h.song_id = s.id
	    LEFT JOIN albums alb 
	    	ON s.album_id = alb.id
    WHERE alb.artist_id = 1
      AND YEAR(h.played_at) = 2024
    GROUP BY h.user_id
)
SELECT user_id, 
       play_count, 
       ROUND(rank_percent, 2) AS top_percentile
FROM UserPlayCounts
WHERE user_id = 6;


-- 강사님 쿼리

WITH artist_listens AS (
	SELECT h.user_id
		, COUNT(h.id) AS played_count
		, PERCENT_RANK() OVER(ORDER BY COUNT(h.id) DESC) AS pct_rnk
	FROM history h
	INNER JOIN songs s ON h.song_id = s.id
	INNER JOIN albums al ON s.album_id = al.id
	WHERE h.played_at >= '2024-01-01'
		AND h.played_at < '2025-01-01'
		AND al.artist_id = 20
	GROUP BY h.user_id)
SELECT *
FROM artist_listens
WHERE user_id = 1
;

-- 4-2. 특정 사용자가 들은 곡 중 다른 사용자들은 많이 듣지 않는 곡을 찾아보세요. (특정 사용자의 감상 횟수와 전체 사용자들의 평균 감상 횟수를 비교)

WITH UserSongCounts AS (
    SELECT song_id
    	, COUNT(id) AS user_count
    FROM history
    WHERE user_id = 1
    GROUP BY song_id
),
AvgSongCounts AS (
    SELECT song_id
    	, COUNT(id) / COUNT(DISTINCT user_id) AS avg_count
    FROM history
    GROUP BY song_id
)
SELECT s.title AS song_title
     , usc.user_count
     , ROUND(ascnt.avg_count, 2) AS avg_count
FROM UserSongCounts usc
	LEFT JOIN AvgSongCounts ascnt 
		ON usc.song_id = ascnt.song_id
	LEFT JOIN songs s 
		ON usc.song_id = s.id
WHERE usc.user_count > ascnt.avg_count
ORDER BY (usc.user_count - ascnt.avg_count) DESC;


-- 강사님 코드
WITH single_history AS (
SELECT song_id
	, COUNT(id) AS one_played_count
FROM history
WHERE user_id = 1
GROUP BY song_id
),
others_history AS (
SELECT song_id
	, AVG(other_played_count) AS avg_played_count
FROM (
SELECT user_id
	, song_id
	, COUNT(id) AS other_played_count
FROM history
WHERE user_id != 1
GROUP BY user_id, song_id) t
GROUP BY song_id
)
SELECT sh.song_id
	, sh.one_played_count
	, oh.avg_played_count
FROM single_history sh
	LEFT JOIN others_history oh
		ON sh.song_id = oh.song_id
WHERE sh.one_played_count > IFNULL(oh.avg_played_count,0)
ORDER BY sh.one_played_count - IFNULL(oh.avg_played_count,0) DESC
;


-- 4-3. 특정 사용자의 요일별 음악 재생 비율을 확인해 보세요.

WITH UserWeeklyPlay AS (
    SELECT DAYNAME(played_at) AS day_of_week
         , COUNT(id) AS play_count
    FROM history
    WHERE user_id = 6  
    GROUP BY DAYNAME(played_at)
),
TotalPlay AS (
    SELECT COUNT(id) AS total_count
    FROM history
    WHERE user_id = 6
)
SELECT day_of_week
     , play_count
     , ROUND((play_count / t.total_count) * 100, 2) AS percentage
FROM UserWeeklyPlay uwp, TotalPlay t
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 강사님 쿼리

SELECT DAYNAME(played_at) AS day_name
-- 	, COUNT(id) AS played_count
--  , SUM(COUNT(id)) OVER() AS total_played_count
    , ROUND(COUNT(id) / SUM(COUNT(id)) OVER() * 100, 1) AS played_ratio
FROM history
WHERE user_id = 1
GROUP BY DAYNAME(played_at)
ORDER BY FIELD(day_name
				, 'Monday'
				, 'Tuesday'
				, 'Wednesday'
				, 'Thursday'
				, 'Friday'
				, 'Saturday'
				, 'Sunday')
;



-- 4-4. 특정 사용자의 시간대별 음악 재생 비율을 확인해 보세요.

WITH UserHourlyPlay AS (
    SELECT HOUR(played_at) AS play_hour
         , COUNT(id) AS play_count
    FROM history
    WHERE user_id = 6
    GROUP BY HOUR(played_at)
),
TotalPlay AS (
    SELECT COUNT(id) AS total_count
    FROM history
    WHERE user_id = 6
)
SELECT play_hour
     , play_count
     , ROUND((play_count / t.total_count) * 100, 2) AS percentage
FROM UserHourlyPlay uhp, TotalPlay t
ORDER BY play_hour ASC;

-- 강사님 쿼리

SELECT CASE WHEN HOUR(played_at) BETWEEN 6 AND 11 THEN 'morning'
		WHEN HOUR(played_at) BETWEEN 12 AND 17 THEN 'afternoon'
        WHEN HOUR(played_at) BETWEEN 18 AND 23 THEN 'evening'
        ELSE 'night' END AS time_period
-- 	, COUNT(id) AS played_count
--  , SUM(COUNT(id)) OVER() AS total_played_count
    , ROUND(COUNT(id) / SUM(COUNT(id)) OVER() * 100, 1) AS played_ratio
FROM history
WHERE user_id = 1
GROUP BY time_period
ORDER BY FIELD(time_period
				, 'morning'
				, 'afternoon'
				, 'evening'
				, 'night')
;
