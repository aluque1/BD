# PL/SQL

SQL es muy potente pero no es un lenguaje de programacion. Para realizar operaciones complejas sobre la BDD se necesita un lenguaje de programacion procedimental

Hay 3 tipos fundamentales de bloques de codigo en PL/SQL:

- Bloque anonimo: un fragmento de codigo sin sobre que se ejecuta una sola vez.
- Funcion y procedimiento almacenado: fragmento de codigo con nombre que puede tener parametro y devolver un valor de retonro
- Disparador(trigger): fragmento de codigo que se ejecita automaticamente cuando ocurre un evento, normalmente suelen cuando ocurre una modificacion en la BDD.

Todos los tipos de bloques salvo los bloques anonimos se compilan y almacenan como objeto de la base de datos.

## Bloque PL/SQL anonimos

Un bloque anonimo se declara y se ejecuta. No se puede almacenar en la BDD ni invocar

``` sql
declare 
        var_saludo varchar2(20);
begin
        var_saludo := 'Hola Mundo!';
        dbms_output.put_line(var_saludo):
end;
/ -- Todo codigo PL/SQL acaba con '/'. Indica el final del codigo
```

Los bloques estan estructurados en secciones:

- declaraciones (DECLARE)
- instrucciones (BEGIN) (es la unica obligatoria BEGIN ... END;)
- excepciones (EXCEPTION)

### DECLARE

Aqui es donde se declaran las variables locales y sus tipos en los bloques anonimos. Los tipos permitidos son los mismos que en columnas de tabla. Tambien se pueden declarar variables de tipo registro, arrays, cursores y exceptiones de usuario.

Pueden declararse como constantes con `CONSTANT`.

Ademas se pueden declarar variables cuyo tipo esta referenciado al tipo de una columna de una tabla o a otra variable con el tabla.columna%TYPE:

``` sql
declare 
        var_saludo constant varchar2(20) := 'Hola Mundo!'
        var_dni_emp emp.dni%type;
```

### BEGIN

Aqui es donde se declaran las instrucciones, se pueden utilizar asignaciones de **variables locales**, condicionales, bucles, y llamadas a procedimientos, asi como sentencias SQL y gestion de cursores.

#### Instrucciones condicionales

Tienen la siguiente sintaxis

``` sql
IF cond THEN
        instrucciones
END IF;

IF cond1 THEN
        instrucciones1
ELSIF cond2 THEN
        instrucciones2
ELSE
        instrucciones3
END IF;
```

donde la cond puede ser cualquier expresion logica que combine variables locales y literales mediante operadores relacionales(`<, <=, > =>, =, !=`), booleanos(`AND, OR, NOT`) y de comprobacion(`expr IS [NOT] NULL`). Es importante notar que **los nombres de columnas solo estan permitidos si se utilizan en cursores o registros**

#### bucles

Hay varios tipos de bucles en PL/SQL, un loop general donde tiene una condicion de salida en cualquier parte del bucle, un bucle while y un bucle for. Estos tienen la siquiente sintaxis:

``` sql
-- LOOP
LOOP
        instrucciones
        EXIT [WHEN cond]
        instrucciones
END LOOP;

-- WHILE
WHILE cond LOOP
        instrucciones
END LOOP;

-- FOR
FOR variable IN [REVERSE] val_inf..val_sup LOOP
        instrucciones
END LOOP;
```

## Procedimientos/funciones

Son bloques con nombre y parametros I/O y valor de retorno(funciones). En Oracle, se compilar para aumentar su eficencia y se almacenan en la BBDD. Un ejemplo es el siguiente;

``` sql
create or replace procedure proc1(p in varchar2) IS
        v_local varchar(50) := 'Mi primer procedimiento.';
begin
        dbms_output.put_line(v_local || ' Param: ' || p); -- || es el operador de concatenacion
end;
/
-- para ejecutarlo se debe invocar dentro de otro bloque o procedimiento
begin
        proc1('Hola Mundo!');
end;
/
```

### Parametros

En los parametros se debe indicar el tipo(no se indica el tamaño) y el modo (si es `IN, OUT o IN OUT`).

En este caso la seccion de declaracion de variables no debe contener la palabra clave declare.

