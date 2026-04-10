CREATE TABLE `kimia_farma.kf_data_analytics` AS 
SELECT 
    kft.transaction_id,
    kft.date,
    kkc.branch_id,
    kkc.branch_name,
    kkc.kota, 
    kkc.provinsi, 
    kft.rating AS rating_transaksi,
    kkc.rating AS rating_cabang, 
    kft.customer_name,
    kfp.product_id, 
    kfp.product_name, 
    kfp.price,
    CONCAT(CAST(ROUND(kft.discount_percentage * 100, 0) AS STRING), '%') AS discount_percentage,

    CONCAT(
        CAST(
            (CASE 
                WHEN kfp.price <= 50000 THEN 0.10
                WHEN kfp.price > 50000 AND kfp.price <= 100000 THEN 0.15
                WHEN kfp.price > 100000 AND kfp.price <= 300000 THEN 0.20
                WHEN kfp.price > 300000 AND kfp.price <= 500000 THEN 0.25
                WHEN kfp.price > 500000 THEN 0.30
                END * 100) AS STRING), '%') AS persentase_gross_laba,
    
    CAST(ROUND((kfp.price * (1 - kft.discount_percentage)), 0) AS INT64) AS nett_sales,

    CAST(ROUND(
        ((kfp.price * (1 - kft.discount_percentage)) * (CASE
        WHEN kfp.price <= 50000 THEN 0.10
        WHEN kfp.price > 50000 AND kfp.price <= 100000 THEN 0.15
        WHEN kfp.price > 100000 AND kfp.price <= 300000 THEN 0.20
        WHEN kfp.price > 300000 AND kfp.price <= 500000 THEN 0.25
        WHEN kfp.price > 500000 THEN 0.30
        END)), 0) AS INT64) AS nett_profit

FROM `kimia_farma.kf_final_transaction` AS kft
LEFT JOIN `kimia_farma.kf_kantor_cabang` AS kkc ON kft.branch_id = kkc.branch_id
LEFT JOIN `kimia_farma.kf_product` AS kfp ON kft.product_id = kfp.product_id