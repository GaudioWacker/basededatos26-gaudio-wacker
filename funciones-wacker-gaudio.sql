
7)
delimiter //
create function beneficio (numero int, codigo varchar(50))returns float deterministic
begin
	declare precio float;
    select (od.priceEach-p.buyPrice) as beneficio into precio from orderdetails od
    join products p on od.productCode=p.productCode
    where od.orderNumber=numero and p.productCode=codigo;
    
    return precio;
end//
delimiter ;

8)
delimiter //
create function estado (numero int)returns int deterministic
begin
	declare estado int;
    select if(status="Cancelled", -1, 0) as resultado into estado from orders
    where orderNumber=numero;
    
    return estado;
end//
delimiter ;

10)
delimiter //
create function sugerido (codigo varchar(50))returns float deterministic
begin
	declare porcentaje float;
    select count(od.productCode)*100.0/(
		                                select count(productCode) from orderdetails where productCode=codigo
									    ) into porcentaje from orderdetails od
    join products p on od.productCode=p.productCode
    where p.MSRP < od.priceEach and od.productCode=codigo;
    
    return porcentaje;
end//
delimiter ;

12)
delimiter //
create function cantOrden (fechaDesde date, fechaHasta date, codigo varchar(50))returns float deterministic
begin
	declare mayorPrecio float;
    select max(od.priceEach) into mayorPrecio from orderdetails od 
    join orders o on od.orderNumber=o.orderNumber
    where o.orderDate between fechaDesde and fechaHasta and od.productCode=codigo;
    
	if mayorPrecio is null then
		return 0;
	end if;
    
    return mayorPrecio;
end//
delimiter ;

14)
delimiter //
create function numeroApellido (numero int)returns varchar(50) deterministic
begin
	declare apellido varchar(50);
    select b.lastName into apellido from employees a join employees b on a.reportsTo=b.employeeNumber 
    where a.employeeNumber=numero;
    
    return apellido;
end//
delimiter ;