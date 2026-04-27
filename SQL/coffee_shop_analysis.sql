SELECT COUNT(*)
FROM receipts_raw;

-- Se creó una copia de la tabla original, para limpieza
CREATE TABLE receipts_clean AS
SELECT * FROM receipts_raw;

/* Limpieza y Preparación de Datos (ETL) */

-- Se contaron celdas vacías ("") y NULL
SELECT COUNT(*) 
FROM receipts_clean
WHERE TRIM(categoria) = "" OR TRIM(categoria) IS NULL; -- 1499 null que sí deberían tener una categoría asignada

SELECT COUNT(*) 
FROM receipts_clean
WHERE TRIM(variante) = "" OR TRIM(variante) IS NULL; -- 16656 nulls, depende de si el cliente pide alguna variante

SELECT COUNT(*) 
FROM receipts_clean
WHERE TRIM(modificadores_aplicados) = "" OR TRIM(modificadores_aplicados) IS NULL; -- 12478 nulls, depende de si el cliente pide modificadores

SELECT COUNT(*) 
FROM receipts_clean
WHERE TRIM(comentario) = "" OR TRIM(comentario) IS NULL; -- 16081 nulls nulls, la mayoría de clientes no comentan nada

SELECT COUNT(*) 
FROM receipts_clean
WHERE TRIM(nombre_del_cliente) = "" OR TRIM(nombre_del_cliente) IS NULL; -- 16656 nulls, la columna está vacía por que no se ocupa en el negocio

SELECT COUNT(*) 
FROM receipts_clean
WHERE TRIM(contacto_del_cliente) = "" OR TRIM(contacto_del_cliente) IS NULL; -- 16656 nulls, la columna está vacía por que no se ocupa en el negocio

-- Se contaron el número de filas duplicadas
WITH filas_duplicadas AS (
	SELECT 
		*,
        ROW_NUMBER() OVER(
			PARTITION BY fecha, numero_de_recibo, tipo_de_recibo, categoria, ref, articulo, variante, modificadores_aplicados, cantidad, ventas_brutas, descuentos, ventas_netas, costo_de_los_bienes, beneficio_bruto, impuestos, tipo_de_pedido, tpv, tienda, nombre_del_cajero, nombre_del_cliente, contacto_del_cliente, comentario, estado
            ORDER BY fecha
            ) AS ranking
    FROM receipts_clean
)
SELECT COUNT(*)
FROM filas_duplicadas
WHERE ranking > 1;

-- Se detectaron las filas duplicadas
WITH filas_duplicadas AS (
	SELECT 
		*,
        ROW_NUMBER() OVER(
			PARTITION BY fecha, numero_de_recibo, tipo_de_recibo, categoria, ref, articulo, variante, modificadores_aplicados, cantidad, ventas_brutas, descuentos, ventas_netas, costo_de_los_bienes, beneficio_bruto, impuestos, tipo_de_pedido, tpv, tienda, nombre_del_cajero, nombre_del_cliente, contacto_del_cliente, comentario, estado
            ORDER BY fecha
            ) AS ranking
    FROM receipts_clean
)
SELECT *
FROM filas_duplicadas
WHERE ranking > 1;

-- Lista de productos que aún no tienen categoría
SELECT 
DISTINCT 
	categoria,
    articulo 
FROM receipts_clean
WHERE TRIM(categoria) = '' OR TRIM(categoria) IS NULL; 

-- Se detectaron errores de codificación UTF-8/latin1
-- (ejemplo: Café -> CafÃ©) en las columnas
-- categoria, tienda y modificadores_aplicados.
SELECT categoria
FROM receipts_clean
WHERE categoria LIKE '%CafÃ©%';

SELECT tienda
FROM receipts_clean
WHERE tienda LIKE '%CafÃ©%';

SELECT modificadores_aplicados
FROM receipts_clean
WHERE modificadores_aplicados LIKE '%FrÃ­o%';

SELECT modificadores_aplicados
FROM receipts_clean
WHERE modificadores_aplicados LIKE '%TÃ©%';

-- Se corrigen problemas de codificación (Ã©) 
-- en las columnas "categoria", "tienda" y "modificadores_aplicados"
UPDATE receipts_clean
SET categoria = REPLACE(categoria, 'CafÃ©', 'Café')
WHERE categoria LIKE '%CafÃ©%';

UPDATE receipts_clean
SET tienda = REPLACE(tienda, 'CafÃ©', 'Café')
WHERE tienda LIKE '%CafÃ©%';

