/*
Encuentra la variabilidad de lo que costaría reemplazar las películas.
*/

select stddev("replacement_cost") as "varianza"  from film f;