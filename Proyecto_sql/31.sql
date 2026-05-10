/*
Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados.
*/

select f.title AS pelicula , a.full_name as "nombre_completo"
from film f
LEFT join film_actor fa ON f.film_id = fa.film_id
LEFT join actor a ON fa.actor_id = a.actor_id
ORDER BY f.title, a.last_name;
