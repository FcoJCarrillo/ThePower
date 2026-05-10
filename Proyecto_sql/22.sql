/*
Crea una columna con el nombre y apellidos de todos los actores y
actrices.
*/

--PRIMERO AÑADIR LA TABLA
alter table actor add full_name VARCHAR(255);
--LUEGO UN UPDATE
UPDATE actor a 
SET full_name = CONCAT(a.first_name , ' ', a.last_name );
