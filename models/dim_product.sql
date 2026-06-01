SELECT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM {{ source('raw', 'products') }} p
LEFT JOIN {{ source('raw', 'product_category_name_translation') }} t
    ON p.product_category_name = t.product_category_name