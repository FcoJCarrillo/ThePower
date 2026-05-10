/*
Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC
17ʼ ni ‘Gʼ en cuanto a su clasificación.
*/

select f.title  from film f WHERE f.rating <> 'NC-17' and f.rating <> 'G'