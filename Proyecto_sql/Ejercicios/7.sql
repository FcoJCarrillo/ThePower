/*
Encuentra la cantidad total de películas en cada clasificación de la tabla
“filmˮ y muestra la clasificación junto con el recuento.
*/

select f.rating ,count(f.rating ) as "total_peliculas" from film f group by f.rating ORDER BY f.rating ;