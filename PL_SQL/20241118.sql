-- -----------------------------------------------
-- 05sql2 Tablas para ejemplos de clase.
-- -----------------------------------------------

DROP TABLE DISTRIBUCION;

DROP TABLE PROYECTO;

DROP TABLE EMP;

DROP TABLE DPTO;

CREATE TABLE DPTO (
  CODDP VARCHAR2(3) PRIMARY KEY,
  NOMBRE VARCHAR2(20)
);

CREATE TABLE EMP (
  NIF VARCHAR2(10) PRIMARY KEY,
  NOMBRE VARCHAR2(40),
  CODDP VARCHAR2(3) REFERENCES DPTO
);

CREATE TABLE PROYECTO (
  CODPR VARCHAR2(3) PRIMARY KEY,
  NIFDIR VARCHAR2(10) REFERENCES EMP,
  DESCR VARCHAR2(20)
);

CREATE TABLE DISTRIBUCION (
  CODPR VARCHAR2(3) REFERENCES PROYECTO,
  NIF VARCHAR2(10) REFERENCES EMP,
  HORAS INTEGER,
  PRIMARY KEY (CODPR, NIF)
);

INSERT INTO DPTO VALUES (
  'SMP',
  'Servicios Multiples'
);

INSERT INTO DPTO VALUES (
  'RH',
  'Recursos Humanos'
);

INSERT INTO EMP VALUES (
  '27347234T',
  'Marta Sanchez',
  'SMP'
);

INSERT INTO EMP VALUES (
  '85647456W',
  'Alberto San Gil',
  'SMP'
);

INSERT INTO EMP VALUES (
  '37562365F',
  'Maria Puente',
  'RH'
);

INSERT INTO EMP VALUES (
  '34126455Y',
  'Juan Panero',
  'SMP'
);

INSERT INTO EMP VALUES (
  '12345678Z',
  'Juan Español',
  NULL
);

INSERT INTO PROYECTO VALUES (
  'PR1',
  '27347234T',
  'Ventas'
);

INSERT INTO PROYECTO VALUES (
  'PR2',
  '37562365F',
  'Personal'
);

INSERT INTO PROYECTO VALUES (
  'PR3',
  '37562365F',
  'Logistica'
);

INSERT INTO DISTRIBUCION VALUES (
  'PR1',
  '27347234T',
  20
);

INSERT INTO DISTRIBUCION VALUES (
  'PR3',
  '27347234T',
  25
);

INSERT INTO DISTRIBUCION VALUES (
  'PR2',
  '27347234T',
  25
);

INSERT INTO DISTRIBUCION VALUES (
  'PR3',
  '37562365F',
  45
);

INSERT INTO DISTRIBUCION VALUES (
  'PR1',
  '37562365F',
  10
);

INSERT INTO DISTRIBUCION VALUES (
  'PR1',
  '34126455Y',
  10
);

COMMIT;

-- -----------------------------------------------------
-- 06plsql: Ejercicios de clase
-- -----------------------------------------------------
SET SERVEROUTPUT ON;

/* 1. Escribe un procedimiento almacenado que reciba como parámetro un
   número N y escriba en la consola los números impares de 1 hasta
   N. Si N es menor o igual a 0 o mayor a 100 debe escribir un mensaje 
   de error. */
CREATE OR REPLACE PROCEDURE IMPARESENTRE(
  P_IN IN INTEGER
) IS -- En procedimientos almacenado no tenemos DECLARE, tenemos IS
BEGIN
  IF P_IN <= 0 OR P_IN > 100 THEN
    DBMS_OUTPUT.PUT_LINE('[ERROR] : N debe estar entre 1 y 100');
  ELSE
    FOR I IN 1..P_IN LOOP
      IF I MOD 2 != 0 THEN
        DBMS_OUTPUT.PUT_LINE(I);
      END IF;
    END LOOP;
  END IF;
END;
/

/* 2. Escribe un procedimiento almacenado que incremente el número de
   horas asignadas a cada proyecto en un porcentaje recibido como
   parámetro. Prueba el procedimiento con distintos valores del
   parámetro. */
CREATE OR REPLACE PROCEDURE INCRHORASASIGNADAS(
  PORCENTAJE_IN IN FLOAT
) IS
BEGIN
  UPDATE DISTRIBUCION
  SET
    HORAS = HORAS + HORAS * PORCENTAJE_IN / 100;
END;
/

SELECT
  *
FROM
  DISTRIBUCION;

EXEC incrHorasAsignadas(30);

SELECT
  *
FROM
  DISTRIBUCION;

