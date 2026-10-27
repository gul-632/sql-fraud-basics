--Query First Count and Rate 
SELECT COUNT(*) AS n_transactions,
       SUM(isFraud) AS n_fraud,
       ROUND(100.0 * SUM(isFraud) / COUNT(*), 2) AS fraud_pct
FROM transactions;

--2nd Query:Count Fraud Rate by ProductCD
SELECT
    ProductCD,
    COUNT(*) AS n_transactions,
    SUM(isFraud) AS n_fraud,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        2
    ) AS fraud_pct
FROM transactions
GROUP BY ProductCD
ORDER BY fraud_pct DESC;

--3rd Query:Fraud Rate by Card Type
SELECT
    card4,card6,
    COUNT(*) AS n_transactions,
    SUM(isFraud) AS n_fraud,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        2
    ) AS fraud_pct
FROM transactions
GROUP BY card4,card6
ORDER BY fraud_pct DESC;

--4th Query:Average Amount by fraud VS non-fraud transactions  

SELECT
    isFraud,
    COUNT(*) AS n_transactions,
    ROUND(AVG(TransactionAmt), 2) AS avg_amount
FROM transactions
GROUP BY isFraud;

--5th Query: Fraud Rate by  Transaction Amount Buckets

SELECT
    CASE
        WHEN TransactionAmt < 10 THEN 'Under 10'
        WHEN TransactionAmt < 50 THEN '10 to 50'
        WHEN TransactionAmt < 100 THEN '50 to 100'
        WHEN TransactionAmt < 500 THEN '100 to 500'
        ELSE '500 and over'
    END AS amount_bucket,
    COUNT(*) AS n_transactions,
    SUM(isFraud) AS n_fraud,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        2
    ) AS fraud_pct
FROM transactions
GROUP BY amount_bucket
ORDER BY
    CASE amount_bucket
        WHEN 'Under 10' THEN 1
        WHEN '10 to 50' THEN 2
        WHEN '50 to 100' THEN 3
        WHEN '100 to 500' THEN 4
        WHEN '500 and over' THEN 5
    END;

--6th Query: Transaction and Fraud per day 

SELECT
    FLOOR(TransactionDT / 86400) AS day_number,
    COUNT(*) AS n_transactions,
    SUM(isFraud) AS n_fraud
FROM transactions
GROUP BY day_number
ORDER BY day_number;


--7th Query: 5 days with the highest number of Fraud Transactions 
SELECT
    FLOOR(TransactionDT / 86400) AS day_number,
    COUNT(*) AS n_transactions,
    SUM(isFraud) AS n_fraud,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        2
    ) AS fraud_pct
FROM transactions
GROUP BY day_number
HAVING COUNT(*) > 500 
ORDER BY fraud_pct DESC 
LIMIT 5;

--8th Query: 10 email domains that have the highest Fraud Transactions 

SELECT
    P_emaildomain,
    COUNT(*) AS n_transactions,
    SUM(isFraud) AS n_fraud,
    ROUND(
        100.0 * SUM(isFraud) / COUNT(*),
        2
    ) AS fraud_pct
FROM transactions
WHERE P_emaildomain IS NOT NULL
GROUP BY P_emaildomain
HAVING COUNT(*) >= 1000
ORDER BY fraud_pct DESC
LIMIT 10;
