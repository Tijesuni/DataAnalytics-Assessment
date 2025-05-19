/* Collapse all money-movement rows into customer totals */

WITH total_transactions AS (
    SELECT
        savings.owner_id,
        COUNT(*) AS total_transaction,
        SUM(savings.amount) AS total_value
    FROM   savings_savingsaccount AS savings
    WHERE  savings.transaction_status = 'success'      -- only completed inflows/outflows
        AND  savings.amount <> 0                         -- ignore rows with savings amount = 0
    GROUP  BY savings.owner_id
)

/* Combine with the user's table and calculate the metrics */
SELECT
    customer.id AS customer_id,
    concat(customer.first_name, ' ', customer.last_name) AS name,

    -- tenure in whole months (>=1)
    GREATEST(TIMESTAMPDIFF(MONTH, customer.date_joined, CURRENT_DATE),1) AS tenure_months,
    t.total_transaction AS total_transactions,
    -- profit per txn = 0.1 % of the txn value
    -- 0.001 * t.total_value AS total_profit,

    /* CLV = (total_transaction / tenure) * 12 * avg_profit_per_txn
				= total_transaction / tenure) * 12 * (total_profit / total_transaction)
				= total_profit * 12 / tenure 
	 */
    
	/* Finds the clv and rounded off to 2 d.p */
    ROUND((0.001 * t.total_value) * 12 / GREATEST(TIMESTAMPDIFF(MONTH, customer.date_joined, CURRENT_DATE), 1), 2) AS estimated_clv

FROM users_customuser AS customer
LEFT JOIN  total_transactions AS t ON t.owner_id = customer.id
WHERE customer.is_active = 1
ORDER BY estimated_clv DESC;
