create database capstone;
-- TASK 1:  CREATE TABLE --
CREATE TABLE brands(
brand_id INT PRIMARY KEY,
brand_name VARCHAR(100)
);

CREATE TABLE categories(
category_id INT PRIMARY KEY,
category_name VARCHAR(100)
);

CREATE TABLE customers (
    Customer_ID INT PRIMARY KEY,
    First_Name VARCHAR(100) NOT NULL,
    Last_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(100),
    Email VARCHAR(100),
    Street VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Zip_Code VARCHAR(100)
);

CREATE TABLE order_items (
    order_id INT PRIMARY KEY,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price DECIMAL(10,2),
    discount DECIMAL(4,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_status VARCHAR(100),
    order_date DATE,
    required_date DATE,
    shipped_date VARCHAR(100),
    store_id INT,
    staff_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    brand_id INT,
    category_id INT,
    model_year YEAR,
    list_price DECIMAL(10,2)
);

CREATE TABLE staffs (
staff_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(100),
    active INT,
    store_id INT,
    manager_id VARCHAR(100),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
);

CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    phone VARCHAR(100),
    email VARCHAR(100),
    street VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(100)
);

-- TASK 2: IMPORT CSVs INTO MY SQL --
-- TASK3:INNER JOIN FOR ORDER DETAILS --
SELECT o.order_id,o.order_date,oi.item_id,p.product_id,p.product_name,oi.quantity,oi.list_price,oi.discount,
ROUND(oi.quantity*oi.list_price*(1-oi.discount),2) AS total_price
FROM orders AS o
INNER JOIN order_items AS oi
ON o.order_id=oi.order_id
INNER JOIN products AS p
ON oi.product_id=p.product_id
ORDER BY o.order_id,oi.item_id;

-- TASK 4: TOTAL SALES BY STORES --
SELECT o.store_id,
ROUND(SUM(oi.quantity*oi.list_price*(1-oi.discount)),2) AS total_sales FROM orders o
INNER JOIN order_items AS oi
ON o.order_id=oi.order_id
GROUP BY o.store_id
ORDER BY total_sales DESC; 

-- TASK:5 TOP 5 SELLING PRODUCTS --
SELECT p.product_id,p.product_name,
SUM(oi.quantity) AS total_quantity_sold,
ROUND(SUM(oi.quantity *oi.list_price *(1 - oi.discount)),2) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
ON oi.product_id = p.product_id
GROUP BY p.product_id,p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- TASK:6 CUSTOMER PURCHASE SUMMARY --
SELECT c.customer_id,c.first_name,c.last_name,
COUNT(DISTINCT o.order_id) AS total_orders,
SUM(oi.quantity) AS total_items,
SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
FROM customers AS c
LEFT JOIN orders AS o
ON c.customer_id = o.customer_id
LEFT JOIN order_items AS oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_spent DESC;

-- TASK:7 SEGMENT CUSTOMERS BY TOTAL SPEND --
SELECT c.customer_id,c.first_name,c.last_name,
SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent,
IF(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 10000,'High',IF(SUM(oi.quantity * oi.list_price * (1 - oi.discount)) >= 5000,'Medium','Low')
    ) AS customer_segment
FROM customers AS c
INNER JOIN orders AS o
ON c.customer_id = o.customer_id
INNER JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_spent DESC;

-- TASK:8 STAFF PERFORMANCE ANALYSIS --
SELECT s.staff_id,CONCAT(s.first_name,s.last_name) AS staff_name,
SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM staffs AS s
INNER JOIN orders AS o
ON s.staff_id = o.staff_id
INNER JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY s.staff_id,s.first_name,s.last_name
ORDER BY total_revenue DESC;

-- TASK:9 STOCK ALERT QUERY --
SELECT st.store_id,str.store_name,st.product_id,p.product_name,st.quantity
FROM STOCKS AS st
INNER JOIN PRODUCTS AS p
ON st.product_id=p.product_id
INNER JOIN stores AS str
ON st.store_id=str.store_id
WHERE st.quantity<10
ORDER BY st.quantity ASC;

-- TASK:10 FINAL CUSTOMER SEGMENTATION TABLE --
CREATE TABLE customer_segments(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
total_orders INT,
total_item_purchased INT,
total_spend DECIMAL(12,2),
segment VARCHAR(100),
FOREIGN KEY (customer_id) REFERENCES customers(Customer_ID));










