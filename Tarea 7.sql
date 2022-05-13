--Autores:
---Jose Mendez
---Franco Fuentes


-- creacion de tabla temporal para cargar 
CREATE table temporal(
	serie varchar(2),
	digitos int

)

copy temporal from 'D:\digitos.csv' CSV delimiter ';' header encoding 'Latin1'



CREATE function sumastring (cadena varchar(10))
				returns integer as
$$
declare 
	suma integer;
	i integer;
begin
	for i in 1..length(cadena) loop
		suma := suma + substring(cadena, i , 1)::integer;
	end loop;
	return (suma);

end;
 $$ language plpgsql;