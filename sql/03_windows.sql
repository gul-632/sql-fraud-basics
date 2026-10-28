--Queries from 13 -15 comes under this section
-- Query 13: CTE plus a 7-day moving fraud rate
WITH daily AS (
  SELECT CAST(FLOOR(TransactionDT / 86400.0) AS INTEGER) AS day_no,
         COUNT(*) AS n,
         SUM(isFraud) AS n_fraud
  FROM transactions
  GROUP BY 1
)
SELECT day_no, n, n_fraud,
       ROUND(100.0 * SUM(n_fraud) OVER (ORDER BY day_no ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
                   / SUM(n) OVER (ORDER BY day_no ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS fraud_pct_7d
FROM daily
ORDER BY day_no;

--14th Query:product code Rank by Fraud Rate

WITH product_fraud AS (
    SELECT
        card4,
        ProductCD,
        COUNT(*) AS total_transactions,
        SUM(isFraud) AS fraud_transactions,
        ROUND(
            100.0 * SUM(isFraud) / COUNT(*),
            2
        ) AS fraud_rate
    FROM transactions
    WHERE card4 IS NOT NULL
      AND ProductCD IS NOT NULL
    GROUP BY card4, ProductCD
)
SELECT
    card4,
    ProductCD,
    total_transactions,
    fraud_transactions,
    fraud_rate,
    RANK() OVER (
        PARTITION BY card4
        ORDER BY fraud_rate DESC
    ) AS product_rank
FROM product_fraud
ORDER BY card4, product_rank;

--15th Query: Share of Fraud

WITH fraud_deciles AS (
    SELECT
        TransactionAmt,
        isFraud,
        NTILE(10) OVER (
            ORDER BY TransactionAmt
        ) AS amount_decile
    FROM transactions
),
decile_summary AS (
    SELECT
        amount_decile,
        COUNT(*) AS total_transactions,
        SUM(isFraud) AS fraud_cases
    FROM fraud_deciles
    GROUP BY amount_decile
)
SELECT
    amount_decile,
    total_transactions,
    fraud_cases,
    ROUND(
        100.0 * fraud_cases /
        SUM(fraud_cases) OVER (),
        2
    ) AS fraud_case_share_pct
FROM decile_summary
ORDER BY amount_decile;
