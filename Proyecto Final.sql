
--CREACION TABLA TEMPORAL
drop  table if exists spotify cascade;
CREATE TABLE spotify(
  id_cancion integer not null,
  cancion varchar(100) not null,
  artista varchar(50) not null,
  genero varchar(50) not null,
  ano integer not null,
  bpm integer not null,
  value_energia integer not null,
  value_dance integer not null,
  decibeles integer not null,
  value_envivo integer not null,
  value_positividad integer not null,
  duracion_sg integer not null,
  value_acustico integer not null,
  value_hablada integer not null,
  value_popularidad integer not null
)

SELECT * FROM spotify;

COPY spotify FROM 'A:\top10s.csv' CSV DELIMITER ',' HEADER ENCODING 'Latin1';

SELECT * FROM spotify;


-- CREACION DE TABLAS   ----------

-- Creacion tabla Generos
drop  table if exists Generos cascade;
CREATE TABLE Generos(
	id_genero INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL UNIQUE 
)
-- Creacion Tabla Artista
drop  table if exists Artistas cascade;
CREATE TABLE Artistas(
	id_artista INTEGER PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL
)

-- Creacin Tabla 
drop  table if exists Canciones cascade;
CREATE TABLE Canciones(
	id_cancion INTEGER PRIMARY KEY,
	titulo VARCHAR(100) NOT NULL,
	ano INTEGER NOT NULL CHECK (ano > 1900),
	bpm INTEGER NOT NULL CHECK (bpm >= 0),
	value_energia INTEGER NOT NULL CHECK (value_energia >= 0),
	value_dance INTEGER NOT NULL CHECK (value_dance >= 0),
	decibeles INTEGER NOT NULL CHECK (decibeles < 0),
	value_envivo INTEGER NOT NULL CHECK (value_envivo >= 0),
	value_positividad INTEGER NOT NULL CHECK (value_positividad >= 0),
	duracion_sg INTEGER NOT NULL CHECK (duracion_sg >= 0),
	value_acustica INTEGER NOT NULL CHECK (value_acustica >= 0),
	value_hablada INTEGER NOT NULL CHECK (value_hablada >= 0),
	value_popularidad INTEGER NOT NULL CHECK (value_popularidad >= 0),
	id_genero INTEGER NOT NULL,
	id_artista INTEGER NOT NULL,
	
	CONSTRAINT fk_genero FOREIGN KEY (id_genero) REFERENCES Generos (id_genero),
	CONSTRAINT fk_artista FOREIGN KEY (id_artista) REFERENCES Artistas (id_artista)
)

SELECT * FROM Canciones;

SELECT * FROM Artistas;

SELECT * FROM Generos;



-- Llenado tabla Generos

SELECT DISTINCT genero from spotify;

ALTER TABLE public.generos
    ALTER COLUMN id_genero ADD GENERATED ALWAYS AS IDENTITY;

INSERT INTO generos (nombre) SELECT DISTINCT genero from spotify;

SELECT * FROM Generos;

-- Llenado tabla Artistas

SELECT DISTINCT artista from spotify;

ALTER TABLE public.artistas
    ALTER COLUMN id_artista ADD GENERATED ALWAYS AS IDENTITY;
	
INSERT INTO artistas (nombre) SELECT DISTINCT artista from spotify;

SELECT * FROM Artistas;

-- LLenado tabla Canciones

SELECT * FROM SPOTIFY;

INSERT INTO canciones (id_cancion, titulo, ano, bpm, value_energia, value_dance, decibeles, value_envivo, value_positividad, duracion_sg, value_acustica, value_hablada,
					   value_popularidad, id_genero, id_artista)
SELECT s.id_cancion, s.cancion, s.ano, s.bpm, s.value_energia, s.value_dance, s.decibeles, s.value_envivo, s.value_positividad, s.duracion_sg, s.value_acustico, s.value_hablada, s.value_popularidad, 
ge.id_genero, ar.id_artista
FROM spotify s, artistas ar, generos ge
WHERE s.artista = ar.nombre
AND s.genero = ge.nombre;

SELECT * FROM canciones;


-- Eliminacion tabla Temproal
drop  table if exists spotify cascade;


--CREACION USERS EN SHELL

CREATE ROLE user1 login encrypted password '12345'
CREATE ROLE user2 login encrypted password '12345'

--ASIGNACION ROLES PG ADMIN


--ROLES USER1(TODOS LOS PRIVILEGIOS SOBRE LAS TABLAS)
GRANT CONNECT ON DATABASE spotify TO user1;

GRANT ALL ON canciones TO user1;
GRANT ALL ON artistas TO user1;
GRANT ALL ON generos TO user1;

--ROLES USER2 (SOLO LECTURA SOBRE CANCIONES)

GRANT CONNECT ON DATABASE spotify TO user2;
GRANT SELECT ON canciones TO user2;


--CREACION VIEW SOBRE CANCIONES

CREATE VIEW view_spotify AS
SELECT * FROM canciones;


--DESDE SHELL CON USER POSTGRES SE CREA PERMISO DE VISTA A USER2

GRANT SELECT ON view_spotify TO user2;

--- Trigger ||| En caso de insertar o update a la tabla Canciones el valor de decibles sea positivo este pasara automaticamente a negativo.

