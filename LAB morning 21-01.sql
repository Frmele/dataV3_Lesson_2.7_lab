USE sakila;
DROP TABLE IF EXISTS films_2020;
CREATE TABLE `films_2020` (
  `film_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `release_year` YEAR(4) DEFAULT NULL,
  `language_id` TINYINT(3) UNSIGNED NOT NULL,
  `original_language_id` TINYINT(3) UNSIGNED DEFAULT NULL,
  `rental_duration` INT(6),
  `rental_rate` DECIMAL(4,2),
  `length` SMALLINT(5) UNSIGNED DEFAULT NULL,
  `replacement_cost` DECIMAL(5,2) DEFAULT NULL,
  `rating` ENUM('G','PG','PG-13','R','NC-17') DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=INNODB AUTO_INCREMENT=1003 DEFAULT CHARSET=UTF8;
/*
We have just one item for each film, and all will be placed in the new table. For 2020, the rental duration will be 3 days, with an offer price of 2.99€ and a replacement cost of 8.99€ (these are all fixed values for all movies for this year). The catalog is in a CSV file named films_2020.csv that can be found at files_for_lab folder.
*/
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;


load data local infile '"C:\Users\thecr\OneDrive\Documents\day 8 sql\films_2020.csv"'
into table films_2020
fields terminated BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
(film_id,title,description,release_year,language_id,original_language_id,rental_duration,rental_rate,length,replacement_cost,rating);

SELECT * FROM films_2020;


/*
Instructions
-- Add the new films to the database. 
-- Update information on rental_duration (3), rental_rate (2.99), and replacement_cost (8.99).

Hint
-- You might have to use the following commands to set bulk import option to ON:
show variables like 'local_infile';
set global local_infile = 1;
-- If bulk import gives an unexpected error, you can also use the data_import_wizard to insert data into the new table.
*/
UPDATE films_2020 SET rental_duration = 3, rental_rate = 2.99, replacement_cost = 8.99;




/*
Lab | SQL Queries - Lesson 2.7 Part 2
In this lab, you will be using the Sakila database of movie rentals. You have been using this database for a couple labs already, but if you need to get the data again, refer to the official installation link.

The database is structured as follows: DB schema

Instructions
1. In the table actor, which are the actors whose last names are not repeated? 
For example if you would sort the data in the table actor by last_name,
 you would see that there is Christian Arkoyd, Kirsten Arkoyd, 
 and Debbie Arkoyd. These three actors have the same last name. 
 So we do not want to include this last name in our output. 
 Last name "Astaire" is present only one time with actor "Angelina Astaire",
 hence we would want this in our output list.
 
2. Which last names appear more than once? We would use the same logic as in the previous
 question but this time we want to include the last names of the actors where the last name
 was present more than once
 
3. Using the rental table, find out how many rentals were processed by each employee.
4. Using the film table, find out how many films were released each year.
5. Using the film table, find out for each rating how many films were there.
6. What is the mean length of the film for each rating type. Round off the average lengths to two decimal places
7. Which kind of movies (rating) have a mean duration of more than two hours?
*/

select  * from sakila.actor;
group by last_name having count(*)<2;

SELECT *, COUNT(last_name)
FROM sakila.actor
GROUP BY last_name 
HAVING COUNT(last_name) > 1;

#3. Using the rental table, find out how many rentals were processed by each employee.

select*, count(rental_id)
from sakila.rental
group by staff_id
order by staff_id;


#4. Using the film table, find out how many films were released each year.
select count(film_id) as no_of_films, release_year from sakila.film
group by release_year;

#5. Using the film table, find out for each rating how many films were there.
select count(film_id) as no_of_films, rating from sakila.film
group by rating;

#6. What is the mean length of the film for each rating type. 
#Round off the average lengths to two decimal places
select rating, round(avg(length),2) as avg_length from sakila.film
group by rating
order by rating asc;

#7. Which kind of movies (rating) have a mean duration of more than two hours?
select rating, round(avg(length),2) as avg_length from sakila.film
group by rating
having avg_length > 120
order by rating asc;



