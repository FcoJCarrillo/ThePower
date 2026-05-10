/*
 Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
 */
select c.customer_id,c.first_name AS nombre,c.last_name AS apellido, SUM(p.amount) AS total_gastado
from customer c
join payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;