class CreateOrderRefundProductDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :order_refund_product_details, comment: "退款订单商品详情" do |t|
      t.bigint :refund_order_no, comment: "退款单编号"
      t.bigint :order_no, comment: "主订单编号"
      t.bigint :sub_order_no, comment: "子订单编号"
      t.bigint :order_detail_id, comment: "订单商品详情ID"
      t.bigint :supplier_id, comment: "供应商id"
      t.integer :refund_prod_num, comment: "退货数量"

      t.timestamps
    end
    add_index :order_refund_product_details, :refund_order_no
    add_index :order_refund_product_details, :order_no
    add_index :order_refund_product_details, :sub_order_no
    add_index :order_refund_product_details, :order_detail_id
    add_index :order_refund_product_details, :supplier_id
  end
end