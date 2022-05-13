drop  table if exists personas cascade;
create  table Personas (
rut varchar(10) not null,
nombre varchar (200) not null,
celular varchar(15),
email varchar (100),
constraint pk_personas primary key (rut),
constraint chk_rut check ( rut like '%_-_' ),
constraint chk_email check (email is null or email like '%_@%_.%_' )
);

drop  table if exists Tipos_Propiedades cascade;
create table Tipos_Propiedades (
id_tipo smallint not null generated always as identity,
tipo_propiedad varchar(50) not null,
constraint pk_tipospropiedades primary key (id_tipo),
constraint uq_tipospropiedades unique (tipo_propiedad)
);

drop  table if exists Provincias cascade;
create table Provincias (
id_provincia smallint not null generated always as identity,
provincia varchar(50) not null,
constraint pk_provincias primary key (id_provincia),
constraint uq_provincia unique (provincia)
);
	
drop  table if exists Tipos_Operaciones cascade;
create table Tipos_Operaciones (
id_tipooperacion smallint not null generated always as identity,
tipo_operacion varchar(50) not null,
constraint pk_tiposoperaciones primary key (id_tipooperacion)
);	

drop  table if exists Vendedores cascade;
create table Vendedores (
id_vendedor smallint not null generated always as identity,
nombre varchar(50) not null,
id_supervisor smallint,
constraint pk_vendedores primary key (id_vendedor)

);

alter table Vendedores add constraint fk_vendedores_supervisores foreign key (id_supervisor)
	                      references vendedores (id_vendedor)
	                      on delete set null on update set null;

drop  table if exists Propiedades cascade;
create table Propiedades (
id_propiedad smallint not null generated always as identity,
tipo_propiedad smallint not null,
provincia smallint not null,
superficie smallint ,	
superficieconstruida smallint,
dueno varchar(10),
constraint pk_propiedades primary key (id_propiedad),
constraint fk_propiedades_tipospropiedades foreign key (tipo_propiedad)
	                      references tipos_propiedades (id_tipo),
constraint fk_propiedades_provincias foreign key (provincia)
	                      references provincias (id_provincia),
constraint fk_propiedades_personas foreign key (dueno)
	                      references personas (rut)	
	                      on delete set null on update set null,
constraint chk_superficie check (superficie is null or superficie >= 0),
constraint chk_superficieconstruida check (superficie is null or superficieconstruida >= 0)

);


drop  table if exists Operaciones cascade;
create table Operaciones (
id_propiedad smallint not null,
fechaalta date not null,
tipo_operacion smallint not null,
precio integer not null,
fechaoperacion date ,
vendedor smallint ,
comprador varchar (10),
constraint pk_operaciones primary key (id_propiedad, fechaalta),
constraint fk_operaciones_propiedades foreign key (id_propiedad)
	                      references propiedades (id_propiedad),
constraint fk_operaciones_tipooperaciones foreign key (tipo_operacion)
	                      references tipos_operaciones (id_tipooperacion),
constraint fk_operaciones_vendedores foreign key (vendedor)
	                      references Vendedores (id_vendedor)	
	                      on delete set null on update set null,
constraint fk_operaciones_personas foreign key (comprador)
	                      references personas (rut)	
	                      on delete set null on update set null,
constraint chk_precio check (precio > 0)	
);


