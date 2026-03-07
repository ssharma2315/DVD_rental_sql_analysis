-- ============================================
-- Query 4: Average Rental Duration by Category
-- Business Question: Which categories have 
-- the longest average rental duration?
-- ============================================

SELECT 
    c.name AS category_name,
    ROUND(AVG(f.rental_duration), 2) AS avg_rental_duration_days
-- Join film to category through film_category bridge table
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY avg_rental_duration_days DESC;

-- Result: Shows which categories customers
-- tend to keep for longer periods


-- ============================================
-- Query 5: Films Never Rented
-- Business Question: Which films have never
-- been rented — potential dead inventory?
-- ============================================

SELECT 
    f.film_id,
    f.title
-- Start with all films and left join to find gaps
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
-- NULL rental_id means no rental record exists
WHERE r.rental_id IS NULL
ORDER BY f.title;

-- Result: These films represent dead inventory
-- business should consider removing or promoting them


-- ============================================
-- Query 6: Top 5 Actors by Film Appearances  
-- Business Question: Which actors appear in
-- the most films in our catalog?
-- ============================================

SELECT 
    a.actor_id,
    a.first_name || ' ' || a.last_name AS actor_name,
    COUNT(f.film_id) AS total_films
-- Join actor to film through film_actor bridge table
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY 
    a.actor_id,
    a.first_name,
    a.last_name
ORDER BY total_films DESC
LIMIT 5;

-- Result: Most prolific actors in the catalog
-- useful for marketing and promotion decisions


-- ============================================
-- Query 7: Revenue by Store
-- Business Question: Which store generates
-- more revenue?
-- ============================================

SELECT 
    i.store_id,
    SUM(p.amount) AS total_revenue
-- Connect payment to store through rental and inventory
FROM payment p
JOIN rental r ON r.rental_id = p.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
GROUP BY i.store_id
ORDER BY total_revenue DESC;

-- Result: Compare performance between stores
-- to identify which location drives more business


-- ============================================
-- Query 8: Active vs Inactive Customer Analysis
-- Business Question: What percentage of our
-- customers are currently active?
-- ============================================

WITH customer_status AS (
    -- Separate customers into active and inactive groups
    SELECT 
        COUNT(CASE WHEN active = 1 THEN 1 END) AS active_customers,
        COUNT(CASE WHEN active = 0 THEN 1 END) AS inactive_customers
    FROM customer
)
SELECT 
    active_customers,
    inactive_customers,
    -- Calculate percentage of each group
    ROUND((active_customers::numeric / 
        (SELECT COUNT(customer_id) FROM customer) * 100), 2) AS active_percentage,
    ROUND((inactive_customers::numeric / 
        (SELECT COUNT(customer_id) FROM customer) * 100), 2) AS inactive_percentage
FROM customer_status;

-- Result: Shows customer retention health
-- high inactive percentage signals churn problem


-- ============================================
-- Query 9: Most Frequently Rented Films
-- Business Question: Which films are rented
-- most often — our best performing inventory?
-- ============================================

SELECT 
    f.title,
    COUNT(r.rental_id) AS total_rentals
-- Connect film to rentals through inventory
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY total_rentals DESC
LIMIT 10;

-- Result: Top performing films by rental count
-- useful for inventory and procurement decisions


-- ============================================
-- Query 10: Month over Month Revenue Growth
-- Business Question: How is revenue trending
-- month by month?
-- ============================================

WITH monthly_revenue AS (
    -- Aggregate total revenue per month
    SELECT 
        TO_CHAR(payment_date, 'YYYY-MM') AS month_wise,
        SUM(amount) AS total_revenue
    FROM payment
    GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
),
growth AS (
    -- Add previous month revenue using LAG
    SELECT *,
        LAG(total_revenue) OVER (ORDER BY month_wise) AS prev_revenue
    FROM monthly_revenue
)
SELECT 
    month_wise,
    total_revenue,
    prev_revenue,
    -- Calculate difference between current and previous month
    ROUND((total_revenue - prev_revenue)::numeric, 2) AS revenue_growth
FROM growth
-- Exclude first month as it has no previous month to compare
WHERE prev_revenue IS NOT NULL
ORDER BY month_wise;

-- Result: Shows revenue trajectory month by month
-- negative growth signals business slowdown