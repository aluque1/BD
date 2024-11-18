-- -------------------------------------------------------------------------
-- Lab 4. CONSULTAS SQL: CONSULTAS ANIDADAS, CONSULTAS ANIDADAS CORRELACIONADAS
-- -------------------------------------------------------------------------

-- Este script contiene la definición de labase de datos de una red de
-- periódicos online, artículos publicados y periodistas. Estudia la
-- estructura de la base de datos para aprender la forma en la que se
-- almacena la información.

-- Ejecuta este script en una sesión de base de datos y después
-- escribe sentencias SELECT a continuación de cada una de las
-- PREGUNTAS INCLUIDAS COMO COMENTARIOS AL FINAL DE ESTE FICHERO.

-- Es muy importante que compruebes que los resultados de tus
-- consultas son efectivamente correctos respecto a los datos
-- contenidos en las tablas.

-- -------------------------------------------------------------------------
alter session set nls_date_format = 'DD/MM/YYYY';

drop table articulo cascade constraints;
drop table periodista cascade constraints;
drop table periodico cascade constraints;

create table periodico(
    idPeriodico integer primary key,
    Nombre varchar2(30),
    url varchar2(200),
    Idioma varchar2(3)
    -- Idioma puede ser 'en', 'es', 'fr', etc.
);

create table periodista(
    idPeriodista integer primary key,
    Nombre varchar2(30)
);

create table articulo(
    idArticulo integer primary key,
    titular varchar2(100),
    url varchar2(200),
    idPeriodico references periodico,
    idPeriodista references periodista,
    fechaPub date,
    numVisitas integer
);

INSERT INTO periodico VALUES (1, 'El Noticiero', 'http://www.newstoday.com','es');
INSERT INTO periodico VALUES (2, 'El Diario de Zaragoza', 'http://www.diariozaragoza.es','es');
INSERT INTO periodico VALUES (3, 'The Gazette', 'http://www.gacetaguadalajara.es','en');
INSERT INTO periodico VALUES (4, 'Toledo Tribune', 'http://www.toledotribune.es','en');
INSERT INTO periodico VALUES (5, 'Alvarado Times', 'http://www.alvaradotimes.es','en');
INSERT INTO periodico VALUES (6, 'El Retiro Noticias', 'http://www.elretironoticias.es','es');

insert into periodista values (201,'Margarita Sanchez');
insert into periodista values (203,'Pedro Santillana');
insert into periodista values (204,'Rosa Prieto');
insert into periodista values (206,'Lola Arribas');
insert into periodista values (207,'Antonio Lopez');

INSERT INTO articulo VALUES (101, 'El Banco de Inglaterra advierte de los peligros del Brexit',
			   'http://www.elnoticiero.es/ibex9000',
			   1,204, TO_DATE('01/06/2018'), 370);
INSERT INTO articulo VALUES (102, 'La UE acabará con el 100% de las emisiones de CO2 para 2050',
			   'http://www.elnoticiero.es/ibex9000',
			   1,204, TO_DATE('01/06/2018'), 1940);
INSERT INTO articulo VALUES (103, 'Madrid Central starts tomorrow',
			   'http://www.gacetaguadalajara.es/nacional24',
			   3,201, TO_DATE('01/06/2018'), 490);
INSERT INTO articulo VALUES (104, 'El Ayuntamiento prepara diez nuevos carriles bici',
			   'http://www.diariozaragoza.es/movilidad33',
			   2,203, TO_DATE('01/06/2018'), 2300);
INSERT INTO articulo VALUES (105, 'Un aragonés cruzará Siberia, de punta a punta en bici',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,203, TO_DATE('01/11/2018'), 2300);
INSERT INTO articulo VALUES (106, 'Hecatombe financiera ante un Brexit duro',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,204, TO_DATE('01/11/2018'), 2220);
 			   
INSERT INTO articulo VALUES (107, 'Fomento anuncia una estrategia nacional para fomentar la intermodalidad y el uso de la bicicleta',
			   'http://www.elnoticiero.es/ibex9001',
			   1,206, TO_DATE('22/06/2018'), 390);
