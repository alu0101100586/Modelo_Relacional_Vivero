/**
  *
  * USAGE:
  * || ~$ sudo su postgres
  * || ~$ psql
  * || ~$ \i bbdd_vivero.sql
  *
  */

/* Remove all the tables in 'public' schema and create the schema 'public' */ 
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

DROP TABLE IF EXISTS vivero;
DROP TABLE IF EXISTS zonas;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS almacena;
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS pedido;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS afiliado;
DROP TABLE IF EXISTS no_afiliado;
DROP TABLE IF EXISTS adquiere;

/* Creación de las tablas de nuestra base de datos de viveros */
/* TABLA VIVERO */
CREATE TABLE vivero (
  id_vivero INT NOT NULL,
  longitud VARCHAR(100) NOT NULL,
  latitud VARCHAR(100) NOT NULL,
  PRIMARY KEY(id_vivero)
);

/* TABLA ZONAS */
CREATE TABLE zonas (
  id_zona INT NOT NULL,
  id_vivero INT,
  nombre VARCHAR(30) NOT NULL,
  tipo VARCHAR(30) NOT NULL,
  PRIMARY KEY(id_zona),
  CONSTRAINT fk_vivero
    FOREIGN KEY(id_vivero)
      REFERENCES vivero(id_vivero)
        ON DELETE CASCADE
);

/* TABLA PRODUCTO */
CREATE TABLE producto (
  id_producto INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  precio_unidad FLOAT,
  unidades_stock INT,
  PRIMARY KEY(id_producto)
);

/* TABLA ALMACENA */
CREATE TABLE almacena (
  id_zona INT NOT NULL,
  id_producto INT NOT NULL,
  stock INT,
  PRIMARY KEY(id_zona, id_producto),
  CONSTRAINT fk_zona 
    FOREIGN KEY(id_zona) 
      REFERENCES zonas(id_zona) 
        ON DELETE CASCADE,
  CONSTRAINT fk_producto 
    FOREIGN KEY(id_producto) 
      REFERENCES producto(id_producto) 
        ON DELETE CASCADE
);

/* TABLA EMPLEADO */
CREATE TABLE empleado (
  id_empleado INT NOT NULL,
  id_zona INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  dni_empleado VARCHAR(9) NOT NULL,
  salario FLOAT NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE,
  PRIMARY KEY(id_empleado),
  CONSTRAINT fk_zona 
    FOREIGN KEY(id_zona) 
      REFERENCES zonas(id_zona) 
        ON DELETE CASCADE,
);

/* TABLA PEDIDO */
CREATE TABLE pedido (
  id_empleado INT NOT NULL,
  id_pedido INT NOT NULL,
  id_producto INT NOT NULL,
  precio_total FLOAT,
  numero_producto INT,
  fecha_compra DATE,
  PRIMARY KEY(id_empleado, id_pedido, id_producto),
  CONSTRAINT fk_empleado
    FOREIGN KEY(id_empleado)
      REFERENCES empleado(id_empleado)
        ON DELETE CASCADE,
  CONSTRAINT fk_producto
    FOREIGN KEY(id_producto)
      REFERENCES producto(id_producto)
        ON DELETE CASCADE,
);

/* TABLA CLIENTE */
CREATE TABLE cliente (
  dni_cliente VARCHAR(9) NOT NULL,
  nombre_cliente VARCHAR(100) NOT NULL,
  tipo VARCHAR(20) NOT NULL,
  PRIMARY KEY(dni_cliente)
);

INSERT INTO cliente
VALUES
  ('12345671H', 'Manuel Ferrero Diaz', 'No Afiliado'),
  ('12345672R', 'Jonás Toledo Hernandez', 'Afiliado'),
  ('12345673T', 'Tomas Alonso Cruz', 'Afiliado'),
  ('12345674J', 'Jorgue Santos Santana', 'No Afiliado'),
  ('12345675M', 'Martin Martin Martinez', 'No Afiliado');

/* TABLA AFILIADO */
CREATE TABLE afiliado (
  dni_cliente VARCHAR(9) NOT NULL,
  bonificación FLOAT,
  fecha_ingreso DATE NOT NULL,
  PRIMARY KEY(dni_cliente),
  CONSTRAINT fk_cliente
    FOREIGN KEY(dni_cliente) 
      REFERENCES cliente(dni_cliente) 
        ON DELETE CASCADE
);

/* TABLA NO_AFILIADO */
CREATE TABLE no_afiliado (
  dni_cliente VARCHAR(9) NOT NULL,
  numero_compras INT,
  PRIMARY KEY(dni_cliente),
  CONSTRAINT fk_cliente
    FOREIGN KEY(dni_cliente) 
      REFERENCES cliente(dni_cliente) 
        ON DELETE CASCADE
);