/* 3. Escribe un procedimiento almacenado que, dado un NIF de empleado
   recibido como parámetro, escriba en la consola su nombre,
   departamento, número de proyectos en los que trabaja y número total
   de horas asignadas a proyectos. Si el empleado no existe en la base
   de datos, debe mostrar un mensaje de error. */
CREATE OR REPLACE PROCEDURE datosEmpleado(
  NIF_IN IN VARCHAR2
) IS 
v_nombre EMP.nombre%TYPE; -- Variables donde voy a almacenar los datos de las consultas
v_dpto DPTO.nombre%TYPE;
v_num_proyecto INTEGER;
v_horas_total INTEGER;
v_existe INTEGER;
BEGIN
  -- Comprobamos si existe el empleado
  SELECT COUNT(*) INTO v_existe
  FROM EMP
  WHERE NIF = NIF_IN;

  IF v_existe=0 THEN
    DBMS_OUTPUT.PUT_LINE('[ERROR] : Empleado con NIF ' || NIF_IN || ' no existe.');
  ELSE
    -- consultamos el nombre del empleado dado por el NIF
    SELECT nombre INTO v_nombre
    FROM EMP
    WHERE NIF = NIF_IN;
    -- consultamos el departamento en al que esta asignado nuestro empleado
    SELECT nombre INTO v_dpto
    FROM DPTO d
    JOIN EMP e ON d.CODDP = e.CODDP
    WHERE e.NIF = NIF_IN;
    -- consultamos el numero de proyectos al que esta asignado nuestro empleado
    SELECT COUNT(*) INTO v_num_proyecto
    FROM DISTRIBUCION
    WHERE NIF = NIF_IN;
    -- consultamos el numero de proyectos al que esta asignado nuestro empleado
    SELECT SUM(HORAS) INTO v_horas_total
    FROM DISTRIBUCION
    WHERE NIF = NIF_IN;

    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Numero de proyectos: ' || v_num_proyecto);
    DBMS_OUTPUT.PUT_LINE('Numero de horas totales: ' || v_horas_total);
  END IF;
END;
/


/* 4. Escribe un procedimiento almacenado que muestre en la consola el
   número total de horas asignadas por proyecto, así como el nombre
   del director del proyecto y el departamento al que pertenece.  */


/* 
  La primera opcion que se plantea es usando una subconsulta como indice del FOR. Se va iterando por cada
  elemento de la subconsulta para construir los datos
 */
CREATE OR REPLACE procedure horas_asignadas(
) IS
BEGIN
  FOR resultados IN (
    SELECT NVL(SUM(dist.horas, 0)) horas_total, e.NOMBRE nombre_dir, d.NOMBRE nombre_dpto
    FROM PROYECTO p
    LEFT JOIN EMP e ON p.NIFDIR = e.NIF
    LEFT JOIN DPTO d ON e.CODDP = d.CODDP
    LEFT JOIN DISTRIBUCION dist ON p.CODPR = dist=CODPR
    GROUP BY e.NOMBRE, d.NOMBRE
  ) LOOP
    DBMS_OUTPUT.PUT_LINE("Total de horas asignadas: " || horas_total);
    DBMS_OUTPUT.PUT_LINE("Nombre del director: " || nombre_dir);
    DBMS_OUTPUT.PUT_LINE("Departamento del director: " || nombre_dpto);
  END LOOP;
END;
/

/* Otra opcion que es mas simple es usar un cursor para iterarar por los elementos de la subconsulta */
CREATE OR REPLACE procedure horas_asignadas IS
CURSOR cur_proyectos IS
SELECT NVL(SUM(dist.horas), 0) horas_total, e.NOMBRE nombre_dir, d.NOMBRE nombre_dpto
FROM PROYECTO p
LEFT JOIN EMP e ON p.NIFDIR = e.NIF
LEFT JOIN DPTO d ON e.CODDP = d.CODDP
LEFT JOIN DISTRIBUCION dist ON p.CODPR = dist.CODPR
GROUP BY e.NOMBRE, d.NOMBRE;

BEGIN
FOR rec IN cur_proyectos LOOP
  DBMS_OUTPUT.PUT_LINE('Total de horas asignadas: ' || rec.horas_total);
  DBMS_OUTPUT.PUT_LINE('Nombre del director: ' || rec.nombre_dir);
  DBMS_OUTPUT.PUT_LINE('Departamento del director: ' || rec.nombre_dpto);
END LOOP;
END;
/


-- Added so there is no problem with future exercises
-- DROP TABLE DISTRIBUCION;
-- DROP TABLE PROYECTO;
-- DROP TABLE EMP;
-- DROP TABLE DPTO;