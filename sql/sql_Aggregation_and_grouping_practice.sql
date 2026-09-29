/*
order_stat 테이블을 사용하여 쇼핑몰의 전체 주문 건수와, 카테고리 정보가 누락되지 않은(NULL이 아닌)
주문건 수를 각각 조회해라.
컬럼의 별칭은 각각 '총 주문 건수', '카테고리 보유 건수'로 지정해라.
*/

USE my_shop;

SELECT
	COUNT(*) AS `총 주문 건수`,
    COUNT(category) AS `카테고리 보유 건수`
FROM order_stat;

/*
2. order_stat 테이블을 사용하여 우리 쇼핑몰의 총 매출액, 평균 주문 금액, 판매된 상품들의
최고 단가와 최저 단가를 한 번에 조회해라.
*/

SELECT
	SUM(price * quantity) AS `총 매출액`,
    AVG(price * quantity) AS `평균 주문 금액`,
    MAX(price) AS `최고 단가`,
    MIN(price) AS `최저 단가`
FROM order_stat;

/*
3. order_stat 테이블을 category 별로 그룹화하여, 각 카테고리별로
총 판매된 상품 수량(quantity의 합계)과 총 매출액을 계산하세요.
결과는 총 매출액이 높은 순서대로 정렬해야 한다.
*/

SELECT
	category,
    SUM(quantity) AS `카테고리별 총 판매 수량`,
    SUM(price * quantity) AS `카테고리별 총 매출액`
FROM order_stat
GROUP BY category
ORDER BY `카테고리별 총 매출액` DESC;

/*
4. order_stat 테이블을 사용하여 고객별로 총 주문 횟수와 총 구매한 상품의 수량을 계산해라.
결과는 주문 횟수가 많은 순으로, 주문 횟수가 같다면 총 구매 수량이 많은 순으로 정렬하시오.
*/

SELECT
	COUNT(*) AS `총 주문 횟수`,
    SUM(quantity) AS `총 구매 수량`
FROM order_stat
GROUP BY customer_name
ORDER BY COUNT(*) DESC, SUM(quantity) DESC;

/*
5. order_stat 테이블에서 고객별 총 구매 금액을 계산하고, 총 구매 금액이 40만 원 이상인
'VIP 고객' 목록만 조회하시오.
결과에는 고객 이름과 총 구매 금액이 포함되어야 하며, 총 구매 금액이 높은 순으로 정렬되어야 한다.
*/

SELECT
	customer_name,
    SUM(price * quantity) AS `총 구매 금액`
FROM order_stat
GROUP BY customer_name
HAVING SUM(price * quantity) >= 400000;

/*
6. order_stat 테이블에서 '도서' 카테고리를 제외한 주문들 중에서, 2회 이상 주문한 고객들을 찾아
그 고객들의 이름, 주문 횟수, 총 사용 금액을 조회하세요.
결과는 총 사용 금액이 높은 순으로 정렬되어야 한다.
*/

SELECT
	customer_name,
    COUNT(*) AS `주문 횟수`,
    SUM(price * quantity) AS `총 사용 금액`
FROM order_stat
WHERE category != '도서' AND category IS NOT NULL
GROUP BY customer_name
HAVING COUNT(*) >= 2
ORDER BY SUM(price * quantity) DESC;