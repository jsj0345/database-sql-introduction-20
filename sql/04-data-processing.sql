SELECT name, price, stock_quantity
FROM products;

SELECT name,
 price,
 stock_quantity,
 price * stock_quantity AS total_stock_value
FROM products;

SELECT
	name,
	price,
    price + 3000 as expected_price
FROM products;

SELECT
	name,
    price,
    price - 1000 as discounted_price
FROM products;

SELECT
	name,
    price,
    price / 10 as monthly_payment
FROM products;

SELECT name,
	email
FROM customers;

SELECT concat(name, ' (', email, ')') AS name_and_email
FROM customers;

SELECT concat_ws(' - ', name, email, address) AS customer_details
FROM customers;

SELECT email, UPPER(email) AS `이메일을 대문자로`
FROM customers;

SELECT name, char_length(name) as char_length, length(name) as byte_length
FROM customers;

SELECT name, description
FROM products;

SELECT
	name,
    IFNULL(description, '상품 설명 없음') as description
FROM
	products;

SELECT
	name,
    coalesce(description, '상품 설명 없음') as description
FROM
	products;
