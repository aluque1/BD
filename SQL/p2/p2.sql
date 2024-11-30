alter session set nls_date_format = 'DD/MM/YYYY';

drop table Cliente cascade constraints;
drop table Pedido cascade constraints;
drop table Autor cascade constraints;
drop table Autores_Libro cascade constraints;
drop table Libro cascade constraints;
drop table Libros_Pedido cascade constraints;

create table Cliente
(IdCliente VARCHAR2(10) PRIMARY KEY,
 nombre VARCHAR2(40) NOT NULL,
 direccion VARCHAR2(60) NOT NULL,
 NumCC VARCHAR2(16) NOT NULL);
 
create table Pedido
(IdPedido VARCHAR2(10) PRIMARY KEY,
 IdCliente VARCHAR2(10) NOT NULL REFERENCES Cliente on delete cascade,
 fechaPedido DATE NOT NULL,
 fechaEnvio DATE);

create table Autor
( idAutor NUMBER PRIMARY KEY,
  Name VARCHAR2(40));

create table Libro
(ISBN VARCHAR2(15) PRIMARY KEY,
titulo VARCHAR2(60) NOT NULL,
anio VARCHAR2(4) NOT NULL,
precioCompra NUMBER(6,2) DEFAULT 0, 
-- PurchasePrice is the price paid to the Publisher.
precioVenta NUMBER(6,2) DEFAULT 0);
-- SalePrice is the Retail price (price paid by customers)

create table Autores_Libro
(ISBN VARCHAR2(15),
Autor NUMBER,
PRIMARY KEY (ISBN, Autor),
FOREIGN KEY (ISBN) REFERENCES Libro on delete cascade,
FOREIGN KEY (Autor) REFERENCES Autor);


create table Libros_Pedido(
ISBN VARCHAR2(15),
idPedido VARCHAR2(10),
cantidad NUMBER(3) CHECK (cantidad >0),
PRIMARY KEY (ISBN, idPedido),
FOREIGN KEY (ISBN) REFERENCES Libro on delete cascade,
FOREIGN KEY (idPedido) REFERENCES Pedido on delete cascade);

insert into Cliente values ('0000001','James Smith', 'Picadilly 2','1234567890123456');
insert into Cliente values ('0000002','Laura Jones', 'Holland Park 13', '1234567756953456');
insert into Cliente values ('0000003','Peter Doe', 'High Street 42', '1237596390123456');
insert into Cliente values ('0000004','Rose Johnson', 'Notting Hill 46', '4896357890123456');
insert into Cliente values ('0000005','Joseph Clinton', 'Leicester Square 1', '1224569890123456');
insert into Cliente values ('0000006','Betty Fraser', 'Whitehall 32', '2444889890123456' );
insert into Cliente values ('0000007','Jack the Ripper', 'Tottenham Court Road 3', '2444889890123456' );
insert into Cliente values ('0000008','John H. Watson', 'Tottenham Court Road 3', '2444889890123456' );

insert into Pedido values ('0000001P','0000001', TO_DATE('01/10/2020'),TO_DATE('03/10/2020'));
insert into Pedido values ('0000002P','0000001', TO_DATE('01/10/2020'),null);
insert into Pedido values ('0000003P','0000002', TO_DATE('02/10/2020'),TO_DATE('03/10/2020'));
insert into Pedido values ('0000004P','0000004', TO_DATE('02/10/2020'),TO_DATE('05/10/2020'));
insert into Pedido values ('0000005P','0000005', TO_DATE('03/10/2020'),TO_DATE('03/10/2020'));
insert into Pedido values ('0000006P','0000003', TO_DATE('04/10/2020'),null);
insert into Pedido values ('0000007P','0000006', TO_DATE('05/09/2012'),NULL);
insert into Pedido values ('0000008P','0000006', TO_DATE('05/09/2012'),TO_DATE('05/10/2012'));
insert into Pedido values ('0000009P','0000007', TO_DATE('05/09/2012'),NULL);

