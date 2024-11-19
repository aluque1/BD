-- -----------------------------------------------
-- 21.10.24 lab1 BBDD
-- -----------------------------------------------

DROP TABLE PRESTAMO;

DROP TABLE USUARIOS;

DROP TABLE LIBROS;

CREATE TABLE LIBROS (
  ISBN VARCHAR2(13) PRIMARY KEY,
  TITULO VARCHAR2(40) NOT NULL,
  AUTORES VARCHAR2(50),
  NUM_COPIES INTEGER
);

CREATE TABLE USUARIOS(
  ID INTEGER PRIMARY KEY,
  NIF VARCHAR2(9) UNIQUE NOT NULL,
  NOMBRE VARCHAR2(30) NOT NULL,
  EMAIL VARCHAR2(30) NOT NULL
);

CREATE TABLE PRESTAMOS (
  ID INTEGER PRIMARY KEY,
  ISBN VARCHAR2(13) REFERENCES LIBROS,
  ID_USR INTEGER REFERENCES USUARIOS,
  FECHA_PRESTAMO DATE NOT NULL,
  NUM_DIAS INTEGER NOT NULL,
  FECHA_DEVOLUCION DATE
);

-- Insterting fake data

INSERT INTO LIBROS VALUES (
  '0-07-115110-9',
  'Database Management Systems',
  'A. Silberschatz , H. F. Korth, S. Sudarshan.',
  2
);

INSERT INTO LIBROS VALUES (
  '9788478290857',
  'Fundamentals of Database Systems',
  'R. Elmasri, S.B. Navathe',
  3
);

INSERT INTO USUARIOS VALUES (
  1,
  '79024344R',
  'Alejandro Luque',
  'aluque02@ucm.es'
);

INSERT INTO USUARIOS VALUES (
  2,
  '79024333R',
  'Alejandro Gomez',
  'alegom24@ucm.es'
);

-- prestamos primer usr
INSERT INTO PRESTAMOS (
  1,
  '0-07-115110-9',
  '79024344R',
  '25.08.24',
  10,
  '30.08.24'
);


INSERT INTO PRESTAMOS (
  2,
  '9788478290857',
  '79024344R',
  '27.08.24',
  10,
  '30.08.24'
);

-- prestamos segundo usr
INSERT INTO PRESTAMOS (
  3,
  '0-07-115110-9',
  '79024333R',
  '12.09.24',
  5,
  NULL
);


INSERT INTO PRESTAMOS (
  4,
  '9788478290857',
  '79024333R',
  '24.09.24',
  30,
  NULL
);

COMMIT;

-- Queries

