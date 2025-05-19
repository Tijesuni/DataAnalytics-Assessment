/* Drop it first if you’re rerunning the script in the same session */
DROP TEMPORARY TABLE IF EXISTS tmp_customer_frequency;

/* Create a temporary table */
CREATE TEMPORARY TABLE tmp_customer_frequency AS
WITH month_transactions AS (
    SELECT
        savings.owner_id,                    -- to select each user
        DATE_FORMAT(savings.transaction_date, '%Y-%m') AS ym,              -- converting the date to just year and month 
        COUNT(*) AS transactions_in_month              -- to count the number of transactions each user make per month
    FROM savings_savingsaccount AS savings
    WHERE savings.transaction_status = 'success'
    GROUP BY savings.owner_id, ym
),

/* Compute the average transactions each customer performs in a month */
avg_transactions AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month    -- find the monthly avarage transaction
    FROM month_transactions
    GROUP BY owner_id
)

/* Classify customers by frequency */
SELECT
    ROUND(a.avg_transactions_per_month, 2) AS avg_transactions_per_month,    -- rounded by 2 d.p
    CASE
        WHEN a.avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN a.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
FROM avg_transactions AS a
JOIN adashi_staging.users_customuser AS customer ON customer.id = a.owner_id
ORDER BY a.avg_transactions_per_month DESC;

/* Show the Frequency category, Customer count and the Average transaction per Month */
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM   tmp_customer_frequency
GROUP  BY frequency_category
ORDER  BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');