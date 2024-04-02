    DROP DATABASE IF EXISTS foggy_bean;
    CREATE DATABASE foggy_bean;
    USE foggy_bean;

    -- Customers Table: Stores customer account information.
    CREATE TABLE customers (
        id INT PRIMARY KEY AUTO_INCREMENT,
        first_name VARCHAR(20) NOT NULL,
        last_name VARCHAR(20) NOT NULL,
        email VARCHAR(40) NOT NULL UNIQUE,
        password_hash VARCHAR(255) NOT NULL
    );

    -- Password Reset Requests Table: Stores password reset request information.
    CREATE TABLE password_reset (
        id INT PRIMARY KEY AUTO_INCREMENT,
        customer_id INT NOT NULL,
        reset_token VARCHAR(255) NOT NULL,
        request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        expired BOOLEAN DEFAULT FALSE,
        FOREIGN KEY (customer_id) REFERENCES customers(id)
    );

    -- Create products table
    CREATE TABLE products (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL,
        category ENUM('Coffee', 'Merchandise') NOT NULL,
        price DECIMAL(10, 2) NOT NULL
    );

    -- Create coffee_sizes table
    CREATE TABLE coffee_sizes (
        id INT PRIMARY KEY AUTO_INCREMENT,
        product_id INT NOT NULL,
        size VARCHAR(50) NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
    );

    -- Create merchandise_products table
    CREATE TABLE merchandise_products (
        id INT PRIMARY KEY AUTO_INCREMENT,
        product_id INT NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
    );


    -- Discounts Table: Stores discount information.
    CREATE TABLE discounts (
        id INT PRIMARY KEY AUTO_INCREMENT,
        discount_code VARCHAR(50) NOT NULL,
        discount_amount DECIMAL(10, 2) NOT NULL,
        validity_start_date DATE NOT NULL,
        validity_end_date DATE NOT NULL
    );

    -- Orders Table: Stores information about customer orders, including reference to discounts.
    CREATE TABLE orders (
        id INT PRIMARY KEY AUTO_INCREMENT,
        customer_id INT NOT NULL,
        address VARCHAR(40),
        postal_code VARCHAR(6),
        discount_id INT,
        total_amount DECIMAL(10, 2),
        status ENUM('Pending', 'Processing', 'Shipped', 'Returned', 'Cancelled') NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (customer_id) REFERENCES customers(id)
        -- If a customer is deleted, delete their orders.
        -- foreign key constraint will ensure that customer_id
        -- in orders table is a valid customer id in customers table.
        ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (discount_id) REFERENCES discounts(id)
    );

    -- Order Items Table: Stores items within each order.
    CREATE TABLE order_invoice (
        id INT PRIMARY KEY AUTO_INCREMENT,
        order_id INT NOT NULL,
        product_id INT NOT NULL,
        quantity INT NOT NULL,
        price DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders(id),
        FOREIGN KEY (product_id) REFERENCES products(id)
    );

    -- Payments Table: Tracks payment information associated with orders.
    CREATE TABLE payments (
        id INT PRIMARY KEY AUTO_INCREMENT,
        order_id INT NOT NULL,
        amount DECIMAL(10, 2) NOT NULL,
        payment_method VARCHAR(50),
        transaction_id VARCHAR(255),
        payment_status ENUM('Pending', 'Completed', 'Failed') NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (order_id) REFERENCES orders(id)
    );

    -- Inventory Table: Tracks inventory levels for products.
    CREATE TABLE inventory (
        id INT PRIMARY KEY AUTO_INCREMENT,
        product_id INT NOT NULL,
        quantity INT NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id)
    );


    -- Returns Table: Tracks product return requests.
    CREATE TABLE returns (
        id INT PRIMARY KEY AUTO_INCREMENT,
        order_id INT NOT NULL,
        reason TEXT,
        authorization_number VARCHAR(50),
        status ENUM('Pending', 'Processing', 'Completed', 'Failed') NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        resell BOOLEAN NOT NULL DEFAULT TRUE, -- Indicates if the product can be resold.
        FOREIGN KEY (order_id) REFERENCES orders(id)
    );

