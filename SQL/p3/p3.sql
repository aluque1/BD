-- -------------------------------------------------------------------------
-- Lab 3. CONSULTAS SQL: REUNIONES EXTERNAS, SELECT EXTENDIDO (GROUP BY, HAVING)
-- -------------------------------------------------------------------------

-- Este script contiene la definición de la base de datos de una red de
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

SET LINESIZE 500;
--SET PAGESIZE 500;
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
			   1,204, TO_DATE('01/06/2019'), 1940);
INSERT INTO articulo VALUES (103, 'Madrid 360 starts tomorrow',
			   'http://www.gacetaguadalajara.es/nacional24',
			   3,201, TO_DATE('01/06/2018'), 490);
INSERT INTO articulo VALUES (104, 'El Ayuntamiento prepara diez nuevos carriles bici',
			   'http://www.diariozaragoza.es/movilidad33',
			   2,203, TO_DATE('01/06/2018'), 2300);
INSERT INTO articulo VALUES (105, 'Un aragonés cruzará Siberia, de punta a punta en bici',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,203, TO_DATE('01/11/2019'), 2300);
INSERT INTO articulo VALUES (106, 'Hecatombe financiera ante un Brexit duro',
			   'http://www.diariozaragoza.es/ibex9000',
			   2,204, TO_DATE('01/11/2018'), 2220);

INSERT INTO articulo VALUES (107, 'Fomento anuncia una estrategia nacional para fomentar la intermodalidad y el uso de la bicicleta',
			   'http://www.elnoticiero.es/ibex9001',
			   1,206, TO_DATE('22/06/2018'), 390);
INSERT INTO articulo VALUES (108, 'Así será el carril bici que pasará por la puerta del Clínico',
			   'http://www.diariozaragoza.es/nacional22062018',
			   2,206, TO_DATE('13/11/2018'), 230);
INSERT INTO articulo VALUES (109, 'How will traffic constraints affect you? The Gazette answers your questions',
			   'http://www.gacetaguadalajara.es/deportes33',
			   3,204, TO_DATE('22/11/2018'), 123);
INSERT INTO articulo VALUES (110, 'How will traffic constraints affect you? Toledo Tribune answers your questions',
			   'http://www.toledotribune.es/deportes33',
			   4,204, TO_DATE('22/11/2018'), 880);
INSERT INTO articulo VALUES (111, 'Financial havoc if there is a hard Brexit',
			   'http://www.toledotribune.es/Business',
			   4,201, TO_DATE('22/01/2019'), 1105);
INSERT INTO articulo VALUES (112, 'Financial havoc if there is a hard Brexit',
			   'http://www.alvaradotimes.es/deportes44',
			   5,204, TO_DATE('22/10/2018'), 130);
INSERT INTO articulo VALUES (113, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.alvaradotimes.es/politics',
			   5,201, TO_DATE('22/10/2019'), 820);
INSERT INTO articulo VALUES (114, 'How President Trump took ''fake news'' into the mainstream',
			   'http://www.toledotribune.es/politics',
			   4,204, TO_DATE('25/08/2019'), 1425);
INSERT INTO articulo VALUES (115, 'Nuestro representante en Eurovision queda en el puesto 22',
			   'http://www.elnoticiero.es/eurovision2019',
			   1,204, TO_DATE('01/06/2019'), 34750);
INSERT INTO articulo VALUES (116, 'Editorial: Most relevant news 2019',
			   'http://www.gacetaguadalajara.es/editorial2019',
            5,null, TO_DATE('31/12/2019'), 44501);

COMMIT;

/*
_________ ________    _______    _____________ ___.____  ________________    _________
\_   ___ \\_____  \   \      \  /   _____/    |   \    | \__    ___/  _  \  /   _____/
/    \  \/ /   |   \  /   |   \ \_____  \|    |   /    |   |    | /  /_\  \ \_____  \ 
\     \___/    |    \/    |    \/        \    |  /|    |___|    |/    |    \/        \
 \______  |_______  /\____|__  /_______  /______/ |_______ \____|\____|__  /_______  /
        \/        \/         \/        \/                 \/             \/        \/ 

Consultas agregadas, funciones de agregacion y sentencias GROUP BY & HAVING
*/

/* 1. Muestra el número de periodicos en la base de datos. */
SELECT COUNT (*) as num_periodicos 
FROM Periodico;

/* 2. Muestra el número de periodicos en cada idioma
Esquema: (Idioma, Num_periodicos) */
SELECT p.Idioma, COUNT (DISTINCT p.Idioma) as num_periodicos 
FROM Periodico p
GROUP BY p.Idioma;

