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
