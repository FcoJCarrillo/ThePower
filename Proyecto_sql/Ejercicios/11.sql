/*
Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
*/

select p.amount, p.rental_id  from payment p join rental r on p.rental_id = r.rental_id ORDER BY r.return_date desc limit 1 offset 2;