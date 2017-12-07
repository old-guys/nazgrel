class CreateOrderSubs < ActiveRecord::Migration[5.1]
  def change
    create_table :order_subs, comment: "子订单" do |t|
      t.bigint :sub_order_no, comment: "订单编号"
      t.bigint :order_no, comment: "主订单编号"
      t.bigint :order_express_id, comment: "物流单ID"
      t.datetime :pay_time, comment: "支付时间"
      t.datetime :deliver_time, comment: "订单发货日期"
      t.datetime :finish_time, comment: "订单完成日期"
      t.datetime :cancel_time, comment: "订单取消日期"
      t.integer :order_status, comment: "00待付款,01待发货02,已发货,03已完成,04已取消"
      t.decimal :express_price, precision: 11, scale: 3, default: 0, comment: "运费"
      t.decimal :sale_price, precision: 11, scale: 3, default: 0, comment: "优惠价格"
      t.decimal :comm, precision: 11, scale: 3, default: 0, comment: "佣金相关值"
      t.decimal :pay_price, precision: 11, scale: 3, default: 0, comment: "支付价格"
      t.decimal :total_price, precision: 11, scale: 3, default: 0, comment: "总价"
      t.integer :shop_user_deliveried_push, default: 0, comment: "是否推送(00 未推送，01 已推送）已发货状态订单, 店主"
      t.integer :user_deliveried_push, default: 0, comment: "是否推送(00 未推送，01 已推送）已发货状态订单, 用户"
      t.integer :supplier_deliveried_push, default: 0, comment: "是否推送(00 未推送，01 已推送）已发货状态订单, 供应商"
      t.string :remarks, comment: "备注"
      t.bigint :supplier_id, comment: "供应商id"
      t.decimal :express_free_price, precision: 11, scale: 3, comment: "满多少包邮"
      t.integer :version
      t.integer :activity_id, comment: "供应商活动id"
      t.integer :is_zone_freight, default: 0, comment: "是否区域不包邮, 0:包邮， 1:不包邮"

      t.timestamps
    end
    add_index :order_subs, :sub_order_no
    add_index :order_subs, :order_no
    add_index :order_subs, :order_express_id
    add_index :order_subs, :supplier_id
  end
end
