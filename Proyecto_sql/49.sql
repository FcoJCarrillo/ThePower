/*
 Calcula el número total de alquileres realizados por cada cliente.
 */
select c.customer_id,c.first_name,c.last_name, COUNT(r.rental_id) AS total_alquileres from customer c
LEFT join rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;