--Funcion para el trigger
create or replace function SP_db_negativo() returns Trigger
as
$$
begin
	IF(new.decibeles > 0) THEN
		new.decibeles := -1*new.decibeles;
		RETURN NEW;
	ELSE
		RETURN NEW;
	END IF;
End
$$
LANGUAGE plpgsql

-- creacion del TRIGGER

create trigger TR_insert_cancion before Insert on canciones
for each row 
execute procedure SP_db_negativo();
---Prueba del trigger
INSERT INTO canciones (id_cancion, titulo, ano, bpm, value_energia, value_dance, decibeles, value_envivo, value_positividad, duracion_sg, value_acustica, value_hablada, value_popularidad, id_genero, id_artista)
VALUES (604, 'Mi muneca me hablo', 1901, 99, 10, 10, 999, 10, 10, 300, 9, 10, 10, 10, 10);

select * from canciones where id_cancion = 604;

---- IDEAS PARA NUEVOS TRIGGERS? tal vez un trigger que asigne un id correlativo a cada nueva cancion


-- SE CREA TABLA AUDITORIA

drop  table if exists canciones_auditoria cascade;
CREATE TABLE Canciones_auditoria(
	id_auditoria serial not null,
	nombretabla varchar(50) not null,
	valoranterior text,
	nuevovalor text,
	fecha_modificacion DATE,
	tipo_modificacion varchar(25),
	usuario varchar(50) not null
)

SELECT * FROM canciones_auditoria;


-- SE CREA LA FUNCION DEL TRIGGER

CREATE OR REPLACE FUNCTION auditoria() RETURNS trigger AS
$$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO canciones_auditoria ("nombretabla", "valoranterior", "nuevovalor", "fecha_modificacion", "tipo_modificacion", "usuario")
			VALUES (TG_TABLE_NAME, OLD, NULL, now(), 'DELETE', USER);
			RETURN OLD;
	ELSEIF (TG_OP = 'UPDATE') THEN
		INSERT INTO canciones_auditoria ("nombretabla", "valoranterior", "nuevovalor", "fecha_modificacion", "tipo_modificacion", "usuario")
			VALUES (TG_TABLE_NAME, OLD, NEW, now(), 'UPDATE', USER);
			RETURN NEW;
	ELSEIF (TG_OP = 'INSERT') THEN
		INSERT INTO canciones_auditoria ("nombretabla", "valoranterior", "nuevovalor", "fecha_modificacion", "tipo_modificacion", "usuario")
			VALUES (TG_TABLE_NAME, NULL, NEW, now(), 'INSERT', USER);
			RETURN NEW;
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql


-- SE CREA EL TRIGGER PARA INSERT, UPDATE Y DELETE

CREATE TRIGGER trigger_auditoria AFTER INSERT OR UPDATE OR DELETE
ON canciones
FOR EACH ROW EXECUTE PROCEDURE auditoria();


-- SE REALIZA UNA PRUEBA INSERTANDO VALORES
INSERT INTO canciones (id_cancion, titulo, ano, bpm, value_energia, value_dance, decibeles, value_envivo, value_positividad, duracion_sg, value_acustica, value_hablada, value_popularidad, id_genero, id_artista)
VALUES (309, 'Mi muneca me hablo', 1901, 99, 10, 10, -100, 10, 10, 300, 9, 10, 10, 10, 10);

-- SE REALIZA UNA ELIMINACION DE LA FILA RECIENTEMENTE AGREGADA
DELETE FROM CANCIONES
WHERE ID_CANCION = 309;


-- SE MUESTRA EL REGISTRO DE AUDITORIA

select * from canciones_auditoria;

  
-- Generacion de Informes
-------- Canciones con una popularidad mayor al promeido.
-- con inner join
SELECT a.nombre, c.titulo, c.value_popularidad FROM artistas a
INNER JOIN canciones c ON  c.id_artista = a.id_artista
 WHERE c.value_popularidad > 
	(SELECT ROUND(AVG(value_popularidad),2) FROM CANCIONES)
ORDER BY value_popularidad desc;

-- Con left Join

SELECT a.nombre, c.titulo, c.value_popularidad FROM artistas a
LEFT JOIN canciones c ON  c.id_artista = a.id_artista
 WHERE c.value_popularidad > 
	(SELECT ROUND(AVG(value_popularidad),2) FROM CANCIONES)
ORDER BY value_popularidad desc;

--------- Cant de canciones x artista dentro del Top
-- CON INNER JOIN
	SELECT a.nombre, count(*) AS cantidad FROM artistas a
	INNER JOIN canciones c ON c.id_artista = a.id_artista
	WHERE c.value_popularidad >
		(SELECT avg(value_popularidad) From CANCIONES )
	GROUP BY a.nombre
	ORDER BY cantidad desc;

-- CON LEFT JOIN
	SELECT a.nombre, count(*) AS cantidad FROM artistas a
	LEFT JOIN canciones c ON c.id_artista = a.id_artista
	WHERE c.value_popularidad >
		(SELECT avg(value_popularidad) From CANCIONES )
	GROUP BY a.nombre
	ORDER BY cantidad desc;

SELECT * FROM CANCIONES
SELECT * FROM ARTISTAS
SELECT * FROM GENEROS
