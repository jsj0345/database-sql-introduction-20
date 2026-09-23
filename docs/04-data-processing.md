## 1. 조회하면서 숫자 계산하기

숫자 타입의 컬럼은 `SELECT` 안에서 바로 계산할 수 있다.

예를 들어 상품 가격과 재고 수량을 이용해 각 상품의 재고 금액을 확인하려면 두 컬럼을 곱하면 된다.

```sql
SELECT
    name,
    price * stock_quantity AS stock_value
FROM products;
```

계산식 그대로 결과에 표시하면 이름이 길어질 수 있으므로, `AS`를 이용해 알아보기 쉬운 별칭을 붙일 수 있다.

숫자 값에는 기본적인 사칙연산을 사용할 수 있다.

```text
+  → 더하기
-  → 빼기
*  → 곱하기
/  → 나누기
```

예를 들어 가격에 일정 금액을 더한 결과도 바로 확인할 수 있다.

```sql
SELECT
    name,
    price + 2500 AS price_with_extra
FROM products;
```

내가 이해한 핵심은 **숫자 컬럼을 조회하면서 필요한 계산도 함께 할 수 있다는 것**이다.

---

## 2. 여러 문자열을 하나로 이어 붙이기

서로 다른 문자열 값을 하나로 합쳐서 보고 싶을 때는 `CONCAT()`을 사용할 수 있다.

```sql
SELECT
    CONCAT(name, ' / ', email) AS customer_info
FROM customers;
```

괄호 안에는 이어 붙일 값을 쉼표로 구분해서 적는다.

```text
CONCAT(값1, 값2, 값3, ...)
```

컬럼뿐 아니라 직접 작성한 문자열도 함께 넣을 수 있기 때문에, 원하는 표시 형태에 맞춰 값을 연결할 수 있다.

---

## 3. 같은 구분자를 넣어 문자열 연결하기

여러 문자열 사이에 같은 구분자를 넣고 싶다면 `CONCAT_WS()`를 사용할 수 있다.

첫 번째 값으로 구분자를 정하고, 그 뒤에 연결할 값을 적는다.

```sql
SELECT
    CONCAT_WS(' | ', name, email, address) AS customer_info
FROM customers;
```

내가 구분한 방식은 다음과 같다.

```text
CONCAT()     → 전달한 문자열을 순서대로 연결
CONCAT_WS()  → 정한 구분자를 사이에 넣어 연결
```

이번에 배운 내용 기준으로 `CONCAT_WS()`는 MySQL에서 사용하는 함수라는 점도 같이 기억했다.

---

## 4. 문자열의 대소문자 바꾸기

문자열을 대문자나 소문자로 바꿔서 조회할 때는 `UPPER()`와 `LOWER()`를 사용할 수 있다.

```sql
SELECT
    email,
    LOWER(email) AS lower_email
FROM customers;
```

반대로 모두 대문자로 바꾸려면 `UPPER()`를 사용한다.

```text
UPPER() → 대문자로 변환
LOWER() → 소문자로 변환
```

---

## 5. 문자열 길이를 확인할 때 구분할 점

문자열의 길이를 확인할 때는 `LENGTH()`와 `CHAR_LENGTH()`를 사용할 수 있다.

```sql
SELECT
    name,
    CHAR_LENGTH(name) AS char_count,
    LENGTH(name) AS byte_count
FROM customers;
```

두 함수는 확인하는 기준이 다르다.

```text
CHAR_LENGTH() → 글자 수
LENGTH()      → 바이트 수
```

따라서 문자열의 글자 수를 확인하려는지, 바이트 길이를 확인하려는지에 따라 구분해서 사용할 수 있다.

---

## 6. NULL 대신 다른 값을 보여주기

`NULL`인 값을 그대로 보여주지 않고 다른 값으로 대신 표시하고 싶을 때 `IFNULL()`을 사용할 수 있다.

`IFNULL()`은 첫 번째 값이 `NULL`인지 확인하고, `NULL`이면 두 번째 값을 반환한다.

```sql
SELECT
    name,
    IFNULL(description, '설명 미등록') AS description
FROM products;
```

`description`에 값이 있으면 기존 값이 나오고, `NULL`이면 지정한 문자열이 대신 나온다.

```text
IFNULL(확인할 값, NULL일 때 사용할 값)
```

---

## 7. 여러 값 중 NULL이 아닌 값 찾기

`COALESCE()`도 `NULL`을 처리할 때 사용할 수 있다.

`IFNULL()`과 달리 여러 값을 전달할 수 있고, 왼쪽부터 확인해서 처음 나오는 `NULL`이 아닌 값을 반환한다.

```sql
SELECT
    name,
    COALESCE(description, '설명 없음') AS description
FROM products;
```

값을 두 개만 사용하면 위 예제처럼 `IFNULL()`과 비슷한 결과를 만들 수 있다.

```text
COALESCE(값1, 값2, 값3, ...)
```

모든 값이 `NULL`이면 결과도 `NULL`이 된다.

이번 내용에서는 다음 정도로 구분해서 기억했다.

```text
IFNULL()    → 첫 번째 값이 NULL이면 두 번째 값 사용
COALESCE()  → 왼쪽부터 확인해서 처음 만나는 NULL이 아닌 값 사용
```








