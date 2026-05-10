/*
Obtener los actores y el número de películas en las que ha actuado.
*/

select a.full_name , COUNT(a.actor_id) as "total_apariciones_actores" from actor a
join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
