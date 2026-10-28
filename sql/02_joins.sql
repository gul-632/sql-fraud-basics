--Queries from 9-11  comes under this section 
-- Query 9: LEFT JOIN keeps transactions that have no identity row
SELECT CASE WHEN i.TransactionID IS NULL THEN 'no identity' ELSE 'has identity' END AS  identity_status,
       COUNT(*) AS n,
       ROUND(100.0 * AVG(t.isFraud), 2) AS fraud_pct
FROM transactions t
LEFT JOIN identity i ON i.TransactionID = t.TransactionID
GROUP BY 1;

--10th Query: Join and group by identify Device type according to fraud rate 

SELECT
    i.DeviceType,
    COUNT(*) AS total_transactions,
    SUM(t.isFraud) AS fraud_transactions,
    ROUND(
        100.0 * SUM(t.isFraud) / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions AS t
JOIN identity AS i
    ON t.TransactionID = i.TransactionID
GROUP BY i.DeviceType
ORDER BY fraud_rate DESC;
--11th Query: Card with most transaction and  Fraud rateby card

SELECT
    card1,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        2
    ) AS fraud_rate
FROM transactions
WHERE card1 IS NOT NULL
GROUP BY card1
ORDER BY total_transactions DESC
LIMIT 10;

--12th Query: Fraud Rate for transactions

WITH transaction_averages AS (
    SELECT
        ProductCD,
        TransactionAmt,
        isFraud,
        AVG(TransactionAmt) OVER (
            PARTITION BY ProductCD
        ) AS avg_product_amount
    FROM transactions
)
SELECT
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        2
    ) AS fraud_rate
FROM transaction_averages
WHERE TransactionAmt > avg_product_amount;
