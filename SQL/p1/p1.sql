-- -----------------------------------------------
-- 21.10.24 lab1 BBDD
-- -----------------------------------------------

/*
___________     ____._____________________________ .____________ .___________     ____ 
\_   _____/    |    |\_   _____|______   \_   ___ \|   \_   ___ \|   \_____  \   /_   |
 |    __)_     |    | |    __)_ |       _/    \  \/|   /    \  \/|   |/   |   \   |   |
 |        \/\__|    | |        \|    |   \     \___|   \     \___|   /    |    \  |   |
/_______  /\________|/_______  /|____|_  /\______  /___|\______  /___\_______  /  |___|
        \/                   \/        \/        \/            \/            \/        

DB CREATION
*/

DROP TABLE PRESTAMOS;
DROP TABLE USUARIOS;
DROP TABLE LIBROS;

alter session set nls_date_format = 'DD/MM/YYYY';

CREATE TABLE LIBROS (
  isbn VARCHAR2(13) PRIMARY KEY,
  titulo VARCHAR2(40) NOT NULL,
  autores VARCHAR2(50),
  num_copies INTEGER
);

CREATE TABLE USUARIOS (
  id INTEGER PRIMARY KEY,
  nif VARCHAR2(9) UNIQUE NOT NULL,
  nombre VARCHAR2(30) NOT NULL,
  email VARCHAR2(30) NOT NULL
);

CREATE TABLE PRESTAMOS (
  id INTEGER PRIMARY KEY,
  isbn VARCHAR2(13) REFERENCES LIBROS,
  id_usr INTEGER REFERENCES USUARIOS,
  fecha_prestamo DATE NOT NULL,
  num_dias INTEGER NOT NULL,
  fecha_devolucion DATE
);

/*
___________     ____._____________________________ .____________ .___________    ________  
\_   _____/    |    |\_   _____|______   \_   ___ \|   \_   ___ \|   \_____  \   \_____  \ 
 |    __)_     |    | |    __)_ |       _/    \  \/|   /    \  \/|   |/   |   \   /  ____/ 
 |        \/\__|    | |        \|    |   \     \___|   \     \___|   /    |    \ /       \ 
/_______  /\________|/_______  /|____|_  /\______  /___|\______  /___\_______  / \_______ \
        \/                   \/        \/        \/            \/            \/          \/

DATA INSERTION
*/

-- datos usuario 1
INSERT INTO USUARIOS VALUES(
  1,
  '12345678A',
  'Juan',
  'juanito@gmail.com'
);

-- datos usuario 2
INSERT INTO USUARIOS VALUES(
  2,
  '87654321B',
  'Maria',
  'maria@gmail.com'
);

-- datos libro 1
INSERT INTO LIBROS VALUES(
  '0-07-115110-9',
  'Database Management Systems',
  'Abraham Silberschatz, Henry F. Korth, S. Sudarshan',
  2
);

-- datos libro 2
INSERT INTO LIBROS VALUES(
  '9788478290857',
  'Fundamentals of Database Systems',
  'R. Elmasri, S.B. Navathe',
  3
);

-- prestamos primer usr
INSERT INTO PRESTAMOS VALUES(
  1,
  '0-07-115110-9',
  1,
  TO_DATE('25.08.24'),
  10,
  TO_DATE('30.08.24')
);

INSERT INTO PRESTAMOS VALUES(
  2,
  '9788478290857',
  1,
  TO_DATE('27.08.24'),
  10,
  TO_DATE('30.08.24')
);
-- prestamos segundo usr
INSERT INTO PRESTAMOS VALUES(
  3,
  '0-07-115110-9',
  2,
  TO_DATE('12.09.24'),
  5,
  NULL
);

INSERT INTO PRESTAMOS VALUES(
  4,
  '9788478290857',
  2,
  TO_DATE('24.09.24'),
  30,
  NULL
);

COMMIT;

/*
___________     ____._____________________________ .____________ .___________    ________  
\_   _____/    |    |\_   _____|______   \_   ___ \|   \_   ___ \|   \_____  \   \_____  \ 
 |    __)_     |    | |    __)_ |       _/    \  \/|   /    \  \/|   |/   |   \    _(__  < 
 |        \/\__|    | |        \|    |   \     \___|   \     \___|   /    |    \  /       \
/_______  /\________|/_______  /|____|_  /\______  /___|\______  /___\_______  / /______  /
        \/                   \/        \/        \/            \/            \/         \/ 

SQL QUERIES
*/

-- 1. Muestra los datos de todos los prestamos de menos de 10 dias
SELECT id ref_prestamo, id_usr id_usuario, isbn, fecha_prestamo, num_dias, fecha_devolucion
FROM PRESTAMOS
WHERE NUM_DIAS < 10;

-- 2. Muestra la fecha de vencimiento de todos los prestamos
SELECT id ref_prestamo, id_usr id_usuario, isbn, (fecha_prestamo + num_dias) fecha_vto
FROM PRESTAMOS;

