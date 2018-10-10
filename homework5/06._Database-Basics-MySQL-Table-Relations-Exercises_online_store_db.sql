CREATE DATABASE online_store_db;
USE online_store_db;

CREATE TABLE items
(
item_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
item_type_id INT(11) NOT NULL
);

CREATE TABLE item_types
(
item_type_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

ALTER TABLE items
ADD CONSTRAINT fk_item_type_id
FOREIGN KEY(item_type_id)
REFERENCES item_types(item_type_id);

CREATE TABLE order_items
(
order_id INT(11) NOT NULL,
item_id INT(11) NOT NULL
);

CREATE TABLE customers
(
customer_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL,
birthday DATE NOT NULL,
city_id INT(11) NOT NULL
);

CREATE TABLE cities
(
city_id INT(11) PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);

ALTER TABLE customers
ADD CONSTRAINT fk_city_id
FOREIGN KEY(city_id)
REFERENCES cities(city_id);

CREATE TABLE orders
(
order_id INT(11) PRIMARY KEY AUTO_INCREMENT,
customer_id INT(11) NOT NULL
);

ALTER TABLE order_items
ADD CONSTRAINT pk_order_items_id
PRIMARY KEY(order_id, item_id), 
ADD CONSTRAINT fk_order_id
FOREIGN KEY(order_id)
REFERENCES orders(order_id),
ADD CONSTRAINT fk_item_id
FOREIGN KEY(item_id)
REFERENCES items(item_id);

ALTER TABLE orders
ADD CONSTRAINT fk_customer_id
FOREIGN KEY(customer_id)
REFERENCES customers(customer_id);