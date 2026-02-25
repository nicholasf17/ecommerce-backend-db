USE ecomm;

DELIMITER $$
CREATE PROCEDURE RegisterUser(
IN p_email VARCHAR(255),
IN p_password VARCHAR(255),
IN p_name VARCHAR(255)
)
BEGIN
IF EXISTS (SELECT 1 FROM users WHERE email = p_email) 
THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Email already exists';
ELSE 
INSERT INTO users (email, password_hash, full_name)
VALUES (p_email, p_password, p_name);
END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AddToCart(
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_cart_id INT;
    SELECT cart_id INTO v_cart_id
    FROM carts
    WHERE user_id = p_user_id
    LIMIT 1;
    IF v_cart_id IS NULL THEN
        INSERT INTO carts (user_id) VALUES (p_user_id);
        SET v_cart_id = LAST_INSERT_ID();
    END IF;
    IF EXISTS (
        SELECT 1 FROM cart_items
        WHERE cart_id = v_cart_id AND product_id = p_product_id
    ) THEN
        UPDATE cart_items
        SET quantity = quantity + p_quantity
        WHERE cart_id = v_cart_id AND product_id = p_product_id;
    ELSE
        INSERT INTO cart_items (cart_id, product_id, quantity)
        VALUES (v_cart_id, p_product_id, p_quantity);
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE PlaceOrder(IN p_user_id INT)
BEGIN
    DECLARE v_cart_id INT;
    DECLARE v_order_id INT;
    DECLARE v_total DECIMAL(10,2);
    START TRANSACTION;
    SELECT cart_id INTO v_cart_id
    FROM carts
    WHERE user_id = p_user_id
    LIMIT 1;
    IF v_cart_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cart not found';
    END IF;
    -- Check stock 
    IF EXISTS (
        SELECT 1
        FROM inventory i
        JOIN cart_items ci ON i.product_id = ci.product_id
        WHERE ci.cart_id = v_cart_id
        AND i.stock < ci.quantity
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for one or more items';
    END IF;
    -- Calculate total
    SELECT SUM(p.price * ci.quantity)
    INTO v_total
    FROM cart_items ci
    JOIN products p ON ci.product_id = p.product_id
    WHERE ci.cart_id = v_cart_id;
    INSERT INTO orders (user_id, total, status)
    VALUES (p_user_id, v_total, 'completed');
    SET v_order_id = LAST_INSERT_ID();
    -- Insert order items
    INSERT INTO order_items (order_id, product_id, price_at_purchase, quantity)
    SELECT
        v_order_id,
        ci.product_id,
        p.price,
        ci.quantity
    FROM cart_items ci
    JOIN products p ON ci.product_id = p.product_id
    WHERE ci.cart_id = v_cart_id;
    -- Reduce stock
    UPDATE inventory i
    JOIN cart_items ci ON i.product_id = ci.product_id
    SET i.stock = i.stock - ci.quantity
    WHERE ci.cart_id = v_cart_id;
    -- Insert payment
    INSERT INTO payments (order_id, amount, method)
    VALUES (v_order_id, v_total, 'credit_card');
    -- Clear cart
    DELETE FROM cart_items WHERE cart_id = v_cart_id;
    COMMIT;
END$$
DELIMITER ;