Los parametros `IN` no pueden ser modificados porque son parametros de entrada.

### funciones

Las funciones devuelven un valor de retorno como resultado de la llamada. Siempre se debe declarar el tipo de retorno de la funcion en el encabezamiento y se debe incluir al menos una instruccion `RETURN` para devolver un valor de retorno.

``` sql
create or replace function fun1(p varchar2) return varchar2 is
begin
        return '***' || p || '***';
end;
/
```

Se puede utilizar en cualquier contexto donde se espero una expresion del mismo tipo que el valor de retorno por ejemplo dentro de una consulta SQL:

``` sql
select fun1(desc)
from proyecto
where cod_pr > 'PR1';
```

## Excepciones

Son eventos que se producen durante la exe de un programa y que impiden su funcionamiento normal. Normalmente provocan la finalizacion del programa que la recibe pero se puede capturar y asi mostras un mensaje de error o seguir con la ejecuccion con un aviso.

Se capturan usando una seccion al final del bloque, procedimiento o funcion.

Esta compuesta por las sentencias `WHEN excepcioon1 [OR excepcion2...] THEN instrucciones`

Se pueden capturar todas las excepciones con `WHEN OTHERS THEN` pero debe ser la ultima clausula `WHEN` del bloque

Un ejemplo puede ser el siguiente

``` sql
CREATE OR REPLACE PROCEDURE manejo_excepciones IS
        v_cod piezas.cod %TYPE;
BEGIN
        SELECT cod INTO v_cod FROM piezas WHERE 1=2; --prueba con 1=1/0
        DBMS_OUTPUT.PUT_LINE(’Todo bien.’);
EXCEPTION
        WHEN TOO_MANY_ROWS THEN
                DBMS_OUTPUT.PUT_LINE(SELECT INTO devuelve varias filas.’);
        WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE(’SELECT INTO no devuelve ninguna fila.’);
        WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(’Otro error : ’ || SQLCODE); -- SQLCODE OBTIENE EL CODIGO DE ERROR
                DBMS_OUTPUT.PUT_LINE(’con mensaje: ’ || SQLERRM); -- SQLERRM OBTIENE EL MENSAJE DE ERROR
END;
/
```

### Tipos de excepciones

#### Internas

Tienen codigo asociado pero no identificador (estas excepciones no deberian capturarse)

#### Predefinidas

Tiene un identificador asociado. Las mas relevantes son las siguientes:

| Identificador        | Descripcion                           |
| -------------------- | ------------------------------------- |
| NO_DATA_FOUND        | `Select into` no devuelve filas       |
| TOO_MANY_ROWS        | `Select into` devuelve varias filas   |
| ROWTYPE_MISMATCH     | No se corresponden las variables con las columnas de `Select into` o `fetch` |
| ZERO_DIVIDE          | Intento de división por cero.         |
| CURSOR_ALREADY_OPEN  | Se intenta abrir un cursor ya abierto            |
| DUP_VAL_ON_INDEX     | Se intenta insertar fila con clave duplicada  |
| INVALID_NUMBER       | No se puede convertir texto a numero  |

#### Definidas por el programador

Se pueden crear en el programa. Se deben declarar con `nombre_exc EXCEPTION`, se pueden lanzar con `RAISE nombre_exc`.

## SQL dentro de PL/SQL

PL/SQL integra el lenguaje SQL para poder acceder a los datos de la BDD de forma sencilla.

### Comm PL => SQL

Como regla general, dentro de una sentencia sql se pueden utilizar las variables locales del bloque. Un ejemplo de esto es lo siguiente

``` sql
DECLARE
        vCodDp Dpto.CodDp %TYPE;
BEGIN
        FOR X IN 10..15 LOOP
                vCodDp := ’D’ || to_char(X);
                INSERT INTO Dpto
                VALUES (vCodDp, 'Departamento ' || vCodDp);
        END LOOP;
END;
/
```

### Comm SQL => PL

La communicacion desde las tabla de la BS y variables PL/SQL no es automatica y se deben utilizar mecanismo especificos basaos en la sentencia `select`. En un pprograma **no se pueden** utilizar columnas de tablas fuera de las sentencias sql y `%type`. 

