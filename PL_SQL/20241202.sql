-- -------------------------------------------------------------------------
-- LAB 6. PL/SQL: PROCEDIMIENTOS ALMACENADOS Y DISPARADORES 2.
-- -------------------------------------------------------------------------

-- Este script contiene parte de la definición de la BD utilizada por
-- una cadena de centros comerciales. Contiene tablas con la siguiente
-- información:
--  * Los centros comerciales que forman la cadena.
--  * Los departamentos de cada centro comercial.
--  * Las ofertas disponibles en cada departamento de cada centro
--    comercial.
--  * La compra de productos por los clientes.
-- Inspecciona la estructura de la BD para aprender cómo se almacena
-- la información.

-- Ejecuta el script en una sesión de SQLDeveloper para crear la base
-- de datos y escribe tus respuestas a las preguntas que aparecen al
-- final de este script.

-- Es muy importante que comprobéis que el código funciona utilizando
-- varios casos de prueba, con parámetros válidos e inválidos.

-- -------------------------------------------------------------------------
set linesize 300;
SET SERVEROUTPUT ON;
alter session set nls_date_format='DD-MM-YYYY';

DROP TABLE DSVenta CASCADE CONSTRAINTS;
DROP TABLE DSOferta CASCADE CONSTRAINTS;
DROP TABLE DSDept CASCADE CONSTRAINTS;
DROP TABLE DSCentro CASCADE CONSTRAINTS;

CREATE TABLE DSCentro (
  IdCentro VARCHAR2(5) PRIMARY KEY,
  Direccion VARCHAR2(40)
);

CREATE TABLE DSDept (
  IdCentro VARCHAR2(5) REFERENCES DSCentro,
  IdDept NUMBER(3),
  Descr VARCHAR2(40),
  FechaOfertas DATE,
  NumOfertas NUMBER(6,0),
  PRIMARY KEY (IdCentro, IdDept)
);

CREATE TABLE DSOferta (
  IdOferta VARCHAR2(5) PRIMARY KEY,
  IdCentro VARCHAR2(5),
  IdDept NUMBER(3),
  fechaInicio DATE,
  fechaFin DATE,
  Producto VARCHAR2(40),
  ItemsEnOferta NUMBER(4) NOT NULL,
  ItemsVendidos NUMBER(4) DEFAULT 0 NOT NULL,
  FOREIGN KEY (IdCentro, IdDept) REFERENCES DSDept,
  CHECK (ItemsEnOferta > 0),
  CHECK (ItemsEnOferta >= ItemsVendidos)
);

Create TABLE DSVenta (
  IdVenta VARCHAR2(5) PRIMARY KEY,
  IdOferta VARCHAR2(5) REFERENCES DSOferta,
  FechaVenta DATE,
  Cliente VARCHAR2(40),
  NumItems NUMBER(4),
  CHECK (NumItems > 0)
);

INSERT INTO DSCentro VALUES ('37','Conde de Peñalver, 44');
INSERT INTO DSCentro VALUES ('44','Princesa, 25');

INSERT INTO DSDept VALUES ('37',1, 'Stationery',null,0);
INSERT INTO DSDept VALUES ('37',2, 'Computers',null,0);
INSERT INTO DSDept VALUES ('37',3, 'TV and Home Audio',null,0);
INSERT INTO DSDept VALUES ('44',1, 'Computers',null,0);
INSERT INTO DSDept VALUES ('44',2, 'Bookshop',null,0);

INSERT INTO DSOferta VALUES ('o01', '37', 1, TO_CHAR('01-02-2020'), TO_CHAR('01-02-2020'), 'SuperDestroyer 60', 50, 0);
INSERT INTO DSOferta VALUES ('o02', '37', 2, TO_CHAR('15-03-2020'), TO_CHAR('15-04-2020'), 'Victor Computer i7 16Gb 1Tb HD', 15, 0);
INSERT INTO DSOferta VALUES ('o03', '37', 2, TO_CHAR('15-03-2020'), TO_CHAR('15-04-2020'), 'Monitor 27in 4K', 15, 0);
INSERT INTO DSOferta VALUES ('o04', '37', 3, TO_CHAR('01-02-2020'), TO_CHAR('15-05-2020'), 'Soundbar Speaker Megatron', 20, 0);
INSERT INTO DSOferta VALUES ('o05', '44', 1, TO_CHAR('01-02-2020'), TO_CHAR('15-04-2020'), 'Compaq Computer i5 8Gb 1Tb HD', 84, 0);
INSERT INTO DSOferta VALUES ('o06', '44', 1, TO_CHAR('01-02-2020'), TO_CHAR('15-02-2020'), 'Saikushi Printer 3000', 20, 0);
INSERT INTO DSOferta VALUES ('o07', '44', 2, TO_CHAR('01-02-2020'), TO_CHAR('15-02-2020'), 'Tetralogy The Ring', 25, 0);

