-- ABC Bank Customer Risk & Transaction Analytics
-- MySQL Analysis Script
-- Database: banking_analytics

USE banking_analytics;

-- =========================================================
-- 1. DATASET ROW COUNTS
-- =========================================================

SELECT COUNT(*) AS customers FROM customers;
SELECT COUNT(*) AS accounts FROM accounts;
SELECT COUNT(*) AS transactions FROM transactions1;
SELECT COUNT(*) AS loans FROM loan1;
SELECT COUNT(*) AS complaints FROM complaint;
SELECT COUNT(*) AS customer_behaviour FROM customer_behaviours;


-- =========================================================
-- 2. CUSTOMER ANALYSIS
-- =========================================================

-- Customer count by city
SELECT city, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC;

-- Average income by city
SELECT city, ROUND(AVG(annual_income), 2) AS avg_income
FROM customers
GROUP BY city
ORDER BY avg_income DESC;

-- Cities with more than 500 customers
SELECT city, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(customer_id) > 500
ORDER BY customer_count DESC;

-- Customers earning above the overall average income
SELECT customer_id, annual_income
FROM customers
WHERE annual_income > (
    SELECT AVG(annual_income)
    FROM customers
)
ORDER BY annual_income DESC;

-- Customers earning above their city average
SELECT c.customer_id, c.city, c.annual_income
FROM customers c
WHERE c.annual_income > (
    SELECT AVG(c2.annual_income)
    FROM customers c2
    WHERE c2.city = c.city
)
ORDER BY c.city, c.annual_income DESC;


-- =========================================================
-- 3. ACCOUNT ANALYSIS
-- =========================================================

-- Average account balance by account type
SELECT account_type,
       ROUND(AVG(balance), 2) AS avg_balance
FROM accounts
GROUP BY account_type
ORDER BY avg_balance DESC;


-- =========================================================
-- 4. TRANSACTION ANALYSIS
-- =========================================================

-- Transaction count by customer
SELECT c.customer_id,
       COUNT(t.transaction_id) AS transaction_count
FROM customers c
JOIN transactions1 t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY transaction_count DESC;

-- Top 10 customers by transaction frequency
SELECT c.customer_id,
       COUNT(t.transaction_id) AS transaction_count
FROM customers c
JOIN transactions1 t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY transaction_count DESC
LIMIT 10;

-- Top 10 customers by transaction value
SELECT c.customer_id,
       SUM(t.amount) AS total_transaction_value,
       COUNT(t.transaction_id) AS transaction_count
FROM customers c
JOIN transactions1 t
    ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY total_transaction_value DESC
LIMIT 10;

-- Transaction value by city
SELECT c.city,
       SUM(t.amount) AS total_transaction_value
FROM customers c
JOIN transactions1 t
    ON c.customer_id = t.customer_id
GROUP BY c.city
ORDER BY total_transaction_value DESC;

-- Debit vs Credit by city
SELECT c.city,
       SUM(CASE WHEN t.transaction_type = 'Debit' THEN t.amount ELSE 0 END) AS total_debit,
       SUM(CASE WHEN t.transaction_type = 'Credit' THEN t.amount ELSE 0 END) AS total_credit,
       SUM(CASE WHEN t.transaction_type = 'Credit' THEN t.amount ELSE 0 END)
       - SUM(CASE WHEN t.transaction_type = 'Debit' THEN t.amount ELSE 0 END)
       AS credit_debit_difference
FROM customers c
JOIN transactions1 t
    ON c.customer_id = t.customer_id
GROUP BY c.city
ORDER BY credit_debit_difference DESC;

-- Average transaction amount and count by type
SELECT transaction_type,
       ROUND(AVG(amount), 2) AS avg_transaction_amount,
       COUNT(transaction_id) AS transaction_count
FROM transactions1
GROUP BY transaction_type
ORDER BY avg_transaction_amount DESC;

-- Transaction value by channel
SELECT channel,
       COUNT(transaction_id) AS transaction_count,
       ROUND(SUM(amount), 2) AS total_transaction_value
FROM transactions1
GROUP BY channel
ORDER BY total_transaction_value DESC;

