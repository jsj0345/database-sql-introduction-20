## 1. 여러 행을 하나의 값으로 계산하기

테이블의 행을 하나씩 확인하지 않고, 전체 데이터를 기준으로 개수나 합계 같은 값을 바로 계산할 수 있다.

이때 사용하는 함수가 집계 함수다.

이번에 정리한 함수는 다음과 같다.

```text
COUNT() → 개수
SUM()   → 합계
AVG()   → 평균
MAX()   → 최댓값
MIN()   → 최솟값
```

각 함수는 여러 행을 대상으로 계산한 뒤 하나의 결과를 반환한다.

---

## 2. 전체 행 수와 특정 컬럼의 개수는 다를 수 있다

행의 개수를 셀 때 `COUNT(*)`와 `COUNT(컬럼명)`은 같은 결과가 나올 수도 있지만, 컬럼에 `NULL`이 포함되어 있으면 차이가 생긴다.

```sql
SELECT
    COUNT(*) AS total_rows,
    COUNT(category) AS category_count
FROM order_stat;
```

내가 구분한 기준은 다음과 같다.

```text
COUNT(*)        → 전체 행 수
COUNT(컬럼명)   → 해당 컬럼에서 NULL이 아닌 값의 개수
```

따라서 전체 주문 건수를 알고 싶은 경우와, 특정 정보가 실제로 입력된 행의 개수를 알고 싶은 경우를 나눠서 생각해야 한다.

---

## 3. 숫자 컬럼의 합계와 평균 구하기

숫자 값이 저장된 컬럼은 `SUM()`과 `AVG()`를 이용해 전체 합계와 평균을 계산할 수 있다.

예를 들어 주문 수량을 기준으로 전체 판매 수량과 주문당 평균 수량을 확인할 수 있다.

```sql
SELECT
    SUM(quantity) AS total_quantity,
    AVG(quantity) AS avg_quantity
FROM order_stat;
```

집계 함수 안에는 앞에서 배운 계산식도 사용할 수 있다.

```sql
SELECT
    SUM(price * quantity) AS total_sales
FROM order_stat;
```

이 경우 각 행의 `price * quantity` 결과를 기준으로 전체 합계를 계산한다고 이해했다.

`SUM()`과 `AVG()`는 계산할 때 `NULL` 값을 제외한다.

---

## 4. 가장 큰 값과 가장 작은 값 확인하기

컬럼 안에서 가장 큰 값이나 가장 작은 값을 찾을 때는 `MAX()`와 `MIN()`을 사용할 수 있다.

```sql
SELECT
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM order_stat;
```

숫자뿐 아니라 날짜 컬럼에도 사용할 수 있다.

```sql
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM order_stat;
```

내가 기억한 방식은 **컬럼 안에서 값의 범위를 확인할 때 `MAX()`와 `MIN()`을 사용한다**는 것이다.

---

## 5. 중복을 제외한 값의 개수 세기

앞에서 `DISTINCT`로 중복 값을 제거하는 방법을 배웠는데, `COUNT()` 안에서도 함께 사용할 수 있다.

```sql
SELECT
    COUNT(DISTINCT customer_name) AS customer_count
FROM order_stat;
```

이렇게 작성하면 같은 고객 이름이 여러 번 있어도 한 번만 세어진다.

즉 다음처럼 구분할 수 있다.

```text
COUNT(customer_name)
→ NULL이 아닌 고객 이름의 개수

COUNT(DISTINCT customer_name)
→ 중복을 제외한 고객 이름의 개수
```

---

## 6. 같은 값끼리 묶어서 집계하기

집계 함수만 사용하면 테이블 전체를 기준으로 하나의 결과가 나온다.

하지만 카테고리별이나 고객별처럼 기준을 나눠서 계산하고 싶을 때는 `GROUP BY`를 사용할 수 있다.

```sql
SELECT
    category,
    COUNT(*) AS order_count
FROM order_stat
GROUP BY category;
```

`GROUP BY category`는 같은 `category` 값을 가진 행을 하나의 그룹으로 묶는다.

그 뒤 `COUNT(*)`를 사용하면 각 그룹에 몇 개의 행이 있는지 계산할 수 있다.

내가 이해한 흐름은 다음과 같다.

```text
GROUP BY → 같은 기준의 행을 묶음
집계 함수 → 묶인 그룹마다 결과를 계산
```

`GROUP BY`에서 기준 컬럼의 값이 `NULL`인 행도 하나의 그룹으로 묶여 결과에 포함될 수 있다.

---

## 7. 그룹마다 여러 값을 함께 계산하기

`GROUP BY`는 `COUNT()`뿐 아니라 `SUM()`, `AVG()`, `MAX()`, `MIN()`과도 같이 사용할 수 있다.

예를 들어 고객별 주문 횟수와 총 구매 수량을 함께 확인할 수 있다.

```sql
SELECT
    customer_name,
    COUNT(*) AS order_count,
    SUM(quantity) AS total_quantity
FROM order_stat
GROUP BY customer_name;
```

이 경우 먼저 고객 이름이 같은 행끼리 묶고, 각 고객 그룹 안에서 주문 개수와 수량 합계를 각각 계산한다.

필요하다면 계산한 값을 기준으로 정렬할 수도 있다.

```sql
SELECT
    customer_name,
    SUM(price * quantity) AS `total_sales`
FROM order_stat
GROUP BY customer_name
ORDER BY `total_sales` DESC;
```

이번 내용에서 확인한 부분은, 별칭에 공백이나 한글처럼 일반적인 컬럼명과 다른 형태를 사용할 때는 백틱으로 감싸서 표현할 수 있다는 점이다.

반대로 작은따옴표로 감싸면 컬럼 이름이 아니라 문자열 값으로 처리될 수 있으므로 구분해서 사용해야 한다.