/* TABLA ADQUIERE */
CREATE TABLE adquiere (
  dni_cliente VARCHAR(9) NOT NULL,
  id_pedido INT NOT NULL,
  PRIMARY KEY(dni_cliente, id_pedido),
  CONSTRAINT fk_cliente
    FOREIGN KEY(dni_cliente)
      REFERENCES cliente(dni_cliente)
        ON DELETE CASCADE,
  CONSTRAINT fk_pedido
    FOREIGN KEY(id_pedido)
      REFERENCES pedido(id_pedido)
        ON DELETE CASCADE,
);

/* Insertamos t-uplas en las tablas creadas*/
INSERT INTO vivero(id_vivero, longitud, latitud)
VALUES
 (1, '51° 30′ 30″ N', '0° 7′ 32′′ O'),
 (2, '52° 31′ 28′′ N', '13° 24′ 38′′ E'),
 (3, '48° 51′ 12′′ N', '02° 20′ 56′′ E'),
 (4, '40° 24′ 59′′ N', '03° 42′ 09′′ O'),
 (5, '41° 53′ 30′′ N', '12° 29′ 39′′ E');

INSERT INTO zonas(id_zona, id_vivero, nombre, tipo)
VALUES
  (1, 1, 'Tijarafe', 'Zona Interior'),
  (2, 2, 'Bencomo', 'Zona Exterior'),
  (3, 2, 'Masca', 'Cajas'),
  (4, 3, 'Arona', 'Zona Exterior'),
  (5, 5, 'Teno', 'Zona Interior');

INSERT INTO producto(id_producto, nombre, precio_unidad, unidades_stock)
VALUES
  (1, 'Macetas Prime', 6.95, 40),
  (2, 'Carrito Jardin', 19.99, 20),
  (3, 'Expositor Floral', 37.98, 37),
  (4, 'Manguera 15m', 15.99, 50),
  (5, 'Humidificador', 39.95, 29);

INSERT INTO almacena(id_zona, id_pedido, stock)
VALUES
  (1, 1, 40),
  (2, 2, 20),
  (3, 4, 37),
  (4, 5, 50),
  (5, 3, 29);

INSERT INTO empleado(id_empleado, id_zona, nombre, dni_empleado, salario, fecha_inicio, fecha_fin)
VALUES
  (1, 1, 'Juan Perez Lozano', '00000001B', 856.79, '01/01/1999', NULL),
  (2, 2, 'Jose FRancisco, Diaz Melian', '00000003H', 1256.89, '03/05/1999', '30/11/2022'),
  (3, 3, 'Daniel Leon Cruz', '00000002G', 856.79, '10/09/2005', NULL),
  (4, 5, 'Manuel Hernandez Hernandez', '00000009J', 960.58, '04/12/2010', NULL),
  (5, 4, 'Cristian Hernandez Diaz', '00000004L', 1067.47, '02/09/2020', '02/12/2021');

INSERT INTO pedido(id_empleado, id_pedido, id_producto, precio_total, numero_producto, fecha_compra)
VALUES
  (1, 1, 3, 37.98, 1, '07/10/2011'),
  (2, 2, 2, 19.99, 1, NULL),
  (3, 3, 5, 39.95, NULL, NULL),
  (4, 4, 1, NULL, NULL, NULL),
  (5, 5, 4, 31.98, 2, '10/02/2022');

INSERT INTO cliente
VALUES
  ('12345671H', 'Manuel Ferrero Diaz', 'No Afiliado'),
  ('12345672R', 'Jonás Toledo Hernandez', 'Afiliado'),
  ('12345673T', 'Tomas Alonso Cruz', 'Afiliado'),
  ('12345674J', 'Jorgue Santos Santana', 'No Afiliado'),
  ('12345675M', 'Martin Martin Martinez', 'No Afiliado');

INSERT INTO afiliado(dni_cliente, bonificación, fecha_ingreso)
VALUES
  ('12345672R', 28.69, '30/03/2010'),
  ('12345673T', 40.37, '28/02/2006');

INSERT INTO no_afiliado(dni_cliente, numero_compras)
VALUES
  ('12345671H', 15),
  ('12345674J', 30),
  ('12345675M', 20);

INSERT INTO adquiere (dni_cliente, id_pedido)
VALUES
  ('12345671H', 1),
  ('12345672R', 4),
  ('12345673T', 2),
  ('12345674J', 3),
  ('12345675M', 5);

/* Seleccionamos todas las tablas para ver todo el contenido de cada una*/
SELECT * FROM vivero;

SELECT * FROM zonas;

SELECT * FROM producto;

SELECT * FROM almacena;

SELECT * FROM empleado;

SELECT * FROM pedido;

SELECT * FROM cliente;

SELECT * FROM afiliado;

SELECT * FROM no_afiliado;

SELECT * FROM adquiere;
