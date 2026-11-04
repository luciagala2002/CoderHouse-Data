-- =====================================================
-- Pre-entrega 5: Consultas con JOINs
-- Base de datos: Ventas_Tech_DB (TechStore)
-- Objetivo: cruzar ventas, clientes, productos y categorias
--           para preparar los datos de cara a Power BI
-- =====================================================

USE Ventas_Tech_DB;
GO

-- =====================================================
-- CONSULTA 1 - Vista base enriquecida (INNER JOIN)
-- Proposito: unir ventas con clientes, productos y categorias en una
-- sola fila por venta. Es la tabla base para el modelo de Power BI.
-- =====================================================
SELECT
    v.id_venta,
    v.fecha_venta,
    c.nombre            AS cliente,
    c.ciudad,
    p.nombre_producto   AS producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.total
FROM ventas v
INNER JOIN clientes   c   ON v.id_cliente   = c.id_cliente
INNER JOIN productos  p   ON v.id_producto  = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;
GO
-- Hallazgo: las 10 ventas cruzan correctamente con cliente, producto y categoria,
-- sin registros huerfanos. Los clientes de Buenos Aires concentran cerca del 43%
-- de la facturacion y la categoria Notebooks casi el 48%.

-- =====================================================
-- CONSULTA 2 - Clientes sin compras (LEFT JOIN)
-- Proposito: identificar clientes registrados que todavia no compraron,
-- util para acciones de CRM (bienvenida, primer descuento).
-- =====================================================
SELECT
    c.id_cliente,
    c.nombre,
    c.email,
    c.ciudad,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;
GO
-- Hallazgo: con los datos actuales devuelve 0 filas, es decir que los 6 clientes
-- registrados compraron al menos una vez. La consulta queda lista para detectar
-- a los nuevos registros que no concreten una compra.

-- =====================================================
-- CONSULTA 3 - Productos sin ventas (LEFT JOIN)
-- Proposito: ver que articulos del catalogo no tuvieron movimiento,
-- junto con su categoria, stock y estado.
-- =====================================================
SELECT
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio,
    p.stock,
    p.activo
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;
GO
-- Hallazgo: solo el Monitor Samsung 27 pulgadas Curvo no registra ventas, y ademas
-- tiene stock 0 y esta inactivo. Hay que decidir si se repone o se da de baja del catalogo.

-- =====================================================
-- CONSULTA 4 - Consolidado por canal (UNION ALL)
-- Proposito: simular dos canales de venta segun el metodo de pago
-- (Online: tarjeta de credito, Mercado Pago, transferencia;
--  Presencial: efectivo y debito) y calcular el total por canal.
-- =====================================================
SELECT
    canal,
    COUNT(*)   AS cantidad_pedidos,
    SUM(total) AS total_facturado
FROM (
    SELECT 'Online' AS canal, total
    FROM ventas
    WHERE metodo_pago IN ('Tarjeta de credito', 'Mercado Pago', 'Transferencia')

    UNION ALL

    SELECT 'Presencial' AS canal, total
    FROM ventas
    WHERE metodo_pago IN ('Efectivo', 'Debito')
) AS ventas_por_canal
GROUP BY canal
ORDER BY total_facturado DESC;
GO
-- Hallazgo: el canal Online factura 2.787.000 (6 pedidos), cerca del 75% del total,
-- contra 922.500 del canal Presencial (4 pedidos). Conviene reforzar el canal Online.