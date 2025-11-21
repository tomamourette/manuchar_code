-- Auto Generated (Do not modify) 98C3AB075D254A04B5049943451074FCE208DD8E9E2477B48A23527BCC3B5DD4
create view "dbo"."test_products_source_a" as -- test_products_source_a.sql
SELECT
    1 AS product_id,
    'Laptop' AS product_name,
    'Electronics' AS category,
    1200.00 AS price
UNION ALL
SELECT
    2 AS product_id,
    'Mouse' AS product_name,
    'Electronics' AS category,
    25.00 AS price;