CREATE DATABASE IF NOT EXISTS dbHuellitasPets;

dbhuellitaspetsUSE dbHuellitasPets;

CREATE TABLE IF NOT EXISTS clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre_cliente VARCHAR(50) NOT NULL,
  apellido_cliente VARCHAR(50) NOT NULL,
  dui_cliente VARCHAR(10) UNIQUE,
  correo_cliente VARCHAR(100) UNIQUE,
  telefono_cliente VARCHAR(9) UNIQUE,
  nacimiento_cliente DATE,
  direccion_cliente VARCHAR(250) NOT NULL,
  clave_cliente VARCHAR(200),
  estado_cliente ENUM ('Activo', 'Inactivo'),
  fecha_registro_cliente DATE,
  imagen_cliente VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS permisos (
  id_permiso INT AUTO_INCREMENT PRIMARY KEY,
  nombre_permiso VARCHAR(100),
  agregar_actualizar_usuario BOOL,
  eliminar_usuario BOOL,
  agregar_actualizar_producto BOOL,
  eliminar_producto BOOL,
  borrar_comentario BOOL,
  agregar_actualizar_categoria BOOL,
  borrar_categoria BOOL,
  gestionar_cupon BOOL
);

CREATE TABLE IF NOT EXISTS administradores (
  id_admin INT AUTO_INCREMENT PRIMARY KEY,
  nombre_admin VARCHAR(50) NOT NULL,
  apellido_admin VARCHAR(50) NOT NULL,
  correo_admin VARCHAR(100) UNIQUE,
  alias_admin VARCHAR(50) UNIQUE,
  clave_admin VARCHAR(100),
  fecha_registro_admin DATE,
  imagen_admin VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS asignacionPermisos (
  id_asignacion_permiso INT AUTO_INCREMENT PRIMARY KEY,
  id_permiso INT,
  id_admin INT,
  CONSTRAINT fk_asignacionPermisos_permisos FOREIGN KEY (id_permiso) REFERENCES permisos (id_permiso),
  CONSTRAINT fk_asignacionPermisos_administradores FOREIGN KEY (id_admin) REFERENCES administradores (id_admin)
);

CREATE TABLE IF NOT EXISTS categorias (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre_categoria VARCHAR(50) NOT NULL,
  descripcion_categoria VARCHAR(250) NOT NULL,
  imagen_categoria VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS marcas (
  id_marca INT AUTO_INCREMENT PRIMARY KEY,
  nombre_marca VARCHAR(100) NOT NULL,
  imagen_marca VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre_producto VARCHAR(50) NOT NULL,
  descripcion_producto VARCHAR(250) NOT NULL,
  precio_producto DECIMAL(5,2) NOT NULL,
  imagen_producto VARCHAR(50),
  estado_producto ENUM('activo', 'inactivo'),
  existencia_producto INT,
  fecha_registro_producto DATE NOT NULL,
  mascotas ENUM('perro', 'gato'),
  id_categoria INT,
  id_marca INT,
  CONSTRAINT fk_Productos_Marca FOREIGN KEY (id_marca) REFERENCES marcas (id_marca),
  CONSTRAINT fk_Productos_categoria FOREIGN KEY (id_categoria) REFERENCES categorias (id_categoria)
);

CREATE TABLE IF NOT EXISTS pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  estado_pedido ENUM('pendiente', 'completado', 'cancelado'),
  fecha_registro_pedido DATE NOT NULL,
  direccion_pedido VARCHAR(250) NOT NULL,
  id_cliente INT,
  CONSTRAINT fk_Pedidos_Clientes FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente)
);

CREATE TABLE IF NOT EXISTS cuponOferta(
 id_cupon INT AUTO_INCREMENT PRIMARY KEY,
 codigo_cupon VARCHAR(50) UNIQUE,
 porcentaje_cupon FLOAT,
 estado_cupon BOOL,
 fecha_ingreso_cupon DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS cuponesUtilizados(
 id_utilizado INT AUTO_INCREMENT PRIMARY KEY,
 id_cupon INT,
 id_cliente INT,
 CONSTRAINT fk_cupononesUtilizados_idcupon FOREIGN KEY (id_cupon) REFERENCES cuponOferta (id_cupon),	
 CONSTRAINT fk_cupononesUtilizados_idcliente FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente)
);

