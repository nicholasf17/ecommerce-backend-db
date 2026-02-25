USE ecomm;

-- Monthly Revenue
SELECT DATE_FORMAT(created_at, '%Y-%m') AS month,
SUM(total) as revenue
FROM Orders
GROUP BY month
ORDER BY month;

-- Best Selling Products
SELECT p.name,
SUM(oi.quantity) AS Total_Sold
FROM order_items oi 
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY Total_Sold DESC;

-- Customer Lifetime Purchases Total
SELECT u.full_name,
SUM(o.total) AS Lifetime_Total
FROM users u
JOIN orders o
ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY Lifetime_Total DESC;

-- Average Rating Per Product
SELECT p.name,
AVG(r.rating) AS Avg_Rating
FROM reviews r
JOIN products p
ON r.product_id = p.product_id
GROUP BY p.product_id
ORDER BY Avg_Rating DESC;

-- most used payment method
SELECT method,
COUNT(*) AS usage_count
FROM payments
GROUP BY method
ORDER BY usage_count DESC;