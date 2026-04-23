-- 6)

create view sin_pagar as select c.customerNumber from customers c left join payments p on 
c.customerNumber=p.customerNumber where p.customerNumber = null;

-- 10)
create view registro_2_anios as
select c.customerName, c.phone, c.addressLine1, c.addressLine2, p.paymentDate, p.amount from customers c
join payments p on c.customerNumber=p.customerNumber where p.paymentDate < curdate()-interval 2 year
and p.amount>30000;

-- 11)
create view problemas_de_entrega as
select orderNumber, status from orders where status != "Shipped" 
and status != "In Process";

-- 13)
create view mayor_comprador as
select c.customerName, sum(od.quantityOrdered) as total from customers c
join orders o on c.customerNumber=o.customerNumber
join orderdetails od on o.orderNumber=od.orderNumber
group by c.customerNumber
order by total desc limit 1;




