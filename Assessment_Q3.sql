/* Find the last cash inflow of each plan created */
WITH last_cash_inflow AS (
    SELECT
        plan.owner_id AS owner_id,
        plan.id AS plan_id,
        
        /* Checks for whether it's an investment of savings plan */
        CASE WHEN plan.is_fixed_investment = 1
            THEN 'Investment'
            ELSE 'Savings'
        END AS type,
        
        /* Finds the most recent transaction date */
        MAX(savings.transaction_date) AS last_inflow   
    FROM   plans_plan AS plan
    JOIN   savings_savingsaccount AS savings ON savings.plan_id = plan.id AND savings.amount  > 0    -- Joins savings table with the plan table if the amount saved is >0
	
    /* Filters out deleted and archived plans */
    WHERE  plan.is_archived  = 0
      AND  plan.is_deleted = 0
    GROUP  BY plan.owner_id, plan.id, plan.is_fixed_investment, type
)

SELECT
    plan_id,
    owner_id,
    type,
    last_inflow AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_inflow) AS inactivity_days   -- Finds the number of days the plan has been inactive
FROM   last_cash_inflow
WHERE  last_inflow < (CURRENT_DATE - INTERVAL 365 DAY)   -- Filters out those plans that has been inactive for less than a year
ORDER  BY inactivity_days DESC, type, owner_id;