/*
Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido?

El nombre más repetido es Kenneth, Penelope y Julia
 */

select first_name, COUNT(*) AS cantidad from actor
GROUP BY first_name ORDER BY cantidad DESC;