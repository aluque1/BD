-- -----------------------------------------------------
-- 06plsql: Ejercicios de clase (tercera parte)
-- -----------------------------------------------------
-- Utiliza la BD de ejemplo disponible en el tema SQL (script
-- 05sql2-ejemplos-tablas.sql)
-- -----------------------------------------------------
SET SERVEROUTPUT ON;

/* 
-- -----------------------------------------------------
Nos han pedido que la tabla Emp tenga una nueva columna TotalHoras
que contenga suma de todas las horas asignadas a proyectos de cada
empleado. Para ello, debemos ejecutar las siguientes sentencias para
actualizar la estructura de la tabla Emp: */

ALTER TABLE Emp ADD TotalHoras INTEGER;
UPDATE Emp SET TotalHoras = (select NVL(sum(horas),0) from Distribucion where nif = emp.nif);
COMMIT;
-- -----------------------------------------------------



/* 7. (DISPARADOR INSERT OR DELETE) Escribe un disparador llamado
ActualizaTotalHoras que mantenga actualizada automáticamente la
columna TotalHoras de la tabla Emp cada vez que se inserte o elimine
una fila de la tabla distribucion. Escribe sentencias de inserción y
eliminación de filas y ejecútalas para verificar que funciona
correctamente. */


/* 8. (DISPARADOR INSERT OR DELETE OR UPDATE) El disparador anterior
considera solamente los casos de inserciones y borrados. Modifica el
disparador para considerar _cualquier cambio_ sobre la tabla
Distribución. Ten en cuenta que ahora se debe considerar también la
modificación de filas existentes en la tabla, de cualquier forma
posible: no solo al modificar el número de horas, sino también al
cambiar el proyecto o incluso el NIF del empleado. Debes programar el
disparador para que ejecute el mínimo número de sentencias de
modificación de datos.  Escribe sentencias de inserción y eliminación
de filas y ejecútalas para verificar que funciona correctamente. */


/* 9. (DISPARADOR + CAMBIOS EN :NEW) Modifica el
disparador anterior para extender la funcionalidad actual limitando a
40 el número máximo de horas que un empleado puede estar asignado a un
proyecto. De esta forma, si el número de horas es superior a 40, debe
modificar Horas para que se almacenen 40 en la base de datos.
*/
