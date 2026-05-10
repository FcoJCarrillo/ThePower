/*
Muestra el id de los actores que hayan participado en más de 40
películas.
*/

select a.actor_id, COUNT(a.actor_id) as "total_apariciones_actores" from actor a
join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id having count(fa.actor_id) > 40
