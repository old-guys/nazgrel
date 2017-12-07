json.(
  record,
  :id, :sub_order_no
)

# order_express
json.order_express do
  if record.order_express.present?
    json.partial! 'api/channel/order_expresses/show', locals: {record: record.order_express}
  end
end

# order_subs
json.order_details do
  if record.order_details.present?
    json.partial! 'api/channel/order_details/show', collection: record.order_details, as: :record
  end
end


json.(
  record,
  :supplier_id, :express_price, :express_free_price, :version, :activity_id
)

json.shop_user_deliveried_push record.shop_user_deliveried_push
json.shop_user_deliveried_push_text record.shop_user_deliveried_push_i18n

json.user_deliveried_push record.user_deliveried_push
json.user_deliveried_push_text record.user_deliveried_push_i18n

json.supplier_deliveried_push record.supplier_deliveried_push
json.supplier_deliveried_push_text record.supplier_deliveried_push_i18n

json.is_zone_freight record.is_zone_freight
json.is_zone_freight_text record.is_zone_freight_i18n

json.(
  record,
  :created_at, :updated_at
)