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

SELECT COUNT(order_id), avg(amount), country, status
FROM "TAREA_UNED"."OPERACIONES_UNED"."ORDERS"

WHERE created_at <  '2015-07-01 00:00:00'
AND country = 'Francia' OR country = 'Portugal' OR country = 'España'
AND   amount between 100 AND 1500


GROUP BY country, status

ORDER BY avg(amount) DESC

/*2. Realizamos una consulta donde obtengamos los 3 países con el mayor número de
operaciones, el total de operaciones, la operación con un valor máximo y la operación con
el valor mínimo para cada país. La consulta debe cumplir las siguientes condiciones:
a. Excluimos aquellas operaciones con el estado “Delinquent” y “Cancelled”.
b. Operaciones con un valor mayor de 100 €.*/
SELECT COUNT(order_id), MAX(amount), MIN(amount), country
FROM "TAREA_UNED"."OPERACIONES_UNED"."ORDERS"
 
WHERE STATUS != 'Delinquent' OR STATUS != 'Cancelled'
AND   amount > 100
GROUP BY country
ORDER BY COUNT(order_id) DESC
LIMIT 3

/*
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

SELECT name,o.merchant_id, country, COUNT(o.order_id) AS Total_operaciones, AVG(o.amount) AS Valor_promedio, COUNT(r.order_id) AS Total_devoluciones,
CASE
  WHEN COUNT(r.order_id) > 0 THEN 'Si'
ELSE 'No'
END AS acepta_devoluciones
FROM "TAREA_UNED"."OPERACIONES_UNED"."ORDERS" o
INNER JOIN "TAREA_UNED"."OPERACIONES_UNED"."MERCHANTS" m ON o.merchant_id=m.merchant_id
LEFT JOIN "TAREA_UNED"."OPERACIONES_UNED"."REFUNDS" r ON o.order_id=r.order_id
 
WHERE o.amount > 10
AND country = 'Marruecos'OR country = 'Italia'OR country = 'España'OR country = 'Portugal'
GROUP BY name,o.merchant_id, country
ORDER BY Total_operaciones ASC

/*2. Realizamos una consulta donde vamos a traer todos los campos de las tablas operaciones y
comercios. De la tabla devoluciones vamos a traer el conteo de devoluciones por operación
y la suma del valor de las devoluciones.
Una vez tengamos la consulta anterior, creamos una vista con el nombre orders_view
dentro del esquema tarea_uned con esta consulta. */
