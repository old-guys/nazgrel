json.(record, :id, :order_no, :user_id,
  :shop_name, :shop_username, :shop_user_id,
  :pay_time, :deliver_time, :finish_time, :cancel_time,
  :express_price, :sale_price, :comm, :pay_price, :total_price,
  :created_at
)
json.order_status record.order_status
json.order_status_text record.order_status_i18n
json.ref_type record.ref_type
json.ref_type_text record.ref_type_i18n
json.comm_setted record.comm_setted
json.comm_setted_text record.comm_setted_i18n
json.payed_push record.payed_push
json.payed_push_text record.payed_push_i18n
json.global_freight_flag record.global_freight_flag
json.global_freight_flag_text record.global_freight_flag_i18n

json.created_at record.created_at