CREATE TABLE IF NOT EXISTS detallesPedidos (
  id_detalle_pedido INT AUTO_INCREMENT PRIMARY KEY,
  cantidad_detalle_pedido INT CHECK(cantidad_detalle_pedido >= 0),
  precio__detalle_pedido DECIMAL(5,2) NOT NULL,
  id_producto INT,
  id_pedido INT,
  CONSTRAINT fk_DetallesPedidos_Productos FOREIGN KEY (id_producto) REFERENCES productos (id_producto),
  CONSTRAINT fk_DetallesPedidos_Pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido)
);

CREATE TABLE IF NOT EXISTS valoraciones (
  id_valoracion INT AUTO_INCREMENT PRIMARY KEY,
  calificacion_valoracion INT,
  comentario_valoracion VARCHAR(250),
  fecha_valoracion DATE NOT NULL,
  estado_valoracion BOOL,
  id_cliente INT,
  CONSTRAINT fk_Valoraciones_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

INSERT INTO categorias (nombre_categoria, descripcion_categoria, imagen_categoria)
VALUES
  ('Electronics', 'Electronic devices and accessories', 'electronics.jpg'),
  ('Clothing', 'Fashion and apparel', 'clothing.jpg'),
  ('Home and Garden', 'Home decor and gardening', 'home_garden.jpg'),
  ('Toys and Games', 'Toys and games for all ages', 'toys_games.jpg'),
  ('Books', 'Books and literature', 'books.jpg');

-- Insersion de datos en tabla de marcas
INSERT INTO marcas (nombre_marca, imagen_marca)
VALUES
  ('Samsung', 'samsung.jpg'),
  ('Nike', 'nike.jpg'),
  ('Home Essentials', 'home_essentials.jpg'),
  ('ToyJoy', 'toyjoy.jpg'),
  ('BookWorm', 'bookworm.jpg');

-- Insersion de datos en tabla de productos
INSERT INTO productos (nombre_producto, descripcion_producto, precio_producto, imagen_producto, estado_producto, existencia_producto, fecha_registro_producto, mascotas, id_categoria, id_marca)
VALUES
  ('Smartphone X', 'High-end smartphone', 999.99, 'smartphoneX.jpg', 'activo', 100, '2024-02-20', 'perro', 1, 1),
  ('Running Shoes', 'Comfortable running shoes', 79.99, 'runningshoes.jpg', 'activo', 150, '2024-02-20', 'gato', 2, 2),
  ('Home Decor Set', 'Modern home decor set', 249.99, 'homedecorset.jpg', 'activo', 30, '2024-02-20', 'perro', 3, 3),
  ('Board Game Collection', 'Family-friendly board games', 39.99, 'boardgames.jpg', 'activo', 80, '2024-02-20', 'gato', 4, 4),
  ('Bestseller Novels Set', 'Collection of bestselling novels', 129.99, 'bestsellerbooks.jpg', 'activo', 50, '2024-02-20', 'perro', 5, 5); 
  
CREATE FUNCTION calcular_precio_total_producto(producto_id INT, cantidad_detalle_pedido INT)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE precio_total DECIMAL(10,2);
    DECLARE total DECIMAL(10,2);

    SELECT precio_producto INTO precio_total
    FROM productos
    WHERE id_producto = producto_id;

    SET total = precio_total * cantidad_detalle_pedido;

    RETURN total;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AgregarCupon(codigo VARCHAR(100), porcentaje INT, estado BOOL)
BEGIN
    -- Declaramos la variable que contendrá el día de ingreso del cupón
    DECLARE fechaActual DATE;
    SET fechaActual = CURDATE();
    
    INSERT INTO cuponOferta(codigo_cupon, porcentaje_cupon, estado_cupon, fecha_ingreso_cupon) VALUES (codigo, porcentaje, estado, fechaActual);

END //

DELIMITER ;

CALL AgregarCupon ('TREBOR', 30, 1);

 -- TRIGGER PARA ACTUALIZAR EXISTENCIAS DE PRODUCTO SI SE HACE UN PEDIDO --
DELIMITER //

CREATE TRIGGER actualizar_existencias AFTER INSERT ON detallesPedidos
FOR EACH ROW
BEGIN 
	UPDATE productos
	SET existencia_producto = existencia_producto - NEW.cantidad_producto
	WHERE id_producto = NEW.id_producto;
END

//
DELIMITER;

SELECT calcular_precio_total_producto(2, 5);	