insert into Autor values (1,'Jane Austin');
insert into Autor values (2,'George Orwell');
insert into Autor values (3,'J.R.R Tolkien');
insert into Autor values (4,'Antoine de Saint-Exupéry');
insert into Autor values (5,'Bram Stoker');
insert into Autor values (6,'Plato');
insert into Autor values (7,'Vladimir Nabokov');

insert into Libro values ('8233771378567', 'Pride and Prejudice', '2008', 9.45, 13.45);
insert into Libro values ('1235271378662', '1984', '2009', 12.50, 19.25);
insert into Libro values ('4554672899910', 'The Hobbit', '2002', 19.00, 33.15);
insert into Libro values ('5463467723747', 'The Little Prince', '2000', 49.00, 73.45);
insert into Libro values ('0853477468299', 'Dracula', '2011', 9.45, 13.45);
insert into Libro values ('1243415243666', 'The Republic', '1997', 10.45, 15.75);
insert into Libro values ('0482174555366', 'Lolita', '1998', 4.00, 9.45);


insert into Autores_Libro values ('8233771378567',1);
insert into Autores_Libro values ('1235271378662',2);
insert into Autores_Libro values ('4554672899910',3);
insert into Autores_Libro values ('5463467723747',4);
insert into Autores_Libro values ('0853477468299',5);
insert into Autores_Libro values ('1243415243666',6);
insert into Autores_Libro values ('0482174555366',7);

insert into Libros_Pedido values ('8233771378567','0000001P', 1);
insert into Libros_Pedido values ('5463467723747','0000001P', 2);
insert into Libros_Pedido values ('0482174555366','0000002P', 1);
insert into Libros_Pedido values ('4554672899910','0000003P', 1);
insert into Libros_Pedido values ('8233771378567','0000003P', 1);
insert into Libros_Pedido values ('1243415243666','0000003P', 1);
insert into Libros_Pedido values ('8233771378567','0000004P', 1);
insert into Libros_Pedido values ('4554672899910','0000005P', 1);
insert into Libros_Pedido values ('1243415243666','0000005P', 1);
insert into Libros_Pedido values ('5463467723747','0000005P', 3);
insert into Libros_Pedido values ('8233771378567','0000006P', 5); 
insert into Libros_Pedido values ('0853477468299','0000007P', 2);
insert into Libros_Pedido values ('1235271378662','0000008P', 7);
insert into Libros_Pedido values ('8233771378567','0000009P', 1);
insert into Libros_Pedido values ('5463467723747','0000009P', 7);

commit;

/*

_________ ________    _______    _____________ ___.____  ________________    _________
\_   ___ \\_____  \   \      \  /   _____/    |   \    | \__    ___/  _  \  /   _____/
/    \  \/ /   |   \  /   |   \ \_____  \|    |   /    |   |    | /  /_\  \ \_____  \ 
\     \___/    |    \/    |    \/        \    |  /|    |___|    |/    |    \/        \
 \______  |_______  /\____|__  /_______  /______/ |_______ \____|\____|__  /_______  /
        \/        \/         \/        \/                 \/             \/        \/ 

Consultas agregadas, funciones de agregacion y sentencias GROUP BY & HAVING
*/

-- Consulta 1 que muestra los precios de venta de los libros
SELECT ISBN, titulo, anio as año, precioVenta as precio_venta
FROM Libro;

-- Consulta 2 que muestra libros pedidos y el id y nombre del usuario
SELECT idPedido as id_pedido, fechaPedido as fecha_pedido, c.IdCliente as id_cliente, nombre as nombre_cliente 
FROM Pedido p JOIN Cliente c ON p.IdCliente = c.IdCliente;

-- Consulta 3 que muestra los clientes cuyo cliente contiene 'Jo' y los libros que han comprado
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente, l.titulo
FROM Pedido p JOIN Cliente c ON p.IdCliente = c.IdCliente
JOIN Libros_Pedido lp ON p.IdPedido = lp.idPedido
JOIN Libro l ON lp.ISBN = l.ISBN
WHERE nombre LIKE '%Jo%';

-- Consulta 4 que muestra los clientes que han comprado al menos un libro con precio de venta mayor a 10 euros
SELECT distinct c.IdCliente as id_cliente, c.nombre as nombre_cliente
FROM Pedido p JOIN Cliente c on p.IdCliente = c.IdCliente
JOIN Libros_Pedido lp ON p.IdPedido = lp.idPedido
JOIN Libro l ON lp.ISBN = l.ISBN
WHERE l.precioVenta > 10;

