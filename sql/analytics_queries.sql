-- ============================================================
-- Sephora Product Intelligence — Analytics Queries
-- Database: sephora_bi.db (SQLite)
-- ============================================================


-- Query 1: Brand Performance
-- Which brands consistently deliver the best rated products?
SELECT 
    brand_name,
    COUNT(product_id) AS total_products,
    ROUND(AVG(avg_rating), 3) AS avg_rating,
    ROUND(AVG(price_usd), 2) AS avg_price,
    ROUND(AVG(ingredient_score), 3) AS avg_ingredient_score,
    ROUND(AVG(five_star_share), 3) AS avg_five_star_share,
    ROUND(AVG(review_count), 0) AS avg_review_count
FROM features_ml
GROUP BY brand_name
HAVING COUNT(product_id) >= 3
ORDER BY avg_rating DESC
LIMIT 20;


-- Query 2: Category Summary
-- How do skincare subcategories compare on rating, price, and ingredients?
SELECT
    secondary_category,
    COUNT(product_id) AS total_products,
    ROUND(AVG(avg_rating), 3) AS avg_rating,
    ROUND(AVG(price_usd), 2) AS avg_price,
    ROUND(AVG(ingredient_score), 3) AS avg_ingredient_score,
    ROUND(AVG(review_count), 0) AS avg_review_count,
    ROUND(AVG(five_star_share), 3) AS avg_five_star_share,
    ROUND(AVG(recommendation_rate), 3) AS avg_recommendation_rate
FROM features_ml
GROUP BY secondary_category
ORDER BY avg_rating DESC;


-- Query 3: Overrated vs Underrated Products
-- Full list of flagged products with all key metrics
SELECT
    product_name,
    brand_name,
    secondary_category,
    price_usd,
    price_tier,
    ROUND(avg_rating, 3) AS actual_rating,
    ROUND(predicted_rating, 3) AS predicted_rating,
    ROUND(gap, 3) AS gap,
    flag,
    review_count,
    ROUND(ingredient_score, 3) AS ingredient_score
FROM results_reliable
WHERE flag != 'Normal'
ORDER BY gap ASC;


-- Query 4: Price vs Quality Analysis
-- How does price tier affect ratings and ingredient quality?
SELECT
    price_tier,
    COUNT(product_id) AS total_products,
    ROUND(AVG(avg_rating), 3) AS avg_rating,
    ROUND(AVG(ingredient_score), 3) AS avg_ingredient_score,
    ROUND(AVG(rating_per_dollar), 4) AS avg_rating_per_dollar,
    ROUND(AVG(five_star_share), 3) AS avg_five_star_share,
    ROUND(AVG(review_count), 0) AS avg_review_count,
    ROUND(MIN(price_usd), 2) AS min_price,
    ROUND(MAX(price_usd), 2) AS max_price
FROM features_ml
WHERE price_tier IS NOT NULL
GROUP BY price_tier
ORDER BY avg_rating DESC;


-- Query 5: Hidden Gems
-- Budget products with strong ratings and ingredient scores
SELECT
    r.product_name,
    r.brand_name,
    r.secondary_category,
    r.price_usd,
    ROUND(r.avg_rating, 3) AS avg_rating,
    ROUND(r.ingredient_score, 3) AS ingredient_score,
    r.review_count,
    ROUND(f.rating_per_dollar, 4) AS rating_per_dollar,
    ROUND(r.gap, 3) AS gap
FROM results_reliable r
LEFT JOIN features_ml f ON r.product_id = f.product_id
WHERE r.price_usd <= 25
AND r.avg_rating >= 4.3
AND r.review_count >= 50
ORDER BY f.rating_per_dollar DESC
LIMIT 15;


-- Query 6: Feature Importance Ranking
-- What objective signals drive skincare product quality predictions?
SELECT
    feature,
    ROUND(importance, 4) AS importance,
    ROUND(importance * 100, 2) AS importance_pct
FROM feature_importance
ORDER BY importance DESC;


-- Query 7: Review Volume vs Rating Quality
-- Do products with more reviews have more reliable ratings?
SELECT
    CASE 
        WHEN review_count < 50 THEN 'Low (under 50)'
        WHEN review_count < 200 THEN 'Medium (50-200)'
        WHEN review_count < 500 THEN 'High (200-500)'
        ELSE 'Very High (500+)'
    END AS review_volume_bucket,
    COUNT(product_id) AS total_products,
    ROUND(AVG(avg_rating), 3) AS avg_rating,
    ROUND(AVG(five_star_share), 3) AS avg_five_star_share,
    ROUND(AVG(one_star_share), 3) AS avg_one_star_share,
    ROUND(AVG(recommendation_rate), 3) AS avg_recommendation_rate
FROM features_ml
GROUP BY review_volume_bucket
ORDER BY AVG(review_count) ASC;