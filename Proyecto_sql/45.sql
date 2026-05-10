/*
Encuentra los actores que han participado en películas de la categoría
'Action'.
*/

select distinct a.first_name,a.last_name from actor a
join film_actor fa ON a.actor_id = fa.actor_id
join film_category fc ON fa.film_id = fc.film_id
join category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';