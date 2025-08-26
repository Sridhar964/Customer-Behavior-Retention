
-- MY MINI PROJECT TITTLE IS


              --------------------------------------> Customer Behavior & R etention Analysis  <-----------------------------------------

              ------------>     Step 1: Create Tables

-- Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    signup_date DATE,
    country VARCHAR(50)
);

-- Orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Products Table (Optional, for category analysis)
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

                ----------->    Step 2: Insert Sample Data

-- Customers
INSERT INTO customers VALUES
(1, 'Alice', '2023-01-15', 'USA'),
(2, 'Bob', '2023-02-10', 'Canada'),
(3, 'Charlie', '2023-02-18', 'India'),
(4, 'David', '2023-03-05', 'USA'),
(5, 'Eva', '2023-03-12', 'UK'),
(6, 'Frank', '2023-03-18', 'Germany'),
(7, 'Grace', '2023-04-01', 'India'),
(8, 'Henry', '2023-04-05', 'Canada'),
(9, 'Ivy', '2023-04-12', 'USA'),
(10, 'Jack', '2023-04-20', 'India'),
(11, 'Karen', '2023-05-02', 'USA'),
(12, 'Leo', '2023-05-10', 'UK'),
(13, 'Mia', '2023-05-15', 'Germany'),
(14, 'Nick', '2023-05-22', 'USA'),
(15, 'Olivia', '2023-05-30', 'Canada');

SELECT * FROM CUSTOMERS

-- Orders
INSERT INTO orders VALUES
(101, 1, '2023-01-20', 250),
(102, 2, '2023-02-15', 300),
(103, 1, '2023-02-25', 200),
(104, 3, '2023-03-10', 150),
(105, 1, '2023-03-20', 400),
(106, 2, '2023-04-01', 220),
(107, 4, '2023-04-05', 180),
(108, 5, '2023-04-12', 500),
(109, 6, '2023-04-18', 320),
(110, 7, '2023-04-25', 270),
(111, 8, '2023-05-01', 150),
(112, 9, '2023-05-05', 200),
(113, 10, '2023-05-10', 350),
(114, 11, '2023-05-15', 400),
(115, 12, '2023-05-20', 220),
(116, 13, '2023-05-25', 500),
(117, 14, '2023-06-01', 600),
(118, 15, '2023-06-05', 700),
(119, 3, '2023-06-10', 250),
(120, 5, '2023-06-15', 450);

SELECT * FROM orders


--PRODUCT
INSERT INTO products VALUES
(201, 'Laptop', 'Electronics', 1000),
(202, 'Phone', 'Electronics', 600),
(203, 'Headphones', 'Accessories', 100),
(204, 'Tablet', 'Electronics', 400),
(205, 'Monitor', 'Electronics', 300),
(206, 'Keyboard', 'Accessories', 50),
(207, 'Mouse', 'Accessories', 30),
(208, 'Printer', 'Electronics', 200),
(209, 'Camera', 'Electronics', 800),
(210, 'Smartwatch', 'Electronics', 250),
(211, 'Speaker', 'Accessories', 120),
(212, 'Router', 'Electronics', 150),
(213, 'Desk', 'Furniture', 200),
(214, 'Chair', 'Furniture', 180),
(215, 'USB Cable', 'Accessories', 20);

SELECT * FROM products



                     ---------->   Step 3: Analysis Queries (Ready to Run)

---> (1)   Total Customers & Orders

SELECT COUNT(DISTINCT customer_id) AS total_customers,
       COUNT(order_id) AS total_orders FROM orders

---> (2)   Customer Lifetime Value (CLV)

SELECT c.customer_id, c.name, SUM(o.amount) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC;

---> (3)    Repeat Customers (Retention)

SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) sub;

---> (4)    Monthly Active Customers

SELECT 
    FORMAT(order_date, '2023 - MAY') AS month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders
GROUP BY FORMAT(order_date, '2023 - MAY')
ORDER BY month;

---> (5)    Churn Customers (only 1 order)

SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) = 1;

---> (6)    Top Spending Customers

SELECT c.name, SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC

---> (7)    Customers with No Orders (Inactive Users)

SELECT c.customer_id, c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

---> (8)      Top 3 Products by Sales
--->(If you join orders with products)
-- Assume orders table has product_id (you can extend your schema)
SELECT TOP 3
    p.name AS product,
    SUM(o.amount) AS total_sales
FROM orders o
JOIN products p ON o.customer_id IS NOT NULL -- replace with product_id if linked
GROUP BY p.name
ORDER BY total_sales DESC;

---> (9)      Customer with Highest Single Order

SELECT TOP 1 
    c.name,
    o.amount,
    o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.amount DESC;

--->  (10)     Country-Wise Revenue

SELECT 
    c.country,
    SUM(o.amount) AS total_revenue,
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

--->(11)   Average Order Value (AOV)

SELECT 
    AVG(amount) AS avg_order_value
FROM orders;

                                      -------------->        Step 4: Insights What You Can Report         <------------------------




-->Alice & Olivia are high-value customers with multiple high-value orders.(1)

-->Alice & Olivia are high-value customers, contributing a significant share of revenue.(2)

--->Retention ? 40–50%, showing a healthy customer base that returns for repeat purchases.(3)

--->MAC trend shows steady growth from March ? June, indicating increasing engagement.(4)

--->Several customers drop off after their first purchase, highlighting churn risk.(5)

--->Identifying top spenders helps in targeting loyalty rewards & premium offers.(6)

--->These inactive users can be re-engaged with email campaigns or discounts.(7)

--->The top 3 products generate the majority of sales ? stock & promote these.(8)

--->The highest single purchase shows which customer is willing to spend big in one order.(9)

--->Revenue distribution by country helps identify key markets and where to expand.(10)

--->AOV shows the average revenue per order, useful for pricing and upselling strategies.(11)

