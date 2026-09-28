USE my_shop;

CREATE TABLE order_stat (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    category VARCHAR(50),
    product_name VARCHAR(100),
    price INT,
    quantity INT,
    order_date DATE
);

INSERT INTO order_stat (customer_name, category, product_name, price, quantity, order_date)
VALUES
('이순신', '전자기기', '프리미엄 기계식 키보드', 150000, 1, '2025-05-10'),
('세종대왕', '도서', 'SQL 마스터링', 35000, 2, '2025-05-10'),
('신사임당', '가구', '인체공학 사무용 의자', 250000, 1, '2025-05-11'),
('이순신', '전자기기', '고성능 게이밍 마우스', 80000, 1, '2025-05-12'),
('세종대왕', '전자기기', '4K 모니터', 450000, 1, '2025-05-12'),
('장영실', '도서', '파이썬 데이터 분석', 40000, 3, '2025-05-13'),
('이순신', '문구', '고급 만년필 세트', 200000, 1, '2025-05-14'),
('세종대왕', '가구', '높이조절 스탠딩 데스크', 320000, 1, '2025-05-15'),
('신사임당', '전자기기', '노이즈캔슬링 블루투스 이어폰', 180000, 1, '2025-05-15'),
('장영실', '전자기기', '보조배터리 20000mAh', 50000, 2, '2025-05-16'),
('홍길동', NULL, 'USB-C 허브', 65000, 1, '2025-05-17'); -- 카테고리가 NULL인 데이터 추가

SELECT
	*
FROM
	order_stat;

SELECT
	COUNT(*)
FROM
	order_stat; -- 총 주문 건수 파악. COUNT(*)은 행이 몇개인지를 세는 함수.

SELECT COUNT(category)
FROM order_stat;

SELECT COUNT(*)
FROM order_stat
WHERE category IS NOT NULL;

SELECT
	COUNT(*) AS `전체 주문 건수`,
    COUNT(category) AS `카테고리 등록 건수`
FROM
	order_stat;

SELECT
	SUM(price * quantity) AS `총 매출액`,
    AVG(price * quantity) AS `평균 주문 금액`
FROM
	order_stat;

SELECT SUM(quantity)
FROM order_stat;

SELECT
	SUM(quantity) AS `총 판매 수량`,
    AVG(quantity) AS `주문당 평균 수량`
FROM
	order_stat;

SELECT
	MAX(price) AS 최고가,
    MIN(price) AS 최저가
FROM
	order_stat;

SELECT
	MAX(order_date) AS `최초 주문일`,
    MIN(order_date) AS `최근 주문일`
FROM
	order_stat;

SELECT
	COUNT(DISTINCT customer_name)
FROM
	order_stat;

SELECT
	COUNT(customer_name) AS `총 주문 건수`,
    COUNT(DISTINCT customer_name) AS `중복이 제외된 건수`
FROM
	order_stat;

SELECT
	category,
    count(*) as `카테고리별 주문 건수`
FROM
	order_stat
GROUP BY
	category;

SELECT
	customer_name,
    COUNT(*) as `고객별 주문 건수`
FROM
	order_stat
GROUP BY
	customer_name;

SELECT
	customer_name,
    COUNT(*) as `총 주문 횟수`,
    SUM(quantity) AS `총 구매 수량`,
    SUM(price * quantity) AS `총 구매 금액`
FROM
	order_stat
GROUP BY
	customer_name
ORDER BY
	`총 구매 금액` DESC;

-- 백틱을 쓰면 컬럼으로 인식하는데 ' '은 문자로 인식.

SELECT
	customer_name,
    category,
    sum(price * quantity) AS `카테고리별 구매 금액`
FROM
	order_stat
GROUP BY
	customer_name, category
ORDER BY
	customer_name, `카테고리별 구매 금액` DESC;

SELECT
	category,
    -- product_name
    count(*)
FROM
	order_stat
GROUP BY
	category;

SELECT
	category,
    SUM(price * quantity) AS total_sales
FROM
	order_stat
GROUP BY
	category;

SELECT
	category,
    SUM(price * quantity) AS total_sales
FROM
	order_stat
WHERE
SUM(price * quantity) >= 500000
GROUP BY
	category; -- SUM(price * quantity) 이미 한 뭉탱이로 합쳐진값으로 그룹핑을 한다? 말이 안된다.

SELECT
	category,
    SUM(price * quantity) AS total_sales
FROM
	order_stat
WHERE category IS NOT NULL
GROUP BY category;

SELECT
	category,
    SUM(price * quantity) AS total_sales
FROM
	order_stat
GROUP BY category
HAVING SUM(price * quantity) >= 500000;

SELECT
	category,
    SUM(price * quantity) AS total_sales
FROM
	order_stat
GROUP BY category;

SELECT
	category,
    SUM(price * quantity) AS total_sales
FROM
	order_stat
GROUP BY
	category
HAVING
	total_sales >= 500000; -- having 다음 select절이 실행되는거라 total_sales는 다른 DBMS에선 못씀.

SELECT
	customer_name,
    COUNT(*) AS `주문 횟수`
FROM
	order_stat
GROUP BY
	customer_name
HAVING COUNT(*) >= 3;

/*
10만원 이상인 고가 상품들 중에서 카테고리 별로 묶어서
그 고가 상품이 2건 이상 팔린 카테고리는 어디인가?
*/

SELECT
	category,
    COUNT(*) AS `premium_order_count`
FROM
	order_stat
WHERE price >= 100000
GROUP BY category
HAVING COUNT(*) >= 2;

/*
고객별 총 구매 금액을 구하고, 총 구매 금액이 40만원 이상인 고객 조회
*/

SELECT
	customer_name AS 고객명,
    SUM(price * quantity) AS `총 구매 금액`
FROM
	order_stat
GROUP BY
		customer_name
HAVING SUM(price * quantity) >= 400000;

SELECT *
FROM order_stat;

/*
2025년 5월 14일 이전에 들어온 주문들중에서 고객별로 그룹화하여 주문 건수가 2회 이상인 고객을
찾아서 해당 고객의 이름과 총 구매 금액을 조회하고 총 구매 금액을 기준으로 내림차순으로 정렬해라.
*/

SELECT
	customer_name AS 이름,
    SUM(price * quantity) AS `총 구매 금액`
FROM order_stat
WHERE order_date < '2025-05-14'
GROUP BY customer_name
HAVING COUNT(*) >= 2
ORDER BY `총 구매 금액` DESC LIMIT 1;