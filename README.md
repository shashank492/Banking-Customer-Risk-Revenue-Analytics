# ABC Bank — Customer Risk & Transaction Analytics

## Project Overview
An end-to-end Data Analyst portfolio project for a fictional bank, ABC Bank. The project analyzes customer behavior, transactions, loans, complaints, customer value and churn risk.

**Workflow:** Raw Data → Cleaning → MySQL → Python → Power BI → Business Insights → Recommendations

> ABC Bank and all data are fictional and created for educational/portfolio purposes.

## Business Problem
ABC Bank wants to understand customer activity, churn, customer value, complaints and loan risk.

Key questions:
- Where is the customer base concentrated?
- Which customers generate higher transaction value?
- How does churn vary across customer groups?
- Which complaint areas need attention?
- How does loan default risk vary by loan type?
- Which high-value customers show higher-risk signals?
- What measurable actions can management test?

## Tools
- Excel — data inspection and cleaning
- MySQL — relational analysis
- Python — Pandas, NumPy, Matplotlib, Seaborn
- Power BI — dashboards, DAX and business storytelling
- Snowflake — cloud data warehouse learning
- AWS S3 & IAM — cloud learning
- GenAI — analytical assistance and documentation

## Dataset

| Dataset | Records | Description |
|---|---:|---|
| customers.csv | 5,000 | Customer demographics, income and location |
| accounts.csv | 5,000 | Account type, balance and credit limit |
| transactions.csv | 80,000 | Transaction activity and value |
| loans.csv | 3,000 | Loan type, amount and status |
| complaints.csv | 4,500 | Complaint category, resolution and satisfaction |
| customer_behavior.csv | 5,000 | Engagement and churn indicators |
| **Total** | **102,500** | **Complete analytical dataset** |

Relationships:
- One customer → one account
- One customer → many transactions
- One customer → many loans
- One customer → many complaints
- One customer → one behavior record

## Data Cleaning
Quality checks included duplicate IDs, missing values, invalid numeric values, date validation, category standardization, data types, numeric ranges and referential consistency.

Issues handled included missing city, occupation, annual income and transaction amount, a lowercase transaction channel, and an invalid negative complaint resolution value.

## Project Architecture

```text
Raw CSV Data
     ↓
Data Quality Checks & Cleaning
     ↓
    MySQL
     ↓
 ┌───┴───────────┐
 ↓               ↓
Python          Power BI
 ↓               ↓
EDA             Dashboard
 └───────┬───────┘
         ↓
 Business Insights
         ↓
 Recommendations
```

## SQL Analysis
SQL analysis covered customer concentration, income, transaction frequency and value, city activity, debit/credit activity, channels, merchant categories, monthly trends, loan volume and defaults, complaints, churn and high-value customer risk.

Techniques used:
- SELECT, WHERE, GROUP BY, HAVING, ORDER BY
- INNER/LEFT JOIN
- CASE WHEN and conditional aggregation
- Scalar and correlated subqueries
- CTEs
- Window functions and RANK
- Date functions

A key SQL learning was avoiding row multiplication when joining multiple one-to-many tables by aggregating each dataset at customer level before joining.

## Python Analysis
Python was used for:
- Dataset profiling and quality checks
- Descriptive statistics
- Age and income distributions
- Transaction distributions
- Channel and merchant-category analysis
- Monthly transaction trends
- Customer transaction frequency and value
- Churn analysis
- Complaint and engagement analysis
- Customer value segmentation
- High-value customer and churn-risk analysis

## Power BI Dashboard
The final Power BI report contains **3 pages**.

### Page 1 — Executive Overview
KPIs:
- Total Customers
- Total Transactions
- Total Transaction Value
- Average Transaction Value
- Churned Customers
- Churn Rate

Visuals include customers by city, monthly transaction value, transaction type, loan portfolio/status and complaint volume, satisfaction and resolution analysis.

### Page 2 — Customer Risk & Retention
Includes:
- Loan Default Rate by Loan Type
- Defaulted Loan Amount by Loan Type
- Churn by Engagement
- Churn by Income Band
- Churn by City
- Churn by Complaint Group
- Customer Segment Distribution

### Page 3 — Customer Risk & Value Deep Dive
Includes:
- High-Value Customers & Churn Risk
- Top 10 Customers by Transaction Value
- Top 20 Customer Risk & Value Analysis

Customer-level analysis includes transaction value, transaction count, churn probability, churn flag, complaints, login frequency and customer segment.

## Key Findings
- 5,000 customers analyzed.
- Bengaluru is the largest customer city with approximately 970 customers.
- 80,000 transactions analyzed.
- Total transaction value is approximately **₹23.77 crore**.
- Average transaction value is approximately **₹2,972**.
- UPI represents approximately 43% of transaction activity/value.
- Monthly transaction value fluctuates rather than showing continuous growth.
- 708 customers are marked as churned, giving a **14.16% churn baseline**.
- Churn varies by city, income, engagement and complaints, but observed differences should not be interpreted as causal.
- 4,500 complaints analyzed; Transaction Issues have the highest volume, Service has the lowest average satisfaction, and Loan Issues have the longest average resolution time.
- 3,000 loans analyzed; Personal loans have the highest count, Auto loans have the highest average size, and overall default rate is approximately **4.5%**.
- Defaulted loan amount represents exposure, not automatically a bank loss.

## Business Recommendations
1. Target high-value customers showing risk signals with tested retention programs.
2. Investigate uneven transaction activity by city, segment, channel and engagement.
3. Improve high-volume and low-satisfaction complaint areas.
4. Monitor digital transaction channels such as UPI for reliability and complaint patterns.
5. Monitor loan default rates and exposure by loan type and customer segment.

Recommended KPIs include churn, retention, transactions/customer, transaction value/customer, monthly active customers, complaint volume, resolution time, satisfaction and default rate.

## GenAI Usage
GenAI supported business-question generation, SQL structuring, analytical interpretation, segmentation brainstorming, documentation and interview preparation. Calculations and conclusions were validated against the underlying data.

## Analytical Limitations
- The dataset is fictional.
- Churn analysis is observational and does not establish causation.
- No external industry benchmark was used to classify the 14.16% churn rate as high or low.
- Transaction value is not bank revenue or profit.
- Defaulted loan amount is exposure, not automatically financial loss.
- Segmentation thresholds should be validated against historical outcomes.

## Project Structure

```text
Banking-Customer-Risk-Revenue-Analytics/
├── data/
├── sql/
│   └── banking_analysis.sql
├── python/
│   └── banking_analysis.py
├── powerbi/
│   └── Banking_Analytics.pbix
├── screenshots/
└── documentation/
    ├── ABC_Bank_Business_Recommendations.docx
    └── ABC_Bank_Management_Action_Plan.docx
```

## Project Outcome
This project demonstrates an end-to-end Data Analyst workflow:

**Business Problem → Data Quality → SQL → Python → Power BI → Insights → Recommendations**

The analysis connects technical data work with business questions and measurable management actions.

## Interview Summary
> I built an end-to-end banking customer risk and transaction analytics project using Excel, MySQL, Python and Power BI. The project contains 102,500 records across customers, accounts, transactions, loans, complaints and customer behavior. I used MySQL for relational analysis with joins, aggregations, subqueries, CTEs and window functions; Python for deeper EDA and segmentation; and Power BI for a three-page interactive report covering executive KPIs, transactions, churn, complaints, loans and customer-level risk/value analysis. The analysis established a 14.16% churn baseline and identified customer-value, risk and operational patterns that could support targeted business actions.

---
**Disclaimer:** ABC Bank is fictional and all datasets/results are synthetic.
