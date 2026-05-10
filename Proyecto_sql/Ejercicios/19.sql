/*
Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “filmˮ.
*/
--En la tabla de film no sé las he visto que en la columna rating hay algo de sea comedia...

select f.title  from film f WHERE f.length > 180 and f.rating = 'G'