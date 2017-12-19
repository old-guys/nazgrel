json.id record.id
json.name record.to_s
json.shopkeeper_name record.shopkeeper.to_s
json.user_grade record.shopkeeper.user_grade
json.user_grade_text record.shopkeeper.user_grade_i18n

json.order_amount record.shopkeeper.order_amount || BigDecimal.new(0)
json.order_number record.shopkeeper.order_number.to_i

json.created_at record.created_at