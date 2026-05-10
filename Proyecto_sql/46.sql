/*
Encuentra todos los actores que no han participado en películas.
*/

select a.full_name
from actor a
LEFT join film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;