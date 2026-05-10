/*
Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Feverʼ. Ordena los resultados
alfabéticamente por título de película.
 */
select title from film
WHERE length = (
    select length from film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title;