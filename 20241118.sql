-- -----------------------------------------------
-- 05sql2 Tablas para ejemplos de clase.
-- -----------------------------------------------

drop table Distribucion;
drop table Proyecto;
drop table Emp;
drop table Dpto;

create table Dpto (
  CodDp varchar2(3) primary key,
  Nombre varchar2(20));


create table Emp (
  NIF varchar2(10) primary key, 
  Nombre varchar2(40),
  CodDp varchar2(3) references Dpto);
  
create table Proyecto (
  CodPr varchar2(3) primary key,
  NIFDir varchar2(10) references Emp,
  Descr varchar2(20)
  );

create table Distribucion (
  CodPr varchar2(3) references Proyecto,
  NIF varchar2(10) references Emp,
  horas integer,
  primary key (CodPr, NIF));

insert into Dpto values ('SMP','Servicios Multiples');
insert into Dpto values ('RH','Recursos Humanos');
  
insert into Emp values ('27347234T','Marta Sanchez','SMP');
insert into Emp values ('85647456W','Alberto San Gil','SMP');
insert into Emp values ('37562365F','Maria Puente','RH');
insert into Emp values ('34126455Y','Juan Panero','SMP');
insert into Emp values ('12345678Z','Juan Español',null);

insert into Proyecto values ('PR1','27347234T','Ventas');
insert into Proyecto values ('PR2','37562365F','Personal');
insert into Proyecto values ('PR3','37562365F','Logistica');

insert into Distribucion values ('PR1','27347234T',20);
insert into Distribucion values ('PR3','27347234T',25);
insert into Distribucion values ('PR2','27347234T',25);
insert into Distribucion values ('PR3','37562365F',45);
insert into Distribucion values ('PR1','37562365F',10);
insert into Distribucion values ('PR1','34126455Y',10);

commit;

-- -----------------------------------------------------
-- 06plsql: Ejercicios de clase
-- -----------------------------------------------------
SET SERVEROUTPUT ON;

/* 1. Escribe un procedimiento almacenado que reciba como parámetro un
   número N y escriba en la consola los números impares de 1 hasta
   N. Si N es menor o igual a 0 o mayor a 100 debe escribir un mensaje 
   de error. */
   CREATE OR REPLACE PROCEDURE func1(p IN VARCHAR) IS
   
   BEGIN
   
   END;



/* 2. Escribe un procedimiento almacenado que incremente el número de
   horas asignadas a cada proyecto en un porcentaje recibido como
   parámetro. Prueba el procedimiento con distintos valores del
   parámetro. */


/* 3. Escribe un procedimiento almacenado que, dado un NIF de empleado
   recibido como parámetro, escriba en la consola su nombre,
   departamento, número de proyectos en los que trabaja y número total
   de horas asignadas a proyectos. Si el empleado no existe en la base
   de datos, debe mostrar un mensaje de error. */


/* 4. Escribe un procedimiento almacenado que muestre en la consola el
   número total de horas asignadas por proyecto, así como el nombre
   del director del proyecto y el departamento al que pertenece.  */
