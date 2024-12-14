# Data Manipulation Language (DML)

Es el lenguaje que se encarga de manipular los datos y esta formado por 4 sentencias:

- `INSERT` para insertar filas en una tabla
- `DELETE` para eliminar filas de una tabla
- `UPDATE` para modificar el contenido de filas en una tabla
- `SELECT` para relizar consultas en tablas

## INSERT

La sentencia inserta una o varia filas nuevas en una tabla:

``` sql
insert into emp values ('12345678Z', 'Paco Paquez', 'IT');
```

Los literales de caracteres deben encerrarse en comillas simples ' '

La sintaxis basica para insertar una fila con datos es la siguiente

``` sql
insert into nombre_tabla [(col1, ..., colk)] values (val1, ..., valk);
```

donde:

- El orden de la lusta de nombres de las columnas debe coincidir con el orden de la lista de valores
- Si se omite la lista de columnas se utiliza el orden de la creacion de la tabla.

Ademas, se puede sustituir la clausula VALUES por una consulta select.

## DELETE

Es una sentencia que elimina filas existentes en una tabla que cumplan una determinada condicion

``` sql
delete from distr where horas <= 20;
```

La sintaxis basica para una sentencia delete es la siguiente:

``` sql
delete from nombre_tabla where condicion;
```

donde:

- La condicion de la clausula `where` se evalua para cada fila
- La clausula `where` es opccional pero si se omite se borran **todas las filas de la tabla**
- La clausula `where` puede contener condiciones complejas (se vera en detalle en las sentencias `select`)

## UPDATE

Es una sentencia que modifica los valores de las filas existentes en una tabla que cumplan una determinada condicion

``` sql
update distr set horas = horas * 1.5 where cod_pr='PR1';
```

La sintaxis basica para una sentencia update es la siguiente:

``` sql
delete from nombre_tabla set col1 = expr1, ..., colk = exprk where condicion;
```

donde:

- La condicion de la clausula `where` se evalua para cada fila. Si es cierta se modifican las columnas especificadas en la clausula `set`
- La clausula `where` es opccional pero si se omite se borran **todas las filas de la tabla**
- La clausula `where` puede contener condiciones complejas (se vera en detalle en las sentencias `select`)

## SELECT

Las consultas de datos se hacen mediante la sentencia `select`

La sintaxis basica es:

``` sql
select expr1, ..., exprN
from tabla1, ..., tablaN
where condicion
```

- La clausula `select` especifica las columnas (o expresiones) que deben aparecer en el resultado
- La clausula `from` expecifica las tablas de las que obtiene la consulta (realiza el producto cartesiano)

![producto cartesiano](imagenes/producto_cartesiano.png)

-La clausula `where` es opcional y especifica las condiciones de seleccion de filas.
        - Si no se incluye se seleccionan todas las filas

Ejemplo con la siguiente tabla distr:

| cod_pr | dni_dir | horas |
|--------|-----|-------|
| PR1 | 12345678Z | 5  |
| PR2 | 12345678Z | 30 |
| PR3 | 87654321Z | 25 |
| PR4 | 87654321Z | 15 |

Si queremos seleccionar los codigos de proyecto del empleado con dni 12345678Z hariamos los siguiente:

``` sql
select dni 
from distr
where dni = '12345678Z';
```

Y nos devolveria la siguiente tabla:

| dni |
|-----|
| 12345678Z |
| 12345678Z |

Nos devuelve 2 filas porque las consultas SQL trabajan con multiconjuntos en lugar de conjuntos ∴ se pueden repetir valores

Si queremos trabajar con conjuntos (eliminar las tuplas duplicadas) tendriamos que utilizar la clausula `distinct`

``` sql
select distinct dni_dir 
from distr
where dni_dir = '12345678Z';
```

Para seleccionar todas las columnas de las tablas incluidas en la clausula `from` se utiliza *

``` sql
select * 
from distr
where horas > 15;
```

| cod_pr | dni_dir | horas |
|--------|-----|-------|
| PR2 | 12345678Z | 30 |
| PR3 | 87654321Z | 25 |

Los atributos de la clausula `select` pueden ser **expresiones** y se pueden cambiar el nombre de las columnas en el resultado

```sql
select cod_pr "codigo de proyecto", horas/2
from distr;
```

La evaluacion de una sentencia `select` basica se puede ver como una ejecuccion de los siguientes pasos (no es como lo hace un SGDB pero ayuda a entender el significado)

1. Calculo del prod. cartesiano de las tablas de la clausula `from`
2. Eliminacion de las filas que no cumplen la condicion de la clausula `where`
3. Eliminacion de las columnas que no aparecen en la lista de la clausula `select`
4. Si se especifica `distinct` eliminacion de las filas duplicadas

