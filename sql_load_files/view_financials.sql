CREATE VIEW financials AS
SELECT
    t.transaction_id,
    t.transaction_date,
    p.product_name,
    p.category,
    c.customer_name,
    c.segment,
    r.region_name,
    t.quantity,
    t.revenue,
    t.cost,
    (t.revenue - t.cost) AS profit
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN customers c ON t.customer_id = c.customer_id
JOIN regions r ON t.region_id = r.region_id;

SELECT *
FROM financials
LIMIT 1000;