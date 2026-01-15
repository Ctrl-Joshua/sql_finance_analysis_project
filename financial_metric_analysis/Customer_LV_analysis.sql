-- SQL query to analyze Customer Lifetime Value (CLV) ie “How valuable is each customer to the business over time?”
/* This SQL query calculates the lifetime value of customers by aggregating their transaction data.
 Step-by-step behavior:
1. Joins the transactions table with the customers table to get customer details.
2. Groups sales by customer (customer_name, segment).
3. Calculates: Total number of transactions per customer
                Total revenue per customer
                Total profit per customer
4. Orders the results by lifetime profit in descending order to identify the most valuable customers.
5. Computes average transaction value per customer.
*/

SELECT
    c.customer_name,
    c.segment,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.revenue) AS lifetime_revenue,
    SUM(t.revenue - t.cost) AS lifetime_profit,
    ROUND(SUM(t.revenue) / COUNT(t.transaction_id), 2) AS avg_transaction_value
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_name, c.segment
ORDER BY lifetime_profit DESC;

