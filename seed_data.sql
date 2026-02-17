USE ecomm;

-- Categories
INSERT INTO categories (name) VALUES
('Electronics'),
('Books'),
('Clothing'),
('Home'),
('Sports'),
('Toys'),
('Beauty'),
('Automotive'),
('Music'),
('Food');

-- Users 
DELIMITER $$

CREATE PROCEDURE seed_users()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 100 DO
        INSERT INTO users (email, password_hash, full_name)
        VALUES (
            CONCAT('user', i, '@mail.com'),
            CONCAT('hash', i),
            CONCAT('User ', i)
        );

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL seed_users();
DROP PROCEDURE seed_users;

-- Products 
DELIMITER $$

CREATE PROCEDURE seed_products()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 200 DO
        INSERT INTO products (name, description, price, category_id)
        VALUES (
            CONCAT('Product ', i),
            CONCAT('Description for product ', i),
            ROUND(RAND() * 500 + 5, 2),
            FLOOR(1 + RAND() * 10)
        );

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL seed_products();
DROP PROCEDURE seed_products;

-- Inventory for all products
INSERT INTO inventory (product_id, stock)
SELECT product_id, FLOOR(RAND() * 100)
FROM products;

-- Carts 
INSERT INTO carts (user_id)
SELECT user_id
FROM users;

-- Cart Items
INSERT INTO cart_items (cart_id, product_id, quantity)
SELECT
    c.cart_id,
    FLOOR(1 + RAND() * 200),
    FLOOR(1 + RAND() * 5)
FROM carts c;

-- Add extra items so carts aren't empty
INSERT INTO cart_items (cart_id, product_id, quantity)
SELECT
    c.cart_id,
    FLOOR(1 + RAND() * 200),
    FLOOR(1 + RAND() * 5)
FROM carts c
WHERE RAND() > 0.5;



-- Orders
DELIMITER $$

CREATE PROCEDURE seed_orders()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 300 DO
        INSERT INTO orders (user_id, total, status)
        VALUES (
            FLOOR(1 + RAND() * 100),
            ROUND(RAND() * 1000 + 20, 2),
            'completed'
        );

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL seed_orders();
DROP PROCEDURE seed_orders;

-- Order Items
INSERT INTO order_items (order_id, product_id, price_at_purchase, quantity)
SELECT
    o.order_id,
    FLOOR(1 + RAND() * 200),
    ROUND(RAND() * 500 + 5, 2),
    FLOOR(1 + RAND() * 5)
FROM orders o;

INSERT INTO payments (order_id, amount, method)
SELECT
    order_id,
    total,
    ELT(FLOOR(1 + RAND() * 5),
        'credit_card',
        'debit_card',
        'paypal',
        'apple_pay',
        'google_pay'
    )
FROM orders;

-- Reviews
INSERT INTO reviews (user_id, product_id, rating, comment)
SELECT
    FLOOR(1 + RAND() * 100),
    FLOOR(1 + RAND() * 200),
    1 + FLOOR(RAND() * 5),
    'Auto-generated review'
FROM products
LIMIT 150;

