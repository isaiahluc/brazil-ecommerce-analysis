**Project Overview**

This project analyzes customer order data from the Brazilian E-Commerce Public Dataset by Olist(https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), an open-source Kaggle dataset containing real anonymized commerce transactions in Brazil. The goal was to identify revenue-driving product categories and understand the cost structure associated with third-party shipping. The pipeline spans data cleaning in Excel Power Query, deeper cleaning and exploratory analysis in SQL, and final visualization in Power BI.



**Tools & Technologies**

Excel (Power Query): Initial data merging and cleaning

SQL: Data cleaning, deduplication, EDA

Power BI: Dashboard and unit-level product analysis



**Key Findings**

1. Health/Beauty, Watches, and Bed/Bath/Table products were the top revenue-generating categories across the dataset.
2. Bed/Bath/Table and Health/Beauty, despite strong revenue performance, also carry the highest third-party shipping costs, compressing their net margins relative to other categories.



**Workflow**

Raw CSVs (3 files)
    └── Merged & cleaned in Excel Power Query
            └── Brazil_Data.csv
                    └── SQL Cleaning (nulls, duplicates, type validation)
                            └── SQL EDA (outlier detection, variable trends)
                                    └── Brazil_Data_Final.csv
                                            └── Power BI Dashboard



**File Descriptions**

olist_order_items_dataset.csv: Raw source data — order line items

olist_products_dataset.csv: Raw source data — product attributes

olist_product_category_translation.csv: Raw source data — category name translations (PT → EN)

Brazil_Data.csv: Merged dataset post-Power Query; variables of interest selected, initial cleaning applied

Brazil_Data_Cleaning.sql: SQL script checking for nulls, duplicates, and string/numeric inconsistencies

Brazil_Data_EDA.sql: SQL script performing outlier detection and exploratory variable analysis

Brazil_Data_Final.csv: Finalized dataset used as the Power BI data source

Order Analysis.pbix: Power BI report with unit-level product analysis (note: built on Mac without DAX access)



**Notes**

1. The three raw CSVs were joined in Excel Power Query on shared product and order keys before any SQL processing.
2. Power BI visuals were developed on macOS, which limits access to DAX expressions; all calculated fields were handled upstream in SQL.
3. Raw source files are included for full reproducibility. If file sizes exceed GitHub's limits, source data can alternatively be downloaded directly from Kaggle.
