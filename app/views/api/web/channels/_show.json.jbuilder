json.id record.id
json.name record.to_s
json.shop_id record.shop_id
json.shop_name record.own_shop.to_s
json.shopkeeper_user_id record.shopkeeper_user_id
json.shopkeeper_name record.own_shopkeeper.to_s
json.shopkeeper_phone record.own_shopkeeper.try(:user_phone)

json.city record.city
json.category record.category
json.category_text record.category_i18n
json.source record.source
json.source_text record.source_i18n
json.status record.status
json.status_text record.status_i18n

json.updated_at record.updated_at
json.created_at record.created_at
