/*
Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres
de los actores y el número de películas en las que han participado.
*/

CREATE VIEW actor_num_peliculas AS
select a.full_name, COUNT(fa.film_id) AS total_peliculas from actor a
LEFT join film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.full_name;