UPDATE receipts_clean
SET modificadores_aplicados = REPLACE(modificadores_aplicados, 'FrÃ­o', 'Frío')
WHERE modificadores_aplicados LIKE '%FrÃ­o%';

UPDATE receipts_clean
SET modificadores_aplicados = REPLACE(modificadores_aplicados, 'TÃ©', 'Té')
WHERE modificadores_aplicados LIKE '%TÃ©%';

UPDATE receipts_clean
SET modificadores_aplicados = REPLACE(modificadores_aplicados, 'CafÃ©', 'Café')
WHERE modificadores_aplicados LIKE '%CafÃ©%';

-- Validación de categorías únicas por columna
-- Objetivo: detectar typos, caracteres corruptos o categorías inesperadas.
SELECT DISTINCT tipo_de_recibo
FROM receipts_clean;

SELECT DISTINCT categoria
FROM receipts_clean;

SELECT DISTINCT articulo
FROM receipts_clean;

SELECT DISTINCT articulo
FROM receipts_clean
WHERE articulo REGEXP 'Ã';

SELECT DISTINCT modificadores_aplicados
FROM receipts_clean;

SELECT DISTINCT tipo_de_pedido
FROM receipts_clean;

SELECT DISTINCT tpv
FROM receipts_clean;

SELECT DISTINCT tienda
FROM receipts_clean;

SELECT DISTINCT nombre_del_cajero
FROM receipts_clean;

SELECT DISTINCT estado
FROM receipts_clean;

-- Se detectaron errores de codificación y formato regional
-- en la columna fecha (a. m. / p. m.).
SELECT fecha
FROM receipts_clean
WHERE fecha LIKE '%â€¯p.Â m.%' 
	OR fecha LIKE '%â€¯a.Â m.%';
    
-- Se corrigieron errores de codificación en la columna "articulo"
UPDATE receipts_clean
SET articulo = REPLACE(articulo, 'Ã¡', 'á');

UPDATE receipts_clean
SET articulo = REPLACE(articulo, 'Ã©', 'é');

UPDATE receipts_clean
SET articulo = REPLACE(articulo, 'Ã­', 'í');

UPDATE receipts_clean
SET articulo = REPLACE(articulo, 'Ã±', 'ñ');

-- Se corrgieron los problemas de codificación en la columna "fecha"
UPDATE receipts_clean
SET fecha = REPLACE(fecha, 'â€¯', ' ')
WHERE fecha LIKE '%â€¯%';

UPDATE receipts_clean
SET fecha = REPLACE(fecha, 'Â', '')
WHERE fecha LIKE '%Â%';

UPDATE receipts_clean
SET fecha = REPLACE(fecha, UNHEX('C2A0'), ' ');

UPDATE receipts_clean
SET fecha = REPLACE(fecha, 'a. m.', 'AM');

UPDATE receipts_clean
SET fecha = REPLACE(fecha, 'p. m.', 'PM');

UPDATE receipts_clean
SET fecha =
STR_TO_DATE(fecha, '%d/%m/%Y %h:%i %p');

-- Se estandarizarón celdas tipo ('') usando NULL
UPDATE receipts_clean
SET categoria = NULL
WHERE TRIM(categoria) = ''; 

UPDATE receipts_clean
SET nombre_del_cliente = NULL
WHERE TRIM(nombre_del_cliente) = '';

UPDATE receipts_clean
SET contacto_del_cliente = NULL
WHERE TRIM(contacto_del_cliente) = '';

-- Se asignó 'Sin variante' a celdas vacías de la columna variante.
UPDATE receipts_clean
SET variante = 'Sin variante'
WHERE TRIM(variante) = '';

-- Se asignó 'Sin modificadores' a celdas vacías de la columna modificadores_aplicados.
UPDATE receipts_clean
SET modificadores_aplicados = 'Sin modificadores'
WHERE TRIM(modificadores_aplicados) = '';

-- Se asignó 'Sin comentarios' a celdas vacías de la columna comentario.
UPDATE receipts_clean
SET comentario = 'Sin comentarios'
WHERE TRIM(comentario) = '';

-- Se buscó la longitud de los textos para asignar un varchar personalizado
SELECT 
    MAX(CHAR_LENGTH(tipo_de_recibo)) AS max_tipo_de_recibo,
    MAX(CHAR_LENGTH(categoria)) AS max_categoria,
    MAX(CHAR_LENGTH(articulo)) AS max_articulo,
    MAX(CHAR_LENGTH(modificadores_aplicados)) AS max_modificadores_aplicados,
    MAX(CHAR_LENGTH(tipo_de_pedido)) AS max_tipo_de_pedido,
    MAX(CHAR_LENGTH(tpv)) AS max_tpv,
    MAX(CHAR_LENGTH(tienda)) AS max_tienda,
    MAX(CHAR_LENGTH(nombre_del_cajero)) AS max_nombre_del_cajero,
    MAX(CHAR_LENGTH(comentario)) AS max_comentario,
    MAX(CHAR_LENGTH(estado)) AS max_estado,
    MAX(CHAR_LENGTH(variante)) AS max_variante
