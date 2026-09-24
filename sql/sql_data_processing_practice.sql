USE my_shop;

/*
1. products 테이블의 모든 상품에 대해 15% 할인된 가격을 계산하고,
sale_price라는 별칭으로 출력하시오.

상품의 이름, 원래 가격, 그리고 할인가를 함께 조회해야 한다.
*/

SELECT
	name,
    price,
    price * 0.85 AS `sale_price`
FROM
	products;

/*
2. customers 테이블을 사용하여, 각 고객의 이름과 주소를
CONCAT_WS() 함수를 이용해 ' - ' 로 연결하시오.
컬럼의 별칭은 customer_info로 지정한다.
*/

SELECT
	CONCAT_WS(' - ', name, address) AS customer_info
FROM
	customers;

/*
3. products 테이블에서 상품 설명이 없는 상품은, 상품 이름을 대신 설명으로
사용하도록 조회하시오.
COALESCE() 함수를 사용하고, 결과 컬럼의 별칭은 product_display_info로 지정한다.
상품의 원래 이름과 최종적으로 표시될 정보를 함께 출력하시오.
*/

SELECT
	name,
    COALESCE(description, name) AS product_display_info
FROM
	products;

/*
4. products 테이블에 description 컬럼과 name 컬럼이 있다.
상품 정보를 표시할 때, description 값이 존재하면 그 값을 사용하고, description이 NULL이면
name을 사용하고, 만약 name값도 NULL이라면 '정보 없음'이라는 문구를 출력하고 싶다.
이 로직을 COALESCE() 함수를 사용하여 display_text라는 별칭으로 출력하세요.
*/

SELECT
	name,
    description,
    COALESCE(description, name, '정보 없음') AS 'display_text'
FROM
	products;

/*
5. customers 테이블의 email 컬럼에서 아이디 부분만 추출하고, 아이디의 글자 수를 계산하라.
아이디는 '@' 앞부분의 문자열이다.
SUBSTRING_INDEX()와 CHAR_LENGTH() 함수를 활용하여 user_id와 id_length라는
별칭으로 결과를 출력하시오.
*/

SELECT
	email,
    SUBSTRING_INDEX(email, '@', 1) AS user_id,
    CHAR_LENGTH(SUBSTRING_INDEX(email, '@', 1)) AS id_length
FROM
	customers;