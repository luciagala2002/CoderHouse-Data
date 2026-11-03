-- =====================================================
-- Pre-entrega 3: Esquema normalizado y datos iniciales
-- Base de datos: Ventas_Tech_DB (TechStore)
-- Motor: SQL Server
-- =====================================================

-- Crear la base de datos si no existe y usarla
IF DB_ID('Ventas_Tech_DB') IS NULL
    CREATE DATABASE Ventas_Tech_DB;
GO

USE Ventas_Tech_DB;
GO

-- =====================================================
-- 1. DROP TABLES (orden inverso de dependencias)
-- =====================================================
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;
GO

-- =====================================================
-- 2. CREATE TABLES (DDL)
-- =====================================================

CREATE TABLE categorias (
    id_categoria     INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL,
    descripcion      VARCHAR(200)
);
GO

CREATE TABLE clientes (
    id_cliente     INT IDENTITY(1,1) PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL,
    email          VARCHAR(100) UNIQUE,
    ciudad         VARCHAR(50),
    fecha_registro DATE NOT NULL
);
GO

CREATE TABLE productos (
    id_producto     INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria    INT NOT NULL,
    precio          DECIMAL(10,2) NOT NULL,
    stock           INT DEFAULT 0,
    activo          BIT DEFAULT 1,
    CONSTRAINT FK_productos_categorias
        FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);
GO

CREATE TABLE ventas (
    id_venta    INT IDENTITY(1,1) PRIMARY KEY,
    id_cliente  INT NOT NULL,
    id_producto INT NOT NULL,
    fecha_venta DATE NOT NULL,
    cantidad    INT NOT NULL,
    total       DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(50),
    CONSTRAINT FK_ventas_clientes
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT FK_ventas_productos
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
GO

-- =====================================================
-- 3. INSERT INTO (DML)
-- =====================================================

-- Categorias (ids 1 a 4)
INSERT INTO categorias (nombre_categoria, descripcion) VALUES
('Notebooks',    'Computadoras portatiles para trabajo y estudio'),
('Smartphones',  'Telefonos celulares inteligentes'),
('Accesorios',   'Perifericos y accesorios de computacion'),
('Monitores',    'Pantallas y monitores para PC');
GO

-- Clientes (ids 1 a 6)
INSERT INTO clientes (nombre, email, ciudad, fecha_registro) VALUES
('Lucia Fernandez',  'lucia.fernandez@mail.com',  'Buenos Aires', '2026-01-15'),
('Martin Gomez',     'martin.gomez@mail.com',     'Cordoba',      '2026-02-03'),
('Sofia Ramirez',    'sofia.ramirez@mail.com',    'Rosario',      '2026-02-20'),
('Diego Alvarez',    'diego.alvarez@mail.com',    'Mendoza',      '2026-03-08'),
('Camila Torres',    'camila.torres@mail.com',    'La Plata',     '2026-04-12'),
('Nicolas Herrera',  'nicolas.herrera@mail.com',  'Buenos Aires', '2026-05-01');
GO

-- Productos (ids 1 a 9)
INSERT INTO productos (nombre_producto, id_categoria, precio, stock, activo) VALUES
('Notebook Lenovo IdeaPad 3',          1, 850000.00,  15, 1),
('Notebook HP Pavilion 15',            1, 920000.00,  10, 1),
('Samsung Galaxy A55',                 2, 620000.00,  25, 1),
('Motorola Edge 40',                   2, 480000.00,  20, 1),
('Mouse Logitech M185',                3,  18500.00, 100, 1),
('Teclado Mecanico Redragon Kumara',   3,  45000.00,  60, 1),
('Auriculares HyperX Cloud Stinger',   3,  72000.00,  40, 1),
('Monitor LG 24 pulgadas Full HD',     4, 210000.00,  18, 1),
('Monitor Samsung 27 pulgadas Curvo',  4, 330000.00,   0, 0);
GO

-- Ventas (total = cantidad x precio del producto)
INSERT INTO ventas (id_cliente, id_producto, fecha_venta, cantidad, total, metodo_pago) VALUES
(1, 1, '2026-03-10', 1, 850000.00, 'Tarjeta de credito'),
(2, 5, '2026-03-15', 2,  37000.00, 'Efectivo'),
(3, 3, '2026-04-02', 1, 620000.00, 'Debito'),
(4, 8, '2026-04-20', 2, 420000.00, 'Transferencia'),
(5, 6, '2026-05-05', 1,  45000.00, 'Tarjeta de credito'),
(1, 7, '2026-05-18', 1,  72000.00, 'Mercado Pago'),
(6, 4, '2026-06-01', 1, 480000.00, 'Tarjeta de credito'),
(2, 2, '2026-06-12', 1, 920000.00, 'Transferencia'),
(3, 5, '2026-07-07', 3,  55500.00, 'Efectivo'),
(6, 8, '2026-07-22', 1, 210000.00, 'Debito');
GO

-- =====================================================
-- 4. VALIDACION
-- =====================================================
SELECT * FROM categorias;
SELECT * FROM clientes;
SELECT * FROM productos;
SELECT * FROM ventas;
GO