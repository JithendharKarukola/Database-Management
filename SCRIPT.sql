\\(Creating temp table temp_car_sales by importing the datset .csv file)//

CREATE TEMP TABLE temp_car_sales (
    car_id SERIAL PRIMARY KEY,
    car_make VARCHAR(255),
    car_model VARCHAR(255),
    car_vin VARCHAR(17),
    customer_id SERIAL,
    customer_name VARCHAR(255),
    customer_phone VARCHAR(15),
    customer_email VARCHAR(255),
    dealershipagent_id SERIAL,
    dealershipagent_name VARCHAR(255),
    dealershipagent_phone VARCHAR(15),
    sales_id SERIAL,
    sales_purchase_date DATE,
    sales_purchase_amount DECIMAL(10, 2)
);

COPY temp_car_sales FROM 'C:\data\Cardata1.csv' DELIMITER ',' CSV HEADER;


//(Creating a static table with entity as car_info)//

CREATE TABLE car_info (
    car_id SERIAL PRIMARY KEY,
    car_make VARCHAR(255),
    car_model VARCHAR(255),
    car_vin VARCHAR(17)
);

//(Creating a static table with entity as customer_info)//

CREATE TABLE customer_info (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_phone VARCHAR(15),
    customer_email VARCHAR(255)
);

//(Creating a static table with entity as dealershipagent_info)//

CREATE TABLE dealershipagent_info (
    dealershipagent_id SERIAL PRIMARY KEY,
    dealershipagent_name VARCHAR(255),
    dealershipagent_phone VARCHAR(15)
);

//(Inserting the data from temp_car_sales into 3 created tables {car_info,customer_info,dealershipagent_info})//

INSERT INTO car_info SELECT car_id, car_make, car_model, car_vin FROM temp_car_sales;
INSERT INTO customer_info SELECT customer_id, customer_name, customer_phone, customer_email FROM temp_car_sales;
INSERT INTO dealershipagent_info SELECT dealershipagent_id, dealershipagent_name, dealershipagent_phone FROM temp_car_sales;

//(Creating a Dynamic table sales_info with 3 additional attributes {sales_id,sales_purchase_date,sales_purchase_amount}from temp_car_sales)//

CREATE TABLE sales_info (
    sales_id SERIAL PRIMARY KEY,
    car_id INT REFERENCES car_info(car_id),
    customer_id INT REFERENCES customer_info(customer_id),
    dealershipagent_id INT REFERENCES dealershipagent_info(dealershipagent_id),
    sales_purchase_date DATE,
    sales_purchase_amount DECIMAL(10, 2)
);

//(Inserting the dynamic table with the above created table sales_info from temp_car_sales)//

INSERT INTO sales_info SELECT sales_id, car_id, customer_id, dealershipagent_id, sales_purchase_date, sales_purchase_amount FROM temp_car_sales;

//(Dropping each table {sales_info,car_info,customer_info,dealershipagent_info,temp_car_sales} and clearing the data)//

DROP TABLE IF EXISTS sales_info;
DROP TABLE IF EXISTS car_info;
DROP TABLE IF EXISTS customer_info;
DROP TABLE IF EXISTS dealershipagent_info;
DROP TABLE IF EXISTS temp_car_sales;
