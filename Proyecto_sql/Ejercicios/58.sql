/*
Encuentra el título de todas las películas que son de la misma categoría
que ‘Animationʼ.
 */
select f.title from film f
join film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
    select category_id from category WHERE name = 'Animation'
);