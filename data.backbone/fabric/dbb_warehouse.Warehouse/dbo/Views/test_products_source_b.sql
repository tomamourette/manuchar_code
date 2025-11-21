-- Auto Generated (Do not modify) 98C3AB075D254A04B5049943451074FCE208DD8E9E2477B48A23527BCC3B5DD4
create view "dbo"."test_products_source_b" as -- test_products_source_b.sql
SELECT
    3 AS product_id,
    'Keyboard' AS product_name,
    'Electronics' AS category,
    75.00 AS price
UNION ALL
SELECT
    4 AS product_id,
    'Monitor' AS product_name,
    'Electronics' AS category,
    300.00 AS price;