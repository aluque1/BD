-- -------------------------------------------------------------------------
-- Lab 5. Procedimientos almacenados PL/SQL
-- -------------------------------------------------------------------------

-- Este script contiene parte de la BD de una compañía aérea. Contiene
-- tablas con la siguiente información:
--  * modelos de avión que forman la flota de la compañía.
--  * Empleados de la compañía.
--  * Certificados de los empleados para pilotar modelos de avión.
--  * Vuelos operados por la compañía.
-- Inspecciona la estructura de la base de datos para comprender cómo se almacena la información.

-- Ejecuta el script en una sesión de SQLDeveloper para crear la base
-- de datos y escribe los procedimientos almacenados que se piden al final de este fichero.

-- Es muy importante comprobar que el código funciona utilizando
-- varios casos de prueba, con argumentos válidos y no válidos.

-- -------------------------------------------------------------------------
SET SERVEROUTPUT ON;
ALTER SESSION SET nls_date_format='DD/MM/YYYY';

drop table FWCertificate cascade constraints;
drop table FWEmpl cascade constraints;
drop table FWPlane cascade constraints;
drop table FWFlight cascade constraints;

create table FWFlight(
	flno number(4,0) primary key,
	deptAirport varchar2(20),
	destAirport varchar2(20),
	distance number(6,0),
	 -- distance, measured in miles.
	deptDate date,
	arrivDate date,
	price number(7,2));

create table FWPlane(
	pid number(9,0) primary key,
	name varchar2(30),
	maxFlLength number(6,0)
	 -- Maximum flight length, measured in miles.
	);

create table FWEmpl(
	eid number(9,0) primary key,
	name varchar2(30),
	salary number(10,2));

create table FWCertificate(
	eid number(9,0),
	pid number(9,0),
	primary key(eid,pid),
	foreign key(eid) references FWEmpl,
	foreign key(pid) references FWPlane); 



INSERT INTO FWFlight  VALUES (99,'Los Angeles','Washington D.C.',2308,to_date('04/12/2005 09:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:40', 'dd/mm/yyyy HH24:MI'),235.98);