FROM receipts_clean;

-- Se estandarizarón formatos (fechas, texto, unidades)
ALTER TABLE receipts_clean
MODIFY COLUMN ref INT,
MODIFY COLUMN cantidad INT;

ALTER TABLE receipts_clean
MODIFY COLUMN tipo_de_recibo VARCHAR(15),
MODIFY COLUMN categoria VARCHAR(25),
MODIFY COLUMN articulo VARCHAR(50),
MODIFY COLUMN modificadores_aplicados VARCHAR(50),
MODIFY COLUMN tipo_de_pedido VARCHAR(25),
MODIFY COLUMN tpv VARCHAR(15),
MODIFY COLUMN tienda VARCHAR(15),
MODIFY COLUMN nombre_del_cajero VARCHAR(15),
MODIFY COLUMN comentario VARCHAR(100),
MODIFY COLUMN estado VARCHAR(15),
MODIFY COLUMN variante VARCHAR(25);

ALTER TABLE receipts_clean
MODIFY COLUMN ventas_brutas DECIMAL(10, 2),
MODIFY COLUMN descuentos DECIMAL(10, 2),
MODIFY COLUMN ventas_netas DECIMAL(10, 2),
MODIFY COLUMN costo_de_los_bienes DECIMAL(10, 2),
MODIFY COLUMN beneficio_bruto DECIMAL(10, 2),
MODIFY COLUMN impuestos DECIMAL(10, 2);

ALTER TABLE receipts_clean_dedup
MODIFY COLUMN numero_de_recibo VARCHAR(20),
MODIFY COLUMN fecha DATETIME;


/*
Latido de amor - Alimentos - ACTUALIZADO
Cheesecake - Vitrina - ACTUALIZADO
Matcha lavanda - Barra - ACTUALIZADO
Espresso extra - Barra - ACTUALIZADO
Galleta Red Velvet - Vitrina - ACTUALIZADO
Moka - Barra - ACTUALIZADO
Sandwich de jamon - Alimentos - ACTUALIZADO
Extra - Extras - ACTUALIZADO
Choco matcha - Barra - ACTUALIZADO
Extra arroz - Extras - ACTUALIZADO
Extra huevo - Extras - ACTUALIZADO
Galleta Chocomenta - Barra - PENDIENTE ------------------
MEZCAL CORA - Cueva
Empanada - Cueva
Rusa - Cueva
Galleta matcha - Vitrina - ACTUALIZADO
Macetas - Extra - ACTUALIZADO
Palomitas - Cueva
Carnavalito GDE - Cueva
Vermut spritz - Cueva 
Galleta chai - Vitrina - ACTUALIZADO
Twist - Vitrina - ACTUALIZADO
Matcha pumpkin - Barra - ACTUALIZADO
Latte pumpkin - Barra - ACTUALIZADO
Limonada de mandarina - Barra - ACTUALIZADO
Matcha mandarina - Barra - ACTUALIZADO
Pan de muerto relleno - Vitrina - ACTUALIZADO
CafÃ© grano -Extra - ACTUALIZADO
Trenzado nutella - Vitrina - ACTUALIZADO
Pan relleno de nata - Vitrina - ACTUALIZADO
*/

-- Se clasificarón categoríaS de artículos con base a 'Alimentos'
UPDATE receipts_clean
SET categoria = 'Alimentos'
WHERE articulo 
	IN ('Latido de amor', 'Sandwich de jamon');

-- Se clasificarón categoría de artículos con base a 'Vitrina'
UPDATE receipts_clean
SET categoria = 'Vitrina'
WHERE articulo 
	IN ('Cheesecake', 'Galleta Red Velvet', 'Galleta matcha', 'Galleta chai', 'Twist', 'Pan de muerto relleno', 'Trenzado nutella', 'Pan relleno de nata', 'Galleta Chocomenta');
    
-- Se clasificarón categoría de artículos con base a 'Barra'
UPDATE 	receipts_clean
SET categoria = 'Barra'
WHERE articulo
	IN ('Matcha lavanda', 'Espresso extra', 'Moka', 'Choco matcha', 'Matcha pumpkin', 'Latte pumpkin', 'Limonada de mandarina', 'Matcha mandarina');
    
