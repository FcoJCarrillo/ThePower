/*
Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración.
*/

select f.rating, ROUND(AVG("length"), 2) AS "promedio_duracion" 
from film f group by f.rating having ROUND(AVG("length"), 2) > 110