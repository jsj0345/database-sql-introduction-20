# SQL로 테이블 구조와 데이터 다루기

> MySQL에서 테이블을 만들고 관계를 연결한 뒤, 구조를 수정하거나 데이터를 넣는 흐름을 복습하면서 정리했다.

## 1. 테이블을 만들 때 같이 결정하는 것

`CREATE TABLE`은 테이블의 이름만 만드는 명령이 아니라,
각 컬럼에 어떤 값이 들어갈지와 어떤 규칙을 적용할지도 함께 정하는 명령이다.

예를 들어 행을 구분할 번호를 자동으로 증가시키고 싶다면 다음처럼 사용할 수 있다.

```sql
id INT AUTO_INCREMENT PRIMARY KEY
```

각 옵션의 역할은 따로 구분해서 기억하면 이해하기 쉽다.

- `PRIMARY KEY` : 각 행을 구분하는 대표 값
- `AUTO_INCREMENT` : 새로운 행이 추가될 때 정수 값을 자동으로 증가시킴
- `NOT NULL` : `NULL`을 허용하지 않음
- `UNIQUE` : 같은 값의 중복을 허용하지 않음
- `DEFAULT` : 값을 생략했을 때 사용할 기본값을 지정함

즉 테이블을 생성할 때는 **컬럼의 타입뿐 아니라 데이터가 지켜야 할 조건까지 함께 정한다.**

---

## 2. 날짜 값을 자동으로 기록하기

날짜 컬럼에는 현재 시간을 기본값으로 지정할 수 있다.

```sql
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
```

새로운 행을 추가하면서 `created_at` 값을 따로 지정하지 않으면 현재 날짜와 시간이 들어간다.

값이 수정될 때마다 시간도 현재 시각으로 바뀌게 하려면 `ON UPDATE CURRENT_TIMESTAMP`를 함께 사용할 수 있다.

```sql
updated_at DATETIME
DEFAULT CURRENT_TIMESTAMP
ON UPDATE CURRENT_TIMESTAMP
```

따라서 처음 저장된 시간을 남길 컬럼과,
데이터가 변경될 때마다 갱신할 시간 컬럼을 서로 다르게 설정할 수 있다.

---

## 3. 컬럼마다 필요한 조건은 다르다

모든 컬럼에 같은 제약 조건을 걸 필요는 없다.

값이 없어도 되는 컬럼이라면 `NOT NULL`을 사용하지 않을 수 있고,
값을 생략했을 때 특정 값으로 시작하게 하고 싶다면 `DEFAULT`를 사용할 수 있다.

```sql
stock_quantity INT NOT NULL DEFAULT 0
```

이 경우 재고 수량은 `NULL`이 될 수 없고,
값을 따로 넣지 않으면 기본값인 `0`이 사용된다.

따라서 컬럼을 정의할 때는 **값이 필수인지, 생략 가능한지, 생략하면 어떤 값을 사용할지**까지 같이 생각해야 한다.

---

## 4. 다른 테이블의 데이터를 연결하기

주문처럼 다른 테이블의 정보와 연결되어야 하는 데이터는
식별 값을 이용해 테이블 사이의 관계를 만들 수 있다.

이때 사용하는 것이 `FOREIGN KEY`다.

```sql
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id)
```

이렇게 설정하면 주문 쪽의 `customer_id`는
`customers` 테이블에서 참조할 수 있는 값을 기준으로 연결된다.

외래 키는 두 테이블 사이의 연결 기준을 만들고,
참조할 수 없는 값이 들어오는 것을 막아 서로 연결된 데이터의 관계를 유지하는 데 사용한다.

외래 키 제약 조건에는 이름을 붙일 수도 있다.

```sql
CONSTRAINT fk_orders_customers
```

관계가 여러 개 있을 때 이름을 정해두면 어떤 제약 조건인지 구분하기 쉽다.

---

## 5. 테이블 관계를 그림으로 확인하기

테이블이 여러 개로 나뉘고 서로 연결되기 시작하면
SQL만 보고 전체 관계를 한눈에 파악하기 어려울 수 있다.

이런 테이블 사이의 관계를 그림으로 표현한 것이 `ERD(Entity Relationship Diagram)`다.

까마귀발 표기에서는 관계의 `Many` 쪽을 표시하는 형태를 사용한다.

따라서 ERD를 보면 어떤 테이블이 서로 연결되어 있는지와
관계의 방향을 더 쉽게 확인할 수 있다.

---

## 6. 이미 만든 테이블의 구조 바꾸기

테이블을 만든 뒤에도 컬럼을 추가하거나,
기존 컬럼의 정의를 변경하거나,
더 이상 필요 없는 컬럼을 삭제해야 할 수 있다.

이때 `ALTER TABLE`을 사용한다.

### 컬럼 추가

```sql
ALTER TABLE customers
ADD COLUMN point INT NOT NULL DEFAULT 0;
```

### 컬럼 정의 변경

```sql
ALTER TABLE customers
MODIFY COLUMN address VARCHAR(500) NOT NULL;
```

