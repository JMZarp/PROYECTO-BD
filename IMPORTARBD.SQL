--Autores:
---Jose Mendez
---Franco Fuentes

create table temporal (
	referencia INT,
	fechaalta date,
	tipo_prop varchar(50),
	tipo_op varchar(50),
	provincia varchar(50),
	superficie INT,
	construidos INT,
	precioventa INT,
	fechaventa date,
	vendedor varchar(50),
	supervisor varchar(50),
	dueno varchar(150),
	rutdueno varchar(10),
	celulardueno varchar(50),
	emaildueno varchar(150),
	comprador varchar(150),
	rutcomprador varchar(10)

)

SET DATESTYLE TO 'European';

copy temporal from 'D:\Inmuebles.csv' CSV delimiter ';' header encoding 'Latin1'


SELECT * FROM temporal;

INSERT INTO provincias (provincia) SELECT DISTINCT provincia FROM temporal;

SELECT * FROM provincias;

UPDATE temporal SET tipo_op = 'Venta' where tipo_op = 'venta';

INSERT INTO tipos_operaciones (tipo_operacion) SELECT DISTINCT tipo_op FROM temporal;

SELECT * FROM tipos_operaciones;

SELECT distinct tipo_prop FROM temporal;

INSERT INTO tipos_propiedades (tipo_propiedad) SELECT DISTINCT tipo_prop FROM temporal;

SELECT * FROM tipos_propiedades;

SELECT distinct vendedor, supervisor FROM temporal where vendedor is not null;


INSERT INTO vendedores (nombre) SELECT DISTINCT supervisor FROM temporal where supervisor is not null

INSERT INTO vendedores (id_supervisor,nombre) SELECT DISTINCT id_vendedor, vendedor FROM vendedores, temporal WHERE supervisor = nombre

SELECT * FROM vendedores;


SELECT distinct dueno FROM temporal;

SELECT distinct rutdueno FROM temporal;

INSERT INTO personas (rut, nombre, celular, email) SELECT distinct rutdueno, dueno, celulardueno, emaildueno FROM temporal;

SELECT * FROM personas;

SELECT distinct comprador FROM temporal;

SELECT distinct rutcomprador FROM temporal;

INSERT INTO personas (rut, nombre) SELECT distinct rutcomprador, comprador FROM temporal WHERE NOT EXISTS 
(SELECT rut FROM personas WHERE rut = rutcomprador) AND rutcomprador IS NOT NULL;

SELECT distinct rut FROM personas;


SELECT tipo_propiedad, provincia, superficie, superficieconstruida, dueno FROM propiedades

INSERT INTO propiedades (tipo_propiedad, provincia, superficie, superficieconstruida, dueno) 
SELECT id_tipo, id_provincia, superficie, construidos, rutdueno FROM temporal, tipos_propiedades, provincias, personas
where tipos_propiedades.tipo_propiedad = temporal.tipo_prop and
	  provincias.provincia = temporal.provincia and
	  personas.rut = temporal.rutdueno ;
	  
SELECT * FROM propiedades;


select 	p.id_propiedad, t.fechaalta,  t_o.tipo_operacion , t.precioventa, t.fechaventa, v.nombre, pe.rut
from temporal t,
	propiedades p,
	tipos_operaciones t_o,
	vendedores v,
	personas pe,
	tipos_propiedades tp,
	provincias pr
where
	p.tipo_propiedad = tp.tipo_prop and
	p.provincia = t.provincia and
	p.superficie = t.superficie and
	p.superficieconstruida = t.construidos and
	p.dueno = t.dueno and
	
	t_o.tipo_operacion = t.tipo_op and
	
	v.id_vendedor = t.vendedor and

	pe.rut = t.dueno and

	tp.tipo_propiedad = t.tipo_prop and 

	pr.provincia = t.provincia;
		
	













