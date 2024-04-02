USE foggy_bean;

-- Insert discounts
INSERT INTO discounts (discount_code, discount_amount, validity_start_date, validity_end_date)
VALUES
('DISCOUNT10', 10.00, '2024-03-01', '2024-03-31'),
('SPRINGSALE', 15.00, '2024-04-01', '2024-04-30'),
('SUMMERSALE', 20.00, '2024-05-01', '2024-05-31');

-- Insert coffee products
INSERT INTO products (name, category, price)
VALUES
('Costa Rica Aquiares Estate', 'Coffee', 11.25),
('Long Beach Espresso - Medium Roast', 'Coffee', 11.25),
('Happy Camper - Medium Roast', 'Coffee', 11.25),
('South Swell - Medium Dark Roast', 'Coffee', 11.25),
('Raven - Dark French Roast', 'Coffee', 11.25),
('Storm Watch - Dark Roast', 'Coffee', 11.25),
('Rainforest Decaf Espresso - Medium Dark Roast', 'Coffee', 11.25);

-- Insert coffee sizes
INSERT INTO coffee_sizes (product_id, size, price)
SELECT id, '227 G / 0.5 L', 11.25 FROM products WHERE category = 'Coffee';

INSERT INTO coffee_sizes (product_id, size, price)
SELECT id, '454 G / 1.0 L', 21.00 FROM products WHERE category = 'Coffee';

INSERT INTO coffee_sizes (product_id, size, price)
SELECT id, '2.27 KG / 5 L', 90.00 FROM products WHERE category = 'Coffee';

-- Insert merchandise products
INSERT INTO products (name, category, price)
VALUES
('FOGGY BEAN COFFEE CO. 12 OZ TRAVEL TUMBLER', 'Merchandise', 45.00),
('Circle Sticker', 'Merchandise', 3.50);

-- Insert customers
INSERT INTO customers (first_name,last_name, email, password_hash)
VALUES
('John', 'Smith', 'john@example.com', SHA2('password123', 256)),
('Jane', 'Doe', 'jane@example.com', SHA2('password456', 256)),
('Alice', 'Johnson', 'alice@example.com', SHA2('password789', 256)),
('Bob', 'Williams', 'bob@example.com', SHA2('password321', 256));

-- Insert products
INSERT INTO products (name, category, price)
VALUES
('Test Product 1', 'Coffee', 10.00),
('Test Product 2', 'Coffee', 15.00),
('Test Product 3', 'Merchandise', 20.00),
('Test Product 4', 'Merchandise', 25.00);

-- Insert inventory
INSERT INTO inventory (product_id, quantity)
VALUES
(1, 100),
(2, 200),
(3, 300),
(4, 400);

-- Insert orders
INSERT INTO orders (customer_id, address, postal_code, total_amount, status, created_at)
VALUES
(1, '123 Main St', 'V5A3M5', 50.00, 'Pending', NOW()),
(2, '456 Oak St', 'V5B4M6', 75.00, 'Processing', NOW()),
(3, '789 Pine St', 'V5C7N8', 100.00, 'Shipped', NOW()),
(4, '321 Maple St', 'V5D9P0', 125.00, 'Returned', NOW());


-- Insert new order items
INSERT INTO order_invoice (order_id, product_id, quantity, price)
VALUES (LAST_INSERT_ID(), 1, 2, 20.00),
       (LAST_INSERT_ID(), 2, 1, 15.00);

-- Update the discount_id for an order
UPDATE orders SET discount_id = 1 WHERE id = LAST_INSERT_ID(); -- Update discount_id for the last inserted order


-- Insert a new payment for the order
INSERT INTO payments (order_id, amount, payment_method, transaction_id, payment_status)
VALUES (1, 50.00, 'Credit Card', '123456', 'Completed');

-- Insert order items
INSERT INTO order_invoice (order_id, product_id, quantity, price)
VALUES
(1, 1, 2, 20.00),
(1, 2, 1, 15.00),
(2, 3, 3, 25.00),
(2, 4, 2, 12.50),
(3, 1, 4, 20.00),
(3, 2, 2, 15.00),
(4, 4, 5, 12.50),
(4, 3, 3, 25.00);

-- Insert payments
INSERT INTO payments (order_id, amount, payment_method, transaction_id, payment_status, created_at)
VALUES
(2, 75.00, 'Debit Card', '234567', 'Completed', NOW()),
(3, 100.00, 'Credit Card', '345678', 'Completed', NOW()),
(4, 125.00, 'PayPal', '456789', 'Failed', NOW());

-- Insert returns
INSERT INTO returns (order_id, reason, authorization_number, status, resell, created_at)
VALUES
(1, 'Wrong size', 'RMA123', 'Processing', TRUE, NOW()),
(2, 'Did not like the product', 'RMA124', 'Processing', TRUE, NOW()),
(3, 'Wrong product delivered', 'RMA125', 'Completed', TRUE, NOW()),
(4, 'Product damaged', 'RMA126', 'Processing', FALSE, NOW());



