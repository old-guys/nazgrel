json.(
  record,
  :id, :product_sku_id, :product_id, :product_skuinfo,
  :product_name, :product_image, :product_num, :product_market_price,
  :product_sale_price, :commission_rate, :express_price,
  :product_group_id,
  :product_old_sale_price
)

json.is_free_delivery record.is_free_delivery
json.is_free_delivery_text record.is_free_delivery_i18n

json.product_label_type record.product_label_type
json.product_label_type_text record.product_label_type_i18n

json.(
  record,
  :created_at, :updated_at
)