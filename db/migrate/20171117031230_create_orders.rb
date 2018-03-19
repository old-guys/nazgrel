class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders, comment: "订单" do |t|
      t.string :order_no, comment: "订单编号"
      t.bigint :user_id, comment: "用户id"
      t.string :user_phone_no, comment: "用户手机号"
      t.string :user_name, comment: "用户真实姓"
      t.string :recv_user_name, comment: "收件人姓名"
      t.string :recv_phone_no, comment: "收件人手机号"
      t.bigint :shop_id, comment: "店铺id"
      t.string :shop_name, comment: "店铺名"
      t.string :shop_username, comment: "店主名"
      t.integer :shop_user_id, comment: "店主用户ID"
      t.string :shop_phone, comment: "店主手机号"
      t.string :province, comment: "省"
      t.string :city, comment: "市"
      t.string :district, comment: "区"
      t.string :province, comment: "省"
      t.string :detail_address, comment: "详细地址"
      t.integer :order_type, comment: "00开店订单,01店主订单,02三方订单"
      t.integer :ref_type, comment: "订单渠道, 微信好友:0,app:1,微信朋友圈:2,qq:3,qq空间:4,短信:5,二维码:6"
      t.datetime :pay_time, comment: "支付日期"
      t.datetime :deliver_time, comment: "订单发货日期"
      t.datetime :finish_time, comment: "订单完成日期"
      t.datetime :cancel_time, comment: "订单取消日期"
      t.integer :order_status, comment: "00待付款,01待发货02,已发货,03已完成,04已取消,05已完成(异常)"
      t.decimal :express_price, precision: 32, scale: 3, comment: "运费, 动态"
      t.decimal :sale_price, precision: 32, scale: 3, comment: "优惠价格, 动态期"
      t.decimal :comm, precision: 32, scale: 3, comment: "佣金相关值, 动态"
      t.decimal :pay_price, precision: 32, scale: 3, comment: "支付价格"
      t.decimal :total_price, precision: 32, scale: 3, comment: "总价"
      t.integer :comm_setted, comment: "是否已经结算佣金（00否01是）"
      t.string  :openid, comment: "openid"
      t.integer :payed_push, comment: "是否推送(00 未推送，01 已推送）已付款状态订单"
      t.text :remarks, comment: "备注"
      t.integer :activity_id, comment: "动态ID"
      t.decimal :global_freight, precision: 32, scale: 3, comment: "全局包邮金额"
      t.decimal :global_freight_flag, precision: 32, scale: 3, comment: "是否满足全局包邮策略, 1:满足, 0:不满"
      t.integer :user_ticket_id, comment: "用户优惠券ID"
      t.decimal :reduce_price, precision: 32, scale: 3, comment: "减免价格"
      t.decimal :discount_rate, precision: 32, scale: 3, comment: "折扣比例"
      t.integer :reduce_type, comment: "减免类型 0:活动折扣"

      t.timestamps
    end
    add_index :orders, :order_no
    add_index :orders, :user_id
    add_index :orders, :user_phone_no
    add_index :orders, :shop_id
    add_index :orders, :shop_user_id
    add_index :orders, :pay_time
    add_index :orders, :deliver_time
    add_index :orders, :order_status
    add_index :orders, :activity_id
    add_index :orders, :user_ticket_id
  end
end