INSERT INTO articulo VALUES (108, 'Así será el carril bici que pasará por la puerta del Clínico',
			   'http://www.diariozaragoza.es/nacional22062018',
			   2,206, TO_DATE('13/11/2018'), 1230);
INSERT INTO articulo VALUES (109, 'How will traffic constraints affect you? The Gazette answers your questions',
			   'http://www.gacetaguadalajara.es/deportes33',
			   3,204, TO_DATE('22/11/2018'), 123);
INSERT INTO articulo VALUES (110, 'How will traffic constraints affect you? Toledo Tribune answers your questions',
			   'http://www.toledotribune.es/deportes33',
			   4,204, TO_DATE('22/11/2018'), 880);
INSERT INTO articulo VALUES (111, 'Financial havoc if there is a hard Brexit',
			   'http://www.toledotribune.es/deportes44',
			   4,201, TO_DATE('22/11/2018'), 110);
INSERT INTO articulo VALUES (112, 'Financial havoc if there is a hard Brexit',
			   'http://www.alvaradotimes.es/deportes44',
			   5,204, TO_DATE('22/10/2018'), 130);
INSERT INTO articulo VALUES (113, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   5,201, TO_DATE('22/10/2019'), 820);
INSERT INTO articulo VALUES (114, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   4,204, TO_DATE('25/08/2019'), 1425);

COMMIT;

-- -------------------------------------------------------------------------
-- Lab 4. CONSULTAS
-- Escribe tus respuestas a continuación de cada comentario.
-- -------------------------------------------------------------------------

/* 1. Muestra la lista de  periodistas que NO han publicado ningún artículo en el 
 periodico con Id 4.
Esquema: (Id_Periodista, Nombre_Periodista).*/
SELECT p.idPeriodista as Id_Periodista, p.Nombre as Nombre_Periodista
FROM periodista p
WHERE p.idPeriodista NOT IN (
  SELECT a.idPeriodista
  FROM articulo a
  WHERE a.idPeriodico = 4
);

/* 2. Muestra la lista de periodistas que NO han publicado ningún
artículo en el periodico 'The Gazette'. El resultado solo debe incluir
periodistas que han publicado al menos un artículo
Esquema: (Periodista_Id, Periodista_Nombre).*/
SELECT p.idPeriodista as Periodista_Id, p.nombre as Periodista_Nombre
FROM periodista p
WHERE p.idPeriodista IN(
  SELECT a.idPeriodista FROM articulo a
  JOIN periodico per ON a.idPeriodico = per.idPeriodico
  WHERE per.nombre = 'The Gazette'
);


/* 3. Muestra la lista de periodicos que en 2018 recibieron más visitas que
'The Gazette'.
Esquema: (Periodico_Nombre, Num_Visitas)  */
SELECT p.Nombre Periodico_Nombre, SUM(a.numVisitas) Num_Visitas
FROM periodico p
JOIN articulo a ON p.idPeriodico = a.idPeriodico
WHERE EXTRACT(YEAR FROM a.fechaPub) = 2018
GROUP BY p.Nombre
HAVING SUM(a.numVisitas) > (
	SELECT SUM(a2.numVisitas)
	FROM articulo a2
	JOIN periodico p2 ON a2.idPeriodico = p2.idPeriodico
	WHERE p2.Nombre = 'The Gazette' AND EXTRACT(YEAR FROM a2.fechaPub) = 2018
);


/* 4. Muestra los titulares de los artículos escritos por autores que NO han 
escrito NINGÚN artículo en inglés.
Esquema: (Id_articulo, Titular, Nombre_Periodista)
*/
SELECT a.idArticulo Id_Articulo, a.titular Titular, p.nombre Nombre_Periodista
FROM articulo a 
JOIN periodista p ON a.idPeriodista = p.idPeriodista
WHERE p.idPeriodista NOT IN (
	SELECT a2.idPeriodista
	FROM articulo a2
	JOIN periodico per on a2.idPeriodico = per.idPeriodico
	WHERE per.Idioma = 'en'
);


