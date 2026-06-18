--1)

DELIMITER $$

CREATE TRIGGER tr_restar_stock_ingreso
AFTER INSERT ON Pedido_Producto
FOR EACH ROW
BEGIN
    UPDATE IngresoStock_Producto
    SET cantidad = cantidad - NEW.cantidad
    WHERE id_producto = NEW.id_producto; 
END $$

DELIMITER ;

DELIMITER ;

-- 2)

DELIMITER $$

CREATE TRIGGER tr_borrar_ingreso_stock_hijos
BEFORE DELETE ON IngresoStock
FOR EACH ROW
BEGIN
    DELETE FROM IngresoStock_Producto
    WHERE id_ingreso = OLD.id_ingreso;
END $$

DELIMITER ;

--3)

DELIMITER $$

CREATE TRIGGER tr_actualizar_categoria_cliente
AFTER INSERT ON orderdetails
FOR EACH ROW
BEGIN
    DECLARE v_customerNumber INT;
    DECLARE v_total_gastado DECIMAL(10,2);
    DECLARE v_nueva_categoria VARCHAR(10);
    SELECT customerNumber INTO v_customerNumber
    FROM orders
    WHERE orderNumber = NEW.orderNumber;

    SELECT COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) INTO v_total_gastado
    FROM orders o
    JOIN orderdetails od ON o.orderNumber = od.orderNumber
    WHERE o.customerNumber = v_customerNumber
      AND o.orderDate >= DATE_SUB(NOW(), INTERVAL 2 YEAR);
    IF v_total_gastado <= 50000.00 THEN
        SET v_nueva_categoria = 'bronce';
    ELSEIF v_total_gastado > 50000.00 AND v_total_gastado <= 100000.00 THEN
        SET v_nueva_categoria = 'plata';
    ELSE
        SET v_nueva_categoria = 'oro';
    END IF;

    UPDATE customers
    SET categoria = v_nueva_categoria
    WHERE customerNumber = v_customerNumber;
END $$

DELIMITER ;

--4)

DELIMITER $$

CREATE TRIGGER tr_incrementar_stock_productos
AFTER INSERT ON IngresoStock_Producto
FOR EACH ROW
BEGIN
    UPDATE products
    SET quantityInStock = quantityInStock + NEW.cantidad
    WHERE productCode = NEW.productCode;
END $$

DELIMITER ;

--5)

DELIMITER $$

CREATE PROCEDURE sp_eliminar_pedido(IN p_orderNumber INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
        DELETE FROM orderdetails WHERE orderNumber = p_orderNumber;
		DELETE FROM orders WHERE orderNumber = p_orderNumber;
    COMMIT;
END $$

DELIMITER ;