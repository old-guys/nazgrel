json.id record.id
json.shop_id record.shop_id

json.user_id record.user_id
json.shopkeeper_name record.to_s
json.shopkeeper_real_name record.shop_user.try(:real_name)

json.province record.province
json.city record.city

json.status record.status
json.status_text record.status_i18n

json.user_phone record.user_phone
json.shop_name record.shop.to_s
json.shop_img_url record.shop_img_url

json.user_grade record.user_grade
json.user_grade_text record.user_grade_i18n

json.parent_shopkeeper_id record.parent.try :user_id
json.parent_shopkeeper_name record.parent.try :user_name
json.parent_user_phone record.parent.try :user_phone
json.parent_shop_id record.parent.try :shop_id

json.total_income_amount record.total_income_amount
json.balance_amount record.balance_amount
json.withdraw_amount record.withdraw_amount
json.blocked_amount record.blocked_amount
json.create_shop_amount record.create_shop_amount

json.total_income_coin record.total_income_coin
json.balance_coin	record.balance_coin
json.use_coin	record.use_coin

json.commission_income_amount record.commission_income_amount.to_f.to_s
json.team_income_amount record.team_income_amount
json.invite_amount record.invite_amount

json.shop_sales_amount record.shop_sales_amount

json.invite_code record.invite_code
json.invite_qrcode_url record.invite_qrcode_url

json.order_number record.order_number.to_i
json.order_amount record.order_amount.to_f.to_s
json.shopkeeper_order_number record.shopkeeper_order_number.to_i
json.shopkeeper_order_amount record.shopkeeper_order_amount.to_f.to_s
json.sale_order_number record.sale_order_number.to_i
json.sale_order_amount record.sale_order_amount.to_f.to_s

json.tree_depth record.tree_depth

json.parent_names record.parents.map(&:to_s)
json.parent_shop_ids record.parents.map(&:shop_id)
json.parent_ids record.parents.map(&:id)

json.org_grade record.org_grade
json.org_grade_text record.org_grade_i18n

json.order_create_at record.order_create_at
json.upgrade_grade_gold_at record.upgrade_grade_gold_at
json.upgrade_grade_platinum_at record.upgrade_grade_platinum_at

json.created_at record.shop.try(:created_at)