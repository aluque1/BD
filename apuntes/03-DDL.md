# Data Definition Language (DDL)

Se encarga de la creación de tablas, índices, modificación de las tablas ...

Permite la especificación de la estructura de la tabla de datos:

- Definición de la estructura de las tablas y del dominio (tipo) de las columnas
- Especificación de las restricciones de integridad:
        - claves primarias
        - claves externas
        - unicidad
        - valores nulos
        - ...

## Tipos de datos básicos

### CADENAS DE CARACTERES

CHAR(n): cadena de caracteres de longitud fija *n* (hasta 2000, 1 por defecto)

VARCHAR2(n): cadena de caracteres de longitud variable, máximo *n* (hasta 2000)

### TIPOS NUMÉRICOS

INTEGER: entero de 32 bits

NUMBER: en el rango de -10¹²⁵..10¹²⁵ con 38 dígitos significativos

NUMBER(*p*, *s*): números decimales donde *p* es el número **total** de dígitos y *s* es el número total de decimales

| Valor asignado | Tipo | Valor almacenado |
|----------|----------|----------|
| 7456123.89 | NUMBER(9) | 7456124 |
| 7456123.89 | NUMBER(9) | 7456123.89 |
| 7456123.89 | NUMBER(9) | 7456123.9 |
| 7456123.89 | NUMBER(9) | No válido, supera la precisión |

### DATE

DATE: fecha y hora en una sola columna. El formato por defecto viene dado por el parámetro NLS_DATE_FORMAT: `nls_date_format = 'DD/MM/YYYY';`

Internamente se almacena como el número de días desde cierto punto de inicio. Se pueden realizar operaciones aritméticas:

'1-JAN-2001' + 10 = '11-JAN-2001'
'27-FEB-2000' + 2 = '29-FEB-2000'
'10-MAY-2000' - '1-MAY-2000' = 9'

Se puede extraer un elemento en concreto de la siguiente manera:

`EXTRACT(YEAR FROM DATE) -- Obtiene el año de la fecha date`

## Creación de tablas

Se crea una tabla con la sentencia `CREATE TABLE` de la siguiente manera (los [] indican elementos opcionales)

```sql
CREATE TABLE nombre_tabla (
                                nombre_col_1 tipo_1 [propiedades],
                                nombre_col_2 tipo_2 [propiedades],
                                ...
                                nombre_col_n tipo_n [propiedades],
                                [restricción_1,
                                ...
                                restricción_k]
);
```

De manera que unas tablas que tienen la información de unos proyectos divididos en varios departamentos tendrían el siguiente aspecto:

Se debe garantizar el cumplimiento de las restricciones de clave externa:

- Cuando se inserta una fila que referencia otra tabla
- Cuando se modifica la clave primaria de una fila a la que se refiere la clave externa de otra tabla
- Cuando se elimina una fila de una tabla referenciada por otra

Cuando se incumple una clave externa se rechaza la acción y se produce un error, por lo tanto modificamos el comportamiento al crear la tabla de las siguientes maneras:

`ON DELETE CASCADE`: cuando se elimina una fila de la tabla referida, todas las filas de la tabla que la referencia también son borradas (**¡¡** bastante peligroso **!!**).

`ON DELETE SET NULL | SET DEFAULT`: las columnas que referencian a una fila eliminada se actualizan a NULL o valor por defecto.

`ON UPDATE CASCADE | SET NULL | SET DEFAULT`: las columnas que referencian a una fila de la tabla referida, todas las filas de la tabla que la referencian se actualizan o se ponen a NULL o al valor por defecto.

```sql
create table dpto (
                                cod_dp varchar2(3) primary key,
                                nombre varchar2(10) not null unique, -- el nombre del dpto no puede repetirse y no puede ser nulo
);

create table emp (
                                dni varchar(10) primary key,
                                nombre varchar(40) not null,
                                cod_dp varchar(3) references dpto ON DELETE SET NULL -- es una clave externa que referencia dpto y cuando esta se borre se pone el cod_dp a null
);

create table proyecto(
                                cod_pr varchar(3) primary key,
                                dni_dir varchar(10) not null references emp,
                                descr varchar(20) not null
);

create table distr (
                                cod_pr varchar2(3) references proyecto,
                                dni varchar(10) not null references emp ON DELETE CASCADE,
                                horas integer not null,
                                primary key (cod_pr, dni), -- La clave primaria es compuesta
                                check (horas > 0) -- Comprueba que el número de horas tiene que ser mayor a 0
);
```

## Modificación de tablas ya existentes

Las tablas son persistentes y una vez creada una tabla si se quieren añadir campos no se debe eliminar y crearla de nuevo.

Se puede modificar su estructura de las siguientes maneras:

```sql
-- Añadir columnas a una tabla
ALTER TABLE tabla ADD columna dominio [propiedades];

-- Eliminar columnas de una tabla
ALTER TABLE tabla DROP COLUMN col [CASCADE CONSTRAINTS];

-- Modificar columnas de una tabla
ALTER TABLE tabla MODIFY (columna dominio [propiedades]);

-- Renombrar columnas de una tabla
ALTER TABLE tabla RENAME COLUMN column TO nuevo_nombre;

-- Añadir restricciones a una tabla
ALTER TABLE tabla ADD CONSTRAINT nombre Tipo (columnas);

-- Eliminar restricciones de una tabla
ALTER TABLE tabla DROP PRIMARY KEY;
ALTER TABLE tabla DROP UNIQUE(columnas);
ALTER TABLE tabla DROP CONSTRAINT nombre [CASCADE]; -- La opción CASCADE hace que se eliminen las restricciones de integridad que dependen de la eliminada

-- Desactivar restricciones 
ALTER TABLE tabla DISABLE CONSTRAINT nombre [CASCADE];

-- Activar restricciones
ALTER TABLE tabla ENABLE CONSTRAINT nombre;

-- Descripción de una tabla
DESCRIBE table;

-- Eliminación de una tabla
DROP TABLE tabla [CASCADE CONSTRAINTS]; -- La opción CASCADE hace que se eliminen las restricciones de integridad que dependen de la tabla eliminada

-- Renombrar una tabla
RENAME TABLE tabla TO nuevo_nombre;

-- Borrar el contenido de una tabla
TRUNCATE TABLE tabla;
```

## Otros objetos de la BDD

### Secuencias

Permiten generar automáticamente números distintos. La generación de cada valor es atómica y se puede realizar desde distintas sesiones concurrentes.

Los métodos `NEXTVAL` y `CURRVAL` se utilizan para obtener el siguiente número y el valor actual de la secuencia respectivamente.

```sql
CREATE SEQUENCE sq_id_cliente INCREMENT BY 1 START WITH 1 MAXVALUE 2000;
```