`MODIFY COLUMN`으로 컬럼 정의를 다시 지정할 때는
기존에 유지해야 하는 `NOT NULL` 같은 속성도 함께 적어주는 것이 중요하다.

### 컬럼 삭제

```sql
ALTER TABLE customers
DROP COLUMN point;
```

구조를 변경한 뒤에는 `DESC`로 현재 컬럼 정의를 확인할 수 있다.

내 기준으로는 `ALTER TABLE`을 **이미 존재하는 테이블의 구조를 다시 조정할 때 사용하는 명령**으로 기억했다.

---

## 7. 테이블 자체를 없애는 것과 데이터만 비우는 것

`DROP`과 `TRUNCATE`는 모두 데이터가 사라질 수 있지만 결과는 다르다.

### `DROP TABLE`

테이블 자체를 제거한다.

```sql
DROP TABLE orders;
```

실행하면 저장된 데이터와 함께 테이블 구조도 사라진다.

### `TRUNCATE TABLE`

테이블 구조는 남겨두고 저장된 데이터를 모두 제거한다.

```sql
TRUNCATE TABLE orders;
```

테이블 자체는 유지되므로 이후 다시 데이터를 넣을 수 있다.

MySQL에서는 `TRUNCATE`를 실행하면 해당 테이블의 `AUTO_INCREMENT` 값도 초기화된다.
반면 `DELETE`로 모든 행을 삭제하는 경우에는 `AUTO_INCREMENT` 값이 초기화되지 않는다.

또한 테이블 전체 데이터를 제거하는 경우
`TRUNCATE`는 `DELETE`와 처리 방식이 다르기 때문에 일반적으로 더 빠르게 처리될 수 있다.

정리하면 다음처럼 구분할 수 있다.

```text
DROP      → 테이블 자체 제거
TRUNCATE  → 구조는 유지하고 전체 데이터 제거
DELETE    → 행을 삭제
```

---

## 8. 외래 키로 연결된 테이블을 제거할 때

다른 테이블에서 외래 키로 참조하고 있는 테이블은
그 관계 때문에 바로 `DROP`하거나 `TRUNCATE`할 수 없는 경우가 있다.

예를 들어 주문 데이터가 상품을 참조하고 있는데
상품 테이블이 먼저 사라지면 주문 쪽에서는 연결할 상품 정보를 찾을 수 없게 된다.

외래 키 제약 조건은 이런 식으로 테이블 사이의 관계가 깨지는 것을 막는다.

MySQL에서는 현재 세션에서 외래 키 검사를 임시로 비활성화할 수 있다.

```sql
SET FOREIGN_KEY_CHECKS = 0;
```

다시 활성화할 때는 다음과 같이 설정한다.

```sql
SET FOREIGN_KEY_CHECKS = 1;
```

검사를 끄면 외래 키 관계를 확인하지 않는 작업이 가능해질 수 있지만,
그동안 서로 맞지 않는 데이터가 생길 수 있으므로 필요한 작업이 끝나면 다시 활성화해야 한다.

또한 다시 `1`로 설정한다고 해서
검사를 꺼둔 동안 만들어진 데이터가 자동으로 다시 검사되는 것은 아니다.

---

## 9. 테이블에 데이터 추가하기

테이블 구조를 만든 뒤 실제 값을 저장할 때는 `INSERT`를 사용한다.

기본적인 형태는 다음과 같다.

```sql
INSERT INTO customers (name, email)
VALUES ('홍길동', 'hong@example.com');
```

지정한 컬럼 목록과 `VALUES`의 값은
순서와 개수가 서로 맞아야 한다.

### 모든 컬럼에 값을 넣는 방식

컬럼 목록을 생략하면 테이블에 정의된 컬럼 순서에 맞춰 값을 넣어야 한다.

`AUTO_INCREMENT`로 설정된 컬럼은 값을 직접 지정하지 않고
MySQL이 다음 값을 만들도록 둘 수 있다.

MySQL에서는 `AUTO_INCREMENT` 컬럼에 `NULL`을 넣는 방식도 사용할 수 있지만,
직접 값을 넣지 않을 컬럼을 목록에서 생략하는 방법도 가능하다.

### 필요한 컬럼만 지정하는 방식

`AUTO_INCREMENT`나 `DEFAULT`처럼 직접 값을 줄 필요가 없는 컬럼은 생략할 수 있다.

```sql
INSERT INTO customers (name, email, password, address)
VALUES ('사용자', 'user@example.com', 'password', '주소');
```

이렇게 컬럼명을 함께 적으면
어떤 값이 어느 컬럼에 들어가는지 SQL만 보고 확인하기 쉽다.

---

## 10. 여러 행을 한 번에 추가하기

같은 테이블에 여러 데이터를 넣을 때는
하나의 `INSERT`에서 여러 개의 값 묶음을 전달할 수 있다.

```sql
INSERT INTO products (name, price)
VALUES
('상품A', 1000),
('상품B', 2000);
```

즉 같은 컬럼 구성을 사용하는 데이터라면
`VALUES` 뒤에 여러 행을 나열해서 한 번에 추가할 수 있다.






