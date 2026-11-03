-- =====================================================
-- Pre-entrega 4: Consultas SQL de negocio
-- Base de datos: Ventas_Tech_DB (TechStore)
-- Tabla principal: ventas
-- =====================================================

USE Ventas_Tech_DB;
GO

-- =====================================================
-- CONSULTA 1 - Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes
-- =====================================================
SELECT
    MONTH(fecha_venta)  AS mes,
    SUM(total)          AS total_facturado,
    COUNT(*)            AS cantidad_pedidos,
    AVG(total)          AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO

-- =====================================================
-- CONSULTA 2 - Ranking de productos (Top 5 por facturacion)
-- =====================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad)  AS unidades_vendidas,
    SUM(total)     AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
GO

-- =====================================================
-- CONSULTA 3 - Clientes recurrentes (mas de un pedido)
-- =====================================================
SELECT
    id_cliente,
    COUNT(*)    AS cantidad_pedidos,
    SUM(total)  AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO

-- =====================================================
-- CONSULTA 4 - Productos por encima / por debajo del promedio
-- CTE 1: total facturado por producto
-- CTE 2: promedio general de facturacion por producto
-- =====================================================
WITH ventas_por_producto AS (
    SELECT
        id_producto,
        SUM(total) AS total_facturado
    FROM ventas
    GROUP BY id_producto
),
promedio_general AS (
    SELECT AVG(total_facturado) AS promedio_facturacion
    FROM ventas_por_producto
)
SELECT
    vp.id_producto,
    vp.total_facturado,
    pg.promedio_facturacion,
    CASE
        WHEN vp.total_facturado > pg.promedio_facturacion THEN 'Por encima'
        ELSE 'Por debajo'
    END AS clasificacion
FROM ventas_por_producto vp
CROSS JOIN promedio_general pg
ORDER BY vp.total_facturado DESC;
GO

-- =====================================================
-- CONCLUSIONES
-- =====================================================
-- 1) Concentracion de ventas: los 5 productos del Top 5 (ids 2, 1, 8, 3 y 4)
--    generan 3.500.000 de los 3.709.500 facturados, es decir cerca del 94%
--    de los ingresos. Son notebooks, smartphones y un monitor, todos de
--    ticket alto, por lo que conviene cuidar su stock y precio.
--
-- 2) Producto mas vendido vs. mas rentable: el producto 5 (mouse) es el que
--    mas unidades vende (5), pero queda "Por debajo" del promedio de
--    facturacion (92.500 contra un promedio de unos 463.700 por producto).
--    El mayor ingreso lo da el producto 2 (notebook HP) con 920.000 en una
--    sola unidad: vender mas unidades no implica facturar mas.
--
-- 3) Clientes frecuentes: 4 de los 6 clientes (ids 1, 2, 3 y 6) compraron
--    mas de una vez. El cliente 2 es el que mas gasto acumula (957.000),
--    seguido por el 1 (922.000). Son los mejores candidatos para acciones
--    de fidelizacion, descuentos o ventas cruzadas de accesorios.