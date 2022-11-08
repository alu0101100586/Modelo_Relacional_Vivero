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
