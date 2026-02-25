USE ecomm;
-- Foreign key indexes
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_carts_user ON carts(user_id);

-- Analytics optimization
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_payments_method ON payments(method);

-- Composite index for purchase history
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at);