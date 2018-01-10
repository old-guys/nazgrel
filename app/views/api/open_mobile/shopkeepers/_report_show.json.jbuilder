json.id record.id
json.shop_id record.shop_id

json.user_id record.user_id
json.shopkeeper_name record.to_s

json.province record.province
json.city record.city

json.user_phone record.user_phone
json.shop_name record.shop.to_s

json.user_grade record.user_grade
json.user_grade_text record.user_grade_i18n

json.parent_shopkeeper_id record.parent.try :user_id
json.parent_shopkeeper_name record.parent.try :user_name
json.parent_user_phone record.parent.try :user_phone
json.parent_shop_id record.parent.try :shop_id


json.order_number record.order_number
json.order_amount record.order_amount
json.commission_income_amount record.commission_income_amount

json.descendant_order_number record.descendant_order_number
json.descendant_order_amount record.descendant_order_amount
json.descendant_commission_income_amount record.descendant_commission_income_amount

json.children_count record.children_size
json.descendant_count record.descendant_size

json.tree_depth record.tree_depth

json.parent_names record.parents.map(&:to_s)
json.parent_shop_ids record.parents.map(&:shop_id)
json.parent_ids record.parents.map(&:id)

json.created_at record.shop.try(:created_at)