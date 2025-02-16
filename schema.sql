-- Amazon Project - Advanced SQL 

-- category Table 
CREATE TABLE category 
(
category_id INT PRIMARY KEY,
category_name VARCHAR(20)
); 

--customers Table 
CREATE TABLE customers 
(
customer_id INT PRIMARY KEY, 
first_name VARCHAR(20),
last_name VARCHAR(20),
state VARCHAR(20),
address VARCHAR(5) default('xxxx')
);

-- sellers Table 
CREATE TABLE sellers 
(
seller_id INT PRIMARY KEY, 
seller_name VARCHAR(25),
origin VARCHAR(5)
);

-- products Table
CREATE TABLE products 
(
product_id INT PRIMARY KEY,
product_name VARCHAR(50),
price FLOAT,
cogs FLOAT,
category_id INT, --FK
CONSTRAINT product_fk_category FOREIGN KEY(category_id) REFERENCES category(category_id) 
);

-- orders Table 
CREATE TABLE orders
(
order_id INT PRIMARY KEY, 
order_date DATE, 
customer_id INT, --FK
seller_id INT, --FK
order_status VARCHAR(15),
CONSTRAINT orders_fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
CONSTRAINT orders_fk_seller FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

-- oders items Table
CREATE TABLE order_items
(
order_item_id INT PRIMARY KEY, 
order_id INT, --FK
product_id INT,--FK
quantity INT,
price_per_unit FLOAT,
CONSTRAINT orders_items_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
CONSTRAINT order_items_fk_products FOREIGN KEY(product_id) REFERENCES products(product_id)
);

-- payments Table 
CREATE TABLE payments
(
payments_id INT PRIMARY KEY,
order_id INT, --FK
payments__date DATE, 
payment_status VARCHAR(20),
CONSTRAINT payments_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- shipping Table 
CREATE TABLE shippings
(
shipping_id INT PRIMARY KEY,
order_id INT, --FK
shipping_date DATE,
return_date DATE,
shipping_providers VARCHAR(25),
delivery_status VARCHAR(25),
CONSTRAINT shippings_fk_orders FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- inventory Table
CREATE TABLE inventory
(
inventory_id INT PRIMARY KEY,
product_id INT, --FK
stock INT,
warehouse_id INT,
last_stock_date DATE, 
CONSTRAINT inventory_fk_products FOREIGN KEY (product_id) REFERENCES products(product_id)
);

