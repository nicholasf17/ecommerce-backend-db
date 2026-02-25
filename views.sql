USE ecomm;

CREATE VIEW monthly_revenue AS
SELECT DATE_FORMAT(created_at, '%Y-%m') AS month,
       SUM(total) AS revenue
FROM orders
GROUP BY month;

CREATE VIEW top_products AS
SELECT p.name,
       SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id;

CREATE VIEW customer_lifetime_value AS
SELECT u.user_id,
       u.full_name,
       SUM(o.total) AS lifetime_value
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;