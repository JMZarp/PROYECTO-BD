--Autores:
---Jose Mendez
---Franco Fuentes

----ACTIVIDAD 1 

drop  table if exists Transaciones cascade;
--- Se asume que tabla, accion, usuario, campos insetados y modificados se almacenan como VARChar
create table Transaciones (
tabla VARCHAR(30),
accion VARCHAR(30),
fecha-hora TIMESTAMP,
usuario VARCHAR(30),
camposinsertados VARCHAR(300),
camposmodificados VARCHAR(300)
);



CREATE OR REPLACE FUNCTION history() returns trigger as
$$

    begin

    raise exception 'Todo impeque compadre';

    end
$$ language plpgsql   


CREATE TRIGGER tr_Propiedades_insert AFTER INSERT
    on propiedades 
    execute PROCEDURE history();

SELECT * from propiedades 
insert into propiedades (tipo_propiedad,provincia,superficie,superficieconstruida,dueno)
    VALUES(1, 4, 100, 1000,24977874-5)










--- ACTIVIDAD 2 











--- ACTIVIDAD 3