∃ 2 mecanismos en PL/SQL para realizar esta comm

#### SELECT ... INTO

Se puede utilizar caundo vamos a realizar una consulta que devuelve una sola fila. Es igual que una sentencia `select` con una clausula `into` adicional.

Despues de la clausula into se indican las variables locales que contendran el resultado de la ejecucion de la consulta SQL. El numero y tipo de variables debe **coincidir** con el resultado

``` sql
create or replace pr_in(pr in proyecto.cod_pr%type) IS
        v_dir = proyecto.nif_dir%type;
        v_desc = proyecto.descr%type;
begin
        select e.nombre, p.descr INTO v_dir, nif_dir
        from proyecto p
        join emp e on p.nif = e.dni
        where cod_pr = pr;
        dbms_output.put_line('Proyecto: ' || pr || ' - ' || v_desc);
        dbms_output.put_line('Director: ' || v_dir);
end;
/
```

#### Cursores

Como `select ... into` no se puede usar para varias filas, ya que si devuelve mas de uno o ninguna fila se produce una excepcion, para recorrer y tratar una a una las filas resultantes de una sentencia `select` que devuelve varias filas se utiliza un cursor.

Un cursor es como un puntero. Se tiene que asociar a una consulta de la siguiente manera

``` sql
cursor cr_piezas is
        select cod, descr, precio
        from piezas
        where precio > 100;
```

Se puede recorrer un cursor con un bucle `for` de cursor o mediante operaciones de bajo nivel. Como se suele recorrer tanto los cursores con los bucles `for` que hay uno especifico para el recorrido de cursores.

``` sql
CREATE OR REPLACE PROCEDURE mostrarEmpleados IS
        CURSOR crEmpl IS
                SELECT e.NIF, e.nombre, d.nombre Depto
                FROM Emp e 
                JOIN Dpto d ON e.CodDp = d.CodDp;
BEGIN
        DBMS_OUTPUT.PUT_LINE('NIF NOMBRE Departamento');
        DBMS_OUTPUT.PUT_LINE('----------------------------------');
        FOR rec IN crEmpl LOOP
                DBMS_OUTPUT.PUT_LINE(rec.NIF || ' ' ||
                RPAD(rec.nombre,20) || ' ' ||
                RPAD(rec.Depto,20));
        END LOOP;
END;
```

## Disparadores(triggers)

Hay veces que se necesita ejecutar un determinado codigo cuando ocurre un evento en la BDD, un ejemplo de esto es cuando se debe incluir una restriccion de integridad que no se puede incluir en el modelo relacional, o registro de quien ah modificado que tablas/datos.

Hay 3 tipos de eventos a los que se pueden asociar los disparadores:

- Disparadores de tabla: cuando se produce una modificacion del los datos de una tabla
- Disparadores de vista: cuando se produce una modificacion sobre los datos de una vista
- Disparadores de sistema: cuando ocurre un evento del sistema (conexion de un usuario, borrado de un objeto...)

El primer tipo es el que vamoa a ver en mas profundidad son los disparadores de tabla

### Disparadores de tabla

Antes de empezar es necesario fijar una serie de conceptos para definir un disparador.

**La tabla** cuya modificacion va a activar la ejecucion del disparador

**Evento(s)** que dispara el disparador: `insert`, `update`, `delete`

**Cuando se ejecuta el codigo del disparador**: justo antes o justo despues de que se produzca el evento.

- `before`: los datos de la tabla todavia no se han actualizado todavia y pueden ser modificados por el disparador antes de ser almacenado(cambiando el reg `:NEW`)
- `after`: despues de almacenar los datos de la tabla, el disparador no puede modificarlos

**Cuantas veces se ejecuta el disparador**

- Disparador de instruccion: se ejecuta una vez por cada instruccion DML que lo dispara (esta es la opcion por defecto).
- Disparador de fila: se ejecuta una vez por cada fila que se ve afectada y se indica con `FOR EACH ROW`

Con lo anterior un esquema de un disparador es el siguiente:

