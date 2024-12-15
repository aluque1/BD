# Transacciones

El SGBD debe garantizar que el estado de la BD es consistente. En una operación compleja, la BD es consistente si se han realizado todas las operaciones, o bien no se ha realizado ninguna operación.

Los programas de BD deben estar protegidos de cualquier interferencia de otras sesiones sin tener que programar explícitamente todos los casos posibles.

Una transacción es un conjunto de una o varias sentencias SQL que forman una unidad lógica indivisible

## Control de transacción

Existe un conjunto de instrucciones SQL que permiten implementar el control de las transacciones.

### Inicio de transacción

No existe una sentencia específica, se inicia cuando se ejecuta una sentencia DML o DDL.

### Fin de transacción

- **Commit**: Confirma las modificaciones realizadas en la BD y las hace permanentes y visibles a las demás sesiones activas
- **Rollback**: Cancela **<u>todos</u>** los cambios que se hayan realizado desde el inicio de la transacción
- Cualquier sentencia DDL **termina implícitamente cualquier transacción** (confirmando las modificaciones de la misma manera que un commit).

Cuando termina una transacción la siguiente instrucción SQL DML ejecutable inicia automáticamente la siguiente transacción.

Una sentencia DDL forma una transacción **por sí misma**, confirmando cualquier cambio anterior.

### Puntos medios

- **Savepoint** identificador: establece un punto en una transacción hasta el que se puede cancelar parcialmente. Para hacerlo se utiliza la sentencia rollback to savepoint identificador

Los savepoints intermedios no finalizan la transacción actual, solo deshacen algunos de los cambios realizados.

Cuando se retrocede a un savepoint, se eliminan todos los savepoints ejecutados después de este pero no los anteriores.
