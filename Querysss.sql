CREATE DATABASE dbCoffeeShop;

USE dbCoffeeShop;

SELECT * FROM CLIENTE;
------ Ejercicio 1 ------
SELECT nombre_cliente FROM cliente RIGHT JOIN 
pedido USING(id_cliente);

------ Ejercicio 2-------
SELECT * FROM pedido WHERE fecha_registro BETWEEN '' AND '';

----- Ejercicio 3 -------
SELECT * FROM cliente ORDER BY fecha_registro DESC;

----- Ejercicio 4 -------
SELECT nombre_producto FROM producto WHERE id_producto IN (SELECT id_producto FROM detalle_pedido WHERE id_pedido = 5);

----- Ejercicio 5 -------
SELECT nombre_producto, precio_producto FROM producto ORDER BY precio_producto DESC LIMIT 1; 

----- Ejercicio 6 ------
SELECT AVG(precio_producto) FROM producto;

----- Ejercicio 7 ------
SELECT COUNT(id_pedido)
FROM pedido WHERE estado_pedido = 'Pendiente';

----- Ejercicio 8 ------
SELECT nombre_cliente FROM cliente WHERE nombre_cliente REGEXP '^L';

---- Ejercicio 9 -------
SELECT cliente.nombre_cliente, pedido.id_pedido, pedido.fecha_registro FROM cliente
RIGHT JOIN pedido
ON cliente.id_cliente = pedido.id_cliente WHERE cliente.id_cliente = 1 ORDER BY pedido.fecha_registro DESC;

--- Ejercicio 10 -------
SELECT p.nombre_producto, SUM(d.cantidad_producto) AS total_vendido
FROM detalle_pedido d
JOIN producto p ON d.id_producto = p.id_producto
GROUP BY d.id_producto
ORDER BY total_vendido DESC
LIMIT 3;

--- Ejercicio 11 -------
SELECT c.nombre_cliente, COUNT(*) AS compras
FROM cliente c
JOIN pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente
ORDER BY compras DESC
LIMIT 1;


--- Ejercicio 12 -------
SELECT p.id_pedido, p.id_cliente,  CONCAT(c.nombre_cliente, ' ', c.apellido_cliente) AS nombre_cliente, p.direccion_pedido, p.estado_pedido, p.fecha_registro,
dp.id_detalle, pr.nombre_producto, dp.cantidad_producto, dp.precio_producto 
FROM pedido p
INNER JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido
INNER JOIN producto pr ON dp.id_producto = pr.id_producto
INNER JOIN cliente c ON p.id_cliente = c.id_cliente;


