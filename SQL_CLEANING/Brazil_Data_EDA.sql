-- STEP 1:
-- Let's look at the min/max values for each variable of interest
SELECT MIN(price), MAX(price), AVG(price),
       MIN(freight_value), MAX(freight_value),
       MIN(product_weight_g), MAX(product_weight_g),
       MIN(product_length_cm), MAX(product_length_cm),
       MIN(product_height_cm), MAX(product_height_cm),
       MIN(product_width_cm), MAX(product_width_cm)
FROM brazil_data;
-- RESULT: The minimum freight_value and product_weight_g values are zero. Let's investigate this:





-- STEP 2:
-- Let's first investigate the freight_value: 

-- 1. How many zero freight rows are there?
SELECT COUNT(*) AS zero_freight_count
FROM brazil_data
WHERE freight_value = 0;

-- 2. Are zero freight items associated with specific products?
SELECT product_name, COUNT(*) AS count, AVG(price) AS avg_price
FROM brazil_data
WHERE freight_value = 0
GROUP BY product_name
ORDER BY count DESC;
# RESULT: Mainly watches_gifts


-- SOLUTION:
-- They have normal weights, prices, and dimensions, so free freight seems intentional (e.g. a promotion). The right move 
-- is to keep them but flag them:
-- 1. Add the column
ALTER TABLE brazil_data
ADD free_shipping VARCHAR(3);

-- 2. Turn off safe updates so you can update the whole table
SET SQL_SAFE_UPDATES = 0;

-- 3. Update the column using a CASE WHEN expression
UPDATE brazil_data

SET free_shipping = CASE WHEN freight_value = 0 THEN 'Yes' ELSE 'No' END;
-- 5. Turn safe updates back on (Best Practice)
SET SQL_SAFE_UPDATES = 1;

-- RESULT: Products with freight_value equal to 0 labeled as 'Yes' and ones that aren't labeled as 'No' under free_shipping column





-- STEP 3:
-- Let's next investigate the product_weight_g: 

-- 1. How many zero weight rows are there?
SELECT COUNT(*) AS zero_weight_count
FROM brazil_data
WHERE product_weight_g = 0;

-- 2. What do those rows look like?
SELECT *
FROM brazil_data
WHERE product_weight_g = 0;
-- RESULT: All zero-weight products have dimensions and are the same product, so it there was likely an error not inputting weights

-- SOLUTION:
-- 1. Check what other bed_bath_table products weigh
SELECT AVG(product_weight_g) AS avg_weight
FROM brazil_data
WHERE product_name = 'bed_bath_table'
AND product_weight_g > 0;

-- 2. Then impute avg_weight = 2118.278
SET SQL_SAFE_UPDATES = 0;
UPDATE brazil_data
SET product_weight_g = (
    SELECT AVG(product_weight_g)
    FROM (SELECT * FROM brazil_data) AS temp
    WHERE product_name = 'bed_bath_table'
    AND product_weight_g > 0
)
WHERE product_weight_g = 0;
COMMIT;
SET SQL_SAFE_UPDATES = 1;

-- RESULT: Table updated with averages!











-- Step 4: 
-- Last check for sanity values aren't negative
SELECT COUNT(*) FROM brazil_data 
WHERE price < 0 OR freight_value < 0 OR product_weight_g < 0 OR product_length_cm < 0 OR product_height_cm < 0 OR product_width_cm < 0;
-- RESULT: No negative values





