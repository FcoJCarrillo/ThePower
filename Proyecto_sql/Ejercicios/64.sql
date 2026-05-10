/*
Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.
 */
select c.customer_id,c.first_name, c.last_name,COUNT(r.rental_id) AS total_peliculas from customer c
LEFT join rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;