INSERT INTO FWFlight  VALUES (13,'Los Angeles','Chicago',1749,to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:45', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO FWFlight  VALUES (346,'Los Angeles','Dallas',1251,to_date('04/12/2005 11:50', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),225-43);

INSERT INTO FWFlight  VALUES (387,'Los Angeles','Boston',2606,to_date('04/12/2005 07:03', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 05:03', 'dd/mm/yyyy HH24:MI'),261.56);

INSERT INTO FWFlight  VALUES (7,'Los Angeles','Sydney',7487,to_date('04/12/2005 05:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:10', 'dd/mm/yyyy HH24:MI'),278.56);

INSERT INTO FWFlight  VALUES (2,'Los Angeles','Tokyo',5478,to_date('04/12/2005 06:30', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:55', 'dd/mm/yyyy HH24:MI'),780.99);

INSERT INTO FWFlight  VALUES (33,'Los Angeles','Honolulu',2551,to_date('04/12/2005 09:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:15', 'dd/mm/yyyy HH24:MI'),375.23);

INSERT INTO FWFlight  VALUES (34,'Los Angeles','Honolulu',2551,to_date('04/12/2005 12:45', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 03:18', 'dd/mm/yyyy HH24:MI'),425.98);

INSERT INTO FWFlight  VALUES (76,'Chicago','Los Angeles',1749,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:03', 'dd/mm/yyyy HH24:MI'),220.98);

INSERT INTO FWFlight  VALUES (68,'Chicago','New York',802,to_date('04/12/2005 09:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:02', 'dd/mm/yyyy HH24:MI'),202.45);

INSERT INTO FWFlight  VALUES (7789,'Madison','Detroit',319,to_date('04/12/2005 06:15', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 08:19', 'dd/mm/yyyy HH24:MI'),120.33);

INSERT INTO FWFlight  VALUES (701,'Detroit','New York',470,to_date('04/12/2005 08:55', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:26', 'dd/mm/yyyy HH24:MI'),180.56);

INSERT INTO FWFlight  VALUES (702,'Madison','New York',789,to_date('04/12/2005 07:05', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),202.34);

INSERT INTO FWFlight  VALUES (4884,'Madison','Chicago',84,to_date('04/12/2005 10:12', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 11:02', 'dd/mm/yyyy HH24:MI'),112.45);

INSERT INTO FWFlight  VALUES (2223,'Madison','Pittsburgh',517,to_date('04/12/2005 08:02', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 10:01', 'dd/mm/yyyy HH24:MI'),189.98);

INSERT INTO FWFlight  VALUES (5694,'Madison','Minneapolis',247,to_date('04/12/2005 08:32', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 09:33', 'dd/mm/yyyy HH24:MI'),120.11);

INSERT INTO FWFlight  VALUES (304,'Minneapolis','New York',991,to_date('04/12/2005 10:00', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 01:39', 'dd/mm/yyyy HH24:MI'),101.56);

INSERT INTO FWFlight  VALUES (149,'Pittsburgh','New York',303,to_date('04/12/2005 09:42', 'dd/mm/yyyy HH24:MI'),to_date('04/12/2005 12:09', 'dd/mm/yyyy HH24:MI'),1165.00);



Insert into FWPlane  values ('1','Boeing 747-400','8430');
Insert into FWPlane  values ('3','Airbus A340-300','7120');
Insert into FWPlane  values ('4','British Aerospace Jetstream 41','1502');
Insert into FWPlane  values ('5','Embraer ERJ-145','1530');
Insert into FWPlane  values ('7','Piper Archer III','520');


Insert into FWEmpl  values ('567354612','Lisa Walker',256481);
Insert into FWEmpl  values ('254099823','Patricia Jones',223000);
Insert into FWEmpl  values ('355548984','Angela Martinez',212156);
Insert into FWEmpl  values ('310454876','Joseph Thompson',212156);
Insert into FWEmpl  values ('269734834','George Wright',289950);
Insert into FWEmpl  values ('552455348','Dorthy Lewis',251300);
Insert into FWEmpl  values ('486512566','David Anderson',43001);
Insert into FWEmpl  values ('573284895','Eric Cooper',114323);
Insert into FWEmpl  values ('574489457','Milo Brooks',2000);


Insert into FWCertificate values ('269734834','1');
Insert into FWCertificate values ('269734834','3');
Insert into FWCertificate values ('269734834','4');
Insert into FWCertificate values ('269734834','5');
Insert into FWCertificate values ('269734834','7');
Insert into FWCertificate values ('567354612','1');
Insert into FWCertificate values ('567354612','3');
Insert into FWCertificate values ('567354612','4');
Insert into FWCertificate values ('567354612','5');
Insert into FWCertificate values ('567354612','7');
Insert into FWCertificate values ('573284895','3');
Insert into FWCertificate values ('573284895','4');
Insert into FWCertificate values ('573284895','5');
Insert into FWCertificate values ('574489457','7');

commit;


-- -------------------------------------------------------------------------
-- Lab 5.
-- Escribe tus respuestas a continuación de cada comentario. 
-- -------------------------------------------------------------------------

/* 1. Escribe un procedimiento almacenado llamado PrintFlightInfo que
recibe un número de vuelo como parámetro y escribe en la consola la
información relacionada con el vuelo. Si el vuelo no existe, debe
imprimir un mensaje de error en la consola. Utiliza la gestión de
excepciones para controlar este error.

Por ejemplo, si se invoca con el vuelo número 7789, el resultado debe
ser el siguiente:

-------------------------------------------------------------
Información de vuelo: 7789-Madison-Detroit (319 millass)
-------------------------------------------------------------

Si el procedimiento es invocado con un vuelo no existente, por ejemplo
9999, debe mostrar un mensaje como este:

Flight number not found!

Comprueba que el procedimiento escrito funciona bien con varios casos
de prueba.
*/
create or replace procedure PrintFlightInfo(p_num_vuelo in FWFlight.flno%type) is
	v_flight_number FWFlight.flno%type;
	v_dept_airport FWFlight.deptAirport%type;
	v_dest_airport FWFlight.destAirport%type;
	v_distance FWFlight.distance%type;
begin
	select flno, deptAirport, destAirport, distance into v_flight_number, v_dept_airport, v_dest_airport, v_distance
	from FWFlight
	where flno = p_num_vuelo;
	dbms_output.put_line('----------------------------------------------------------');
	dbms_output.put_line('Flight information: ' || v_flight_number || '-'|| v_dept_airport || '-' || v_dest_airport || '(' || v_distance || ' millas)');
	dbms_output.put_line('----------------------------------------------------------');
exception
   when NO_DATA_FOUND then dbms_output.put_line('Flight number not found.');
end;
/




/* 2. Ahora escribe otro procedimiento PlanesForFlight basado en el
código del ejercicio 1: Utiliza el mismo código, pero renómbralo a
PlanesForFlight y extiéndelo para que imprima en la consola todos los
modelos de avión que pueden operar ese vuelo (son los aviones que
tienen una autonomía (maxFlLength) superior a la distancia de
vuelo). Por cada modelo de avión, debe mostrar la siguiente
información: identificador de avión, modelo, número de pilotos
certificados para ese avión, y su salario medio. Si no hay ningún
vuelo con ese número de vuelo, debe imprimir un mensaje de error en la
consola. Por ejemplo, si se invoca con el vuelo número 7789, debe
mostrar el siguiente resultado:

-------------------------------------------------------------
Aviones para el vuelo: 7789-Madison-Detroit (319 millas)
-------------------------------------------------------------
PID Modelo de avión                Num.emp.    Sueldo medio
-------------------------------------------------------------
  1 Boeing 747-400                        2       273,215.50
  3 Airbus A340-300                       3       220,251.33
  4 British Aerospace Jetstream 41        3       220,251.33
  5 Embraer ERJ-145                       3       220,251.33
  7 Piper Archer III                      3       182,810.33
-------------------------------------------------------------

Si es invocado con un vuelo no existente, el resultado debe ser:

Flight number 9999 not found!

Pista: Además de una sentencia SELECT...INTO como en el ejercicio 1,
debes utilizar un cursor para la información de los aviones. Puedes
utilizar funciones de manejo de strings para formatear la salida por
consola, como por ejemplo RPAD o TO_CHAR. Busca en las transparencias
de SQL cómo se utilizan estas funciones.
*/





/* 3. Una vez que has terminado el procedimiento anterior, copia su
código fuente y crea un tercer procedimiento llamado PilotsForFlight
que extienda el anterior de la siguiente forma: para cada modelo de
avión, debe mostrar el nombre y salario de los empleados que están
certificados para pilotar ese modelo, en orden alfabético. Por
ejemplo, si es invocado con el vuelo número 2, debe mostrar:

-------------------------------------------------------------
Aviones para el vuelo 2-Los Angeles-Tokyo (5478 millas)
-------------------------------------------------------------
PID Modelo de avión                Num.emp.    Sueldo medio
-------------------------------------------------------------
  1 Boeing 747-400                        2       273,215.50
    Pilotos:
     George Wright                                289,950.00
     Lisa Walker                                  256,481.00
-------------------------------------------------------------
  3 Airbus A340-300                       3       220,251.33
    Pilotos:
     Eric Cooper                                  114,323.00
     George Wright                                289,950.00
     Lisa Walker                                  256,481.00
-------------------------------------------------------------

Pista: para este procedimiento puedes utilizar dos cursores: uno para
los aviones (el que ya has usado en el ejercicio anterior) y otro
cursor para mostrar los pilotos certificados para ese vuelo. Los
cursores deben ser recorridos utilizando bucles FOR de cursor
anidados. Puedes utilizar variables locales para proporcionar
información del cursor externo al interno. */



/* 4. Crea un disparador llamado payRaise que, siempre que un piloto
obtenga un nuevo certificado para pilotar otro modelo de avión,
incremente un 3% su salario. Incluye varias sentencias DML para probar
el disparador.  */



