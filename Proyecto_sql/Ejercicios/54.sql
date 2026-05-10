/*
Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados
alfabéticamente por apellido.
*/
select distinct a.first_name, a.last_name
from actor a
join film_actor fa ON a.actor_id = fa.actor_id
join film_category fc ON fa.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;