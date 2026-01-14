CREATE DATABASE E_COMMERCE_DB;
USE E_COMMERCE_DB;


CREATE TABLE customers(
customer_id VARCHAR(50) PRIMARY KEY,
country VARCHAR(50) NOT NULL
);


CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id VARCHAR(50) NOT NULL,
payment_method VARCHAR(50)NOT NULL,
order_date date NOT NULL,
FOREIGN KEY(customer_id) REFERENCES Customers(customer_id)
);




CREATE TABLE categories(
category_id INT PRIMARY KEY,
category_name VARCHAR(50) NOT NULL
);


CREATE TABLE products(
product_id VARCHAR(50) PRIMARY KEY,
category_id INT NOT NULL,
price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);



CREATE TABLE order_Items(
order_item_id INT PRIMARY KEY,
order_id INT NOT NULL,
product_id VARCHAR(50) NOT NULL,
discount INT NOT NULL,
final_price DECIMAL(10,2) NOT NULL,
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
FOREIGN KEY (product_id) REFERENCES Products(product_id)
);



-- Category wise number of orders,total revenue and average order value
SELECT c.category_name, COUNT(cu.customer_id) AS no_of_customers, COUNT(o.order_id) AS total_orders,
SUM(oi.final_price)AS total_value, ROUND(sum(oi.final_price)/COUNT(oi.order_id), 2) AS average_value
FROM categories AS c
JOIN products AS p on c.category_id=p.category_id
JOIN order_items as oi on p.product_id=oi.product_id
JOIN orders AS o ON oi.order_id=o.order_id
JOIN customers AS cu ON o.customer_id= cu.customer_id
GROUP BY c.category_name
ORDER BY COUNT(o.order_id) DESC;



-- country wise number of customers, number of orders, revenue and average order value
SELECT c.country,COUNT(c.customer_id) AS no_of_customers,COUNT(o.order_id) AS no_of_orders,
SUM(oi.final_price)AS revenue, ROUND(SUM(final_price)/COUNT(o.order_id),2) AS average_value
FROM customers as c
JOIN orders AS o ON c.customer_id=o.customer_id
JOIN order_items AS oi ON o.order_id=oi.order_id
GROUP BY c.country
ORDER BY COUNT(o.order_id) DESC;



-- month wise number of orders and revenue generated
SELECT YEAR(o.order_date) AS year,MONTH(o.order_date) AS month,COUNT(o.order_id) AS no_of_orders,SUM(oi.final_price) AS revenue
FROM orders AS o
JOIN order_items as oi ON o.order_id=oi.order_id
GROUP BY year, month
ORDER BY month ASC;



-- payment mode used on orders and revenue generated using different payment modes
SELECT o.payment_method, COUNT(o.order_id) AS no_of_orders, SUM(oi.final_price) AS revenue
FROM Orders AS o
JOIN order_items AS oi ON o.order_id=oi.order_id
GROUP BY o.payment_method
ORDER BY COUNT(o.order_id) DESC;