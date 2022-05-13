--Autores:
---Jose Mendez
---Franco Fuentes

-- Actividad n° 1
---En caso de existir el TYPE propiedadDiponible lo Dropea y procede a crearlo.
DROP TYPE IF EXISTS propiedadDisponible CASCADE; 
 CREATE TYPE propiedadDisponible AS (
 	 ide int,
	 tipo varchar(50),
	 op varchar(50),
	 prov varchar(50),
	 constr int,
	 sup int,
	 prec integer 	 
 ); --- Identificacion , tipo de propiedad, tipo de operacion , provincia, Metros Construidos, Superficie, Precio
 


CREATE OR REPLACE FUNCTION propiedadesDisponibles(
	tipo_pr varchar(50),
	tipo_op varchar(50),
	provin varchar(50),
	minconstr int,
	minsup	int,
	maxprecio integer 
) returns setof propiedadDisponible AS
$$ 	
	DECLARE 
		prop propiedadDisponible; 
		propiedad int;
		valido int;
		tipo_propiedad varchar(50);
		tipo_operacion varchar(50);
		provincia varchar(50);
		construido int;
		super int;
		pre integer;
	BEGIN
		
	---	IF tipo_pr IS NULL or tipo_op IS NULL or provin IS NULL or minconstr IS NULL or maxprecio IS NULL THEN
	--- Falto tiempo terminarlo :'c
	
	
		FOR propiedad,tipo_propiedad,tipo_operacion,provincia,construido,super,pre IN(
			SELECT propiedades.id_propiedad,tipos_propiedades.tipo_propiedad,tipos_operaciones.tipo_operacion,provincias.provincia,superficieconstruida,superficie,precio FROM operaciones
				LEFT JOIN propiedades on propiedades.id_propiedad = operaciones.id_propiedad
				LEFT JOIN tipos_propiedades on propiedades.tipo_propiedad = tipos_propiedades.id_tipo
				LEFT JOIN tipos_operaciones on operaciones.tipo_operacion = tipos_operaciones.id_tipooperacion
				LEFT JOIN provincias on propiedades.provincia = provincias.id_provincia
				WHERE fechaoperacion ISNULL 
			)
			LOOP 
				valido := 1;


				IF tipo_pr IS NOT NULL and tipo_propiedad <> tipo_pr THEN
					valido := 0;
				END IF;
				IF tipo_op IS NOT NULL and tipo_operacion <> tipo_op THEN
					valido := 0;
				END IF;
				IF provin IS NOT NULL and provincia <> provin THEN
					valido := 0;
				END IF;
				IF minconstr IS NOT NULL and construido < minconstr THEN
					valido := 0;
				END IF;
				IF minsup IS NOT NULL and super < minsup THEN
					valido := 0;
				END IF;
				IF maxprecio IS NOT NULL and pre > maxprecio THEN
					valido := 0;
				END IF;
				
				IF valido = 1 THEN 
					prop.ide := propiedad;
					prop.tipo := tipo_propiedad;
					prop.op := tipo_operacion;
					prop.prov := provincia;
					prop.constr := construido;
					prop.sup := super;
					prop.prec := pre;
					return next prop;
				
				END IF;
			END LOOP;
			RETURN;
		END;
$$ language plpgsql;

select * from propiedadesDisponibles('Casa','Venta','Barcelona',66,128,1497132)


-- Activiad n° 2

CREATE OR REPLACE FUNCTION Pagar_comision(fecha_inicio date, fecha_termino date)
RETURNS SETOF record AS
$$

DECLARE
	registro record;	
BEGIN

FOR registro IN SELECT nombre, SUM(comision) AS cantidad
FROM (SELECT vendedores.nombre, SUM((operaciones.precio)*(0.04)) AS comision FROM operaciones
	  INNER JOIN vendedores ON vendedores.id_vendedor = operaciones.vendedor JOIN tipos_operaciones ON tipos_operaciones.id_tipooperacion = operaciones.tipo_operacion
	  WHERE operaciones.fechaoperacion >= fecha_inicio AND operaciones.fechaalta <= fecha_termino AND tipos_operaciones.tipo_operacion = 'Venta'
	  GROUP BY vendedores.nombre
	  UNION
	  SELECT v1.nombre, SUM(operaciones.precio)*(0.02) as comision FROM vendedores v
	  	INNER JOIN vendedores v1 ON v.id_supervisor = v1.id_vendedor
	  	INNER JOIN operaciones ON operaciones.vendedor = v.id_vendedor
	  	JOIN tipos_operaciones ON tipos_operaciones.id_tipooperacion = operaciones.tipo_operacion
	  	WHERE operaciones.fechaoperacion >= fecha_inicio AND operaciones.fechaalta <= fecha_termino AND tipos_operaciones.tipo_operacion = 'Venta'
	  	GROUP BY v1.nombre
	  UNION
		SELECT vendedores.nombre, SUM(operaciones.precio)*(0.08) AS comision FROM operaciones
		INNER JOIN vendedores ON vendedores.id_vendedor = operaciones.vendedor
		INNER JOIN tipos_operaciones ON tipos_operaciones.id_tipooperacion = operaciones.tipo_operacion
		WHERE operaciones.fechaoperacion >= fecha_inicio AND operaciones.fechaalta <= fecha_termino AND tipos_operaciones.tipo_operacion = 'Alquiler'
		GROUP BY vendedores.nombre
	  UNION
	  	SELECT v1.nombre, SUM(operaciones.precio)*(0.01) AS comision FROM vendedores v
	  	INNER JOIN vendedores v1 ON v.id_supervisor = v1.id_vendedor
	  	INNER JOIN operaciones ON operaciones.vendedor = v.id_vendedor
	  	INNER JOIN tipos_operaciones ON tipos_operaciones.id_tipooperacion = operaciones.tipo_operacion
	  	WHERE operaciones.fechaoperacion >= fecha_inicio AND operaciones.fechaalta <= fecha_termino AND tipos_operaciones.tipo_operacion = 'Alquiler'
	  	GROUP BY v1.nombre
	 ) AS cantidades
 	GROUP BY nombre
 
LOOP
 	RETURN NEXT registro;
END LOOP;
END;
$$language plpgsql;


