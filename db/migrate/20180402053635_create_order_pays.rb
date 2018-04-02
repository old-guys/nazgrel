class CreateOrderPays < ActiveRecord::Migration[5.2]
  def change
    create_table :order_pays, comment: "订单支付记录" do |t|
      t.bigint :order_no, comment: "主订单编号"
      t.string :serial_number, comment: "支付平台流水号"
      t.decimal :pay_price, precision: 11, scale: 3, comment: "支付价格"
      t.string :pay_type, comment: "支付方式"
      t.integer :pay_status, comment: "支付状态,00待付款,01付款完成"

      t.timestamps
    end
  end
end