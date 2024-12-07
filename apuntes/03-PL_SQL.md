# PL/SQL

SQL es muy potente pero no es un lenguaje de programacion. Para realizar operaciones complejas sobre la BDD se necesita un lenguaje de programacion procedimental

Hay 3 tipos fundamentales de bloques de codigo en PL/SQL:

- Bloque anonimo: un fragmento de codigo sin sobre que se ejecuta una sola vez.
- Funcion y procedimiento almacenado: fragmento de codigo con nombre que puede tener parametro y devolver un valor de retonro
- Disparador(trigger): fragmento de codigo que se ejecita automaticamente cuando ocurre un evento, normalmente suelen cuando ocurre una modificacion en la BDD.

Todos los tipos de bloques salvo los bloques anonimos se compilan y almacenan como objeto de la base de datos.

## Bloque PL/SQL anonimos

Un bloque anonimo se declara y se ejecuta. No se puede almacenar en la BDD ni invocar

``` sql
declare 
        var_saludo varchar2(20);
begin
        var_saludo := 'Hola Mundo!';
        dbms_output.put_line(var_saludo):
end;
/ -- Todo codigo PL/SQL acaba con '/'. Indica el final del codigo
```

Los bloques estan estructurados en secciones:

- declaraciones 