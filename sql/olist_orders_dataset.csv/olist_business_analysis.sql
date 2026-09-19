CREATE DATABASE olist_ecommerce;

USE olist_ecommerce;
SHOW DATABASES;

USE olist_ecommerce;

SELECT *
FROM olist_orders_dataset
LIMIT 5;

SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;
SELECT *
FROM olist_orders_dataset;
SELECT COUNT(*) FROM olist_orders_dataset;

DROP TABLE olist_orders_dataset;
USE olist_ecommerce;

DROP TABLE IF EXISTS olist_orders_dataset;

USE olist_ecommerce;

CREATE TABLE olist_orders_dataset (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_orders_dataset.csv/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_orders_dataset.csv/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'local_infile';

USE olist_ecommerce;
LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_orders_dataset.csv/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;

USE olist_ecommerce;

TRUNCATE TABLE olist_orders_dataset;
LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_orders_dataset.csv/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;

CREATE TABLE olist_order_items_dataset (
    order_id TEXT,
    order_item_id TEXT,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price TEXT,
    freight_value TEXT
);
LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_order_items_dataset.csv/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS total_items
FROM olist_order_items_dataset;

CREATE TABLE olist_order_payments_dataset (
    order_id TEXT,
    payment_sequential TEXT,
    payment_type TEXT,
    payment_installments TEXT,
    payment_value TEXT
);

LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_order_payments_dataset.csv/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS total_payments
FROM olist_order_payments_dataset;

USE olist_ecommerce;

CREATE TABLE olist_products_dataset (
    product_id TEXT,
    product_category_name TEXT,
    product_name_lenght TEXT,
    product_description_lenght TEXT,
    product_photos_qty TEXT,
    product_weight_g TEXT,
    product_length_cm TEXT,
    product_height_cm TEXT,
    product_width_cm TEXT
);
LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_products_dataset.csv/olist_products_dataset.csv'
INTO TABLE olist_products_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS total_products
FROM olist_products_dataset;

USE olist_ecommerce;

CREATE TABLE olist_customers_dataset (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);
LOAD DATA LOCAL INFILE 'C:/Users/Admin/Downloads/olist_customers_dataset.csv/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS total_customers
FROM olist_customers_dataset;

USE olist_ecommerce;

SELECT 'Orders' AS table_name, COUNT(*) AS total_rows
FROM olist_orders_dataset

UNION ALL

SELECT 'Order Items', COUNT(*)
FROM olist_order_items_dataset

UNION ALL

SELECT 'Payments', COUNT(*)
FROM olist_order_payments_dataset

UNION ALL

SELECT 'Products', COUNT(*)
FROM olist_products_dataset

UNION ALL

SELECT 'Customers', COUNT(*)
FROM olist_customers_dataset;

SHOW TABLES;
SELECT price
FROM olist_order_items_dataset
LIMIT 5;
ALTER TABLE olist_order_items_dataset
MODIFY price DECIMAL(10,2);
ALTER TABLE olist_order_items_dataset
MODIFY freight_value DECIMAL(10,2);
DESCRIBE olist_order_items_dataset;


SELECT SUM(price) AS total_revenue
FROM olist_order_items_dataset;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM olist_orders_dataset;

-- Q1
SELECT 
    SUM(price) / COUNT(DISTINCT order_id) AS average_order_value
FROM olist_order_items_dataset;

-- Q2
SELECT SUM(freight_value) AS total_freight_cost
FROM olist_order_items_dataset;

-- Q3
SELECT 
    order_id,
    SUM(price) AS order_value
FROM olist_order_items_dataset
GROUP BY order_id
ORDER BY order_value DESC
LIMIT 1;

-- Q4
SELECT 
    order_id,
    SUM(price) AS order_value
FROM olist_order_items_dataset
GROUP BY order_id
ORDER BY order_value DESC
LIMIT 5;
-- Q5
SELECT 
    order_id,
    SUM(price) AS order_revenue
FROM olist_order_items_dataset
GROUP BY order_id
ORDER BY order_revenue DESC;

-- Q6. Find the total revenue generated by each customer.
SELECT 
    o.customer_id,
    SUM(i.price) AS total_spending
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i
ON o.order_id = i.order_id
GROUP BY o.customer_id
ORDER BY total_spending DESC;

-- Q7. Find customers who placed more than 1 order.

SELECT 
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Q8. Find customers who have never placed an order.

SELECT 
    c.customer_unique_id,
    c.customer_city,
    c.customer_state
FROM olist_customers_dataset c
LEFT JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q9. Find the top 5 product categories by number of products sold.

SELECT 
    p.product_category_name,
    COUNT(i.product_id) AS products_sold
FROM olist_products_dataset p
JOIN olist_order_items_dataset i
ON p.product_id = i.product_id
GROUP BY p.product_category_name
ORDER BY products_sold DESC
LIMIT 5;

-- Q10. Find the most frequently used payment method.

SELECT 
    payment_type,
    COUNT(*) AS usage_count
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY usage_count DESC
LIMIT 1;

-- Q11. Classify payments into Low, Medium and High value categories.

SELECT
    order_id,
    payment_value,
    CASE
        WHEN payment_value < 100 THEN 'Low'
        WHEN payment_value <= 500 THEN 'Medium'
        ELSE 'High'
    END AS payment_category
FROM olist_order_payments_dataset;

-- Q12. Find the number of orders placed in each month.

SELECT
    MONTH(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS month,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY MONTH(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'))
ORDER BY month;

-- Q13. Find the average number of items purchased per order.

SELECT
    round(COUNT(*) / COUNT(DISTINCT order_id)) AS average_items_per_order
FROM olist_order_items_dataset;

-- Q14. Find the percentage of orders that were delivered to customers.

SELECT
    ROUND(
        SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS delivered_order_percentage
FROM olist_orders_dataset;

-- Q15. Find the top 5 customers based on their total spending.

SELECT
    c.customer_unique_id,
    SUM(i.price) AS total_spending
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset i
ON o.order_id = i.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spending DESC
LIMIT 5;

-- Q16. Find the average delivery time for delivered orders.

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                DATE(order_delivered_customer_date),
                DATE(order_purchase_timestamp)
            )
        )
    ) AS average_delivery_days
FROM olist_orders_dataset
WHERE order_status = 'delivered';

-- Q17. Find the product category with the highest average product price.

SELECT
    p.product_category_name,
    AVG(i.price) AS average_price
FROM olist_products_dataset p
JOIN olist_order_items_dataset i
ON p.product_id = i.product_id
GROUP BY p.product_category_name
ORDER BY average_price DESC
LIMIT 1;

-- Q18. Find the percentage of orders that were cancelled.

SELECT
    ROUND(
        SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS cancelled_order_percentage
FROM olist_orders_dataset;

-- Q19. Find orders that were delivered later than the estimated delivery date.

SELECT
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset
WHERE STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
    > STR_TO_DATE(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s');
    
    -- Q20. Find the month with the highest total sales revenue.

SELECT
    MONTH(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS month,
    SUM(i.price) AS total_sales
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i
ON o.order_id = i.order_id
GROUP BY MONTH(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'))
ORDER BY total_sales DESC
LIMIT 1;

-- Q21. Rank sellers based on their total sales revenue.

SELECT
    seller_id,
    SUM(price) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(price) DESC
    ) AS seller_rank
FROM olist_order_items_dataset
GROUP BY seller_id;

-- Q22. Find the absolute difference between each order's value and the average order value.

SELECT
    order_id,
    SUM(price) AS order_value,
    abs(SUM(price) - AVG(SUM(price)) OVER ()) AS difference_from_average
FROM olist_order_items_dataset
GROUP BY order_id;

-- Q23. Find the highest-value order for each customer.

SELECT
    customer_id,
    order_id,
    order_value
FROM (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(i.price) AS order_value,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY SUM(i.price) DESC
        ) AS row_num
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset i
    ON o.order_id = i.order_id
    GROUP BY o.customer_id, o.order_id
) AS ranked_orders
WHERE row_num = 1;

-- Q24. Find the percentage of total sales contributed by the top 10 orders.

SELECT
    ROUND(
        SUM(order_value) * 100 /
        (SELECT SUM(price) FROM olist_order_items_dataset),
        2
    ) AS top_10_orders_percentage
FROM (
    SELECT
        order_id,
        SUM(price) AS order_value
    FROM olist_order_items_dataset
    GROUP BY order_id
    ORDER BY order_value DESC
    LIMIT 10
) AS top_orders;