### Condicion de clausula where

La condicion de la clausulas `where` debe ser una expresion logica formada por:

- `and`, `or`, `not` y una condicion booleana simple

donde las condiciones booleanas simples son:

- operadores de comparacion: <, > <=, >=, =, !=
- comprobacion de valor nulo: expr IS [NOT] NULL
- pertenencia a un conunto de valores: expr [NOT] IN (v1, ..., vn)
- pertenencia a un rango: expr [NOT] BETWEEN v1 AND v2
- similitud entre cadena de caracteres: expr [NOT] LIKE 'patron'
        - el caracter _ representa un caracter cualquiera
        - el caracter % representa un caracter cualquiera

si quieremos ver que un nombre contenga los caracteres jo:

```sql
select nombre 
from emp
where nombre like %jo%;
```

si quiremos el nombre de los empleados que tengan una 'a' en el tercer caracter del nombre:

```sql
select nombre 
from emp
where nombre like %__a%;
```

### Ordenacion de los resultados de una consulta

La clausula `order by` permite establecer el orden de presentacion de las filas resultado de una consulta `select`. Se pueden especificar varia columnas e incluso expresiones.

Debe ser la ultima clausula de la sentencia `select`.

``` sql
-- Codigo de proyecto, dni y horas trabajadas de los empleados que trabajan mas de 10 horas en algun proy ordenado por horas
SELECT CodPr, NIF, horas 
FROM distribucion
WHERE horas > 10 
ORDER BY horas;

-- Lo mismo ordenado de manera descendente
SELECT CodPr, NIF, horas 
FROM distribucion
WHERE horas > 10 
ORDER BY horas DESC;

-- Ordenado por codPR de forma asc y dentro de cada pr de forma desc
SELECT CodPr, NIF, horas 
FROM distribucion
WHERE horas > 10 
ORDER BY CodPR ASC, horas DESC;
```

### Funciones predefinidas

Se pueden utilizar expresiones y funciones en las clausulas predefinidas en las clausulas `select` y `where`. Existe un gran numero de funciones predefinidas

#### Funciones sobre nulos

`NVL(v, s)`: if *v* is null return s, else return v
`NVL2(v, s1, s2)`: if *v* is null return s2, else return s1

#### Funciones de fecha

`SYSDATE`: obtiene fecha y horas actuales
`ADD_MONTHS(fecha, n)`: añade a fecha el numero de meses *n*
`MONTHS_BETWEEN(f1, f2)`: obtiene la diferencia en meses entre 2 fechas
`EXTRACT(v FROM fecha)`: extrae el componente *v* de fecha, *v* puede ser `day`, `month`, `year`, `minute`...

### Conversion de tipos de datos

La que mas vamos a usar es la conversion explicita entre texto y fecha:

`TO_DATE(texto[,formato])`
`TO_CHAR(texto[,formato])`

Un ejemplo de uso seria:

``` sql
select to_char(sysdate, 'DD/MONTH/YYYY, DAY HH:MI:SS')
from dual 

-- Seleccionara lo siguiente 05/DICIEMBRE/2024, JUEVES 17:33:04
```

### Consultas con operaciones sobre conjuntos

En SQL se pueden combinar los resultados de distintas sentencias `select` utilizando los operadores de teoria de conjuntos `union`, `intersect`, `minus`.

Hay que tener en cuenta que las columnas devueltas por las 2 consultas deben ser similares: mismo numero y tipo.

Estos operadores eliminan las filas duplicadas, pero se pueden mostrar todas las filas de la union con `union all`

``` sql
-- NIF de los empleados que tienen horas asignadas a los dos proyectos PR1 y PR3 
select nif
from distr
where cod_pr = 'PR1'
intersect
select nif
from distr
where cod_pr = 'PR3'
```

### Consultas sobre varias tablas

En una consulta se pueden combinar varias tablas para formar una consulta mas complejas. A estas combinaciones se les llama reuniones (`join`) y se especifican en la clausula `from`

La condicion de la clausula where puede contener nombres de columnas de cualuqiera de las tablas. Si las columnas de 2 tablas tienen el mismo nombre se pueden usar los denominados alias de tabla:

#### Reuniones JOIN (LEFT JOIN / RIGHT JOIN / FULL JOIN)

Vamos a usar las siguientes tablas como ejemplo:

##### dpto

| cod_dp | nombre      |
|--------|-------------|
| D01    | HR          |
| D02    | IT          |
| D03    | Sales       |
| D04    | Marketing   |

##### emp