-- Se clasificarón categoría de artículos con base a 'Extra'
UPDATE receipts_clean
SET categoria = 'Extra'
WHERE articulo
	IN ('Extra', 'Extra arroz', 'Extra huevo', 'Macetas', 'Café grano');
    
-- Se clasificarón categoría de artículos con base a 'Cueva'
UPDATE receipts_clean
SET categoria = 'Cueva'
WHERE articulo
	IN ('MEZCAL CORA', 'Empanada', 'Rusa', 'Palomitas', 'Carnavalito GDE', 'Vermut spritz');
    
-- Se detectaron outliers usando el método Rango Intercuartílico (IQR, por sus siglas en inglés: Interquartile Range)
WITH cuartiles AS (
	SELECT
		ventas_brutas,
        NTILE(4) OVER(ORDER BY ventas_brutas) AS numero_cuartil
	FROM receipts_clean
),
valores_iqr AS (
	SELECT
		MAX(CASE WHEN numero_cuartil = 1 THEN ventas_brutas END) AS q1,
        MAX(CASE WHEN numero_cuartil = 3 THEN ventas_brutas END) AS q3
	FROM cuartiles
)
SELECT 
	r.ventas_brutas
FROM receipts_clean r
CROSS JOIN valores_iqr v
WHERE r.ventas_brutas > (v.q3 + 1.5 * (v.q3 - v.q1))
   OR r.ventas_brutas < (v.q1 - 1.5 * (v.q3 - v.q1));
   
SELECT *
FROM receipts_clean
WHERE cantidad < 0;

SELECT COUNT(*)
FROM receipts_clean
WHERE cantidad < 0;
    
-- IMPORTANTE: Se creó la tabla receipts_clean_dedup para pasar los datos de la tabla final sin filas duplicadas afectando al ~3% del dataset original
CREATE TABLE receipts_clean_dedup AS
WITH filas_duplicadas AS (
	SELECT 
		*,
        ROW_NUMBER() OVER(
			PARTITION BY fecha, numero_de_recibo, tipo_de_recibo, categoria, ref, articulo, variante, modificadores_aplicados, cantidad, ventas_brutas, descuentos, ventas_netas, costo_de_los_bienes, beneficio_bruto, impuestos, tipo_de_pedido, tpv, tienda, nombre_del_cajero, nombre_del_cliente, contacto_del_cliente, comentario, estado
            ORDER BY fecha
            ) AS ranking
    FROM receipts_clean
)
SELECT *
FROM filas_duplicadas
WHERE ranking = 1;

-- Se eliminó las columna "ranking" ya que no será necesaria en el análisis
ALTER TABLE receipts_clean_dedup DROP COLUMN ranking;

/*
Análisis Exploratorio (EDA)
*/

-- El reembolso sobre las ventas netas brutas es < 1%, lo que es un buen indicador
SELECT 
	SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas ELSE 0 END) AS total_ventas_netas_brutas,
    SUM(CASE WHEN tipo_de_recibo = 'Reembolso' THEN ventas_netas ELSE 0 END) * -1 AS total_reembolsos,
    SUM(CASE WHEN tipo_de_recibo = 'Reembolso' THEN ventas_netas ELSE 0 END) * -1 / SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas END) * 100.0 AS porcentaje_reembolsado_sobre_ventas_netas_brutas,
	SUM(ventas_netas) AS ventas_netas_después_de_reembolsos
FROM receipts_clean_dedup;

-- Más del 99% de los clientes comen dentro del lugar
SELECT
	AVG(CASE WHEN tipo_de_pedido = 'Comer dentro' THEN 1 ELSE 0 END) * 100.0 AS porcentaje_clientes_comer_dentro,
    AVG(CASE WHEN tipo_de_pedido = 'Para llevar' THEN 1 ELSE 0 END) * 100.0 AS porcentaje_clientes_para_llevar
FROM receipts_clean_dedup;

-- El ticket promedio por cliente se mantiene en ~$260 MXN por persona y el ticke neto es de ~$256
-- lo que indica bajo nivel de reembolsos, estabilidad, pocos errores operativos 
-- ya que estos mismos no afectan en gran medida las ganancias totales
SELECT
	SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas ELSE 0 END) AS total_ventas_netas_brutas, 
    COUNT(DISTINCT CASE WHEN tipo_de_recibo = 'Venta' THEN numero_de_recibo ELSE 0 END) AS tickets_totales_ventas,
    SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas ELSE 0 END) / COUNT(DISTINCT CASE WHEN tipo_de_recibo = 'Venta' THEN numero_de_recibo ELSE 0 END) AS ticket_promedio
