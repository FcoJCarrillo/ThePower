/*
Encuentra todos los alquileres y los nombres de los clientes que los
realizaron.
 */

select r.rental_id,c.first_name,c.last_name from rental r
join customer c ON r.customer_id = c.customer_id;