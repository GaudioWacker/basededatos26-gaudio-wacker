DELIMITER $$
DROP PROCEDURE IF EXISTS InsertarPedidosMasivos$$

CREATE PROCEDURE InsertarPedidosMasivos()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_pedidos INT DEFAULT 20000;
    DECLARE v_customerNumber INT;
    DECLARE v_orderDate DATE;
    DECLARE v_requiredDate DATE;
    DECLARE v_shippedDate DATE;
    DECLARE v_status VARCHAR(15);
    DECLARE v_comments TEXT;
    DECLARE v_nextOrderNumber INT;

    SET AUTOCOMMIT = 0;

    SELECT IFNULL(MAX(orderNumber), 10000) INTO v_nextOrderNumber FROM orders;

    WHILE i <= max_pedidos DO
        SET v_nextOrderNumber = v_nextOrderNumber + 1;

-- 1
        SELECT customerNumber INTO v_customerNumber
        FROM customers
        ORDER BY RAND()
        LIMIT 1;
-- 2
        SET v_orderDate = DATE_ADD('2021-01-01', INTERVAL FLOOR(RAND() * 1200) DAY);

        SET v_requiredDate = DATE_ADD(v_orderDate, INTERVAL FLOOR(RAND() * 15) + 1 DAY);
-- 3
        CASE FLOOR(RAND() * 6)
            WHEN 0 THEN
                SET v_status = 'Shipped';
                SET v_shippedDate = DATE_ADD(v_orderDate, INTERVAL FLOOR(RAND() * 10) + 1 DAY);
                SET v_comments = 'Customer requested express delivery.';
            WHEN 1 THEN
                SET v_status = 'On Hold';
                SET v_shippedDate = NULL;
                SET v_comments = 'Waiting for payment confirmation.';
            WHEN 2 THEN
                SET v_status = 'In Process';
                SET v_shippedDate = NULL;
                SET v_comments = NULL;
            WHEN 3 THEN
                SET v_status = 'Resolved';
                SET v_shippedDate = DATE_ADD(v_orderDate, INTERVAL FLOOR(RAND() * 4) + 1 DAY);
                SET v_comments = 'Dispute resolved successfully.';
            ELSE
                SET v_status = 'Cancelled';
                SET v_shippedDate = NULL;
                SET v_comments = 'Customer cancelled before shipping.';
        END CASE;
-- 4
        INSERT INTO orders (orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber)
        VALUES (v_nextOrderNumber, v_orderDate, v_requiredDate, v_shippedDate, v_status, v_comments, v_customerNumber);

        IF MOD(i, 5000) = 0 THEN
            COMMIT;
        END IF;

        SET i = i + 1;
    END WHILE;

    COMMIT;
    SET AUTOCOMMIT = 1;

    SELECT 'se insertaron 20,000 pedidos.' AS Resultado;
END$$

DELIMITER ;

CALL InsertarPedidosMasivos();

explain analyze select * from orders o where orderNumber > 19999 and status='DELIVERED';

explain analyze select * from orders o where orderDate between '2024-04-23' and '2026-04-23';

CREATE INDEX nombre_del_indice ON orders(orderDate);
CREATE INDEX statusAndCN ON orders(status, customerNumber);