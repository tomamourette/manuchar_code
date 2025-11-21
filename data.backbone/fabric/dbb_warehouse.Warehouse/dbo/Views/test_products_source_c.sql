-- Auto Generated (Do not modify) 98C3AB075D254A04B5049943451074FCE208DD8E9E2477B48A23527BCC3B5DD4
create view "dbo"."test_products_source_c" as -- test_products_source_c.sql
SELECT
    5 AS product_id,
    'Webcam' AS product_name,
    'Electronics' AS category,
    50.00 AS price
UNION ALL
SELECT
    6 AS product_id,
    'Headphones' AS product_name,
    'Electronics' AS category,
    150.00 AS price;