/* 
    This SQL query calculates the rolling 3-month revenue from a transactions table.
    It first aggregates the total revenue per month and then computes the rolling sum
    of revenue over the current month and the two preceding months.
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
    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_3_month_revenue
FROM monthly_revenue
ORDER BY month;
