insert into provincias (provincia) select distinct provincia from temporal;

update temporal set  tipo_operacion = 'Venta' where tipo_operacion = 'venta';
insert into tipos_operaciones (tipo_operacion) select distinct tipo_operacion from temporal;

insert into tipos_propiedades (tipo_propiedad) select distinct tipo_prop from temporal;

insert into personas (rut,nombre,celular,email) 
               select distinct rutdueno,dueno,celulardueno,emaildueno from temporal;
insert into personas (rut,nombre) 
               select distinct rutcomprador,comprador from temporal
			   where rutcomprador not in (select rut from personas)
			   and rutcomprador is not null;
			   
			   
select * from operaciones			   			   
insert into vendedores (nombre) select distinct vendedor from temporal where vendedor is not null	;

update vendedores 
set id_supervisor = v2.id_vendedor
from temporal t , vendedores v2 
where vendedores.nombre = t.vendedor and t.supervisor = v2.nombre;


insert into propiedades (tipo_propiedad,provincia,superficie,superficieconstruida,dueno)
  select  tp.id_tipo, p.id_provincia, t.superficie, t.construidos, t.rutdueno
  from temporal t, tipos_propiedades tp, provincias p
  where t.tipo_prop = tp.tipo_propiedad
  and   p.provincia = t.provincia;

insert into operaciones (id_propiedad, fechaalta,tipo_operacion,precio,fechaoperacion,
						 vendedor,comprador)
select pr.id_propiedad, t.fechaalta, tio.id_tipooperacion, t.precioventa, t.fechaventa,v.id_vendedor,t.rutcomprador
from temporal t, propiedades pr, tipos_operaciones tio, vendedores v, tipos_propiedades tp, provincias p
where t.tipo_operacion = tio.tipo_operacion
and v.nombre = t.vendedor
and t.tipo_prop = tp.tipo_propiedad
and   p.provincia = t.provincia
and tp.id_tipo = pr.tipo_propiedad
and pr.provincia = p.id_provincia
and pr.superficie = t.superficie
and ( pr.superficieconstruida = t.construidos or t.construidos is null)
and pr.dueno = t.rutdueno;






=======================================================================================================================================

insert into provincias (provincia) select distinct provincia from temporal;

update temporal set  tipo_op = 'Venta' where tipo_op = 'venta';
insert into tipos_operaciones (tipo_operacion) select distinct tipo_op from temporal;

insert into tipos_propiedades (tipo_propiedad) select distinct tipo_prop from temporal;

insert into personas (rut,nombre,celular,email) 
               select distinct rutdueno,dueno,celulardueno,emaildueno from temporal;
insert into personas (rut,nombre) 
               select distinct rutcomprador,comprador from temporal
			   where rutcomprador not in (select rut from personas)
			   and rutcomprador is not null;
			   
			   
select * from operaciones;		   
			      		   
			   
insert into vendedores (nombre) select distinct vendedor from temporal where vendedor is not null	;

update vendedores 
set id_supervisor = v2.id_vendedor
from temporal t , vendedores v2 
where vendedores.nombre = t.vendedor and t.supervisor = v2.nombre;


insert into propiedades (tipo_propiedad,provincia,superficie,superficieconstruida,dueno)
  select  tp.id_tipo, p.id_provincia, t.superficie, t.construidos, t.rutdueno
  from temporal t, tipos_propiedades tp, provincias p
  where t.tipo_prop = tp.tipo_propiedad
  and   p.provincia = t.provincia;

insert into operaciones (id_propiedad, fechaalta,tipo_operacion,precio,fechaoperacion,
						 vendedor,comprador)
select pr.id_propiedad, t.fechaalta, tio.id_tipooperacion, t.precioventa, t.fechaventa,v.id_vendedor,t.rutcomprador
from temporal t, propiedades pr, tipos_operaciones tio, vendedores v, tipos_propiedades tp, provincias p
where t.tipo_op = tio.tipo_operacion
and v.nombre = t.vendedor
and t.tipo_prop = tp.tipo_propiedad
and   p.provincia = t.provincia
and tp.id_tipo = pr.tipo_propiedad
and pr.provincia = p.id_provincia
and pr.superficie = t.superficie
and ( pr.superficieconstruida = t.construidos or t.construidos is null)
and pr.dueno = t.rutdueno;
		   
