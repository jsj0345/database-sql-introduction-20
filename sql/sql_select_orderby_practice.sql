/*
1. products 테이블에 있는 모든 상품의 이름과 가격 정보를 조회하시오.
단, 조회결과의 열이름은 각각 '상품명'과 '판매가'로 표시되어야 한다.
*/

USE my_shop;

SELECT name AS `상품명`,
price AS `판매가`
FROM products;

/*
2. customers 테이블에서 '장영실' 고객의 모든 정보를 조회하시오.
*/

SELECT *
FROM customers
WHERE name = '장영실';

/*
3. products 테이블에서 가격이 10000원 이상이면서,
동시에 재고가 50개 미만인 상품을 조회하시오.
*/

SELECT *
FROM products
WHERE price >= 10000 AND
stock_quantity < 50;

/*
4. products 테이블에서 product_id가 2번, 3번, 4번 중 하나에
해당하는 상품들의 이름과 가격을 조회하시오.
*/

SELECT name, price
FROM products
WHERE product_id IN (2, 3, 4);

/*
5. customers 테이블에서 주소가 '서울특별시'로 시작하는
고객의 이름과 전체 주소를 조회해라.
*/

SELECT *
FROM customers
WHERE address LIKE '서울특별시%';

/*
6. products 테이블에서 상품 설명(description)이 아직 입력되지 않은(NULL) 상품의
모든 정보를 조회하시오.
*/

SELECT *
FROM products
WHERE description IS NULL;

/*
7. products 테이블의 모든 상품 정보를 가격이 비싼 순서대로 정렬하여 조회하세요.
*/

SELECT *
FROM products
ORDER BY price DESC;

/*
8. products 테이블의 상품 정보를 먼저 가격의 오름차순으로 정렬하고, 만약 가격이 같다면
재고 수량이 많은 순으로 정렬하여 조회하시오.
*/

SELECT *
FROM products
ORDER BY price ASC, stock_quantity DESC;

/*
9. customers 테이블에서 가장 최근에 가입한 고객 2명의 모든 정보를 조회하세요.
*/

SELECT *
FROM customers
ORDER BY join_date DESC LIMIT 2;

/*
10. orders 테이블을 참조하여, 한 번이라도 주문을 한 적이 있는 고객의 ID와
주문한 상품의 ID 조합을 중복 없이 조회하세요.
*/

SELECT DISTINCT customer_id, product_id
FROM orders;

/*
11. products 테이블에서 3000원을 초과하고 재고가 100개 이하인 상품들을 대상으로,
재고가 많은 순서대로 정렬하여 상위 3개의 상품명과 재고 수량을 조회하시오.
이때 상품명은 '상품 이름'으로, 재고 수량은 '남은 수량'으로 출력하시오.
*/

SELECT
	name AS `상품 이름`,
	stock_quantity AS `남은 수량`
FROM products
WHERE
	price > 3000
	AND stock_quantity <= 100
ORDER BY
	stock_quantity DESC
LIMIT 3;