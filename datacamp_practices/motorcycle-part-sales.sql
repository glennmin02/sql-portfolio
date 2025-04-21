--Finding wholesale net revenue each product_line generated per month per warehouse in the dataset.
SELECT 
    product_line, 
    TO_CHAR(date, 'Month') AS month, 
    warehouse, 
    (SUM(total) - SUM(payment_fee)) AS net_revenue
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY product_line, month, warehouse
ORDER BY product_line, month, net_revenue DESC;
