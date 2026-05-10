/*
Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres.
 */
select c.name,COUNT(*) AS total_alquiladas from rental r
join inventory i ON r.inventory_id = i.inventory_id
join film_category fc ON i.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
GROUP BY c.name;