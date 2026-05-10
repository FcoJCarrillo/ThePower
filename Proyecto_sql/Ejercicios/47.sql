/*
Selecciona el nombre de los actores y la cantidad de películas en las
que han participado.
*/

select a.full_name, COUNT(fa.film_id) AS total_peliculas from actor a
LEFT join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.full_name;