-- Consulta 5 que Muestra los clientes y las fechas en las que han solicitado pedidos que todavia no han sido enviados.
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente, p.IdPedido as id_pedido, p.fechaPedido as fecha_pedido
FROM Pedido p JOIN Cliente c ON p.IdCliente = c.IdCliente
WHERE fechaEnvio IS NULL;

-- Consulta 6 que muestra los clientes que NO han comprado ningun libro
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente
FROM Cliente c
WHERE NOT EXISTS (SELECT idPedido FROM Pedido p WHERE p.IdCliente = c.IdCliente);

-- Consulta 7 que muestra los clientes que SOLO han comprado libros que cuestan menos de 20 euros.
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente
FROM Cliente c JOIN Pedido p ON c.IdCliente = p.IdCliente
JOIN Libros_Pedido lp ON p.IdPedido = lp.idPedido
JOIN Libro l ON lp.ISBN = l.ISBN
GROUP BY c.IdCliente, c.nombre
HAVING MAX(l.precioVenta) < 20;

-- Consulta 8 que muestra los libros que cuestan más de 30 euros o de los que se han vendido más de 5 ejemplares en el mismo pedido.
SELECT l.ISBN, l.titulo, l.precioVenta as precio_venta
FROM Libro l JOIN Libros_Pedido lp ON l.ISBN = lp.ISBN
WHERE l.precioVenta > 30 OR lp.cantidad > 5
GROUP BY l.ISBN, l.titulo, l.precioVenta;

-- Consulta 9 que muesta los clientes que han hecho más de un pedido en una misma fecha
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente, p.fechaPedido as fecha_pedido
FROM Cliente c JOIN Pedido p ON c.IdCliente = p.IdCliente
GROUP BY c.IDCliente, c.nombre, p.fechaPedido
HAVING COUNT(c.IdCliente) > 1;

-- Consulta 10 que muestra los clientes que han comprado los libros 'Dracula' o '1984'
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente
FROM Cliente c JOIN Pedido p ON c.IdCliente = p.IDCLIENTE
JOIN Libros_Pedido lp ON p.IdPedido = lp.IdPedido
JOIN Libro l ON lp.ISBN = l.ISBN
WHERE l.titulo IN ('Dracula', '1984');

-- Consulta 11 que muestra  los clientes que han comprado los libros 'Pride and Prejudice' y 'The Little Prince'.
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente
FROM Cliente c JOIN Pedido p ON c.IdCliente = p.IdCliente
JOIN Libros_Pedido lp ON p.IdPedido = lp.IdPedido
JOIN Libro l ON lp.ISBN = l.ISBN
WHERE l.titulo IN ('Pride and Prejudice', 'The Little Prince')
GROUP BY c.IdCliente, c.nombre
HAVING COUNT(DISTINCT l.titulo) = 2;

/* 
  Consulta 12 que muestra los clientes y los libros para los que se ha obtenido una
  rentabilidad de al menos 50 euros en un único pedido. La
  rentabilidad es la diferencia entre el precio de venta y
  el precio de compra. Debes tener en cuenta el número de ejemplares
  vendidos. 
*/ 
SELECT c.IdCliente as id_cliente, c.nombre as nombre_cliente, l.titulo, (l.precioVenta - l.precioCompra) * lp.cantidad as rentabilidad
FROM Cliente c 
JOIN Pedido p ON c.IdCliente = p.IdCliente
JOIN Libros_Pedido lp ON p.IdPedido = lp.idPedido
JOIN Libro l ON lp.ISBN = l.ISBN
WHERE (l.precioVenta - l.precioCompra) * lp.cantidad >= 50;


-- Added so this is no problem with later exercises
drop table Cliente cascade constraints;
drop table Pedido cascade constraints;
drop table Autor cascade constraints;
drop table Autores_Libro cascade constraints;
drop table Libro cascade constraints;
drop table Libros_Pedido cascade constraints;