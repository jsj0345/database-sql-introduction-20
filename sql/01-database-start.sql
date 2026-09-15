CREATE DATABASE my_shop; -- ctrl + enter는 한 줄 실행 

-- ctrl + shift + enter는 다 실행 

-- 데이터베이스는 창고, 물건 정리할 선반 = 테이블 

USE my_shop;

CREATE TABLE sample (
	product_id INT PRIMARY KEY,
    name VARCHAR(100),
    price INT,
    stock_quantity INT,
    release_date DATE
);

DESC sample; -- 또는 DESCRIBE sample; 

SHOW DATABASES; -- 어떤 데이터베이스가 있는지를 보여줌. 

SHOW TABLES; -- 테이블 조회

DROP TABLE sample; -- 테이블 삭제 

-- 스키마 -> 데이터를 어떤 구조로 만들지에 대해서 정의한 틀 

-- DataBase는 테이블들을 포함하는 논리적인 저장 공간

-- Oracle: DB에 접속해서 사용

-- MySQL: 서버에 접속한 뒤 DB를 만들어서 사용

DROP DATABASE my_shop;

SHOW DATABASES;

-- 데이터베이스 생성
CREATE DATABASE my_shop;

-- 데이터베이스 선택
USE my_shop;

-- 테이블 생성
CREATE TABLE sample (
	product_id INT PRIMARY KEY,
    name VARCHAR(100),
    price INT,
    stock_quantity INT,
    release_date DATE
);

SHOW TABLES;

SHOW DATABASES;

INSERT INTO sample (product_id, name, price, stock_quantity, release_date)
VALUES (1, '프리미엄 청바지', 59900, 100, '2025-06-11');

-- 문자와 날짜는 ' ' 로 감싸주기

SELECT * FROM sample; -- 테이블에 있는 데이터들 조회

SELECT name, price FROM sample; -- 일부 컬럼만 조회

UPDATE sample
SET price = 40000
WHERE product_id = 1; -- 수정

DELETE FROM sample
WHERE product_id = 1;


