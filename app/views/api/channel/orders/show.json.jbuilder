json.id @order.id
# 订单编号
json.order_no @order.order_no
# 用户id
json.user_id @order.user_id
# 用户手机号
json.user_phone @order.user_phone_no
json.user_phone_mask "*********"
# 用户真实姓名
json.user_name @order.user_name

# 收件人姓名
json.recv_user_name @order.recv_user_name
# 收件人手机号
json.recv_phone @order.recv_phone_no

# 店铺id
json.shop_id @order.shop_id
# 店铺名
json.shop_name @order.shop_name
# 店主名
json.shop_username @order.shop_username
# 店主手机号
json.shop_user_id @order.shop_user_id
# 店主手机号
json.shop_phone @order.shop_phone

# 省
json.province @order.province
# 市
json.city @order.city
# 区
json.district @order.district
# 详细地址
json.detail_address @order.detail_address

# 订单类型
json.order_type @order.order_type
json.order_type_text @order.order_type_i18n

# 订单渠道
json.ref_type @order.ref_type
json.ref_type_text @order.ref_type_i18n

# 支付日期
json.pay_time @order.pay_time
# 订单发货日期
json.deliver_time @order.deliver_time
# 订单完成日期
json.finish_time @order.finish_time
# 订单取消日期
json.cancel_time @order.cancel_time

# 订单状态
json.order_status @order.order_status
json.order_status_text @order.order_status_i18n

json.order_status @order.order_status
json.order_status_text @order.order_status_i18n

json.express_price @order.express_price
json.sale_price @order.sale_price
json.comm @order.comm
json.pay_price @order.pay_price
json.total_price @order.total_price

json.openid @order.openid

json.comm_setted @order.comm_setted
json.comm_setted_text @order.comm_setted_i18n
json.payed_push @order.payed_push
json.payed_push_text @order.payed_push_i18n
json.global_freight_flag @order.global_freight_flag
json.global_freight_flag_text @order.global_freight_flag_i18n

json.remarks @order.remarks
json.user_ticket_id @order.user_ticket_id

json.reduce_price @order.reduce_price
json.discount_rate @order.discount_rate

# json.reduce_type @order.reduce_type

json.created_at @order.created_at
