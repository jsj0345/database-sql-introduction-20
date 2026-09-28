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

---

## 8. 두 가지 기준을 같이 묶어서 보기

하나의 기준만으로는 원하는 정보를 충분히 나누기 어려울 때가 있다.
예를 들어 고객별 합계만 보는 것이 아니라, **고객마다 어떤 카테고리에서 얼마를 구매했는지**까지 보고 싶을 수 있다.

이럴 때는 `GROUP BY`에 기준 컬럼을 여러 개 지정하면 된다.

```sql
GROUP BY customer_name, category
```

내가 이해한 방식은 다음과 같다.

```text
고객 이름으로 구분하고
→ 같은 고객 안에서 카테고리까지 다시 나눔
→ 각 조합마다 집계값을 계산함
```

즉 `customer_name`만 사용했을 때보다 결과가 더 잘게 나뉜다.

예를 들어 구매 금액을 계산한다면 핵심은 다음 정도다.

```sql
SUM(price * quantity)
```

이 값을 `customer_name`, `category` 조합별로 계산하면 고객이 카테고리별로 얼마를 구매했는지 확인할 수 있다.

---

## 9. GROUP BY를 사용한 뒤 SELECT에 아무 컬럼이나 넣을 수 없는 이유

`GROUP BY`로 여러 행을 하나의 그룹으로 묶으면, `SELECT`에는 그 그룹을 대표할 수 있는 값이 필요하다.

예를 들어 카테고리별로 묶었다고 하자.

```sql
GROUP BY category
```

이 상태에서 `category`는 그룹을 만든 기준이기 때문에 결과에 표시할 값이 명확하다.
또한 `COUNT(*)`, `SUM()`처럼 그룹 전체를 계산한 값도 하나의 결과로 정리할 수 있다.

하지만 그룹 기준에 포함되지 않은 일반 컬럼을 그대로 조회하면 문제가 생길 수 있다.

```sql
SELECT category, product_name, COUNT(*)
```

`category`가 전자기기인 행이 여러 개라면 그 안에는 서로 다른 `product_name`이 존재한다.
이때 데이터베이스 입장에서는 그중 어떤 상품명을 한 개 골라 보여줘야 하는지 기준이 없다.

내가 이해한 핵심은 다음과 같다.

```text
GROUP BY 컬럼
→ 그룹을 대표하는 기준값이라 조회 가능

집계 함수
→ 그룹 전체를 하나의 값으로 계산하므로 조회 가능

그 외 일반 컬럼
→ 그룹 안에 여러 값이 있을 수 있어 하나를 특정하기 어려움
```

따라서 `GROUP BY`를 사용할 때는 **그룹 기준 컬럼 또는 집계된 값 위주로 SELECT를 구성해야 한다.**

---

## 10. 묶인 결과에 조건을 걸 때는 HAVING 사용

카테고리별 매출을 구한 뒤, 그중 일정 금액 이상인 카테고리만 보고 싶다고 가정한다.

처음에는 다음처럼 `WHERE`에서 `SUM()` 결과를 검사하고 싶을 수 있다.

```sql
WHERE SUM(price * quantity) >= 500000
```

하지만 이 방식은 사용할 수 없다.

`SUM(price * quantity)`는 여러 행을 하나의 집계값으로 계산하는 함수다.
그런데 `WHERE`가 처리되는 시점에는 아직 `GROUP BY`로 그룹이 만들어지지 않았다.
따라서 어느 그룹의 합계를 계산해야 하는지 정해지지 않은 상태라 `WHERE`에서 집계값을 조건으로 사용할 수 없다.

내가 정리한 흐름은 다음과 같다.

```text
WHERE
→ 그룹으로 묶기 전의 행을 검사함

GROUP BY
→ 조건을 통과한 행을 기준별로 묶음

HAVING
→ 만들어진 그룹의 집계 결과를 검사함
```

그래서 그룹별 합계를 기준으로 필터링할 때는 `HAVING`을 사용한다.

```sql
HAVING SUM(price * quantity) >= 500000
```

즉 **개별 행을 먼저 거를 때는 `WHERE`, 그룹 계산 결과를 거를 때는 `HAVING`**이라고 구분했다.

### HAVING에서 별칭을 사용할 때

MySQL에서는 `SELECT`에서 만든 별칭을 `HAVING`에서 사용할 수 있다.

```sql
HAVING total_sales >= 500000
```

다만 표준 SQL의 논리적 처리 순서만 놓고 보면 `HAVING`이 `SELECT`보다 앞이기 때문에, 다른 데이터베이스까지 고려한다면 집계식을 직접 적는 방식이 더 무난하다.

```sql
HAVING SUM(price * quantity) >= 500000
```

또한 같은 방식으로 고객별 주문 횟수를 묶은 뒤 일정 횟수 이상인 고객만 남길 수도 있다.

```sql
HAVING COUNT(*) >= 3
```

---

## 11. WHERE와 HAVING을 같이 사용할 때

둘 다 조건을 거는 문법이지만 대상으로 보는 데이터가 다르다.

```text
WHERE
→ GROUP BY 이전
→ 개별 행을 대상으로 조건을 검사
→ 집계 함수 결과를 조건으로 사용하지 않음

HAVING
→ GROUP BY 이후
→ 만들어진 그룹을 대상으로 조건을 검사
→ 집계 함수 결과를 조건으로 사용할 수 있음
```

예를 들어 **가격이 일정 금액 이상인 주문만 먼저 고른 다음**, 그 데이터에서 **카테고리별 주문 건수가 일정 횟수 이상인 경우만 보고 싶다**고 하자.

이 경우 역할을 나누면 된다.

```sql
WHERE price >= 100000
```

먼저 가격 조건에 맞는 개별 주문만 남긴다.

그 다음 카테고리별로 묶고,

```sql
GROUP BY category
```

마지막으로 묶인 결과의 주문 건수를 검사한다.

```sql
HAVING COUNT(*) >= 2
```

즉 `WHERE`와 `HAVING`은 둘 중 하나만 선택하는 관계가 아니라, 필요하다면 서로 다른 단계에서 함께 사용할 수 있다.

---

## 12. 작성 순서와 실제 처리 흐름은 다르다

SQL은 보통 `SELECT`부터 작성하지만, 데이터베이스가 논리적으로 처리하는 순서는 다르다.

이번 내용에서 사용한 흐름은 다음과 같이 정리했다.

```text
FROM
→ WHERE
→ GROUP BY
→ HAVING
→ SELECT
→ ORDER BY
→ LIMIT
```

각 단계의 역할을 짧게 보면 다음과 같다.

```text
FROM      : 어떤 테이블을 사용할지 결정
WHERE     : 개별 행을 먼저 필터링
GROUP BY  : 남은 행을 기준에 따라 묶음
HAVING    : 만들어진 그룹을 다시 필터링
SELECT    : 최종적으로 보여줄 값과 집계 결과를 선택
ORDER BY  : 결과를 정렬
LIMIT     : 반환할 행의 개수를 제한
```

이 순서를 알고 있으면 `WHERE`에서 왜 집계 함수를 바로 사용할 수 없는지, `ORDER BY`에서는 왜 `SELECT`에서 만든 별칭을 사용할 수 있는지 이해하기 쉬워진다.