/* 5. Muestra los titulares de los artículos escritos por periodistas que en 
2018 solo escribieron artículos en inglés.
Esquema: (Id_articulo, Titular, Fecha_publicacion, Nombre_Periodista)
*/
SELECT a.idArticulo Id_Articulo, a.titular Titular, a.fechaPub Fecha_publicacion, p.nombre nombre
FROM articulo a 
JOIN periodista p ON a.idPeriodista = p.idPeriodista
WHERE p.idPeriodista IN (
	SELECT a2.idPeriodista
	FROM articulo a2
	JOIN periodico per on a2.idPeriodico = per.idPeriodico
	WHERE EXTRACT(YEAR FROM a2.fechaPub) = 2018
	GROUP BY a2.idPeriodista
	HAVING COUNT(DISTINCT per.idioma) = 1 AND MAX(per.idioma) = 'en'
);
  
/* 6. Muestra los artículos más visitados en cada periódico.
Esquema: (Periodico_Id, Articulo_Id, Titular, Num_visitas) */
SELECT per.idPeriodico Periodico_Id, a.idArticulo Articulo_Id, a.titular Titula, a.numVisitas NumVisitas
FROM articulo a



/* 7. Nombre de los periodistas que han publicado artículos en todos
los periódicos en inglés.
Esquema: (Id_Periodista, Nombre_Periodista)*/



/* 8. Muestra el nombre y número de visitas del/de los periodistas más
visitados (los periodistas cuyos artículos han tenido el mayor número
de visitas en total).  
Esquema: (Id_Periodista, Nombre_Periodista, TotalVisitas) */



/* 9. Muestra los años en los que TODOS los periódicos ingleses que
han publicado al menos un artículo, el número total de artículos
publicados cada uno de esos años y el número total de visitas
recibidas por esos periódicos.
(Pistas: (a) puedes utilizar expresiones en las cláusulas GROUP BY,
como por ejemplo llamadas a funciones;
(b) Puedes comprobar la condición universal ("TODOS") comprobando que
el número de periódicos en inglés que han publicado artículos en cada
año es igual al número total de periódicos en inglés.)
Esquema: (Año, Num_Articulos, Num_Visitas)*/



/* 10. Por cada periodista, calcula la diferencia entre el número de
visitas recibidas por sus artículos y el número medio de visitas
recibidas por cada periodista.
(Difícil! Esta consulta requiere consultar dos conjuntos diferentes de
filas de la tabla articulo: por una parte, las filas agrupadas por
periodista, para calcular la suma de visitas de cada periodista; por
otra, todas las filas de todos los periodistas para calcular el número
medio de visitas recibidas por periodista.  Entonces se puede calcular
la diferencia. Para ello, se necesitan dos consultas.  
Pista: puedes intentar tener subconsultas en la cláusula FROM, una
para calcular el número total de visitas de cada periodista, y la otra
para obtener el número medio de visitas por periodista.)
Esquema: (Periodista_Id, Nombre_Periodista, Diferencia)*/



/* 11. Muestra los artículos que han recibido más visitas que el
número medio de visitas del periódico en el que se han publicado.
(Pista: Intenta utilizar una subconsulta correlacionada que calcule el
número medio de visitas de cada periódico.)
Esquema: (Id_Periodico, Id_Articulo, Titular, Num_visitas) */



/* 12. Muestra los artículos que han recibido más visita que el número
medio de visitas del periódico en el que se han publicado.
Esquema: (Id_Periodico, Id_Articulo, Titular, Num_visitas, Media_visitas_Periodico) 
(Difícil, porque se debe mostrar en el resultado el número medio de
visitas de cada periódico. Puedes utilizar una subconsulta en la
cláusula FROM para obtener el id y el número medio de visitas de cada
periódico, y hacer un JOIN de esta consulta con los artículos para
comprobar que el número de visitas en mayor a la media.)
*/







