json.id record.id
json.shop_id record.shop_id

json.user_id record.user_id
json.shopkeeper_name record.to_s
json.shopkeeper_real_name record.shop_user.try(:real_name)

json.province record.province
json.city record.city

json.user_phone record.user_phone
json.shop_name record.shop.to_s
json.shop_img_url record.shop_img_url

json.user_grade record.user_grade
json.user_grade_text record.user_grade_i18n

json.parent_shopkeeper_id record.parent.try :user_id
json.parent_shopkeeper_name record.parent.try :user_name
json.parent_user_phone record.parent.try :user_phone
json.parent_shop_id record.parent.try :shop_id


json.order_number record.order_number.to_i
json.order_amount record.order_amount.to_f.to_s
json.shopkeeper_order_number record.shopkeeper_order_number.to_i
json.shopkeeper_order_amount record.shopkeeper_order_amount.to_f.to_s
json.sale_order_number record.sale_order_number.to_i
json.sale_order_amount record.sale_order_amount.to_f.to_s
json.commission_income_amount record.commission_income_amount.to_f.to_s

json.descendant_order_number record.descendant_order_number.to_i
json.descendant_order_amount record.descendant_order_amount.to_f.to_s
json.descendant_commission_income_amount record.descendant_commission_income_amount.to_f.to_s

json.children_count record.children_size
json.descendant_count record.descendant_size

json.tree_depth record.tree_depth

json.parent_names record.parents.map(&:to_s)
json.parent_shop_ids record.parents.map(&:shop_id)
json.parent_ids record.parents.map(&:id)

json.created_at record.shop.try(:created_at)