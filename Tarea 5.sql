--Autores:
---Jose Mendez
---Franco Fuentes

-- Consulta 1 


SELECT p.rut, p.nombre
FROM  personas p, propiedades pr
WHERE p.rut = pr.dueno
GROUP BY p.rut
HAVING COUNT(DISTINCT pr.id_propiedad) > 1;


--- Consulta 2
select distinct pr.provincia, tp.tipo_propiedad, t.tipo_operacion, min(precio) 
from operaciones as o
	inner join propiedades as p on (p.id_propiedad = o.id_propiedad)
	inner join provincias as pr on (pr.id_provincia = p.provincia)
	inner join tipos_propiedades as tp on (tp.id_tipo = p.tipo_propiedad)
	inner join tipos_operaciones as t on (t.id_tipooperacion = o.tipo_operacion)
WHERE comprador ISNULL
group by  pr.provincia, tp.tipo_propiedad, t.tipo_operacion
ORDER BY provincia;


--CONSULTA 3 
SELECT p.nombre 
FROM personas p, operaciones op
WHERE p.rut = op.comprador and op.tipo_operacion = 2
EXCEPT 
	SELECT p.nombre FROM personas p, propiedades pr
	where p.rut = pr.dueno			
			
--Autores:
---Jose Mendez
---Franco Fuentes	
