-- ============================================
-- Schema Exploration
-- Purpose: Understand database structure before
-- writing business queries. Lists all tables
-- and columns in the public schema.
-- ============================================

SELECT 
    table_name, 
    column_name 
FROM information_schema.columns
-- Filter to only show our working schema
WHERE table_schema = 'public'
ORDER BY 
    table_name, 
    column_name;

-- Use this as a reference map when building
-- multi-table joins in queries below

-- ============================================
-- Query 1: Revenue by Film Category
-- Business Question: Which film categories 
-- generate the most revenue?
-- ============================================

SELECT 
    c.category_id,
    c.name AS category_name,
    SUM(p.amount) AS total_revenue,
    ROUND(SUM(p.amount)::numeric / (SELECT SUM(amount) FROM payment) * 100, 2) AS revenue_percentage
-- Joining payment to category through rental and inventory chain
FROM payment p
JOIN rental r ON r.rental_id = p.rental_id
-- inventory connects rentals to films
JOIN inventory i ON r.inventory_id = i.inventory_id
-- film_category links films to their categories
JOIN film_category fc ON fc.film_id = i.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY total_revenue DESC;


-- ============================================
-- Query 2: Top 10 Customers by Lifetime Spend
-- Business Question: Who are our most valuable
-- customers based on total amount spent?
-- ============================================

SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(p.amount) AS lifetime_spend
-- Direct join between customer and payment
-- no need to go through rental or film
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY lifetime_spend DESC
LIMIT 10;

-- Result: Eleanor Hunt is the highest spending
-- customer with $211.55 lifetime spend


-- ============================================
-- Query 3: Highest and Lowest Rental Activity
-- Business Question: Which months had the 
-- highest and lowest rental activity?
-- ============================================

WITH month_activity AS (
    -- Aggregate total rentals per month
    SELECT 
        TO_CHAR(rental_date, 'YYYY-MM') AS mon_year, 
        COUNT(*) AS rental_activity
    FROM rental 
    GROUP BY TO_CHAR(rental_date, 'YYYY-MM')
)
SELECT 
    mon_year,
    rental_activity,
    -- Label each row as Highest or Lowest month
    CASE 
        WHEN rental_activity = MAX(rental_activity) OVER () THEN 'Highest'
        WHEN rental_activity = MIN(rental_activity) OVER () THEN 'Lowest'
    END AS status
FROM month_activity
-- Filter to only show the highest and lowest months
WHERE rental_activity = (SELECT MAX(rental_activity) FROM month_activity)
   OR rental_activity = (SELECT MIN(rental_activity) FROM month_activity)
ORDER BY rental_activity DESC;

-- Result: Shows which month peaked and which 
-- month had least rental activity






