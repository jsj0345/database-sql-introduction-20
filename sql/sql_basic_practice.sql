/*
1. my_test 데이터베이스 생성.
2. members 테이블 생성 (id, name, join_date)
*/

CREATE DATABASE my_test;

USE my_test;

CREATE TABLE members (
	id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    join_date DATE
);

DESC members;

/*
2. 1번에서 생성한 members 테이블에 두 명의 회원 데이터 추가 및 테이블 전체 내용 조회
*/

INSERT INTO members VALUES
(1, '션', '2025-01-10'),
(2, '네이트', '2025-02-15');

SELECT * FROM members;

/*
3. 데이터 수정 및 삭제하기 (UPDATE, DELETE)

2번에서 추가한 데이터에 두 가지 작업을 수행하고, 최종 결과를 조회하기

- id가 2인 회원 '네이트'의 이름을 '네이트2'로 변경
- id가 1인 회원 '션'의 정보를 삭제해라.
*/

UPDATE members
SET name = '네이트2'
WHERE id = 2;

DELETE FROM members
WHERE id = 1;

SELECT * FROM members;

/*
4.

product_id => 정수, 자동으로 1씩 증가하는 기본 키(PRIMARY KEY)
product_name => 최대 100글자의 문자열, 비어 있을 수 없음 (NOT NULL)
product_code => 최대 20글자의 문자열, 값이 중복될 수 없음 (UNIQUE)
price => 정수, 비어 있을 수 없음 (NOT NULL)
stock_count => 정수, 비어 있을 수 없으며 (NOT NULL), 값을 지정하지 않으면 기본으로 0이 입력됨.
*/

CREATE TABLE products (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_code VARCHAR(20) UNIQUE,
    price INT NOT NULL,
    stock_count INT NOT NULL DEFAULT 0
);

DESC products;

/*
5.
고객(customers)과 주문(orders) 테이블을 생성해라.
orders 테이블의 customer_id는 customers 테이블의 customer_id를 참조하는 외래 키 관계를 맺어야 한다.

테이블을 생성하고 나서 '홍길동' 고객과 그 고객이 주문한 데이터를 각각 1개씩 추가하고, 두 테이블의 전체 내용을
조회하시오.
*/

CREATE TABLE customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE orders (
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers (customer_id)
);


INSERT INTO customers (name)
VALUES ('홍길동');

SELECT * FROM customers;

INSERT INTO orders (customer_id)
VALUES  (1);

SELECT * FROM orders;

DESC orders;

/*
6.
- customers 테이블에 존재하지 않는 customer_id (예: 999)를 사용하여
orders 테이블에 새로운 주문을 추가해라.
- customers 테이블에 고객을 추가할 때, 필수 항목인 name을 빼고 추가해라.
*/

INSERT INTO orders (customer_id)
VALUES (999); -- 부모 테이블에 999번 데이터는 없으니까 당연히 참조 할 수 있는게 없어서 실행 불가.

INSERT INTO customers (customer_id)
VALUES (2); -- NOT NULL 제약 조건으로 인해 실패함.
