-- subject_db 생성하기
CREATE DATABASE subject_db;

-- subject_db 선택하기
USE subject_db;

-- math 테이블 생성하기
CREATE TABLE math (
    student_id VARCHAR(10),
    math_score INT
);

-- math 테이블에 데이터 삽입하기
INSERT INTO math (student_id, math_score)
	VALUES ('A', 60),
		('B', 90),
		('C', 70),
		('D', 70),
		('E', 50);

-- english 테이블 생성하기
CREATE TABLE english (
    student_id VARCHAR(10),
    english_score INT
);

-- english 테이블에 데이터 삽입하기
INSERT INTO english (student_id, english_score)
	VALUES ('A', 100),
		('C', 30),
		('D', 80),
		('F', 80),
		('G', 60);
        
-- Q1) math 테이블의 모든 열을 조회하세요.

SELECT *
FROM math
;

-- Q2) english 테이블의 모든 열을 조회하세요.

SELECT *
FROM english
;

-- Q3) math 테이블과 english 테이블을 student_id를 기준으로 INNER JOIN하세요.

SELECT *
FROM math m
INNER JOIN english e
	ON m.student_id = e.student_id
;

-- Q4) math 테이블과 english 테이블을 student_id라는 공통된 컬럼을 기준으로 USING 절을 사용하여 INNER JOIN하세요.

SELECT *
FROM math
INNER JOIN english
	USING(student_id)
;

-- Q5) math 테이블과 english 테이블을 student_id를 기준으로 LEFT JOIN하세요.

SELECT *
FROM math m
LEFT JOIN english e
	ON m.student_id = e.student_id
;

-- Q6) math 테이블과 english 테이블을 student_id라는 공통된 컬럼을 기준으로 USING절을 사용하여 LEFT JOIN하세요.

SELECT *
FROM math
LEFT JOIN english
	USING(student_id)
;

-- Q7) math 테이블과 english 테이블을 student_id를 기준으로 RIGHT JOIN하세요.

SELECT *
FROM math m
RIGHT JOIN english e
	ON m.student_id = e.student_id
;

-- Q8) math 테이블과 english 테이블을 student_id라는 공통된 컬럼을 기준으로 USING절을 사용하여 RIGHT JOIN하세요.

SELECT *
FROM math
RIGHT JOIN english
	USING(student_id)
;

-- Q9) math 테이블과 english 테이블을 student_id를 기준으로 FULL OUTER JOIN하세요.
-- 힌트 : LEFT JOIN과 RIGHT JOIN을 각각 사용하고, UNION을 사용하여 중복된 데이터를 제거하세요.

SELECT *
FROM math m
LEFT JOIN english e
	ON m.student_id = e.student_id
UNION
SELECT *
FROM math m
RIGHT JOIN english e
	ON m.student_id = e.student_id
;

-- Q10) math 테이블과 english 테이블을 CROSS JOIN하여, 두 테이블의 모든 가능한 조합을 조회하세요.

SELECT *
FROM math m
CROSS JOIN english e
;

