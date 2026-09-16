USE my_shop; -- 방금 전 까지 practice_shop을 이용했기에 다른 데이터베이스로 바꾸기

CREATE TABLE customers (
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM customers;

CREATE TABLE products (
	product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
);

SELECT * FROM products;

CREATE TABLE orders(
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT '주문접수',

    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id), -- 외래 키는 다른 테이블의 데이터를 식별할 수 있는 키를 참조하며, 일반적으로 다른 테이블의 Primary Key를 참조한다.
    CONSTRAINT fk_orders_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);

ALTER TABLE customers ADD COLUMN point INT NOT NULL DEFAULT 0;

SELECT * FROM customers;

DESC customers;

ALTER TABLE customers
MODIFY COLUMN address VARCHAR(500) NOT NULL;

DESC customers;

ALTER TABLE customers
MODIFY COLUMN address VARCHAR(255) NOT NULL;

DESC customers;

ALTER TABLE customers
DROP COLUMN point;

DROP TABLE products;

-- Error Code: 3730. Cannot drop table 'products' referenced by a foreign key constraint 'fk_orders_products' on table 'orders'.

TRUNCATE TABLE products;

-- Error Code: 1701. Cannot truncate a table referenced in a foreign key constraint (`my_shop`.`orders`, CONSTRAINT `fk_orders_products`)

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE products;

SET FOREIGN_KEY_CHECKS = 1;

DESC customers;

SELECT * FROM customers;

INSERT INTO customers VALUES (NULL, '강감찬', 'kang@example.com', 'hashed_password_123', '서울시 관악구', '2025-06-11 10:30:00');

INSERT INTO customers VALUES (NULL, '이순신', 'lee@example.com', 'hashed_password_123', '서울시 관악구', '2025-06-12 10:30:00');

SELECT * FROM customers;

DESC customers;

INSERT INTO customers (name, email, password, address) VALUES
('세종대왕', 'sejong@example.com', 'hashed_password_123', '서울시 관악구');

SELECT * FROM products;

INSERT INTO products (name, price, stock_quantity) VALUES ('베이직 반팔 티셔츠', 19900, 200);

INSERT INTO products (name, price, stock_quantity) VALUES ('초록색 긴팔 티셔츠', 30000, 50);

INSERT INTO products (name, price, stock_quantity) VALUES
('검정 양말', 5000, 100),
('갈색 양말', 5000, 150),
('흰색 양말', 5000, 200);

SELECT * FROM products;

SELECT * FROM products
WHERE name = '베이직 반팔 티셔츠';

UPDATE products
SET price = 9800, stock_quantity = 580
WHERE product_id = 1;

UPDATE products
SET price = 990;

-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

SELECT @@SQL_SAFE_UPDATES;

UPDATE products
SET price = 990
WHERE name = '베이직 반팔 티셔츠';

-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- 오라클이랑 다르게 WHERE 절 뒤에 기본키 값을 뒀을때만 수정 가능함. (workBench는 기본적으로 안전 모드가 켜져 있다.)

SET SQL_SAFE_UPDATES = 0;

UPDATE products
SET price = 990;

SELECT * FROM products;

SET SQL_SAFE_UPDATES = 1;