``` sql
create [or replace] trigger nombre_disp
before|after evento [or evento[or evento]]
on tabla -- Indica la tabla que cuando se modifican datos en ell provoca la ejecucion del disparador
[for each row [when cond]] -- disparador de fila
[declare
        declaraciones_del_disparador]
begin
        cuerpo_del_disparador
end;
```

Un ejemplo de como se haria un disparador de instruccion seria el siguiente

``` sql
-- -----------------------------------------------------
-- Ejemplo12: Disparador de instruccion.
-- -----------------------------------------------------
CREATE OR REPLACE TRIGGER disparadorDeInstruccion
AFTER UPDATE OR INSERT OR DELETE
ON distribucion
BEGIN
  DBMS_OUTPUT.PUT_LINE('!! Se ha ejecutado una sentencia de modificacion de Allocation.');
END;
/

insert into distribucion values ('PR2','85647456W',25);
select * from distribucion;
update distribucion set horas = horas + 4;
delete from distribucion where horas > 100; -- the trigger fires even if no row is changed. 
```

El codigo de arriba se ejecuta una vez **por cada instr DML** que lo dispara

Por lo contrario un disparador de fila se ejecuta una vez **por cada fila afectada en una instr DML** lo cual consume muchos recursos porque se puede ejecutar millones de veces para una sola instr DML por lo tanto:

- Se debe evitar ejecutarlo sin necesidad
- Si el evento es `update` se puede indicar la columna afectada por el disparador con `update of columna` y asi solo se ejecuta cuando se modifica la columna
- Usar la clausula `when` en la clausula `for each row [when cond]` para precidar con mas detalle cuando se ejecuta el disparador

Un ejemplo de un disparador de fila es el siguiente

``` sql
CREATE OR REPLACE TRIGGER pruebaTriggerFila
AFTER UPDATE OR INSERT OR DELETE ON Emp FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Modificando una fila de la tabla Emp');
    DBMS_OUTPUT.PUT_LINE('   Old value: ' || :OLD.NIF || ' - ' || :OLD.nombre || ' - ' || :OLD.CodDp);
    DBMS_OUTPUT.PUT_LINE('   New value: ' || :NEW.NIF || ' - ' || :NEW.nombre || ' - ' || :NEW.CodDp);
END;
/

update Emp set nombre = nombre || '--' where NIF like '3%';
insert into Emp values ('1234Z','John Doe',null);
delete from Emp where emplId = '1234Z';
commit;
```

### Elementos especificos para programar disparadores

#### Predicados

Si un disparador se ejecuta por varios eventos podemos utilizar los siguientes predicados para identificar el evento que produjo su ejecucion:

- `inserting`
- `updating`
- `deleting`

Por ejemplo dentro del disparador podriamos tener lo siguente

``` sql
if inserting then ...
if updatin then ...
if deleting then ...
end if;
```

#### Registros con los datos

En el codigo de un disparador de fila se puede acceder a los datos de la fila cuya modificacion produjo la ejecucion del disparador. En el ejemplo mostrado mas arriba se lo que se usa para ver los valores antiguos y los nuevos.

- `:OLD`: contiene los valores de las columnas de la fila antes de ejecutar la instruccion de modificacion que provoco la exe del disparador
- `:NEW`: contiene los valores de las columnas de la fila despues de ejecutar la instruccion de modificacion que provoco la exe del disparador. Si el disparador es de tipo `BEFORE` se pueden cambiar los valores de `:NEW`

#### Orden de ejecucion de disparadores

Dado que se pueden crear varios disparadores asociados a una misma tabla tiene que haber un orden determinado para saber que se ejecuta antes:

1. Disparadores `BEFORE` de instruccion
2. Por cada fila : disparadores `BEFORE` de fila
3. Se modific la fila
4. Por cada fila : disparadores `AFTER` de fila
5. Disparadores `AFTER` de instruccion


#### Otras operaciones sobre triggers

``` sql
DROP TRIGGER nombreDisparador; -- elimina disparador
ALTER TRIGGER nombreDisparador DISABLE; -- desactiva disparador
ALTER TRIGGER nombreDisparador ENABLE; -- reactiva disparador
ALTER TABLE tabla {DISABLE|ENABLE} ALL TRIGGERS; -- desactiva/reactiva todos los disparadores asociados a una tabla
```
