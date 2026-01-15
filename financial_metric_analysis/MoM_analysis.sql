
/* This SQL query calculates the Month-over-Month (MoM) growth in revenue
 through the use of window functions to compare each month's revenue with the previous month's revenue. 
  Step-by-step behavior:
1.The data is grouped by month
2. Each month’s total revenue is calculated
3. Each month is compared to the previous month
4. Growth is calculated as: (Current Month − Previous Month) ÷ Previous Month
 */
 
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) AS month,
        SUM(revenue) AS total_revenue
    FROM transactions
    GROUP BY 1
)
SELECT
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY month))
        / LAG(total_revenue) OVER (ORDER BY month) * 100,
        2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;
