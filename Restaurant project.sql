USE restaurant_db;

-- We gonna answer these questions:

-- 1) View the menu_items table

SELECT *
FROM menu_items;

-- 2) Fnd the number of items in the menu

SELECT COUNT(*)
FROM menu_items;

-- 3) What are the least and most expensive items on the menu

-- The most expensive

SELECT *
FROM menu_items
ORDER BY price DESC
LIMIT 1;

-- The cheapest

SELECT *
FROM menu_items
ORDER BY price ASC
LIMIT 1;

-- 4) How many Italinas dishes are in the menu

SELECT COUNT(*)
FROM menu_items
WHERE category = "Italian";

-- 5) Which are the least and most expensive Italian dishes in the menu

-- The most expensive

SELECT *
FROM menu_items
WHERE category = "italian"
ORDER BY price DESC
LIMIT 1;

-- The least expensive

SELECT *
FROM menu_items
WHERE category = "italian"
ORDER BY price ASC
LIMIT 1;

-- 6) How many dishes every category has

SELECT category, COUNT(*)
FROM menu_items
GROUP BY category;

-- 7) What is the average price of dishes in every category

SELECT category, AVG(price)
FROM menu_items
GROUP BY category;

-- 8) View order detaills table

SELECT *
FROM order_details;

-- In the first order the item with id 109 was ordered. In the second order the iems with id 108,124,117,129,106 were ordered

-- 9) What is the date range of the table

-- Let's check if the column order_date is in date format

SHOW FIELDS
FROM order_details;

SELECT MIN(order_date),MAX(order_date)
FROM order_details;

-- 10) How many orders were made in this date range

-- The easiest way

SELECT COUNT(DISTINCT(order_id))
FROM order_details;

-- 11) How many items were ordered within this date range?

SELECT COUNT(*)
FROM order_details;

-- How many items every order had?

SELECT order_id, COUNT(*)
FROM order_details
GROUP BY order_id;

-- Which order had the most items

SELECT order_id, COUNT(item_id) AS num
FROM order_details
GROUP BY order_id
ORDER BY 2 DESC;

-- How many orders had more than 12 items?
SELECT COUNT(*) FROM

(SELECT order_id, COUNT(item_id) AS num_of_items
FROM order_details
GROUP BY order_id
HAVING num_of_items > 12) AS num_of_order_gr_than_12_items
;

-- 1. Combine the menu_items and order_details tables into a single table.

SELECT *
FROM order_details
LEFT JOIN menu_items ON
order_details.item_id = menu_items.menu_item_id;

-- 2. What were the least and most ordered items? What categories were they in?

SELECT item_name, category, COUNT(order_id) AS num_of_ord #I calculated the exact number of unit of every item were ordered
FROM order_details
LEFT JOIN menu_items ON
order_details.item_id = menu_items.menu_item_id
GROUP BY item_name, category
ORDER BY num_of_ord DESC; #DESC for the most and ASC for the least

-- 3. What were the top 5 orders that spent the most money?

SELECT order_id, SUM(price) AS total_price
FROM order_details
LEFT JOIN menu_items ON
order_details.item_id = menu_items.menu_item_id
GROUP BY order_id
ORDER BY total_price DESC
limit 5;

-- 4. View the details of the highest spend order. What insights can you gather from theis order

SELECT category, COUNT(category)
FROM
(SELECT *
FROM order_details
LEFT JOIN menu_items ON
order_details.item_id = menu_items.menu_item_id
WHERE order_id = 440) AS exp_order
GROUP BY category;

-- As we can see in the most expensive order most of the dishes were Italian. That means that Italian dishes are very preferable, so this is a sign that we should keep them
-- in our menu and maybe we should add more.

-- 5. View the details of the top 5 highest spend orders. What insights can you gather from them

-- As we have seen in a previous code the top 5 highest spend orders were these with id: 440,2075,1957,330,2675

SELECT category, COUNT(category)
FROM
(SELECT *
FROM order_details
LEFT JOIN menu_items ON
order_details.item_id = menu_items.menu_item_id
WHERE order_id  IN (440,2075,1957,330,2675)) AS exp_order
GROUP BY category;

-- As we can see, in the top 5 highest orders the Italian dishes dominate. So it would be a great idea to keep them or add more Italian dishes.

-- Also we can see in each arder from which category the most dishes were

SELECT order_id, category, COUNT(category)
FROM
(SELECT *
FROM order_details
LEFT JOIN menu_items ON
order_details.item_id = menu_items.menu_item_id
WHERE order_id  IN (440,2075,1957,330,2675)) AS exp_order
GROUP BY order_id, category;

-- We can see in the order with id 330 the most dishes were Asian, in the order with id 440 the most dishes were Italian, in the order with id 1957 the most dishes were Italia,n
-- in the order with id  2075 the most dishes were Italian, in the order with id 2675 the most dishes were Italian and Mexican.