-- Merchant category analysis
SELECT merchant_category,
       COUNT(transaction_id) AS transaction_count,
       ROUND(SUM(amount), 2) AS total_transaction_value
FROM transactions1
GROUP BY merchant_category
ORDER BY transaction_count DESC;

-- Monthly transaction value
SELECT DATE_FORMAT(
           STR_TO_DATE(transaction_date, '%Y-%m-%d'),
           '%Y-%m'
       ) AS month,
       ROUND(SUM(amount), 2) AS total_transaction_value,
       COUNT(transaction_id) AS transaction_count
FROM transactions1
GROUP BY DATE_FORMAT(
           STR_TO_DATE(transaction_date, '%Y-%m-%d'),
           '%Y-%m'
       )
ORDER BY month;

-- Transaction data completeness check
SELECT COUNT(*) AS total_rows,
       COUNT(transaction_id) AS transaction_ids,
       COUNT(transaction_date) AS transaction_dates,
       COUNT(amount) AS transaction_amounts
FROM transactions1;


-- =========================================================
-- 5. LOAN ANALYSIS
-- =========================================================

-- Loan count by type
SELECT loan_type,
       COUNT(loan_id) AS loan_count
FROM loan1
GROUP BY loan_type
ORDER BY loan_count DESC;

-- Average loan amount by type
SELECT loan_type,
       ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM loan1
GROUP BY loan_type
ORDER BY avg_loan_amount DESC;

-- Loan status distribution
SELECT loan_status,
       COUNT(loan_id) AS loan_count
FROM loan1
GROUP BY loan_status
ORDER BY loan_count DESC;

-- Default rate by loan type
SELECT loan_type,
       COUNT(loan_id) AS total_loans,
       SUM(CASE WHEN loan_status = 'Defaulted' THEN 1 ELSE 0 END)
           AS defaulted_loans,
       ROUND(
           SUM(CASE WHEN loan_status = 'Defaulted' THEN 1 ELSE 0 END)
           * 100.0 / COUNT(loan_id),
           2
       ) AS default_rate
FROM loan1
GROUP BY loan_type
ORDER BY default_rate DESC;

-- Defaulted loan exposure by type
SELECT loan_type,
       ROUND(SUM(
           CASE WHEN loan_status = 'Defaulted'
                THEN loan_amount ELSE 0 END
       ), 2) AS defaulted_loan_amount
FROM loan1
GROUP BY loan_type
ORDER BY defaulted_loan_amount DESC;

-- Churn probability by loan type
SELECT l.loan_type,
       COUNT(DISTINCT l.customer_id) AS customer_count,
       ROUND(AVG(cb.churn_probability), 4) AS avg_churn_probability
FROM loan1 l
JOIN customer_behaviours cb
    ON l.customer_id = cb.customer_id
GROUP BY l.loan_type
ORDER BY avg_churn_probability DESC;


-- =========================================================
-- 6. COMPLAINT ANALYSIS
-- =========================================================

-- Complaint volume by category
SELECT category,
       COUNT(complaint_id) AS complaint_count
FROM complaint
GROUP BY category
ORDER BY complaint_count DESC;

-- Average satisfaction by category
SELECT category,
       ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction
FROM complaint
GROUP BY category
ORDER BY avg_satisfaction ASC;

-- Average resolution time by category
SELECT category,
       ROUND(AVG(resolution_days), 2) AS avg_resolution_days
FROM complaint
GROUP BY category
ORDER BY avg_resolution_days DESC;


-- =========================================================
-- 7. CHURN ANALYSIS
-- =========================================================

-- Overall churn
SELECT churn_flag,
       COUNT(*) AS customer_count,
       ROUND(
           COUNT(*) * 100.0 /
           (SELECT COUNT(*) FROM customer_behaviours),
           2
       ) AS percentage
FROM customer_behaviours
GROUP BY churn_flag;

-- Churn by city
SELECT c.city,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN cb.churn_flag = 'Yes' THEN 1 ELSE 0 END)
           AS churned_customers,
       ROUND(
           SUM(CASE WHEN cb.churn_flag = 'Yes' THEN 1 ELSE 0 END)
           * 100.0 / COUNT(*),
           2
       ) AS churn_rate
