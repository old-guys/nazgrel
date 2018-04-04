class CreateOrderRefundPays < ActiveRecord::Migration[5.2]
  def change
    create_table :order_refund_pays, comment: "退款订单支付记录" do |t|
      t.bigint :refund_order_no, comment: "退款单编号"
      t.bigint :order_no, comment: "主订单编号"
      t.string :serial_number, comment: "平台流水号"
      t.decimal :refund_amount, precision: 11, scale: 3, comment: "退款金额"
      t.string :refund_type, comment: "退款方式"
      t.integer :refund_status, comment: "00待退款,01退款成功,02退款失败,03取消退款"

      t.timestamps
    end
    add_index :order_refund_pays, :refund_order_no
    add_index :order_refund_pays, :order_no
  end
end