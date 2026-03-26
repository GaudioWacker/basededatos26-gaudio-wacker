1)
delimiter //
create function estado (fechaDesde date, fechaHasta date, estado varchar(50))
returns int deterministic
begin
	declare cantidad int;
    
    select count(*) into cantidad from orders
    where status=estado and orderDate between fechaDesde and fechaHasta;
    
    return cantidad;
end //
delimiter ;

2)
DELIMITER //
CREATE FUNCTION OrdenesEntregadas(fechaDesde DATE, fechaHasta DATE)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    
    SELECT COUNT(*) INTO cantidad
    FROM orders
    WHERE shippedDate IS NOT NULL
	AND shippedDate BETWEEN fechaDesde AND fechaHasta;
    
    RETURN cantidad;
END //
DELIMITER ;

3)
delimiter //
create function ciudadEmpleado (numeroCliente int)
returns varchar(50) deterministic
begin
	declare ciudad varchar(50);
    
    select o.city into ciudad from
    customers c
    join employees e on c.salesRepEmployeeNumber=e.employeeNumber
    join offices o on e.officeCode=o.officeCode
    where c.customerNumber=numeroCliente;
    
    return ciudad;
end //
delimiter ;

8)
delimiter //
create function estado (numero int)
returns int deterministic
begin
	declare estado int;
    
    select if(status="Cancelled", -1, 0) as resultado into estado from
    orders
    where orderNumber=numero;
    
    return estado;
end//
delimiter ;