-- 3. Muestra los prestamos con fecha de vencimiento anterior al 27 de octubre de 2024
SELECT id ref_prestamo, id_usr id_usuario, isbn, (fecha_prestamo + num_dias) fecha_vto
FROM PRESTAMOS
WHERE (fecha_prestamo + num_dias) < TO_DATE('27.10.2024');

-- 4. Muestra los prestamos devueltos despues de la fecha vencimiento
SELECT id ref_prestamo, id_usr id_usuario, isbn, fecha_prestamo, num_dias, fecha_devolucion, (fecha_prestamo + num_dias) fecha_vto
FROM PRESTAMOS
WHERE fecha_devolucion > (fecha_prestamo + num_dias);

-- 5. Muestra los prestamos vencidos antes de la fecha actual que no han sido devueltos todavia
-- para encontrar la fecha actual SYSDATE para obtener la fecha actual
SELECT id ref_prestamo, id_usr id_usuario, isbn, fecha_prestamo, num_dias, fecha_devolucion, (fecha_prestamo + num_dias) fecha_vto
FROM PRESTAMOS
WHERE fecha_devolucion IS NULL AND (fecha_prestamo + num_dias) < SYSDATE;

-- 6. Muestra los prestamos prestados antes de hoy ordenados por fecha de prestamo
SELECT isbn, fecha_prestamo, (fecha_prestamo + num_dias) fecha_vto, fecha_devolucion 
FROM PRESTAMOS
WHERE fecha_prestamo < SYSDATE
ORDER BY fecha_prestamo ASC;

-- 7. Muestra los libros devueltos en orden cronologico inverso
SELECT isbn, fecha_prestamo, (fecha_prestamo + num_dias) fecha_vto, fecha_devolucion 
FROM PRESTAMOS
WHERE fecha_devolucion IS NOT NULL
ORDER BY fecha_devolucion DESC;

-- 8. Muestra todos los libros prestados en octubre
SELECT l.titulo, l.isbn, p.fecha_prestamo
FROM LIBROS l
JOIN PRESTAMOS p ON l.isbn = p.isbn
WHERE EXTRACT(MONTH FROM p.fecha_prestamo) = 10;

-- 9. Muestra los nombres de los usuarios que han pedido prestado el libro con ISBN: 9788478290857
SELECT u.nombre nombre_usr 
FROM USUARIOS u 
JOIN PRESTAMOS p ON u.id = p.id_usr
JOIN LIBROS l on p.isbn = l.isbn
WHERE l.isbn = '9788478290857';

/* 
  10. Muestra los nombres de los usuarios que tienen libros en prestamo en octubre de 2024 
  asi como los libros que han tenido en prestamo
*/
SELECT u.nombre nombre_usr, l.titulo
FROM USUARIOS u 
LEFT JOIN PRESTAMOS p on u.id = p.id_usr
LEFT JOIN LIBROS l on p.isbn = l.isbn
WHERE (EXTRACT(MONTH FROM p.fecha_prestamo) = 10 AND EXTRACT(YEAR FROM p.fecha_prestamo) = 2024) OR p.FECHA_PRESTAMO IS NOT NULL;

/*
___________     ____._____________________________ .____________ .___________       _____  
\_   _____/    |    |\_   _____|______   \_   ___ \|   \_   ___ \|   \_____  \     /  |  | 
 |    __)_     |    | |    __)_ |       _/    \  \/|   /    \  \/|   |/   |   \   /   |  |_
 |        \/\__|    | |        \|    |   \     \___|   \     \___|   /    |    \ /    ^   /
/_______  /\________|/_______  /|____|_  /\______  /___|\______  /___\_______  / \____   | 
        \/                   \/        \/        \/            \/            \/       |__| 

DB MODIFICATION
*/

-- 1. Utiliza una consulta SQL para modificar el email del usuario cuyo id es el 1.
SELECT * FROM USUARIOS;

UPDATE USUARIOS
SET email = 'juanito_updated@gmail.com'
WHERE id = 1;

SELECT * FROM USUARIOS;

/*
  2. Utiliza una unica sentencia SQL para modificar la informacion sobre todos los prestamos
  del libro con isbn para que el numero de dias de los prestamos se duplique
*/

SELECT * FROM PRESTAMOS;

UPDATE PRESTAMOS
SET num_dias = num_dias * 2
WHERE isbn = '9788478290857';

SELECT * FROM PRESTAMOS;

-- 3. Borra todos los datos de los usuarios de la biblioteca
SELECT * FROM USUARIOS;
DELETE FROM PRESTAMOS WHERE id_usr IN (SELECT id FROM USUARIOS);
DELETE FROM USUARIOS;
SELECT * FROM USUARIOS;


-- Added so there is no conflict with later exercises
DROP TABLE PRESTAMOS;
DROP TABLE USUARIOS;
DROP TABLE LIBROS;