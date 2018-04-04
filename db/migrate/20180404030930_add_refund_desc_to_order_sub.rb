class AddRefundDescToOrderSub < ActiveRecord::Migration[5.2]
  def change
    add_column :order_subs, :sync_price,
      :integer, after: :is_zone_freight, comment: "商品价格同步"
    add_column :order_subs, :refund_time,
      :datetime, after: :sync_price, comment: "最新退款日期"
    add_column :order_subs, :refund_apply_time,
      :datetime, after: :refund_time, comment: "最新退款申请日期"
    add_column :order_subs, :refunded_amount,
      :decimal, precision: 11, scale: 3, after: :refund_apply_time, comment: "退款累计总金额"
    add_column :order_subs, :refunding_amount,
      :decimal, precision: 11, scale: 3, after: :refunded_amount, comment: "当前正在退款金额"
    add_column :order_subs, :refunded_product_num,
      :integer, after: :refunding_amount, comment: "累计退款商品数量"
    add_column :order_subs, :refunding_product_num,
      :integer, after: :refunded_product_num, comment: "当前正在退款商品数量"
    add_column :order_subs, :refunded_comm,
      :decimal, precision: 11, scale: 3, after: :refunding_product_num, comment: "累计退款佣金"
    add_column :order_subs, :refunding_comm,
      :decimal, precision: 11, scale: 3, after: :refunded_comm, comment: "当前正在退款佣金"

    add_column :order_subs, :order_sub_status, :integer, after: :refunding_comm, comment: "子订单状态:00正常订单,01部分退款,02全部退款"
    add_column :order_subs, :old_order_status, :integer, after: :order_sub_status, comment: "子订单状态快照"
    add_column :order_subs, :delivered_flag, :integer, after: :old_order_status, comment: "是否导出订单详情,导出则为已发货,用于退款处理"
    add_column :order_subs, :sub_product_num, :integer, after: :delivered_flag, comment: "商品总数"
  end
end