commit;

/* 1. Escribe un procedimiento almacenado OfertasCentro que, dado un
identificador de centro y una fecha recibidos como parámetros, muestre
en la consola la dirección del centro y las ofertas disponibles en sus
departamentos en su fecha: debe mostrar los departamentos del centro
y, para cada departamento, una lista con las ofertas para ese
departamento: IdOferta, descripción del producto, fecha de fin de la
oferta y el número de ítems disponible. Si no hay ofertas para algún
departamento, debe mostrar 'No hay ofertas para este departamento'. Si
no hay ningún centro con ese identificador, debe mostrar un mensaje de
error 'No hay ningún centro con identificador XXX', donde XXX es el
identificador del centro.

Además, el procedimiento debe actualizar las columnas FechaOfertas y
NumOfertas (in la table DSDept) con la fecha recibida como parámetro y
el número total de ofertas para ese departamento, respectivamente.

Por ejemplo, si el procedimiento es invocado para las ofertas del 1 de
abril de 2020 en el centro 37, el resultado debe ser el siguiente:

-----------------------------------------------------------------------
OFERTAS DEL 01-04-2020 EN EL CENTRO 37 -- Conde de Peñalver, 44
-----------------------------------------------------------------------
Departamento:    1 -- Papeleria
  No sales offers in this department.
Departamento:    2 -- Informatica
  o03    Monitor 27in 4K                      15-04-2020    15 items
  o02    Victor Computer i7 16Gb 1Tb HD       15-04-2020    15 items
Departamento:    3 -- TV y Audio
  o04    Soundbar Speaker Megatron            15-05-2020    20 items

*/




/* 2. Escribe un disparador ActualizaItemsVendidos que se ejecute ante
cualquier cambio de la tabla DSVenta (cualquier operación: inserción,
actualización o borrado). Debe actualizar el valor de la columna
ItemsVendidos. Debe ser capaz de funcionar ante cualquier cambio de
cualquier columna de DSVenta, incluyendo IdOferta (por ejemplo, si una
sentencia UPDATE cambia la oferta de una venta).

Además, si la fecha de la venta es anterior a la fecha actual, el
disparador debe cambiar automáticamente la fecha a la fecha
actual. Incluye en tu respuesta algunas sentencias para probar el
disparador para todos los tipos de sentencia de modificación de
datos. */




/* 3. (TRANSACCIONES) Considera el siguiente script de Oracle que se
ejecuta en una sesión recién iniciada:

SAVEPOINT Pzero;
ROLLBACK TO SAVEPOINT Pzero;
CREATE TABLE Tab1(key1 INT PRIMARY KEY, total INT DEFAULT 0);
SAVEPOINT Pone;
INSERT INTO Tab1 VALUES (1, 100);
CREATE TABLE TabX(keyX INT PRIMARY KEY, totalX INT DEFAULT 0);
SAVEPOINT Ptwo;
INSERT INTO Tab1 VALUES (2, 200);
ROLLBACK TO SAVEPOINT Pone;
UPDATE Tab1 SET total = total + 2000 where key1 = 2; 
ROLLBACK;
Select * from Tab1;
COMMIT;  
INSERT INTO Tab1 VALUES (3, 300);
COMMIT;  
INSERT INTO TabX VALUES (4, 400);
DELETE FROM  Tab1 WHERE key1 = 3;

a) Identifica las sentencias de control de transacciones que son
innecesarias y las que muestran un mensaje de error, explicando por
qué.

b) ¿Cuáles son las tablas y sus contenidos al final de la ejecución
del script?

c) ¿Cuántas transacciones se han ejecutado? Detalla las líneas de
inicio y fin de cada transacción.
*/



/* 4. (Extra) Crea la siguiente tabla:

CREATE TABLE tablaPrueba (codigo INTEGER PRIMARY KEY, descr VARCHAR2(30));

Suponiendo que tablaPrueba está inicialmente vacía, escribe una
secuencia de sentencias DML sobre tablaPrueba que sean ejecutadas en
dos sesiones separadas A y B de forma que la sesión B acabe esperando
que la sesión A finalice su transacción. Indica claramente el orden de
las sentencias y la sesión en la que se ejecutan. */





