/*
Encuentra las películas con una duración superior al promedio.
*/

select f2.title, f2.length from film f2  WHERE cast(f2.length as Float) > (select AVG(f.length) from film f )