| dni        | nombre               | cod_dp |
|------------|----------------------|--------|
| 1234567890 | John Doe             | D01    |
| 0987654321 | Jane Smith           | D02    |
| 1122334455 | Emily Johnson        | D03    |
| 2233445566 | Michael Brown        | D01    |
| 3344556677 | Sarah Davis          | NULL   |

##### proyecto

| cod_pr | dni_dir    | descr           |
|--------|------------|-----------------|
| P01    | 1234567890 | Project Alpha   |
| P02    | 0987654321 | Project Beta    |
| P03    | 1122334455 | Project Gamma   |

##### distr

| cod_pr | dni        | horas |
|--------|------------|-------|
| P01    | 1234567890 | 10    |
| P01    | 2233445566 | 20    |
| P02    | 0987654321 | 15    |
| P03    | 1122334455 | 25    |
| P03    | 3344556677 | 30    |

El **JOIN** une las tablas donde los indices aparecen en ambas, es decir si hacemos lo siguiente:

``` sql
select e.nombre nombre_emp, d.nombre_dpto 
from emp e join on dpto d e.cod_dp = d.cod_dp;
```

Obtendriamos una tabla como la siguiente. Vease que Sarah Davis no aparece ya que no tiene un cod_pr asociado.

| nombre_emp    | nombre_dpto |
|---------------|-------------|
| John Doe      | HR          |
| Michael Brown | HR          |
| Jane Smith    | IT          |
| Emily Johnson | Sales       |

El **LEFT JOIN** une las tablas de manera que obtiene todas las filas de la primera tabla y las combina con los resultados de la segunda o rellena con valores nulos por correspondencia de manera que:

``` sql
select e.nombre nombre_emp, d.nombre_dpto 
from emp e left join on dpto d e.cod_dp = d.cod_dp;
```

daria como resultado la siguiente tabla

| Employee Name | Department Name |
|---------------|-----------------|
| John Doe      | HR              |
| Michael Brown | HR              |
| Jane Smith    | IT              |
| Emily Johnson | Sales           |
| Sarah Davis   | NULL            |

El **RIGHT JOIN** une las tablas de manera que obtiene todas las filas de la segunda tabla y las combina con los resultado de la primera o rellena con valores nulos por correspondencia de manera que:

``` sql
select e.nombre nombre_emp, d.nombre_dpto 
from emp e right join on dpto d e.cod_dp = d.cod_dp;
```

daria como resultado:

| Employee_Name | Department_Name |
|---------------|-----------------|
| John Doe      | HR              |
| Michael Brown | HR              |
| Jane Smith    | IT              |
| Emily Johnson | Sales           |
| NULL          | Marketing       |

EL **FULL JOIN** une las tablas de manera que obtiene todas las filas de ambas tablas y las combina o rellena con valores nulos por correspondencia de manera que:

``` sql
select e.nombre nombre_emp, d.nombre_dpto 
from emp e full join on dpto d e.cod_dp = d.cod_dp;
```

obtiene la tabla:

| Employee_Name | Department_Name |
|---------------|-----------------|
| John Doe      | HR              |
| Michael Brown | HR              |
| Jane Smith    | IT              |
| Emily Johnson | Sales           |
| Sarah Davis   | NULL            |
| NULL          | Marketing       |

### Funciones de agregacion

En sql tambien se pueden realizar consultas en las que se agrupan las filas resutlado. Permiten calcular resultados sobre grupos de filas de una consulta `select`.

``` sql
-- devuelve el numero de filas resultado de la consulta
COUNT(*) 

-- Devuelve el numero de valores [distintos] de la columna col (o expresion expr). No incluye las filas con valor NULL
COUNT([DISTINCT]col|expr)

-- Devuelve la suma de todos los valores [distintos] de la columna col(numerica) (o expresion expr).
SUM([DISTINCT]col|expr)
-- Devuelve el valor medio de todos los valores [distintos] de la columna col(numerica) (o expresion expr).
AVG([DISTINCT]col|expr)

-- Devuelve el valor maximo de la columna o expresion o el MIN
MAX(col|expr)
```

### Agrupaciones

Las funciones de agregacion consideran las filas de una consulta como un grupo sobre el que se calcula una sola fila resultado. Esta idea se puede extender a multiples grupos

``` sql
select [distinct] lista_expr 
from tablas
where condicion_where
group by cols_group
having condicion_group
[order by orden]
```

La sentencia `group by` produce tantas filas como valores diferentes de cols_group. Si se omite el group by toda la tabla es un unico grupo.

La clausula `having` selecciona que grupos aparecen en el resultado. En las clausulas de `select` y `having` solo pueden aparecer expresiones disponibles para las filas de grupo:

