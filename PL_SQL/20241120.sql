-- -----------------------------------------------------
-- 06plsql: Ejercicios de clase (segunda parte)
-- -----------------------------------------------------
SET SERVEROUTPUT ON;
/* 5. (SELECT INTO + control excepciones + cursor) Escribe un
   procedimiento almacenado que, dado el NIF de un director de
   proyecto, muestre los empleados que están a su cargo en algún
   proyecto. Debe mostrar un mensaje de error si el NIF no existe en
   la BD, y otro mensaje de error diferente si el el NIF existe pero
   no corresponde a un director de proyecto. Ejemplo:

Empleados a cargo de: 37562365F - Maria Puente
-------------------------------------------------------------
NIF        Nombre               Departamento
-------------------------------------------------------------
27347234T  Marta Sanchez        Servicios Multiples   
37562365F  Maria Puente         Recursos Humanos
-------------------------------------------------------------
*/
create or replace procedure a_cargo_de(p_dni in proyecto.NIFDIR%TYPE) is
   v_nombre_dir emp.nombre%type;
   v_num_proyectos integer; -- una variable que nos va a servir para saber si hay un empleado con ese nif pero no tiene ningun proy a su cargo
   cursor curs_cargo is
      select distinct e.nif, e.nombre, dpt.nombre nombre_dpt
      from proyecto p
      join distribucion d on p.codPr = d.codPr
      join emp e on d.nif = e.nif
      join dpto dpt on e.coddp = dpt.coddp
      where p.nifdir = p_dni;
begin
   select nombre into v_nombre_dir from emp where nif = p_dni; -- Aqui atrapamos la excepcion si no existe empleado con ese dni
   select count(*) into v_num_proyectos from proyecto where NIFDIR = p_dni;
   if v_num_proyectos = 0 then -- nuestra propia "excepcion"
      dbms_output.put_line('El empleado con dni ' || p_dni || ' no es el director de ningun proyecto');
   else
      dbms_output.put_line('Empleados a cargo de ' || v_nombre_dir || ' con dni: ' || p_dni);
      dbms_output.put_line('------------------------------------------------------------------');
      dbms_output.put_line(' DNI                  Nombre                        Departamento');
      dbms_output.put_line('------------------------------------------------------------------');
      for rec in curs_cargo loop
         dbms_output.put_line(rpad(rec.nif, 15) || ' ' || rpad(rec.nombre, 20) || ' ' || rpad(rec.nombre_dpt, 20));
      end loop;
   end if;
exception
   when NO_DATA_FOUND then dbms_output.put_line('El director con dni ' || p_dni || ' no existe en la BDD');
end;
/

exec a_cargo_de('ZZZ');
exec a_cargo_de('27347234T');
exec a_cargo_de('85647456W');

/* 6. (doble cursor) Escribe un procedimiento almacenado que liste
   todos los departamentos y, por cada uno de ellos, muestre los
   proyectos cuyo director pertenece a ese departamento, mostrando el
   número total de horas asignadas al proyecto y el número de
   empleados asignados. Ejemplo:

Departamento: SMP - Servicios Multiples
-----------------------------------------------------
Proyecto: PR1 - Ventas                        40    3
-----------------------------------------------------
Departamento: RH - Recursos Humanos
-----------------------------------------------------
Proyecto: PR2 - Personal                      25    1
Proyecto: PR3 - Logistica                     70    2
-----------------------------------------------------
*/
