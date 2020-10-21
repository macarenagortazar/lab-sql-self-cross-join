
#In this lab, you will be using the Sakila database of movie rentals.
use sakila;
#Instructions

#Get all pairs of actors that worked together and where?.

select a1.actor_id, concat(a1.first_name," ", a1.last_name), a2.actor_id, concat(a2.first_name," ", a2.last_name) from sakila.film as f1
join sakila.film_actor as fa1
on f1.film_id=fa1.film_id
join sakila.actor as a1
on fa1.actor_id=a1.actor_id
join sakila.actor as a2
on a1.actor_id<>a2.actor_id
join sakila.film_actor as fa2
on a2.actor_id<>fa2.actor_id;

select fa1.film_id,a1.actor_id, concat(a1.first_name," ", a1.last_name), a2.actor_id, concat(a2.first_name," ", a2.last_name) from sakila.film_actor as fa1
join sakila.actor as a1
on fa1.actor_id=a1.actor_id
join sakila.actor as a2
on a1.actor_id<>a2.actor_id
group by a1.actor_id,a2.actor_id
order by a1.actor_id;

#Get all pairs of customers that have rented the same film more than 3 times.
select customer_id, count(rental_id) from sakila.rental
group by customer_id
having count(rental_id)>3;

SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

#Nope
select r1.customer_id as "Customer 1",r1.inventory_id,count(r1.rental_id) as "Times rented 1",r2.customer_id as "Customer 2", r2.inventory_id, count(r2.rental_id) as "Times rented 2" from sakila.rental as r1
join sakila.rental as r2
on r1.customer_id<>r2.customer_id
and r1.inventory_id=r2.inventory_id
group by r1.inventory_id,r1.customer_id,r2.customer_id
having count(*)>3;

#Yes
select r1.customer_id as "Customer 1",r2.customer_id as "Customer 2", count(*) from sakila.rental as r1
join sakila.inventory as i1
on r1.inventory_id=i1.inventory_id
join sakila.inventory as i2
on i1.film_id=i2.film_id
join sakila.rental as r2
on i2.inventory_id=r2.inventory_id
where r1.customer_id<>r2.customer_id
group by r1.customer_id,r2.customer_id
having count(*)>3
order by count(*) desc, r2.customer_id;


#Get all possible pairs of actors and films.
select*from (select distinct title from sakila.film) as b1
cross join (select distinct actor_id, first_name, last_name from sakila.actor) as b2;

select first_name,last_name from sakila.actor
where actor_id=100;
