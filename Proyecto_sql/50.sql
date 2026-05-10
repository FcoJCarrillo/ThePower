/*
Calcula la duración total de las películas en la categoría 'Action'.
 */
select SUM(f.length) AS duracion_total from film f
join film_category fc ON f.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';