-- Online Store Database Project (MySQL)

CREATE DATABASE online_store;
USE online_store;

-- Customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE
);

-- Products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150),
    category_id INT,
    price DECIMAL(10,2),
    stock INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Payments
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2),
    payment_method ENUM('Credit Card','PayPal','Cash'),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Inventory Logs
CREATE TABLE inventory_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    change_amount INT,
    action ENUM('Stock In','Stock Out','Order'),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Sample Data
INSERT INTO categories (category_name) VALUES
('Electronics'), ('Books'), ('Clothing');

INSERT INTO products (product_name, category_id, price, stock) VALUES
('Laptop', 1, 1200, 10),
('Headphones', 1, 150, 25),
('Novel Book', 2, 20, 40),
('T-Shirt', 3, 15, 50);

INSERT INTO customers (full_name, email, phone) VALUES
('Alice Johnson', 'alice@gmail.com', '1234567890'),
('Bob Smith', 'bob@gmail.com', '9876543210');

INSERT INTO orders (customer_id, status) VALUES
(1, 'Pending'),
(2, 'Pending');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200),
(1, 2, 2, 150),
(2, 3, 1, 20);

INSERT INTO payments (order_id, amount, payment_method) VALUES
(1, 1500, 'Credit Card');

SELECT c.full_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id;

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC;

SELECT product_name, stock 
FROM products 
WHERE stock < 10;

SELECT SUM(amount) AS total_revenue 
FROM payments;
SELECT c.full_name, o.order_id, o.order_date, o.status
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;
SELECT o.order_id, p.product_name, oi.quantity, oi.price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id;
SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status;
SELECT p.product_name, l.change_amount, l.action, l.log_date
FROM inventory_logs l
JOIN products p ON l.product_id = p.product_id;
SELECT *
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);
SELECT c.customer_id, c.full_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 3;
SELECT o.order_id, SUM(oi.price * oi.quantity) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY order_total DESC;
SELECT AVG(t.order_total) AS avg_order_value
FROM (
    SELECT o.order_id, SUM(oi.price * oi.quantity) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) t;
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id;
SELECT order_id, SUM(quantity) AS total_products
FROM order_items
GROUP BY order_id
HAVING total_products > 2;
DELIMITER $$

CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    INSERT INTO inventory_logs(product_id, change_amount, action)
    VALUES (NEW.product_id, -NEW.quantity, 'Order');
END $$

DELIMITER ;
DELIMITER $$

CREATE PROCEDURE place_order(
    IN p_customer INT,
    IN p_product INT,
    IN p_qty INT
)
BEGIN
    DECLARE new_order_id INT;
    
    -- Create order
    INSERT INTO orders(customer_id) VALUES (p_customer);
    SET new_order_id = LAST_INSERT_ID();
    
    -- Add item
    INSERT INTO order_items(order_id, product_id, quantity, price)
    SELECT new_order_id, p_product, p_qty, price
    FROM products
    WHERE product_id = p_product;

END $$

DELIMITER ;
USE online_store;
SHOW TABLES;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM orders;
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC;
SELECT c.full_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id;
SELECT order_id, SUM(quantity) AS total_items
FROM order_items
GROUP BY order_id;
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 3, 2, 20);
select * from order_items;
SELECT product_name, stock FROM products WHERE product_id = 3;











