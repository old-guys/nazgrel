class CreateOrderRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :order_refunds, comment: "退款订单" do |t|
      t.bigint :refund_order_no, comment: "订单编号"
      t.bigint :order_no, comment: "主订单编号"
      t.decimal :refund_amount, precision: 11, scale: 3, comment: "退款金额"
      t.decimal :refund_comm, precision: 11, scale: 3, comment: "退款佣金"
      t.decimal :refund_virt_coin_reduce_price, precision: 11, scale: 3, comment: "退款芝蚂币"
      t.integer :refund_type, comment: "退款类型(00退货退款,01仅退款)"
      t.integer :refund_status, comment: "退款单状态(00待审核,01待寄回,02待退款,03退款失败,04退款成功,05取消申请,06驳回申请)"
      t.string :refund_reason, comment: "申请原因"
      t.text :refund_detail, comment: "备注"
      t.text :audit_detail, comment: "审核意见"
      t.string :refund_account_name, comment: "退款账户详情"
      t.integer :ref_type, comment: "订单渠道"
      t.string :audit_username, comment: "审核用户名"
      t.string :audit_userid, comment: "审核用户ID"
      t.integer :refund_flag, comment: "是否发起退款标志"

      t.timestamps
    end
    add_index :order_refunds, :refund_order_no
    add_index :order_refunds, :order_no
  end
end