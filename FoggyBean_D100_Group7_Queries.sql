USE foggy_bean;
-- Create stored procedures and triggers

-- Create a stored procedure to initiate password reset
DELIMITER //
CREATE PROCEDURE initiate_password_reset(IN p_email VARCHAR(255))
BEGIN
    DECLARE customer_id INT;
    DECLARE reset_token VARCHAR(255);

    SELECT id INTO customer_id FROM customers WHERE email = p_email;
    SET reset_token = UUID();
    INSERT INTO password_reset (customer_id, reset_token) VALUES (customer_id, reset_token);
END;//
DELIMITER ;

-- CALL initiate the initiate_password_reset trigger
CALL initiate_password_reset('john@example.com');

-- Create a trigger that resets the password when a new password reset request is inserted
DELIMITER //
CREATE TRIGGER reset_password_trigger AFTER INSERT ON password_reset FOR EACH ROW
BEGIN
    DECLARE new_password VARCHAR(255);
    SET new_password = CONCAT('new_password_', RAND());
    UPDATE customers SET password_hash = SHA2(new_password, 256) WHERE id = NEW.customer_id;
END;//
DELIMITER ;

-- Create a stored procedure to validate postal code to make sure it is in British Columbia (BC)
DELIMITER //
CREATE TRIGGER check_postal_code BEFORE INSERT ON orders FOR EACH ROW
BEGIN
    DECLARE valid_postal_code BOOLEAN;
    IF NEW.postal_code REGEXP '^[Vv][0-9][A-Za-z] [0-9][A-Za-z][0-9]$' THEN
        SET valid_postal_code = TRUE;
    ELSE
        SET valid_postal_code = FALSE;
    END IF;
    IF NOT valid_postal_code THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid postal code. Postal code must be in British Columbia (BC).';
    END IF;
END;//
DELIMITER ;

-- Create a trigger that updates the total amount of an order with a discount
DELIMITER //
CREATE TRIGGER before_order_update BEFORE UPDATE ON orders FOR EACH ROW
BEGIN
    DECLARE discount_amount DECIMAL(10, 2);
    SELECT discount_amount INTO discount_amount FROM discounts WHERE id = NEW.discount_id AND CURRENT_DATE BETWEEN validity_start_date AND validity_end_date;
    IF discount_amount IS NOT NULL THEN
        SET NEW.total_amount = NEW.total_amount - (NEW.total_amount * discount_amount / 100);
    END IF;
END;//
DELIMITER ;

-- Create a stored procedure to update the order status and inventory based on payment status
DROP PROCEDURE IF EXISTS UpdateOrderAndInventory;

DELIMITER //
CREATE PROCEDURE UpdateOrderAndInventory(IN p_order_id INT)
BEGIN
    -- Declare a variable to hold the payment status
    DECLARE paymentStatus VARCHAR(10);

    -- Select the payment status for the given order ID from the payments table
    SELECT payment_status INTO paymentStatus FROM payments WHERE order_id = p_order_id;

    -- Check if the payment status is 'Completed'
    IF paymentStatus = 'Completed' THEN
        -- If the payment status is 'Completed', update the order status to 'Processing'
        UPDATE orders SET status = 'Processing' WHERE id = p_order_id;

        -- Update the inventory by subtracting the ordered quantity from the current quantity for each product in the order
        UPDATE inventory i
        INNER JOIN order_invoice oi ON i.product_id = oi.product_id
        SET i.quantity = i.quantity - oi.quantity
        WHERE oi.order_id = p_order_id;
    ELSE
        -- If the payment status is not 'Completed', update the order status to 'Pending'
        UPDATE orders SET status = 'Pending' WHERE id = p_order_id;
    END IF;
END;//
DELIMITER ;

-- Call the stored procedure to update the order status and inventory
CALL UpdateOrderAndInventory(1);



-- Create a trigger that updates the inventory when a product is returned
DELIMITER //
CREATE TRIGGER AfterReturns AFTER DELETE ON returns FOR EACH ROW
BEGIN
    DECLARE orderId INT;
    DECLARE resell BOOLEAN;
    SET orderId = OLD.order_id;
    SET resell = OLD.resell;
    IF resell THEN
        UPDATE inventory JOIN order_invoice ON inventory.product_id = order_invoice.product_id
        SET inventory.quantity = inventory.quantity + order_invoice.quantity WHERE order_invoice.order_id = orderId;
    END IF;
END;//
DELIMITER ;




