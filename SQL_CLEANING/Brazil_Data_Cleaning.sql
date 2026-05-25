-- CLEANING

-- Step 1: We need to check for nulls in each column
SELECT 
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(order_id) AS order_id_nulls,
    COUNT(*) - COUNT(order_item_id) AS order_item_id_nulls,
    COUNT(*) - COUNT(price) AS price_nulls,
    COUNT(*) - COUNT(freight_value) AS freight_nulls,
    COUNT(*) - COUNT(product_weight_g) AS product_weight_nulls,
    COUNT(*) - COUNT(product_length_cm) AS len_cm_nulls,
    COUNT(*) - COUNT(product_height_cm) AS height_cm_nulls,
    COUNT(*) - COUNT(product_width_cm) AS width_cm_nulls,
    COUNT(*) - COUNT(product_name) AS name_nulls
FROM
    brazil_data;
-- RESULT: There are no nulls to handle







-- Step 2: Check for duplicates in appropriate rows

-- We check for duplicates in both order_id and order_item_id because it is possible for a customer to buy items multiple times,
-- but a specific item sequence number within a specific order should only ever exist exactly once in the database.
SELECT 
    order_id, order_item_id, COUNT(*) AS duplicate_count
FROM
    brazil_data
GROUP BY order_id , order_item_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
-- RESULT: Because there is no data, we have confirmed that there are no duplicated





-- Step 3: We need to check for any inconsistencies in the columns

-- Checking if there are any non-numerical values in variables
SELECT DISTINCT price
FROM brazil_data
WHERE price NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
-- RESULT: Only numeric values

SELECT DISTINCT freight_value
FROM brazil_data
WHERE freight_value NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
-- RESULT: Only numeric values

SELECT DISTINCT product_weight_g
FROM brazil_data
WHERE product_weight_g NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
-- RESULT: Only numeric values

SELECT DISTINCT product_length_cm
FROM brazil_data
WHERE product_length_cm NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
-- RESULT: Only numeric values

SELECT DISTINCT product_height_cm
FROM brazil_data
WHERE product_height_cm NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
-- RESULT: Only numeric values

SELECT DISTINCT product_width_cm
FROM brazil_data
WHERE product_width_cm NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';
-- RESULT: Only numeric values




-- Checking to see if the varchar variable:
SELECT DISTINCT TRIM(product_name) AS Distinct_Product_Name
FROM brazil_data;
-- RESULT: I notice that there is a blank product name

-- To handle this:
-- 1. Turn off safe updates
SET SQL_SAFE_UPDATES = 0;

-- 2. Run the ultimate update
UPDATE brazil_data
SET product_name = 'Unknown Product'
WHERE product_name IS NULL 
   OR product_name REGEXP '^[[:space:]]*$'  -- Catches empty strings, tabs, and line breaks
   OR LOWER(product_name) = 'null';         -- Catches the literal word 'null' or 'NULL'

COMMIT;
SET SQL_SAFE_UPDATES = 1;


SELECT DISTINCT product_name AS Distinct_Product_Name
FROM brazil_data;
-- RESULT: Now, we have no empty values



SELECT * FROM brazil_data;


