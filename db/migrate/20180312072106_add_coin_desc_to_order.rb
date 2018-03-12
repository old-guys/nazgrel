class AddCoinDescToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :virt_coin_reduce_price, :decimal, default: 0, precision: 11, scale: 3, comment: "当前使用芝蚂币金额"
    add_column :orders, :refund_time, :datetime, comment: "最新退款日期"
    add_column :orders, :refund_apply_time, :datetime, comment: "最新退款申请日期"
    add_column :orders, :after_sale_status, :integer, comment: "最新售后状态,用于审核过程(00待审核,01待寄回,02待退款,03退款失败,04退款成功,05取消申请,06驳回申请)"
    add_column :orders, :refunded_amount, :decimal, default: 0, precision: 11, scale: 3, comment: "退款累计总金额"
    add_column :orders, :refunding_amount, :decimal, default: 0, precision: 11, scale: 3, comment: "当前正在退款金额"
    add_column :orders, :refunded_product_num, :integer, default: 0, comment: "累计退款商品数量"
    add_column :orders, :refunding_product_num, :integer, default: 0, comment: "当前正在退款商品数量"
    add_column :orders, :refunded_comm, :decimal, default: 0, precision: 11, scale: 3, comment: "累计退款佣金"
    add_column :orders, :refunding_comm, :decimal, default: 0, precision: 11, scale: 3, comment: "当前正在退款佣金"
    add_column :orders, :refunded_virt_coin_reduce_price, :decimal, default: 0, precision: 11, scale: 3, comment: "退款累计总芝蚂币"
    add_column :orders, :refunding_virt_coin_reduce_price, :decimal, default: 0, precision: 11, scale: 3, comment: "当前正在退款芝蚂币"
    add_column :orders, :order_sub_status, :integer, default: 0, comment: "00正常订单,01部分退款,02全部退款"
    add_column :orders, :old_order_status, :integer, default: 0, comment: "订单状态快照"
    add_column :orders, :order_product_num, :integer, default: 0, comment: "商品总数"
    add_column :orders, :cur_refund_order_no, :bigint, comment: "当前退款单编号"
  end
end