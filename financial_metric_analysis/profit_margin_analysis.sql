/* This SQL query calculates the profit margin percentage for each product
 by aggregating revenue and cost data from transactions. 
 Step-by-step behavior:
1. Joins the transactions table with the products table to get product names.Basic Logic
2. Group sales by product(product_name)
3. Calculate: Total revenue per product
                Total cost per product
4. Compute profit: Profit = Revenue − Cost
5. Calculate profit margin percentage: Profit Margin % = (Profit ÷ Revenue) × 100
6. Filters out products with zero revenue to avoid division by zero errors.
7. Orders the results by profit margin percentage(not revenue) in descending order and limits the output to the top 10 products.

*/

SELECT
    p.product_name,
    SUM(t.revenue) AS total_revenue,
    SUM(t.cost) AS total_cost,
    SUM(t.revenue - t.cost) AS profit,
    ROUND(
        SUM(t.revenue - t.cost) / SUM(t.revenue) * 100,
        2
    ) AS profit_margin_pct
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(t.revenue) > 0
ORDER BY profit_margin_pct DESC
LIMIT 10;
