json.partial! 'api/shared/paginator', records: @shops
json.models @shops do |record|
  json.id record.id
  json.name record.to_s
  json.shopkeeper_name record.shopkeeper.to_s
  json.user_grade record.shopkeeper.user_grade
  json.user_grade_text record.shopkeeper.user_grade_i18n

  json.order_amount record.shopkeeper.order_amount
  json.order_number record.shopkeeper.order_number

  json.created_at record.created_at
end

json.total_order_amount @channel_user.total_order_amount