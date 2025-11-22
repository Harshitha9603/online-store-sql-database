# 🛒 Online Store SQL Database (MySQL)

A complete end-to-end SQL project built for data analytics and database development.  
This project models an online store’s operations, including customers, products, orders, payments, and inventory management.

This repository demonstrates SQL skills used in real data analyst roles, including:
- Database schema design
- ETL-style data inserts
- Analytical querying
- Automations using triggers & stored procedures

---

## 📁 Project Structure

```
/online-store-sql-database
│
├── online_store_project.sql     # Full database schema + inserts
├── online_store_project.pdf     # Project documentation
└── README.md                    # Project overview (this file)
```

---

## 🧱 Database Features

### ✔ **7 Core Tables**
- `customers`
- `categories`
- `products`
- `orders`
- `order_items`
- `payments`
- `inventory_logs`

### ✔ **Data Modeling**
- 1-to-many relationships across orders, customers, and products  
- Normalized structure for analytics  
- Strong primary/foreign key integrity  

### ✔ **Automation**
- Trigger to auto-update product stock on new order
- Stored procedure for creating a new order workflow

---

## 📊 Sample Analytical Queries

### 1. Total spending per customer
```sql
SELECT c.full_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.customer_id;
```

### 2. Best-selling products
```sql
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC;
```

### 3. Orders without payments
```sql
SELECT *
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM payments);
```

---

## ⚙ Trigger Example

```sql
CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock = stock - NEW.quantity
    WHERE product_id = NEW.product_id;

    INSERT INTO inventory_logs(product_id, change_amount, action)
    VALUES (NEW.product_id, -NEW.quantity, 'Order');
END;
```

---

## 🧪 How to Use

### 1. Open MySQL Workbench  
### 2. Run the script:
```sql
SOURCE online_store_project.sql;
```
### 3. Query the database and explore sales, customers, products, and inventory analytics.

---

## 🎯 Skills Demonstrated

- SQL (MySQL)
- Relational database design
- Data Modeling & Normalization
- Analytical SQL (JOIN, GROUP BY, subqueries)
- Stored Procedures & Triggers
- ETL-style data loading
- E-commerce analytics

---

## 👤 Author

**Harshitha**  
_Data Analyst_  
📫 harshithareddy430@gmail.com
---
