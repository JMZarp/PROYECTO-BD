--- Taller n° 6
-- Franco Fuentes
-- Jose Mendez

-- Actividad n° 1:Monstrae el mes con mayor venta/arriendo

Opción 1 

SELECT to_char(fechaoperacion, 'MM/YYYY') AS fecha ,  SUM(precio) AS totalmes from operaciones
where fechaoperacion is not null
GROUP BY to_char(fechaoperacion, 'MM/YYYY')
HAVING SUM(precio) >= all (
	SELECT SUM(precio) from operaciones
	where fechaoperacion is not null
	GROUP BY to_char(fechaoperacion, 'MM/YYYY')
)


-- Actividad n° 2: 

SELECT p.provincia, to_char(o.fechaoperacion, 'MM/YYYY') AS fecha
	from provincias as p, operaciones as o
	WHERE  o.precio = (SELECT  SUM(precio) AS totalmes from operaciones
						GROUP BY to_char(fechaoperacion, 'MM/YYYY')
						HAVING SUM(precio) >= all (
						SELECT SUM(precio) from operaciones
						GROUP BY to_char(fechaoperacion, 'MM/YYYY')
						)
					)








--Actividad n° 3








--- Taller n° 6
-- Franco Fuentes
-- Jose Mendez