FROM customers c
JOIN customer_behaviours cb
    ON c.customer_id = cb.customer_id
GROUP BY c.city
ORDER BY churn_rate DESC;

-- Churn by income band
SELECT c.income_band,
       COUNT(*) AS total_customers,
       SUM(CASE WHEN cb.churn_flag = 'Yes' THEN 1 ELSE 0 END)
           AS churned_customers,
       ROUND(
           SUM(CASE WHEN cb.churn_flag = 'Yes' THEN 1 ELSE 0 END)
           * 100.0 / COUNT(*),
           2
       ) AS churn_rate
FROM customers c
JOIN customer_behaviours cb
    ON c.customer_id = cb.customer_id
GROUP BY c.income_band
ORDER BY churn_rate DESC;

-- Churn by complaint status
SELECT
    CASE
        WHEN cb.complaint_count = 0 THEN 'No Complaints'
        ELSE '1+ Complaints'
    END AS complaint_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN cb.churn_flag = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN cb.churn_flag = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customer_behaviours cb
GROUP BY
    CASE
        WHEN cb.complaint_count = 0 THEN 'No Complaints'
        ELSE '1+ Complaints'
    END
ORDER BY churn_rate DESC;

-- Churn by engagement
SELECT
    CASE
        WHEN login_frequency_monthly < 5 THEN 'Low Engagement'
        WHEN login_frequency_monthly < 10 THEN 'Medium Engagement'
        ELSE 'High Engagement'
    END AS engagement_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_flag = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn_flag = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM customer_behaviours
GROUP BY
    CASE
        WHEN login_frequency_monthly < 5 THEN 'Low Engagement'
        WHEN login_frequency_monthly < 10 THEN 'Medium Engagement'
        ELSE 'High Engagement'
    END
ORDER BY churn_rate DESC;


-- =========================================================
-- 8. CUSTOMER VALUE + RISK
-- =========================================================

-- Rank customers by transaction value
WITH customer_value AS (
    SELECT customer_id,
           SUM(amount) AS total_transaction_value
    FROM transactions1
    GROUP BY customer_id
)
SELECT customer_id,
       ROUND(total_transaction_value, 2) AS total_transaction_value,
       RANK() OVER (
           ORDER BY total_transaction_value DESC
       ) AS value_rank
FROM customer_value
ORDER BY value_rank
LIMIT 10;

-- Top 100 high-value customers with churn information
WITH customer_value AS (
    SELECT customer_id,
           SUM(amount) AS total_transaction_value,
           COUNT(transaction_id) AS transaction_count
    FROM transactions1
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT customer_id,
           total_transaction_value,
           transaction_count,
           RANK() OVER (
               ORDER BY total_transaction_value DESC
           ) AS value_rank
    FROM customer_value
)
SELECT r.customer_id,
       ROUND(r.total_transaction_value, 2) AS total_transaction_value,
       r.transaction_count,
       r.value_rank,
       cb.churn_probability,
       cb.churn_flag,
       cb.complaint_count,
       cb.login_frequency_monthly
FROM ranked_customers r
JOIN customer_behaviours cb
    ON r.customer_id = cb.customer_id
WHERE r.value_rank <= 100
ORDER BY r.value_rank;

-- Correct approach when combining multiple one-to-many datasets
WITH transaction_summary AS (
    SELECT customer_id,
           SUM(amount) AS total_transaction_value,
           COUNT(transaction_id) AS transaction_count
    FROM transactions1
    GROUP BY customer_id
),
loan_summary AS (
    SELECT customer_id,
           SUM(loan_amount) AS total_loan_amount
    FROM loan1
    GROUP BY customer_id
)
SELECT t.customer_id,
       ROUND(t.total_transaction_value, 2) AS total_transaction_value,
       t.transaction_count,
       ROUND(l.total_loan_amount, 2) AS total_loan_amount
FROM transaction_summary t
JOIN loan_summary l
    ON t.customer_id = l.customer_id
ORDER BY t.total_transaction_value DESC
LIMIT 10;


-- =========================================================
-- END OF ANALYSIS
-- =========================================================
