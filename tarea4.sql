--- Taller n° 4
-- Franco Fuentes
-- Jose Mendez

-- Item n°1, entregar fecha de hoy.
SELECT 'Hoy es  '|| TO_CHAR(NOW() :: DATE, 'dd/mm/yyyy');


-- Item n°2 Ventas x vendedor ordenado por fecha y provincia

---- Se asume que solamente se solicito el Id_operacion, fecha, provincia y tipo de cada operacion
select op.id_propiedad , TO_CHAR(op.fechaoperacion :: DATE, 'dd/mm/yyyy'), pr.provincia, case
					when op.tipo_operacion = 1 then 'Venta'
					when op.tipo_operacion = 2 then 'Arriendo'
					end
from operaciones op , vendedores v, propiedades p, provincias pr
where v.nombre = 'Luisa'    -- Definir nombre de vendedor manualmente
	and op.vendedor = v.id_vendedor
	and op.id_propiedad = p.id_propiedad
	and p.provincia = pr.id_provincia
Order by pr.id_provincia, op.fechaoperacion 

-- Item n°3 Vendedores junto a sus supervisores

select 'El vendedor ' || v1.nombre || ' es supervisado por '||
case 
	when v1.id_supervisor is not null
		and v1.id_supervisor = v2.id_vendedor	
	then v2.nombre
	else 'nadie'
	end
from vendedores as v1 left join vendedores as v2 on v1.id_supervisor = v2.id_vendedor



--Item 4: Comision de cada vendedor 


select 'Entre  *25/03/05 al 10/04/06*  ' || v.nombre ||' en la propiedad n°'|| o.id_propiedad || ' comisiono por concepto de ' || tp.tipo_operacion || ' $' ||-- fecha pre definida
case
	when o.tipo_operacion = 2 then o.precio*0.07
	else o.precio*0.1	
	
end

from vendedores as v left join operaciones as o on v.id_vendedor = o.vendedor, tipos_operaciones tp
where o.fechaoperacion <= '2006-04-10'     -- fechas pre definidar, modificar utilizando el formato aaaa-mm-dd
	and o.fechaoperacion >= '2005-03-25'
	and tp.id_tipooperacion = o.tipo_operacion



--- Taller n° 4
-- Franco Fuentes
-- Jose Mendez
