CREATE DATABASE swiggy_db;
USE swiggy_db;

CREATE TABLE swiggy( 
restaurant_no INTEGER NOT NULL, 
restaurant_name VARCHAR(50) NOT NULL, 
city VARCHAR(10) NOT NULL, 
address VARCHAR(250), 
rating DECIMAL(3,1) NOT NULL, 
cost_per_person INTEGER , 
cuisine VARCHAR(50) NOT NULL, 
restaurant_link VARCHAR(150) NOT NULL, 
menu_category VARCHAR(100), 
item VARCHAR(200), 
price VARCHAR(15) NOT NULL, 
veg_or_nonveg VARCHAR(10) 
);

SELECT * FROM swiggy LIMIT 10;

SELECT COUNT(DISTINCT restaurant_no) AS high_rated_restaurants 
FROM swiggy 
WHERE rating > 4.5;

SELECT city, COUNT(DISTINCT restaurant_name) AS restaurant_count 
FROM swiggy 
GROUP BY city 
ORDER BY restaurant_count DESC 
LIMIT 1; 

SELECT COUNT(DISTINCT restaurant_name) AS pizza_restaurants 
FROM swiggy 
WHERE restaurant_name LIKE '%pizza%';

SELECT DISTINCT restaurant_name AS pizza_restaurants 
FROM swiggy 
WHERE restaurant_name LIKE '%pizza%';


SELECT cuisine, COUNT(cuisine) AS cuisine_count 
FROM swiggy 
GROUP BY cuisine 
ORDER BY cuisine_count DESC 
LIMIT 1; 

SELECT city, AVG(rating) AS average_rating 
FROM swiggy 
GROUP BY city;

SELECT restaurant_name, MAX(price) AS highest_price 
FROM swiggy 
WHERE menu_category = 'recommended' 
GROUP BY restaurant_name;

SELECT distinct restaurant_name, cost_per_person 
FROM swiggy 
WHERE cuisine <> 'Indian' 
ORDER BY cost_per_person DESC 
LIMIT 5;

SELECT restaurant_name, AVG(cost_per_person) AS avg_price 
FROM swiggy 
GROUP BY restaurant_name 
ORDER BY avg_price 
LIMIT 1; 

SELECT restaurant_name, COUNT(item) AS no_of_items 
FROM swiggy 
WHERE menu_category = 'Main Course' 
GROUP BY restaurant_name 
ORDER BY no_of_items DESC 
LIMIT 1;

SELECT Distinct restaurant_name, cost_per_person 
FROM swiggy 
WHERE cost_per_person > (SELECT AVG(cost_per_person) FROM swiggy); 

SELECT distinct t1.restaurant_name, t1.city, t2.city 
FROM swiggy AS t1 
JOIN swiggy AS t2 
ON t1.restaurant_name = t2.restaurant_name 
AND t1.city <> t2.city; 

SELECT restaurant_name, COUNT(DISTINCT menu_category) AS no_of_categories 
FROM swiggy 
GROUP BY restaurant_name 
ORDER BY no_of_categories DESC 
LIMIT 5;

SELECT restaurant_name, 
(COUNT(CASE WHEN veg_or_nonveg = 'Veg' THEN 1 END) * 100 / COUNT(*)) 
AS vegetarian_percentage 
FROM swiggy 
GROUP BY restaurant_name 
HAVING vegetarian_percentage = 100 
ORDER BY restaurant_name; 

SELECT restaurant_name, 
(COUNT(CASE WHEN veg_or_nonveg = 'Non-veg' THEN 1 END) * 100 / COUNT(*)) 
AS nonvegetarian_percentage 
FROM swiggy 
GROUP BY restaurant_name 
ORDER BY nonvegetarian_percentage DESC 
LIMIT 1; 


WITH city_expense AS ( 
    SELECT city, 
           MAX(cost_per_person) AS max_cost, 
           MIN(cost_per_person) AS min_cost 
    FROM swiggy 
    GROUP BY city 
) 
SELECT city, max_cost, min_cost 
FROM city_expense 
ORDER BY max_cost DESC;

WITH rating_rank_by_city AS ( 
    SELECT DISTINCT restaurant_name, city, rating, 
           DENSE_RANK() OVER (PARTITION BY city ORDER BY rating DESC)
           AS rating_rank 
    FROM swiggy 
) 
SELECT restaurant_name, city, rating, rating_rank 
FROM rating_rank_by_city 
WHERE rating_rank = 1;





