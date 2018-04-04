class CreateOrderRefundIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :order_refund_icons, comment: "退款订单图片" do |t|
      t.bigint :refund_order_no, comment: "退款单编号"
      t.string :img_url, comment: "图片url"

      t.timestamps
    end
    add_index :order_refund_icons, :refund_order_no
  end
end