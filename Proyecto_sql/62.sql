/*
Encuentra el número de películas por categoría estrenadas en 2006.
 */
select c.name,COUNT(*) AS total_peliculas from film f
join film_category fc ON f.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name;