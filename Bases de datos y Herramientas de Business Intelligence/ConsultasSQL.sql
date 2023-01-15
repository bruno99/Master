CREATE TABLE tarea_uned.operaciones_uned.merchants
(
  merchant_id varchar(30),
  name varchar(50)
)
CREATE TABLE tarea_uned.operaciones_uned.orders
(
  order_id varchar(30),
  created_at datetime,
  status varchar(20),
  amount float,
  refunded_at datetime,
  merchant_id varchar(30),
  country varchar(20)
 
)

CREATE TABLE tarea_uned.operaciones_uned.refunds
(
  order_id varchar(30),
   refunded_at datetime,
  amount float
 
 
)

/*1. Realizamos una consulta donde obtengamos por país y estado de operación, el total de
operaciones y su importe promedio. La consulta debe cumplir las siguientes condiciones:
a. Operaciones más antiguas que el 01-07-2015.
b. Operaciones realizadas en Francia, Portugal y España.
c. Operaciones con un valor mayor de 100 € y menor de 1500€.
Ordenamos los resultados por el promedio del importe de manera descendente.*/

/*2. Realizamos una consulta donde obtengamos los 3 países con el mayor número de
operaciones, el total de operaciones, la operación con un valor máximo y la operación con
el valor mínimo para cada país. La consulta debe cumplir las siguientes condiciones:
a. Excluimos aquellas operaciones con el estado “Delinquent” y “Cancelled”.
b. Operaciones con un valor mayor de 100 €.*/

/*A partir de las tablas incluidas en la base de datos tarea_uned vamos a realizar las siguientes
consultas:
1. Realizamos una consulta donde obtengamos, por país y comercio, el total de operaciones,
su valor promedio y el total de devoluciones. La consulta debe cumplir las siguientes
condiciones:
a. Se debe mostrar el nombre y el id del comercio.
b. Comercios con más de 10 ventas.
c. Comercios de Marruecos, Italia, España y Portugal.
d. Creamos un campo que identifique si el comercio acepta o no devoluciones. Si no
acepta (total de devoluciones es igual a cero) el campo debe contener el valor
“No” y si sí lo acepta (total de devoluciones es mayor que cero) el campo debe
contener el valor “Sí”. Llamaremos al campo “acepta_devoluciones”.
Ordenamos los resultados por el total de operaciones de manera ascendente.*/

/*2. Realizamos una consulta donde vamos a traer todos los campos de las tablas operaciones y
comercios. De la tabla devoluciones vamos a traer el conteo de devoluciones por operación
y la suma del valor de las devoluciones.
Una vez tengamos la consulta anterior, creamos una vista con el nombre orders_view
dentro del esquema tarea_uned con esta consulta. */
