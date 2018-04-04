class CreateOrderRefundExpresses < ActiveRecord::Migration[5.2]
  def change
    create_table :order_refund_expresses, comment: "退款物流订单" do |t|
      t.bigint :refund_order_no, comment: "退款订单编号"
      t.bigint :order_no, comment: "订单编号"
      t.bigint :supplier_id, comment: "供应商id"
      t.string :supplier_name, comment: "供应商名称"
      t.string :province, comment: "省"
      t.string :city, comment: "市"
      t.string :district, comment: "区"
      t.string :detail_address, comment: "详细地址"
      t.string :recv_phone_no, comment: "手机号"
      t.string :recv_name, comment: "姓名"
      t.string :express_name, comment: "物流公司名"
      t.string :express_no, comment: "物流单号"

      t.timestamps
    end
    add_index :order_refund_expresses, :refund_order_no
    add_index :order_refund_expresses, :order_no
    add_index :order_refund_expresses, :supplier_id
  end
end