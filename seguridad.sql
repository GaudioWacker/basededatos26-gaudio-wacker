-- 1)
CREATE USER 'analista_stock'@'localhost' IDENTIFIED BY 'analista de stock';
CREATE USER 'gestor_productos'@'localhost' IDENTIFIED BY 'gestor de productos';
CREATE USER 'analista_ordenes'@'localhost' IDENTIFIED BY ' analista de órdenes';
CREATE USER 'usuario_reportes'@'localhost' IDENTIFIED BY ' usuario de reportes';
CREATE USER 'desarrollo'@'localhost' IDENTIFIED BY 'desarrollo';
CREATE USER 'administrador_base_de_datos'@'localhost' IDENTIFIED BY 'administrador de base de datos';

SELECT User, Host FROM mysql.user;
-- 2)
CREATE ROLE 'Procedimientos_Stock';
GRANT EXECUTE ON PROCEDURE stock.actualizarStock TO 'Procedimientos_Stock';
GRANT EXECUTE ON PROCEDURE stock.reducirPrecio TO 'Procedimientos_Stock';
GRANT EXECUTE ON PROCEDURE stock.actualizarPrecioPorProveedor TO 'Procedimientos_Stock';
GRANT SELECT ON stock.* TO 'Procedimientos_Stock';

CREATE ROLE 'Gestion_Ordenes';
GRANT EXECUTE ON PROCEDURE stock.borrarOrden TO 'Gestion_Ordenes';
GRANT EXECUTE ON PROCEDURE stock.borrarLineaProductos TO 'Gestion_Ordenes';
GRANT EXECUTE ON PROCEDURE stock.actualizarComentarios TO 'Gestion_Ordenes';
GRANT SELECT ON classicmodels.orders TO 'Gestion_Ordenes';
GRANT SELECT ON classicmodels.ordersdetails TO 'Gestion_Ordenes';

CREATE ROLE 'Lectura_Reportes';
GRANT SELECT ON stock.* TO 'Lectura_Reportes';
GRANT SELECT ON classicmodels.* TO 'Lectura_Reportes';

CREATE ROLE 'Desarrollo';
GRANT SELECT, INSERT, UPDATE, DELETE ON stock.* TO 'Desarrollo';
GRANT CREATE ROUTINE, ALTER ROUTINE, EXECUTE ON stock.* TO 'Desarrollo';
GRANT TRIGGER ON stock.* TO 'Desarrollo';
GRANT EVENT ON stock.* TO 'Desarrollo';

CREATE ROLE 'Administrador';
GRANT ALL PRIVILEGES ON classicmodels.* TO 'Administrador';
GRANT ALL PRIVILEGES ON stock.* TO 'Administrador';

SELECT * FROM mysql.role_edges re;

-- 3)
GRANT 'Procedimientos_Stock' TO 'analista_stock'@'localhost';
GRANT 'Gestion_Ordenes' TO 'gestor_productos'@'localhost';
GRANT 'Lectura_Reportes' TO 'usuario_reportes'@'localhost';
GRANT 'Desarrollo' TO 'desarrollo'@'localhost';
GRANT 'Administrador' TO 'administrador_base_de_datos'@'localhost';

-- 4)
CREATE USER 'RRHH'@'localhost' IDENTIFIED BY 'RRHH';
GRANT SELECT (firstName, lastName, jobTitle, officeCode) ON classicmodels.employees TO 'RRHH';
GRANT EXECUTE ON PROCEDURE classicmodels.cantEmpleados TO 'RRHH';
ALTER TABLE classicmodels.employees
ADD salary decimal(10,2);
SELECT salary FROM classicmodels.employees;

-- 5) 
CREATE USER ' operador_de_stock '@'localhost' IDENTIFIED BY 'operador de stock ';
GRANT EXECUTE ON PROCEDURE stock.actualizarStock TO 'operador_de_stock';
call actualizarStock();