- Nombres de columnas: solo aquellas que tambien aparezcan en la clausula `group by`
- Funciones de agregacion

Un ejemplo simple de lo mencionado arriba seria el siguiente:

Imaginemos que tenemos una tabla de ventas con los siguientes datos:

| CountryCode | Country | Amount |
|---------|---------|--------|
| A       | USA     | 100    |
| B       | USA     | 150    |
| A       | Canada  | 200    |
| B       | Canada  | 50     |
| C       | USA     | 300    |
| D       | Canada  | 400    |
| A       | Mexico  | 500    |
| B       | Mexico  | 100    |
| C       | Canada  | 150    |
| D       | USA     | 100    |
| A       | Canada  | 250    |
| B       | USA     | 200    |

``` sql
SELECT Country, SUM(Amount) TotalSales
FROM Sales
GROUP BY Country;
```

| Country | TotalSales |
|---------|------------|
| USA     | 850        |
| Canada  | 850        |
| Mexico  | 600        |

Un ejemplo mas complicado podria ser el siguiente

| OrderID | CustomerID | OrderDate  | Amount | ProductCategory |
|---------|------------|------------|--------|-----------------|
| 1       | 101        | 2024-01-01 | 500    | Electronics     |
| 2       | 102        | 2024-01-02 | 700    | Furniture       |
| 3       | 101        | 2024-01-03 | 200    | Electronics     |
| 4       | 103        | 2024-01-04 | 800    | Electronics     |
| 5       | 104        | 2024-01-05 | 300    | Furniture       |
| 6       | 102        | 2024-01-06 | 400    | Electronics     |
| 7       | 101        | 2024-01-07 | 600    | Furniture       |
| 8       | 103        | 2024-01-08 | 900    | Furniture       |
| 9       | 104        | 2024-01-09 | 500    | Electronics     |
| 10      | 105        | 2024-01-10 | 1000   | Furniture       |

To find the total and average amount spent by each customer on each product category, but only include customers who have spent more than $1000 in total, you can use the following SQL query:

Imaginamos que queremos encontrar el total y la media gastada por cada cliente en cada categoria, pero solo queremos incluir aquellos que se han gastado mas de 600 en total.

```sql
SELECT CustomerID, ProductCategory, SUM(Amount) as TotalSpent, AVG(Amount) as AvgSpent
FROM Orders
GROUP BY CustomerID, ProductCategory
HAVING SUM(Amount) > 600;
```

| CustomerID | ProductCategory | TotalSpent | AvgSpent |
|------------|-----------------|------------|----------|
| 101        | Electronics     | 700        | 350      |
| 102        | Furniture       | 700        | 700      |
| 103        | Electronics     | 800        | 800      |
| 103        | Furniture       | 900        | 900      |
| 105        | Furniture       | 1000       | 1000     |

### Consultas anidadas

Es posible utilizar una consulta dentro de otra consulta.

Se pueden incluir subconsultas en las clausulas `where` pero tambien pueden estar en las clausulas `from` y `having`.

Normalmente se utiliza para comrobar la pertenencia a una (multi)conjunto, su cardinalidad o hacer comparaciones:

``` sql
-- Empleados con sueldo por debajo del sueldo medio
select nombre, salario
from emp
where salario < (select avg(salario) from emp);
```

∃ operadores especificos especificos de subconsultas que permiten comprobar la pertenencia a un conjunto y resultado (no) vacio de una consulta

- `expr [NOT] IN (subconsulta)`: comprueba la pertenencia o no de expr al multiconjunto resultante de una subconsulta
- `[NOT] EXISTS (subconsulta)`: comprueba si la consulta devuelve algun resultado (o no) (devuelve true, o false)

``` sql
-- Empleados que son directores de proyectos
select *
from emp
where dni IN 
(select dni_dir from proyecto);
```

#### Consultas anidadas correlacionadas

Ocurre cuando una subconsulta depende de la fila de la consulta externa. Son muy comunes cuando se utiliza el operador exists

``` sql
-- Directores de proyecto asignados al proyecto al que dirigen
select dni_dir
from proyecto p
where cod_pr in 
(select cod_pr 
from distr d 
where d.dni = p.dni_dir);
```

Se pueden usar subconsultas en `from` como si fueran tablas

``` sql
/* 
Para cada empleado asignado a proyectos, obtener la diferencia entre el 
total de horas asignadas al empleado y el promedio global de horas por
empleado 
 */
select nif, e.horas_emp - a.horas_avg
from ( 
        select dni, sum(horas) horas_emp
        from distribucion
        group by nif
) e, 
(
        select avg(sum(horas)) horas_avg
        from distr
        group by nif
) a
```
