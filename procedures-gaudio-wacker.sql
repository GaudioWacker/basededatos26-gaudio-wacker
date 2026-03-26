1)
delimiter //
create procedure mayorPrecio()
begin
	select productCode from products where buyPrice > (select avg(buyPrice) from products);
    select count(*) as cantidad from products where buyPrice > (select avg(buyPrice) from products);
end //
delimiter ;

2) 
delimiter //
create procedure ordenborrar(in numero int)
begin
	
    declare cuenta int default 0;
    declare lineasBorradas int default 0;
    select count(*) into cuenta from orders where orderNumber=numero;
    if cuenta = 0 then
		select 0;
	else
		delete from orderdetails where orderNumber=numero;
        set lineasBorradas = row_count();
        delete from orders where orderNumber=numero;
        select lineasBorradas;
	end if;
end //
delimiter ;

3)
delimiter //
create procedure borrarlineaproducto (in linea varchar(50), out mensaje varchar(200))
begin
	declare cantProductos int default 0;
	select productos(linea) into cantProductos;
    if cantProductos=0 then
		set mensaje="La línea fue borrada";
	else
		set mensaje="La línea de productos no pudo borrarse";
	end if;
end //
delimiter ;

8)
delimiter //
create procedure modificarcampocomments (in numero int, in mensaje varchar(200), out logro bool)
begin
	update orders set comments=mensaje where orderNumber=numero;
    if row_count()>0 then
		set logro=1;
	end if;
end //
delimiter ;