/* 3. Muestra los periodicos que han publicado articulos en 2019, el
número de articulos publicados y el número medio de visitas recibidas
por los articulos publicados en cada periodico.  Esquema:
(Id_Periodico, Nombre_Periodico, Num_Articulos, Media_visitas) */
SELECT p.IdPeriodico as Id_periodico, p.nombre as Nombre_periodico,
COUNT(a.IdArticulo) as Num_Articulos,
AVG(a.numVisitas) as Media_Visitas
FROM Periodico p JOIN Articulo a ON p.IdPeriodico = a.IdPeriodico
WHERE EXTRACT(YEAR FROM a.fechaPub) >= 2019
GROUP BY (p.IdPeriodico, p.nombre);

/* 4. Muestra información agregada de los periodistas y los idiomas
que utilizan para escribir articulos: Muestra la lista de periodistas
que han publicado articulos y el idioma en el que lo publicaron, y la
siguiente información estadística: número de periodicos en los que
cada periodista ha publicado articulos en cada idioma, el número total
de visitas a sus articulos en cada idioma, y el número máximo de
visitas recibidas por un articulo escrito por cada periodista en cada
idioma.  Esquema: (Id_Periodista, Nombre_Periodista, Idioma,
Num_periodicos, Total_visitas, Max_visitas).*/
SELECT per.idPeriodista as Id_Periodista, per.nombre as Nombre_Periodista, p.Idioma,
COUNT(p.idPeriodico) as Num_periodicos,
SUM(a.numVisitas) as Total_visitas,
MAX(a.numVisitas) as Max_Visitas
FROM Periodista per JOIN Articulo a ON per.idPeriodista = a.idPeriodista
JOIN Periodico p on a.idPeriodico = p.idPeriodico
GROUP BY per.idPeriodista, per.nombre, p.Idioma;

/* 5. Muestra la lista de TODOS los periodistas y el nombre de los
periodicos para los que cada periodista ha escrito articulos. Si un
periodista no ha escrito ningún articulo para ningún periodico, debe
mostrar '(ninguno)' en lugar del nombre del periodico.  Esquema:
(Id_Periodista, Nombre_Periodista, Nombre_Periodico) */
SELECT per.idPeriodista Id_Periodista, per.nombre Nombre_Periodista, NVL(p.nombre, '(ninguno)') Nombre_Periodico
FROM Periodista per
LEFT JOIN Articulo a ON per.idPeriodista = a.idPeriodista
LEFT JOIN Periodico p ON a.idPeriodico = p.idPeriodico
GROUP BY per.idPeriodista, per.nombre, p.nombre;



/* 6. Muestra la lista de TODOS los periodicos y los periodistas que
han escrito articulos en ellos en 2019. Si ningún periodista ha
escrito ningún articulo para un periodico en 2019, debe mostrar
'(ninguno)' en lugar del nombre del periodista.  Esquema:
(Id_Periodico, Nombre_Periodico, Id_Periodista, Nombre_Periodista) */
SELECT p.idPeriodico Id_Periodico, p.nombre Nombre_Periodico, per.idPeriodista Id_Periodista, NVL(per.nombre, '(ninguno)') Nombre_Periodista
FROM periodico p
LEFT JOIN articulo a ON p.idPeriodico = a.idPeriodico
LEFT JOIN periodista per ON a.idPeriodista = per.idPeriodista
WHERE EXTRACT(YEAR FROM a.fechaPub) = 2019;




/* 7. Muestra la lista de TODOS los periodistas, el número de
articulos escritos por cada periodista, y el número de periodicos
donde se han publicado esos articulos.  Si un periodista no ha escrito
ningún articulo, debe mostrar 0 en esas columnas.  Esquema:
(Id_Periodista, Nombre_Periodista, Num_Articulos, Num_Periodicos) */
SELECT j.idPeriodista as Id_Periodista, j.nombre as Nombre_Periodista, COUNT(idArticulo) as Num_Articulos, COUNT(DISTINCT idPeriodico) as Num_periodicos
FROM periodistas j JOIN articulo a on j.idPeriodista = a.idPeriodista;
  


/* 8. Contesta la pregunta anterior (7) utilizando operaciones de
teoría de conjuntos en lugar de utilizar reuniones externas.*/



/* 9. Muestra la lista de los periodicos que han publicado más de 2
articulos con menos de 2000 visitas recibidas por cada articulo. La
consulta debe mostrar el número de articulos publicados y el número
total de visitas a esos articulos.  Esquema: (Id_Periodico,
Nombre_Periodico, Num_Articulos, Total_Visitas)*/



/* 10. Muestra la lista de TODOS los periodistas, el número de
periodicos para los que han escrito articulos y el número total de
visitas a esos articulos.  Si un periodista no ha publicado ningún
artículo, debe mostrar 0 en esas columnas.  Esquema: (Id_Periodista,
Nombre_Periodista, Num_Periodicos, Total_Visitas)*/



/* 11. Contesta la pregunta anterior (10) ordenando los resultados por
Num_Articulos en orden decreciente y, si hay varias filas con el mismo
valor, ordena estas filas por Total_Visitas en orden creciente.*/
