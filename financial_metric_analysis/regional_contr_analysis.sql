/* This sql query analyzes the contribution of different regions to the overall financial metrics.
 Step-by-step behavior:
1. Joins the transactions table with the regions table to get region details.
2. Groups sales by region (region_name).   
3. Calculates: Total revenue per region
4. Calculates overall total revenue across all regions.
5. Computes each region's contribution percentage to the overall revenue by dividing region revenue by total revenue.
6. Orders the results by contribution percentage in descending order to identify the most contributing regions.
*/

WITH regional_revenue AS (
    SELECT
        r.region_name,
        SUM(t.revenue) AS region_revenue
    FROM transactions t
    JOIN regions r ON t.region_id = r.region_id
    GROUP BY r.region_name
),
total_revenue AS (
    SELECT SUM(region_revenue) AS total_revenue
    FROM regional_revenue
)
SELECT
    rr.region_name,
    rr.region_revenue,
    ROUND(
        rr.region_revenue / tr.total_revenue * 100,
        2
    ) AS contribution_pct
FROM regional_revenue rr
CROSS JOIN total_revenue tr
ORDER BY contribution_pct DESC;
