# DataAnalytics-Assessment

## Table of Content
1. [Introduction](#introduction)
2. [Data Analysis](#data-analysis)
3. [Problem Encountered](#problems-encountered)
3. [Recommendation](#recommendation)

---

### **Introduction**

#### Data Source
The database, adashi_staging.sql, was provided by Cowrywise. It includes four tables which are;
1. users_customuser: contains customer demographic and contact information
2. savings_savingsaccount: contain records of deposit transactions
3. plans_plan: contain records of plans created by customers
4. withdrawals_withdrawal:  contain records of withdrawal transactions

#### Tools Used
MySQL: It ia an open-source Relational Database Management System (RDBMS) that utilises Structured Query Language (SQL) for database operations.

#### Addressed Questions
1. Which customers have both a savings and an investment plan, and how many of each do they possess?
2. What is the average number of transactions of each customers per month, and how frequently do these transactions occur?
3. Which active accounts have not had any transactions in the past year (365 days)?
4. How long has each customer been with us (in months), what is their total transaction, and what is their estimated Customer Lifetime Value (CLV)?

#### Data Loading
The database was directing loading into MySQL using Query tool.

### **Data Analysis**

#### Q1: High-Value Customers with Multiple Products
Obi David stands out with 8,812 savings transactions, 1 investment plan, and a total deposit of ₦38 billion.. This can be seen here [Assessment_Q1.sql](./Assessment_Q1.sql)

#### Q2: Transaction Frequency Analysis
- 110 users exhibit high transaction frequency (average of 32.83).
- 160 users fall into the medium frequency category (average of 4.93).
- 601 users have low transaction frequency (average of 1.45).
This analysis can be seen here [Assessment_Q2.sql](./Assessment_Q2.sql)

#### Q3: Account Inactivity Alert
- All inactive plans exceeding 365 days are savings plans.
- The longest inactive plan spans 3,165 days (~8.7 years). 
This can be seen here [Assessment_Q3.sql](./Assessment_Q3.sql)

#### Q4: Customer Lifetime Value (CLV) Estimation
Edward Popoola has the highest CLV at ₦6,350.53. 
This can be seen here [Assessment_Q4.sql](./Assessment_Q4.sql)

### **Problems Encountered**
1. JOIN Statement Errors
I encountered several errors while working with SQL JOINs. To resolve them, I carefully reviewed my queries and sought assistance from ChatGPT when needed.
2. Unexpected Results from Arithmetic Operations
At times, the results didn't align with expectations, likely due to incorrect arithmetic combinations. I addressed these issues by consulting resources like Google and ChatGPT.

3. Duplicate Rows After JOIN Operations
I noticed duplicate rows appearing post-JOIN operations. By thoroughly examining my queries, I identified and corrected the issues causing the duplication.

### **Recommendation**
1. Enhance Engagement with High-Value Customers: leverage the app to provide tailored financial advice and exclusive services. Utilise AI-driven tools to analyse user behaviour and offer customised insights, helping users make informed financial decisions. This approach ensures that high-value customers like Mr. Obi David receives personalised support directly within the app.

2. Implement Targeted Strategies Based on Transaction Frequency
- High-Frequency Users: keep them engaged with a perks or points programme.
- Medium-Frequency Users: nudge them with personalised offers and product tips.
- Low-Frequency Users: ask for feedback to learn what’s holding them back and fix it.

3. Address Account Inactivity: Run focused campaigns, bonus rates or limited-time rewards—to bring inactive savers back, and review the savings product design to remove any friction.

4. Optimise Customer Lifetime Value: Use AI to spot behaviour patterns, then suggest products that fit each customer’s needs—especially cross-selling investments to pure savers and vice-versa.

