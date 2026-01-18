# SQL Finance Analysis 📊💰

## Introduction
This project demonstrates how SQL can be used to perform **practical financial analysis** on transactional business data.  
The objective is to go beyond basic querying and apply SQL across the **entire data analysis pipeline** — from raw financial data to business-ready insights.

The analysis focuses on key finance metrics such as:
- Revenue growth
- Profitability
- Customer lifetime value
- Regional performance
- Rolling (trend-based) revenue analysis



SQL queries? Check them out here: [financial_metric_analysis folder](/financial_metric_analysis/)

---

## Background
After completing foundational SQL learning, this project was designed to **solidify understanding through applied analysis** rather than isolated queries.

The dataset represents a simplified but realistic business environment consisting of:
- Customers
- Products (with associated costs)
- Regions
- Sales transactions over time

My goal was to answer **business-driven questions**, not just technical ones, and to interpret results in a way that supports **decision-making**.

---

## Tools I Used
- **PostgreSQL** – relational database and query execution  
- **SQL** – CTEs, joins, aggregations, and window functions  
- **CSV datasets** – imported as relational tables  
- **Financial analysis concepts** – revenue growth, margins, CLV, rolling metrics  

---

## The Analysis

### 1️⃣ Month-over-Month (MoM) Revenue Growth

**Business Question:**  
Is the business growing month over month, and at what rate?

 **Logic:**  
- Aggregate revenue by month  
- Compare each month’s revenue with the previous month  
- Calculate percentage growth  

```sql
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(quantity * unit_price) AS total_revenue
    FROM transactions
    GROUP BY 1
),
mom_growth AS (
    SELECT
        month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY month) AS prev_month_revenue
    FROM monthly_revenue
)
SELECT
    month,
    total_revenue,
    prev_month_revenue,
    ROUND(
        (total_revenue - prev_month_revenue) / prev_month_revenue * 100,
        2
    ) AS mom_growth_percent
FROM mom_growth
ORDER BY month;
```
**Key Insight:**
The average MoM revenue growth was approximately 0.31%, indicating slow but stable growth rather than rapid expansion.

### 2️⃣ Rolling 3-Month Revenue (Trailing Quarterly Performance)
**Business Question:**
What is the underlying revenue trend when short-term volatility is smoothed?

 **Logic:**
- Calculate monthly revenue
- Apply a rolling 3-month window to capture trailing performance

```sql
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(quantity * unit_price) AS monthly_revenue,
    SUM(SUM(quantity * unit_price)) OVER (
        ORDER BY DATE_TRUNC('month', transaction_date)
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_month_revenue
FROM transactions
GROUP BY 1
ORDER BY month;
```
**Key Insight:**
The monthly revenue appears (trends) to be predictably stable averaging around about $100,000 monthly, ie about $300,000 in a 3-month window.

Rolling revenue behaves like a moving quarterly report, offering earlier visibility into performance trends than fixed quarterly reporting.


### 3️⃣ Top Products by Profit Margin (Not Revenue)
**Business Question:**
Which products are most profitable relative to their sales?

**Logic:**
- Join transaction data with product cost data
- Calculate revenue, cost, profit, and profit margin
- Rank products by margin efficiency

```sql

SELECT
    p.product_name,
    SUM(t.quantity * t.unit_price) AS revenue,
    SUM(t.quantity * p.unit_cost) AS cost,
    SUM(t.quantity * t.unit_price) - SUM(t.quantity * p.unit_cost) AS profit,
    ROUND(
        (SUM(t.quantity * t.unit_price) - SUM(t.quantity * p.unit_cost))
        / SUM(t.quantity * t.unit_price) * 100,
        2
    ) AS profit_margin_percent
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_name
ORDER BY profit_margin_percent DESC;
```
**Key Insight:**
All products appear to have similar margin efficiency (profit margin) of around 30%. Indicating an even return from all products which is not a perfectly realistic market. It likely reflects how the dataset was generated, implying artificially balanced product margins. 

High revenue does not always imply high profitability — profit margin is a stronger indicator of product performance.

### 4️⃣ Customer Lifetime Value (CLV)
**Business Question:**
Which customers contribute the most long-term value to the business?

 **Logic:**
- Aggregate revenue and cost per customer
- Compute lifetime profitability by subtracting lifetime cost from lifetime revenue

```sql
SELECT
    c.customer_id,
    c.customer_name,
    SUM(t.quantity * t.unit_price) AS lifetime_revenue,
    SUM(t.quantity * p.unit_cost) AS lifetime_cost,
    SUM(t.quantity * t.unit_price) - SUM(t.quantity * p.unit_cost) AS customer_lifetime_value
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
JOIN products p ON t.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_lifetime_value DESC;
```
#### Table 1: Customer Lifetime Value (CLV)

| Customer Name | Lifetime Revenue | Lifetime Cost | Lifetime Profit |
|---------------|------------------|---------------|-----------------|
| Vertex Stores | 286,915          | 199,400       | 87,515          |
| Alpha Stores  | 286,909          | 199,991       | 86,918          |
| Prime Supplies| 280,027          | 195,307       | 84,720          |

**As shown in Table 1, CLV varies significantly despite similar revenue levels.**

**Key Insight:**
Though it is worth noting that the data was synthetically balanced as real world Data on customers are unlikely to be so evenly distributed. That said, 
CLV analysis helps prioritize customer retention and segmentation, I.e helps a business know which customers to focus on for better results (revenue and profit), rather than treating all customers equally.

### 5️⃣ Regional Revenue Contribution %
**Business Question:**
How much does each region contribute to total revenue?

 **Logic:**

- Aggregate revenue by region
- Calculate combined total revenue of all regions
- Calculate each region’s percentage contribution

```sql
WITH regional_revenue AS (
    SELECT
        r.region_name,
        SUM(t.quantity * t.unit_price) AS revenue
    FROM transactions t
    JOIN regions r ON t.region_id = r.region_id
    GROUP BY r.region_name
),
total_revenue AS (
    SELECT SUM(revenue) AS total FROM regional_revenue
)
SELECT
    rr.region_name,
    rr.revenue,
    ROUND(rr.revenue / tr.total * 100, 2) AS contribution_percent
FROM regional_revenue rr
CROSS JOIN total_revenue tr
ORDER BY contribution_percent DESC;
```
#### Table 2: Regional Revenue Contribution

| Region Name | Region Revenue | Contribution Percent (%) |
|------------|----------------|--------------------------|
| West       | 675,044        | 25.38                    |
| South      | 674,582        | 25.37                    |
| North      | 671,451        | 25.25                    |
| East       | 638,306        | 24.00                    |

**Key Insight:**
Regional contributions were relatively even, suggesting a balanced or synthetic dataset, which is useful for learning but uncommon in real markets.


## What I Learned


- How to frame business questions and translate them into SQL logic


- Effective use of window functions for time-series analysis



- Why profitability often matters more than revenue


- How to critically evaluate whether results are realistic, not just correct



## Conclusions


- The business demonstrates stable but slow growth, which may be acceptable for mature companies but weak for growth-stage firms



- Profit margin and CLV analyses reveal insights that revenue alone cannot


- Balanced regional performance should be questioned in real-world scenarios


- SQL is most powerful when used as a decision-support tool, not just a querying language


