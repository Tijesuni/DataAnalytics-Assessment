/* Savings side – customers with ≥1 funded savings wallet */
WITH savings_totals AS (
    SELECT
        savings.owner_id,  -- get the users that save
        COUNT(*) AS savings_count,   -- number of savings transaction of each user
        SUM(savings.amount) AS savings_deposit  -- total amount of money saved
    FROM   savings_savingsaccount AS savings
    WHERE  savings.transaction_status = 'success'     -- only settled inflows
      AND  savings.amount > 0            -- positive-value
    GROUP  BY savings.owner_id
),

/* Investment side – customers with ≥1 funded plan */
plan_totals AS (
    SELECT
        plan.owner_id,
        COUNT(DISTINCT plan.id) AS inv_count,
        SUM(plan.amount) AS inv_deposit
    FROM   plans_plan AS plan
    JOIN   savings_savingsaccount AS savings
        ON savings.plan_id = plan.id
        AND savings.transaction_status = 'success'
        AND savings.amount > 0
	/* filters out non fixed-investment plan, deleted and archived plans*/
    WHERE  plan.is_fixed_investment = 1           
      AND  plan.is_deleted  = 0
      AND  plan.is_archived = 0
    GROUP  BY plan.owner_id
)

/* Only keep customers who appear in *both* tables */
SELECT
    customer.id AS owner_id,
    concat(customer.first_name, ' ', customer.last_name) AS name,
    savings_totals.savings_count,
    plan_totals.inv_count AS investment_count,
    ROUND((savings_totals.savings_deposit + plan_totals.inv_deposit),2)  AS total_deposits
FROM savings_totals
JOIN plan_totals  ON plan_totals.owner_id = savings_totals.owner_id
JOIN users_customuser AS customer ON customer.id = savings_totals.owner_id
ORDER BY total_deposits DESC;