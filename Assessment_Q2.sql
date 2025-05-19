-- Drop the temporary table if it already exists (useful when rerunning the script in the same session)
DROP TEMPORARY TABLE IF EXISTS tmp_customer_frequency;

-- Create a temporary table to store customers’ transaction frequency categories
CREATE TEMPORARY TABLE tmp_customer_frequency AS
-- Calculate the number of successful transactions each customer made per month
WITH month_transactions AS (
    SELECT
        savings.owner_id,                   
        DATE_FORMAT(savings.transaction_date, '%Y-%m') AS ym,              -- Convert transaction date to 'YYYY-MM' format
        COUNT(*) AS transactions_in_month                                  -- Total number of transactions per customer per month
    FROM savings_savingsaccount AS savings
    WHERE savings.transaction_status = 'success'                           -- Consider only successful transactions
    GROUP BY savings.owner_id, ym
),

-- Calculate the average number of transactions per month for each customer
avg_transactions AS (
    SELECT
        owner_id,
        AVG(transactions_in_month) AS avg_transactions_per_month          -- find the monthly avarage transaction
    FROM month_transactions                                     
    GROUP BY owner_id
)

-- Categorise customers based on their average monthly transaction frequency
SELECT
    ROUND(a.avg_transactions_per_month, 2) AS avg_transactions_per_month,    -- Round to two decimal places for clarity
    CASE
        WHEN a.avg_transactions_per_month >= 10 THEN 'High Frequency'        
        WHEN a.avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'     
        ELSE 'Low Frequency'
    END AS frequency_category
FROM avg_transactions AS a
JOIN adashi_staging.users_customuser AS customer ON customer.id = a.owner_id
ORDER BY a.avg_transactions_per_month DESC;

-- Summarise the frequency categories by counting the number of customers in each group
-- and calculating the average number of transactions per category
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM   tmp_customer_frequency
GROUP  BY frequency_category
ORDER  BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');