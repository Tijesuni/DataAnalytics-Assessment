/* ----------------------------------------
   CTE 1: savings_totals
   Description: Retrieve customers who have made at least one successful savings deposit.
   - Filters for only successful transactions with a positive amount.
   - Aggregates total number and total value of savings deposits per customer.
---------------------------------------- */
WITH savings_totals AS (
    SELECT
        savings.owner_id,                             -- Unique identifier for each customer
        COUNT(*) AS savings_count,                    -- Total number of successful savings transactions
        SUM(savings.amount) AS savings_deposit        -- Total amount deposited across all savings transactions
    FROM   savings_savingsaccount AS savings
    WHERE  savings.transaction_status = 'success'     -- Only include successful transactions
      AND  savings.amount > 0                         -- Exclude zero or negative transactions
    GROUP  BY savings.owner_id
),

/* ----------------------------------------
   CTE 2: plan_totals
   Description: Retrieve customers who have made at least one successful investment into a funded plan.
   - Filters for valid plans (fixed, not deleted, not archived).
   - Includes only successful, positive-amount transactions tied to those plans.
   - Aggregates count and total amount of funded investment plans per customer.
---------------------------------------- */
plan_totals AS (
    SELECT
        plan.owner_id,
        COUNT(DISTINCT plan.id) AS inv_count,           -- Total number of unique investment plans funded
        SUM(plan.amount) AS inv_deposit                 -- Total amount deposited across all plans
    FROM   plans_plan AS plan
    JOIN   savings_savingsaccount AS savings            -- Join to get funding transaction details
        ON savings.plan_id = plan.id
        AND savings.transaction_status = 'success'
        AND savings.amount > 0
    WHERE  plan.is_fixed_investment = 1                 -- Include only fixed investment plans
      AND  plan.is_deleted  = 0                         -- Exclude deleted plans
      AND  plan.is_archived = 0                         -- Exclude archived plans
    GROUP  BY plan.owner_id
)

/* ----------------------------------------
   Final SELECT: Combine Savings and Investment Data
   Description:
   - Only include customers who have both savings and investment records.
   - Join customer information for reporting.
   - Calculate total deposits by summing savings and investment contributions.
---------------------------------------- */
SELECT
    customer.id AS owner_id,
    concat(customer.first_name, ' ', customer.last_name) AS name,             -- Full customer name
    savings_totals.savings_count,                                             -- Number of savings transactions
    plan_totals.inv_count AS investment_count,                                -- Number of investment plans funded
    ROUND((savings_totals.savings_deposit + plan_totals.inv_deposit),2)  AS total_deposits
FROM savings_totals
JOIN plan_totals  ON plan_totals.owner_id = savings_totals.owner_id            -- Match customers who have both savings and investments
JOIN users_customuser AS customer ON customer.id = savings_totals.owner_id     -- Fetch customer profile info
ORDER BY total_deposits DESC;