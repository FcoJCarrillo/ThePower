/*
Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película.
*/

select a.actor_id,a.first_name,a.last_name,f.title AS pelicula
from actor a
LEFT join film_actor fa 
    ON a.actor_id = fa.actor_id
LEFT join film f 
    ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name;