FROM receipts_clean_dedup;

SELECT
	SUM(ventas_netas) AS total_ventas_netas_brutas, 
    COUNT(DISTINCT numero_de_recibo) AS tickets_totales,
	SUM(ventas_netas) / COUNT(DISTINCT numero_de_recibo) AS ticket_neto
FROM receipts_clean_dedup;

-- La cantidad promedio de productos comprados por cliente es de ~4
WITH tickets AS (
    SELECT
        numero_de_recibo,
        SUM(cantidad) AS items_por_ticket
    FROM receipts_clean_dedup
    WHERE tipo_de_recibo = 'Venta'
    GROUP BY numero_de_recibo
)
SELECT
    AVG(items_por_ticket) AS cantidad_promedio_por_ticket
FROM tickets;

-- Barra es la categoría que mayores ganancias genera
-- Alimentos es la categoría con más reembolsos
SELECT 
	categoria,
    SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas ELSE 0 END) AS ventas_totales_por_categoria,
    SUM(CASE WHEN tipo_de_recibo = 'Reembolso' THEN ventas_netas ELSE 0 END) AS reembolsos_totales_por_categoria,
	SUM(ventas_netas) AS ventas_netas_por_categoria
FROM receipts_clean_dedup
GROUP BY categoria
ORDER BY SUM(ventas_netas) DESC;


SELECT 
	ref,
    articulo,
    SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas ELSE 0 END) AS ventas_totales_por_articulo,
    SUM(CASE WHEN tipo_de_recibo = 'Reembolso' THEN ventas_netas ELSE 0 END) AS reembolsos_totales_por_articulo,
    SUM(ventas_netas) AS ventas_netas_por_articulo
FROM receipts_clean_dedup
GROUP BY ref, articulo
ORDER BY SUM(ventas_netas) DESC;

WITH ventas_por_dia AS (
	SELECT
		*,
		DAYNAME(fecha) AS dia
	FROM receipts_clean_dedup
)
SELECT 
	dia,
    SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas ELSE 0 END) AS ventas_totales_por_dia,
    SUM(CASE WHEN tipo_de_recibo = 'Reembolso' THEN ventas_netas ELSE 0 END) AS reembolsos_totales_por_articulo,
	SUM(ventas_netas) AS ventas_netas_por_dia
FROM ventas_por_dia
GROUP BY dia
ORDER BY ventas_netas_por_dia DESC;

WITH ventas_por_hora AS (
	SELECT
		*,
		HOUR(fecha) AS hora
	FROM receipts_clean_dedup
)
SELECT
	hora,
    SUM(CASE WHEN tipo_de_recibo = 'Venta' THEN ventas_netas ELSE 0 END) AS ventas_totales_por_hora,
    SUM(CASE WHEN tipo_de_recibo = 'Reembolso' THEN ventas_netas ELSE 0 END) AS reembolsos_totales_por_hora,
	SUM(ventas_netas) AS ventas_netas_por_hora
FROM ventas_por_hora
GROUP BY hora
ORDER BY ventas_netas_por_hora;

SELECT
    articulo,
    SUM(cantidad) AS unidades_vendidas,
    SUM(ventas_netas) AS ventas,
    COUNT(DISTINCT numero_de_recibo) AS tickets_donde_aparece
FROM receipts_clean_dedup
WHERE tipo_de_recibo = 'Venta'
GROUP BY articulo
ORDER BY unidades_vendidas ASC;

WITH tickets AS (
	SELECT
		numero_de_recibo,
		SUM(CASE WHEN categoria IN ('Alimentos', 'Vitrina') THEN 1 ELSE 0 END) AS tiene_comida,
		SUM(CASE WHEN categoria = 'Barra' THEN 1 ELSE 0 END) AS tiene_bebida
	FROM receipts_clean_dedup
	WHERE tipo_de_recibo = 'Venta'
	GROUP BY numero_de_recibo
)
SELECT 
	COUNT(*) AS total_tickets,
	SUM(CASE WHEN tiene_comida >= 1 AND tiene_bebida >= 1 THEN 1 ELSE 0 END) AS tickets_combo,
    SUM(CASE WHEN tiene_comida > 1 AND tiene_bebida > 1 THEN 1 ELSE 0 END) / COUNT(*) * 100 AS porcentaje_tickets_bebida_alimento
FROM tickets;
